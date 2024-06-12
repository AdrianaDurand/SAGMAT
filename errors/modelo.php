<!DOCTYPE html>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet">

<html>
<head>
  <style>
    .pagination {
      display: flex;
      justify-content: center;
      margin: 20px;
    }
    
    .pagination-item {
      width: 40px;
      height: 40px;
      background-color: #fff;
      border: 1px solid #cecece;
      border-radius: 20%; /* Borde redondeado */
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      margin: 10px;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #000;
    }
    
    .pagination-item.active {
      color: #2c7be5;
      font-weight: bold;
    }
    
    .pagination-arrow {
      font-size: 24px;
      margin: 10px;
      cursor: pointer;
      border: 1px solid #cecece;
      border-radius: 20%; /* Borde redondeado */
      width: 40px;
      height: 40px;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    
    .pagination-arrow.disabled {
      color: #808080; 
      cursor: not-allowed;
    }
  </style>
</head>
<body>
  <div class="pagination">
    <div class="pagination-arrow" id="prev">&laquo;</div>
    <div class="pagination-item" id="item-1" data-page="1">1</div>
    <div class="pagination-item" id="item-2" data-page="2">2</div>
    <div class="pagination-item" id="item-3" data-page="3">3</div>
    <div class="pagination-arrow" id="next">&raquo;</div>
  </div>

  <script>
    let currentPage = 1;
    let totalPages = 3;

    // Función para cambiar la página
    function changePage(page) {
      currentPage = page;
      updatePagination();
    }

    // actualizar la paginación
    function updatePagination() {
      //desactivar todas las cajas
      document.querySelectorAll('.pagination-item').forEach(item => item.classList.remove('active'));

      // activar la caja actual
      document.querySelector(`#item-${currentPage}`).classList.add('active');

      // desactivar/activar flechas según la página actual
      document.getElementById('prev').classList.toggle('disabled', currentPage === 1);
      document.getElementById('next').classList.toggle('disabled', currentPage === totalPages);

      // deshabilitar o habilitar las flechas según la página actual
      document.getElementById('prev').style.pointerEvents = currentPage === 1 ? 'none' : 'auto';
      document.getElementById('next').style.pointerEvents = currentPage === totalPages ? 'none' : 'auto';
    }

    //agregar eventos a las flechas
    document.getElementById('prev').addEventListener('click', () => {
      if (currentPage > 1) {
        changePage(currentPage - 1);
      }
    });

    document.getElementById('next').addEventListener('click', () => {
      if (currentPage < totalPages) {
        changePage(currentPage + 1);
      }
    });

    // Agregar eventos a las cajas
    document.querySelectorAll('.pagination-item').forEach(item => {
      item.addEventListener('click', () => {
        changePage(parseInt(item.dataset.page));
      });
    });

    // Inicializar la paginación
    updatePagination();
  </script>
</body>
</html>