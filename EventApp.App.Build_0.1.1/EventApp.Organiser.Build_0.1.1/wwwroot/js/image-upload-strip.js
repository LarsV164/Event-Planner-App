(() => {
    const MAX = 10;
    const items = []; // { file, url, x, y }
    let editing = null;

    const $ = id => document.getElementById(id);
    const input = $('images-input'), addBtn = $('add-images-btn'),
          shell = $('image-strip-shell'), strip = $('image-strip'),
          meta = $('image-meta-inputs'), modal = $('image-position-modal'),
          preview = $('position-preview-image'),
          rx = $('position-x-range'), ry = $('position-y-range');

    if (!input || !addBtn) return;

    addBtn.addEventListener('click', () => input.click());



    function sync() {
        // keep the real input in step so the form posts every file
        const dt = new DataTransfer();
        items.forEach(i => dt.items.add(i.file));
        input.files = dt.files;

        meta.innerHTML = items.map((i, n) =>
            `<input type="hidden" name="ImagePositions[${n}].X" value="${i.x}" />
             <input type="hidden" name="ImagePositions[${n}].Y" value="${i.y}" />`).join('');

        strip.innerHTML = '';
        items.forEach(item => {
            const slot = document.createElement('div');
            slot.className = 'portal-image-slot portal-image-slot--clickable';

            const img = document.createElement('img');
            img.className = 'portal-image-thumb';
            img.src = item.url;
            img.alt = '';
            img.style.objectPosition = `${item.x}% ${item.y}%`;

            const remove = document.createElement('button');
            remove.type = 'button';
            remove.className = 'portal-image-remove-btn';
            remove.setAttribute('aria-label', 'Verwijderen');
            remove.textContent = '×';
            remove.addEventListener('click', e => {
                e.stopPropagation();
                URL.revokeObjectURL(item.url);
                items.splice(items.indexOf(item), 1);
                sync();
            });

            slot.addEventListener('click', () => openModal(item));
            slot.append(img, remove);
            strip.appendChild(slot);
        });

        shell.hidden = items.length === 0;
        addBtn.disabled = items.length >= MAX;
        document.getElementById('image-count').textContent = `${items.length}/${MAX}`;
    }
    function addFiles(files) {
        for (const file of files) {
            if (items.length >= MAX) break;
            if (!file.type.startsWith('image/')) continue;
            items.push({ file, url: URL.createObjectURL(file), x: 50, y: 50 });
        }
        sync();
    }

    input.addEventListener('change', () => addFiles(input.files));

    const zone = document.querySelector('.portal-image-upload');

    zone.addEventListener('dragover', e => {
        e.preventDefault(); // required, otherwise drop never fires
        zone.classList.add('portal-image-upload--dragover');
    });

    zone.addEventListener('dragleave', e => {
        if (!zone.contains(e.relatedTarget)) {
            zone.classList.remove('portal-image-upload--dragover');
        }
    });

    zone.addEventListener('drop', e => {
        e.preventDefault();
        zone.classList.remove('portal-image-upload--dragover');
        addFiles(e.dataTransfer.files);
    });

    function openModal(item) {
        editing = item;
        preview.src = item.url;
        rx.value = item.x;
        ry.value = item.y;
        updatePreview();
        modal.hidden = false;
    }

    function closeModal() { modal.hidden = true; editing = null; }
    function updatePreview() { preview.style.objectPosition = `${rx.value}% ${ry.value}%`; }

    rx.addEventListener('input', updatePreview);
    ry.addEventListener('input', updatePreview);

    $('save-image-position').addEventListener('click', () => {
        if (editing) { editing.x = +rx.value; editing.y = +ry.value; }
        closeModal();
        sync();
    });
    $('close-image-modal').addEventListener('click', closeModal);
    modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
})();