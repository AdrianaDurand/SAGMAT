<div class="row">
                            <div class="col-md-6">
                                <label for="fechayhorarecepcion"><strong>Fecha de inicio:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                            </div>
                            <div class="col-md-6">
                                <label for="fechayhorarecepcion"><strong>Fecha de Fin:</strong></label>
                                <input type="datetime-local" class="form-control border" id="fechayhorarecepcion" required max="<?php echo date('Y-m-d\TH:i'); ?>">
                            </div>

                        </div>


                        <div class="col-md-12">
                            <label for="horainicio" class="form-label">Comentarios:</label>
                            <input type="time" class="form-control" id="horainicio">
                        </div>
                        <div class="col-md-12">
                            <label for="horafin" class="form-label">Ficha:</label>
                            <input type="file" class="form-control" id="horafin">
                        </div>