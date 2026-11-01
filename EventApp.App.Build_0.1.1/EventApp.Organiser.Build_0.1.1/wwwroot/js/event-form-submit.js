(() => {
    const form = document.getElementById('create-event-form');
    const feedback = form?.querySelector('#event-save-feedback');
    if (!form || !feedback) return;

    let saving = false;

    function showNotice(text) {
        const message = document.createElement('p');
        message.className = 'portal-validation-summary';
        message.textContent = text;
        feedback.replaceChildren(message);
        feedback.focus();
    }

    function showFieldErrors(errors) {
        const remaining = new Map(Object.entries(errors));
        let firstMessage = null;

        for (const span of form.querySelectorAll('[data-valmsg-for]')) {
            const key = span.dataset.valmsgFor;
            const messages = errors[key] ?? [];
            const invalid = messages.length > 0;

            span.textContent = messages.join(' ');
            span.classList.toggle('field-validation-error', invalid);
            span.classList.toggle('field-validation-valid', !invalid);

            if (invalid) {
                span.closest('details')?.setAttribute('open', '');
                firstMessage ??= span;
                remaining.delete(key);
            }
        }

        for (const field of form.querySelectorAll('input[name], select[name], textarea[name]')) {
            const invalid = Object.hasOwn(errors, field.name);
            field.classList.toggle('input-validation-error', invalid);

            if (invalid) {
                field.setAttribute('aria-invalid', 'true');
            } else {
                field.removeAttribute('aria-invalid');
            }
        }

        // Fouten zonder eigen veldmelding komen boven het formulier.
        const otherMessages = Array.from(remaining.values()).flat();

        if (otherMessages.length) {
            showNotice(otherMessages.join(' '));
        } else if (firstMessage) {
            firstMessage.tabIndex = -1;
            firstMessage.focus();
        } else {
            showNotice('Controleer de ingevulde gegevens.');
        }
    }

    // De bestaande veldvalidatie krijgt eerst de kans om het opslaan te stoppen.
    document.addEventListener('submit', async event => {
        if (event.target !== form || event.defaultPrevented) return;

        event.preventDefault();
        if (saving) return;

        const button = event.submitter ?? form.querySelector('button[type="submit"]');
        saving = true;
        let navigating = false;

        if (button) button.disabled = true;
        form.setAttribute('aria-busy', 'true');
        feedback.replaceChildren();

        try {
            const response = await fetch(form.action, {
                method: 'POST',
                body: new FormData(form),
                headers: {
                    'X-Event-Form': '1',
                    'Accept': 'application/json'
                },
                mode: 'same-origin'
            });

            if (response.redirected || response.status === 401 || response.status === 403) {
                showNotice('Controleer in een ander tabblad of je nog bent ingelogd.');
                return;
            }

            if (response.status === 413) {
                showNotice('De totale upload is te groot. Kies minder of kleinere bestanden.');
                return;
            }

            if (response.headers.get('content-type')?.includes('application/json')) {
                const result = await response.json();

                if (result.errors) {
                    showFieldErrors(result.errors);
                    return;
                }

                if (response.ok && result.redirectUrl) {
                    const destination = new URL(result.redirectUrl, location.href);

                    if (destination.origin === location.origin) {
                        location.assign(destination.href);
                        navigating = true;
                        return;
                    }
                }
            }

            showNotice('De server heeft het opslaan niet bevestigd. Controleer je dashboard in een ander tabblad.');
        } catch {
            showNotice('Geen bevestiging ontvangen. Controleer je dashboard in een ander tabblad voordat je opnieuw opslaat.');
        } finally {
            if (!navigating) {
                saving = false;
                if (button) button.disabled = false;
                form.removeAttribute('aria-busy');
            }
        }
    });
})();