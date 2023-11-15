USE tienda_friki;

-- Orden para sacar el id_empleado de un empleado a partir de su nombre y apellido
PREPARE ids FROM 'SELECT id_empleado FROM empleado WHERE nombre = (?) AND apellido = (?)';

SET @var1 = 'Antonio'; SET @var2 = 'Perez'; 
EXECUTE ids USING @var1, @var2;
SET @var1 = 'Antonio'; SET @var2 = 'Gonzalez'; -- El empleado no existe por lo que no saldria nada
EXECUTE ids USING @var1, @var2;
DEALLOCATE PREPARE ids;

-- Orden preparada para actualizar precios de productos
DELIMITER //
CREATE PROCEDURE actualizar_precio_producto(IN id_producto INT, IN nuevo_precio DECIMAL(10,2), OUT actualizado VARCHAR(20))
BEGIN
	SET actualizado = 'Sin Actualizar';
  
	SET @var1 = id_producto; SET @var2 = nuevo_precio;
	PREPARE stmt FROM 'UPDATE producto SET precio = ? WHERE id_producto = ?';
	EXECUTE stmt USING @var2, @var1;
	IF (ROW_COUNT() > 0)
		THEN SET actualizado = 'Actualizado';
	END IF;
	DEALLOCATE PREPARE stmt;
END //
DELIMITER ;

SET @actualizado = '';
CALL actualizar_precio_producto(1,15.99,@actualizado);
SELECT @actualizado;
CALL actualizar_precio_producto(26,15.99,@actualizado);
SELECT @actualizado;

-- Orden para insertar valores 
PREPARE insert_provee FROM 'INSERT INTO provee (cantidad, id_distribuidor, id_producto) VALUES ((?),(?),(?))';
SET @var1 = 12; SET @var2 = 14; SET @var3 = 7;
EXECUTE insert_provee USING @var1,@var2,@var3;
SET @var1 = 17; SET @var2 = 19; SET @var3 = 16;
EXECUTE insert_provee USING @var1,@var2,@var3;
DEALLOCATE PREPARE insert_provee;

-- Orden para saber la cantidad de videojuegos que compro un cliente
PREPARE videojuegosCliente FROM 'SELECT COUNT(c.id_compra) FROM compra c LEFT JOIN producto_compra pc ON c.id_compra = pc.id_compra
LEFT JOIN producto p ON p.id_producto = pc.id_producto WHERE c.id_cliente = (?) AND p.categoria = "V";';

SET @var1 = 3; EXECUTE videojuegosCliente USING @var1;
SET @var1 = 10; EXECUTE videojuegosCliente USING @var1;
SET @var1 = 22; EXECUTE videojuegosCliente USING @var1;

-- Funcion busqueda de comics con titulos
DELIMITER //
CREATE FUNCTION busquedaTitulos(tituloComic VARCHAR(40))
RETURNS INTEGER
BEGIN
    RETURN (SELECT cantidad 
	FROM provee pr
    INNER JOIN producto p ON pr.id_producto = p.id_producto
    INNER JOIN comic c ON c.id_producto_comic = p.id_producto
    WHERE c.titulo = tituloComic);
END // 
DELIMITER ;

-- Función para calcular el total de ventas por categoría de producto
DELIMITER //
CREATE FUNCTION totalCateg(categ ENUM('L', 'F', 'C', 'V', 'P'))
RETURNS INTEGER
BEGIN
	DECLARE total DECIMAL(10,2) DEFAULT 0;
    DECLARE venta DECIMAL(10,2);
    DECLARE fin INT DEFAULT FALSE;
    DECLARE curs CURSOR FOR SELECT precio FROM producto p INNER JOIN producto_compra pc ON pc.id_producto = p.id_producto WHERE p.categoria = categ;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
    
    OPEN curs;
    contar: LOOP
    FETCH curs INTO venta;
		IF fin THEN
        LEAVE contar;
		END IF;
        SET total = total+venta;
	END LOOP;
    CLOSE curs;
    RETURN total;    
END //
DELIMITER ;
SELECT totalCateg('F'); SELECT totalCateg('C');

-- Disparador que actualiza la cantidad de la columna provee (donde se guardan la cantidad de productos que hay) cada vez que se realiza una compra
DELIMITER //
CREATE TRIGGER actualizarCantidad
AFTER INSERT ON producto_compra 
FOR EACH ROW 
BEGIN 
  UPDATE provee 
  SET cantidad = cantidad + 1 
  WHERE id_producto = NEW.id_producto ;
END //
DELIMITER ;

-- Disparador para colocar una clasificacion al cliente de 'Cliente frecuente' una vez que ya haya hecho 5 compras o mas

DELIMITER //
CREATE TRIGGER clienteFrecuente
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE compras INT;
    SELECT COUNT(id_cliente) INTO compras FROM compra WHERE id_cliente = NEW.id_cliente; 
    IF compras >= 5 THEN
        UPDATE cliente
        SET clasificacion = 'F'
        WHERE cliente_id = NEW.id_cliente;
    END IF;
END //
DELIMITER ;


