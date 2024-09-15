const addButton = document.getElementById('add-listitem');
const formset = document.getElementById('listitem-forms');
const template = document.getElementById('empty-form');
const totalFormsInput = document.getElementById('id_listitem_set-TOTAL_FORMS');

// Function to update ORDER fields after sorting
const updateOrder = () => {
    let visibleIndex = 1;
    [...formset.children].forEach(form => {
        if (window.getComputedStyle(form).display !== 'none') {
            form.querySelector('input[name$="-ORDER"]').value = visibleIndex++;
        }
    });
};

// Initialize Sortable
const sortable = new Sortable(formset, {
    onEnd: updateOrder
});

addButton.addEventListener('click', () => {
    const formCount = parseInt(totalFormsInput.value);
    const newForm = template.content.cloneNode(true);

    [...newForm.children].forEach(element => {
        for (const attr of element.attributes) {
            element.setAttribute(
                attr.name,
                attr.value.replace(/__prefix__/g, formCount)
            );
        }
    });

    formset.appendChild(newForm);
    totalFormsInput.value = formCount + 1;
    updateOrder();
});

// Add event listener for changes in DELETE checkboxes
formset.addEventListener('change', event => {
    if (event.target.name && event.target.name.endsWith('-DELETE')) {
        updateOrder();
    }
});
