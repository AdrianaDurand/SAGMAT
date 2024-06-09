function completefields() {
    Swal.fire({
        icon: 'error',
        title: 'Complete los campos...',
        text: 'Por favor complete todos los campos requeridos correctamente.',
    });
}

function addresource() {
    Swal.fire({
        icon: "warning",
        title: 'Añada un recurso',
        text: 'Por favor añada y complete los números de serie',
    }).then(() => {
        //borde del botón brillante
        const botonAgregar = document.getElementById('btnAgregar');
        botonAgregar.classList.add('brillar');
    });
}

function cantidadenviada() {
    Swal.fire({
        icon: "error",
        title: 'Error en las cantidades',
        text: 'La cantidad recibida debe ser menor o igual que la cantidad enviada.',
    });
}

function showDuplicateSerialNumberError(inputsNumerosDeSerie, numeroSerie, toggleInputError) {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Existen números de serie duplicados. Por favor, verifique y corrija los errores.',
    }).then(() => {
        inputsNumerosDeSerie.forEach(i => {
            if (i.value.trim() === numeroSerie) {
                toggleInputError(i, true); 
                i.addEventListener('input', () => toggleInputError(i, false), { once: true }); // escribiendo
            } else {
                toggleInputError(i, false); 
            }
        });
    });
}

function store() {
    return new Promise((resolve) => {
        Swal.fire({
            title: '¿Desea guardar la recepción?',
            text: "Asegúrate de que toda la información es correcta.",
            icon: 'question',
            showCancelButton: true,
            confirmButtonColor: '#28a745',
            cancelButtonColor: '#dc3545',
            confirmButtonText: 'Sí, guardar',
            cancelButtonText: 'No, cancelar',
        }).then((result) => {
            resolve(result); 
        });
    });
}

function successfulreception() {
    Swal.fire({
        icon: "success",
        title: 'Recepción exitosa',
        text: 'La recepción ha sido registrada correctamente',
        showConfirmButton: false
    });
}

function guardarRecurso() {
    Swal.fire({
        title: '¿Está seguro de guardar?',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#3085d6',
        cancelButtonColor: '#d33',
        confirmButtonText: 'Sí, guardar',
        cancelButtonText: 'Cancelar'
    }).then((result) => {
        if (result.isConfirmed) {
            registrarRecurso();
        }
    });
}

function finalizando() {
    Swal.fire({
        title: 'Éxito',
        text: 'Recurso registrado correctamente',
        icon: 'success',
        timer: 1500,
        showConfirmButton: false
    });
}