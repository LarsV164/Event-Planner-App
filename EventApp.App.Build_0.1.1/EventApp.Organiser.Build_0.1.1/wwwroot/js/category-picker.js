(() => {
    const pickers = document.querySelectorAll('[data-category-picker]');
    if (!pickers.length) return;

    function normalize(value) {
        return (value || '').trim().toLocaleLowerCase('nl');
    }

    function parseCategories(rawValue) {
        try {
            const parsed = JSON.parse(rawValue || '[]');
            if (!Array.isArray(parsed)) return [];

            const seen = new Set();

            return parsed
                .map(category => ({
                    id: Number(category.id),
                    name: String(category.name || '').trim()
                }))
                .filter(category => Number.isInteger(category.id) && category.id > 0 && category.name)
                .filter(category => {
                    if (seen.has(category.id)) return false;
                    seen.add(category.id);
                    return true;
                });
        } catch {
            return [];
        }
    }

    pickers.forEach((picker, pickerIndex) => {
        const searchInput = picker.querySelector('[data-category-search]');
        const suggestions = picker.querySelector('[data-category-suggestions]');
        const selectedBox = picker.querySelector('[data-category-selected]');
        const hiddenBox = picker.querySelector('[data-category-hidden]');
        const feedback = picker.querySelector('[data-category-feedback]');

        if (!searchInput || !suggestions || !selectedBox || !hiddenBox) return;

        const addUrl = picker.dataset.addUrl;
        let categories = parseCategories(picker.dataset.categories);
        let selectedIds = Array.from(hiddenBox.querySelectorAll('input[type="hidden"]'))
            .map(input => Number(input.value))
            .filter(id => Number.isInteger(id) && id > 0);
        let availableOptions = [];
        let activeIndex = -1;
        let addInProgress = false;

        selectedIds = [...new Set(selectedIds)];

        function getCategory(id) {
            return categories.find(category => category.id === Number(id));
        }

        function setFeedback(message, isError = false) {
            if (!feedback) return;

            feedback.textContent = message || '';
            feedback.hidden = !message;
            feedback.classList.toggle('is-error', Boolean(message) && isError);
        }

        function renderSelected() {
            selectedBox.replaceChildren();
            hiddenBox.replaceChildren();

            selectedIds.forEach((id, index) => {
                const category = getCategory(id);
                const tag = document.createElement('button');

                tag.type = 'button';
                tag.className = 'portal-tag';
                tag.title = category ? category.name : `Categorie ${id}`;

                const label = document.createElement('span');
                label.textContent = category ? category.name : `Categorie ${id}`;

                const remove = document.createElement('span');
                remove.setAttribute('aria-hidden', 'true');
                remove.textContent = '×';

                tag.append(label, remove);
                tag.addEventListener('click', () => {
                    selectedIds = selectedIds.filter(selectedId => selectedId !== id);
                    renderSelected();
                    renderSuggestions(searchInput.value);
                    searchInput.focus();
                });

                selectedBox.appendChild(tag);

                const hidden = document.createElement('input');
                hidden.type = 'hidden';
                hidden.name = `Input.CategoryIds[${index}]`;
                hidden.value = String(id);
                hiddenBox.appendChild(hidden);
            });
        }

        function closeSuggestions() {
            suggestions.hidden = true;
            suggestions.replaceChildren();
            searchInput.setAttribute('aria-expanded', 'false');
            searchInput.removeAttribute('aria-activedescendant');
            activeIndex = -1;
        }

        function setActiveOption(index) {
            activeIndex = index;

            suggestions.querySelectorAll('[data-category-option]').forEach((option, optionIndex) => {
                const isActive = optionIndex === activeIndex;
                option.classList.toggle('is-active', isActive);

                if (isActive) {
                    searchInput.setAttribute('aria-activedescendant', option.id);
                    option.scrollIntoView({ block: 'nearest' });
                }
            });

            if (activeIndex < 0) {
                searchInput.removeAttribute('aria-activedescendant');
            }
        }

        function selectCategory(category) {
            if (!selectedIds.includes(category.id)) {
                selectedIds.push(category.id);
            }

            searchInput.value = '';
            setFeedback('');
            renderSelected();
            renderSuggestions('');
            searchInput.focus();
        }

        async function addCategory(name) {
            if (!addUrl || addInProgress) return;

            const trimmedName = name.trim();
            if (!trimmedName) return;

            addInProgress = true;
            searchInput.disabled = true;
            setFeedback('Categorie toevoegen...');

            try {
                const body = new URLSearchParams();
                body.set('categoryName', trimmedName);

                const token = picker.closest('form')?.querySelector('input[name="__RequestVerificationToken"]');
                if (token) body.set('__RequestVerificationToken', token.value);

                const response = await fetch(addUrl, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    credentials: 'same-origin',
                    body: body.toString()
                });

                const payload = await response.json().catch(() => null);

                if (!response.ok || !payload || !payload.categoryId || !payload.categoryName) {
                    throw new Error(payload?.message || 'De categorie kon niet worden toegevoegd.');
                }

                const newCategory = {
                    id: Number(payload.categoryId),
                    name: String(payload.categoryName).trim()
                };

                if (!categories.some(category => category.id === newCategory.id)) {
                    categories.push(newCategory);
                    categories.sort((a, b) => a.name.localeCompare(b.name, 'nl'));
                }

                selectCategory(newCategory);
                setFeedback(`Categorie "${newCategory.name}" is toegevoegd.`);
            } catch (error) {
                setFeedback(error.message || 'De categorie kon niet worden toegevoegd.', true);
            } finally {
                addInProgress = false;
                searchInput.disabled = false;
                searchInput.focus();
            }
        }

        function createOption(option, index) {
            const button = document.createElement('button');
            button.type = 'button';
            button.className = 'portal-category-option';
            button.id = `category-option-${pickerIndex}-${index}`;
            button.dataset.categoryOption = option.type;
            button.setAttribute('role', 'option');

            const label = document.createElement('span');
            label.className = 'portal-category-option-label';
            label.textContent = option.type === 'add'
                ? `Nieuwe categorie toevoegen: "${option.name}"`
                : option.category.name;

            const hint = document.createElement('span');
            hint.className = 'portal-category-option-hint';
            hint.textContent = option.type === 'add' ? '+' : 'Toevoegen';

            button.append(label, hint);
            button.addEventListener('mousedown', event => event.preventDefault());
            button.addEventListener('click', () => {
                if (option.type === 'add') {
                    addCategory(option.name);
                } else {
                    selectCategory(option.category);
                }
            });

            return button;
        }

        function renderSuggestions(rawQuery) {
            const query = (rawQuery || '').trim();
            const normalizedQuery = normalize(query);
            const unselected = categories.filter(category => !selectedIds.includes(category.id));

            const matches = unselected
                .filter(category => !normalizedQuery || normalize(category.name).includes(normalizedQuery))
                .sort((a, b) => {
                    if (normalizedQuery) {
                        const aStarts = normalize(a.name).startsWith(normalizedQuery);
                        const bStarts = normalize(b.name).startsWith(normalizedQuery);

                        if (aStarts !== bStarts) return aStarts ? -1 : 1;
                    }

                    return a.name.localeCompare(b.name, 'nl');
                });

            const exactMatch = categories.some(category => normalize(category.name) === normalizedQuery);

            availableOptions = matches.map(category => ({ type: 'existing', category }));

            if (query && !exactMatch && query.length <= 100) {
                availableOptions.push({ type: 'add', name: query });
            }

            suggestions.replaceChildren();
            activeIndex = -1;

            if (availableOptions.length === 0) {
                closeSuggestions();

                if (query && exactMatch) {
                    setFeedback('Deze categorie is al geselecteerd.');
                }

                return;
            }

            availableOptions.forEach((option, index) => {
                suggestions.appendChild(createOption(option, index));
            });

            suggestions.hidden = false;
            searchInput.setAttribute('aria-expanded', 'true');
        }

        function activateOption(index) {
            const option = availableOptions[index];
            if (!option) return;

            if (option.type === 'add') {
                addCategory(option.name);
            } else {
                selectCategory(option.category);
            }
        }

        searchInput.addEventListener('input', () => {
            setFeedback('');
            renderSuggestions(searchInput.value);
        });

        searchInput.addEventListener('focus', () => {
            renderSuggestions(searchInput.value);
        });

        searchInput.addEventListener('keydown', event => {
            if (event.key === 'ArrowDown') {
                event.preventDefault();

                if (suggestions.hidden) {
                    renderSuggestions(searchInput.value);
                }

                if (availableOptions.length > 0) {
                    setActiveOption((activeIndex + 1) % availableOptions.length);
                }
            } else if (event.key === 'ArrowUp') {
                event.preventDefault();

                if (suggestions.hidden) {
                    renderSuggestions(searchInput.value);
                }

                if (availableOptions.length > 0) {
                    setActiveOption(activeIndex <= 0 ? availableOptions.length - 1 : activeIndex - 1);
                }
            } else if (event.key === 'Enter') {
                if (!suggestions.hidden && availableOptions.length > 0) {
                    event.preventDefault();
                    activateOption(activeIndex >= 0 ? activeIndex : 0);
                }
            } else if (event.key === 'Escape') {
                closeSuggestions();
            }
        });

        document.addEventListener('click', event => {
            if (!picker.contains(event.target)) {
                closeSuggestions();
            }
        });

        searchInput.addEventListener('blur', () => {
            window.setTimeout(() => {
                if (!picker.contains(document.activeElement)) {
                    closeSuggestions();
                }
            }, 120);
        });

        renderSelected();
    });
})();
