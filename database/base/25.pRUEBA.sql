-- pruebas
DELETE FROM recepciones;
DELETE FROM detrecepciones;
DELETE FROM EJEMPLARES;
DELETE FROM SOLICITUDES;
DELETE FROM DETSOLICITUDES;
DELETE FROM PRESTAMOS;
DELETE FROM DEVOLUCIONES;
DELETE FROM MANTENIMIENTOS;
DELETE FROM BAJAS;

ALTER TABLE RECEPCIONES AUTO_INCREMENT 1;
ALTER TABLE DETRECEPCIONES AUTO_INCREMENT 1;
ALTER TABLE EJEMPLARES AUTO_INCREMENT 1;
ALTER TABLE SOLICITUDES AUTO_INCREMENT 1;
ALTER TABLE DETSOLICITUDES AUTO_INCREMENT 1;
ALTER TABLE PRESTAMOS AUTO_INCREMENT 1;
ALTER TABLE DEVOLUCIONES AUTO_INCREMENT 1;
ALTER TABLE MANTENIMIENTOS AUTO_INCREMENT 1;
ALTER TABLE BAJAS AUTO_INCREMENT 1;

SET foreign_key_checks = 1;