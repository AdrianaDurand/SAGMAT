
// sweetalert.js

function showSaveChangesConfirmationFinally() {
    return Swal.fire({
        title: "¿Deseas finalizar la recepción?",
        icon: "question",
        showDenyButton: true,
        confirmButtonText: "Finalizar y Guardar",
        denyButtonText: `No guardar cambios`,
    }).then((result) => {
        if (result.isConfirmed) {
            return { isConfirmed: true }; 
        } else {
            return { isDenied: true }; 
        }
    });
}

function showSaveChangesConfirmationContinue() {
    return Swal.fire({
        title: "¿Estás seguro de registrar estos recursos?",
        icon: "question",
        showDenyButton: true,
        confirmButtonText: "Si",
        denyButtonText: `No`,
    }).then((result) => {
        if (result.isConfirmed) {
            return { isConfirmed: true }; 
        } else {
            return { isDenied: true }; 
        }
    });
}

function datosregistrados() {
    return Swal.fire({
        position: "top-end",
        icon: "success",
        title: "¡Recepción registrada con éxito!",
        showConfirmButton: false,
        timer: 4000
    });
}

