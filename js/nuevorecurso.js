function addrow() {
    var caracteristicasContainer = document.getElementById("datasheets");

    var nuevaFila = document.createElement("div");
    nuevaFila.classList.add("row");

    nuevaFila.innerHTML = `
            <div class="mb-3">
                <div class="row">
                    <div class="col-md-5">
                        <input type="text" class="form-control border car" placeholder="Característica" required>
                    </div>
                    <div class="col-md-5">
                        <input type="text" class="form-control border det" placeholder="Detalle" required>
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="button" class="btn btn-white border btnEliminarFila"><i class="bi bi-x-lg"></i></button>
                    </div>
                </div>
            </div>
            `;

    caracteristicasContainer.appendChild(nuevaFila);
}

document.getElementById("btnAgregarCaracteristica").addEventListener("click", function() {
    addrow();
});
// evento del botón de eliminar fila
document.addEventListener("click", function(event) {
    if (event.target.classList.contains("btnEliminarFila")) {
        event.target.closest(".row").remove(); // Con esto se elimina la fila más cercana al botón
    }
});

function gettypes() {
    const parametros = new FormData();
    parametros.append("operacion", "listar");

    fetch(`../../controllers/tipo.controller.php`, {
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
            console.log(datos)
            datos.forEach(element => {
                const tagOption = document.createElement("option");
                tagOption.innerText = element.tipo;
                tagOption.value = element.idtipo;
                document.querySelector("#idtipo").appendChild(tagOption)
            });
        })
        .catch(e => {
            console.error(e);
        });
}

function getbrands() {
    const parametros = new FormData();
    parametros.append("operacion", "listar");

    fetch(`../../controllers/marca.controller.php`, {
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
            datos.forEach(element => {
                const tagOption = document.createElement("option");
                tagOption.innerText = element.marca;
                tagOption.value = element.idmarca;
                document.querySelector("#idmarca").appendChild(tagOption)
            });
        })
        .catch(e => {
            console.error(e);
        });
}


function registrarRecurso() {
    // Realizar el registro del recurso
    const idtipo = document.querySelector("#idtipo").value;
    const idmarca = document.querySelector("#idmarca").value;
    const descripcion = document.querySelector("#descripcion").value;
    const modelo = document.querySelector("#modelo").value;

    // Verificar si ya existe el recurso
    const recursosRegistrados = JSON.parse(localStorage.getItem('recursos') || '[]');
    const recursoExistente = recursosRegistrados.find(recurso => recurso.idmarca === idmarca && recurso.modelo === modelo);

    if (recursoExistente) {
        alert("No se puede registrar un recurso existente.");
        return;
    }

    const carInputs = document.querySelectorAll(".form-control.border.car");
    const detInputs = document.querySelectorAll(".form-control.border.det");

    const datasheets = [];
    carInputs.forEach((carInput, index) => {
        datasheets.push({
            clave: carInput.value.trim(),
            valor: detInputs[index].value.trim()
        });
    });

    const parametros = new FormData();
    parametros.append("operacion", "registrar");
    parametros.append("idtipo", idtipo);
    parametros.append("idmarca", idmarca);
    parametros.append("descripcion", descripcion);
    parametros.append("modelo", modelo);
    parametros.append("datasheets", JSON.stringify(datasheets));
    parametros.append("fotografia", document.querySelector("#fotografia").files[0]);

    fetch(`../../controllers/recurso.controller.php`, {
            method: "POST",
            body: parametros
        })
        .then(respuesta => respuesta.json())
        .then(datos => {
            console.log("registro hecho");
            // Agregar el recurso registrado al localStorage para futuras validaciones
            recursosRegistrados.push({
                idmarca
            });
            localStorage.setItem('recursos', JSON.stringify(recursosRegistrados));

            // Resetear los campos del formulario
            const camposNoResetear = ["idpersonal", "fechayhorarecepcion", "tipodocumento", "nrodocumento", "serie_doc", "observaciones"];
            const inputs = document.querySelectorAll("#form-recurso input, #form-recurso select");

            inputs.forEach(input => {
                if (!camposNoResetear.includes(input.id)) {
                    input.value = ""; // Resetear el valor del campo
                    if (input.tagName === "SELECT") {
                        input.selectedIndex = 0; // Resetear la selección de la opción
                    }
                }
            });

            // Resetear el campo de buscar tipo de recurso y seleccionar el detalle
            document.getElementById("buscar").value = "";
            document.getElementById("detalles").selectedIndex = 0;

            // Limpiar las características agregadas dinámicamente
            const caracteristicasContainer = document.getElementById("datasheets");
            caracteristicasContainer.innerHTML = `
                <div class="col-md-5 mb-3">
                    <input type="text" class="form-control border car" placeholder="Característica" required>
                    </div>
                    <div class="col-md-5 mb-3">
                    <input type="text" class="form-control border det" placeholder="Detalle" required>
                    </div>
                    <div class="col-md-2 d-flex align-items-end mb-3">
                    <button type="button" class="btn btn-white border" id="btnAgregarCaracteristica"><i class="bi bi-plus-lg"></i></button>
                    </div>
                    `;

            // Resetear el estado de los campos deshabilitados
            const camposDeshabilitar = [document.getElementById("idpersonal"), document.getElementById("fechayhorarecepcion"), document.getElementById("tipodocumento"), document.getElementById("nrodocumento"), document.getElementById("serie_doc"), document.getElementById("observaciones")];

            camposDeshabilitar.forEach(campo => {
                // Resetear los campos del formulario
                const camposNoResetear = ["idpersonal", "fechayhorarecepcion", "tipodocumento", "nrodocumento", "serie_doc", "observaciones"];
                const inputs = document.querySelectorAll("#form-recurso input, #form-recurso select");
                campo.disabled = false;
            });
        })
        .catch(error => {

            alert("No se puede agregar un recurso existente.");
        });
}



getbrands();
gettypes();
