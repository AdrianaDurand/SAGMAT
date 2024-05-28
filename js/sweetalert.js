<script src="../../css//probandoboton.css"></script>

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
        // Después de que se cierre la alerta, haz que el borde del botón brille
        const botonAgregar = document.getElementById('btnAgregar');
        botonAgregar.classList.add('brillar');
    });
}
