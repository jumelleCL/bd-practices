USE tienda_friki;

-- Procedimiento para consultar el significado de los enum en la columna de categoria en la tabla de productos
DELIMITER //
CREATE PROCEDURE categoria(IN categoria_consultar VARCHAR(1)) -- Un varchar por si el enum no existe mostrar un mensaje
	BEGIN 
		CASE categoria_consultar
		WHEN('L') THEN
        SET @producto := 'Libros';
        WHEN('F') THEN
        SET @producto := 'Figuras';
        WHEN('C')THEN
        SET @producto :=  'Camisetas';
        WHEN('V') THEN
        SET @producto :=  'Videojuegos';
        WHEN('P')THEN
        SET @producto :=  'Posters';
        ELSE
        SET @producto := 'No existe esa categoria.';
        END CASE;
        SELECT @producto AS categoria;
END //
DELIMITER ;
CALL categoria('P'); CALL categoria('C');CALL categoria('F');CALL categoria('y');

-- Procedimiento para insertar compras hechas
DELIMITER //
CREATE PROCEDURE compra (IN cliente INTEGER, empleado INTEGER, producto INTEGER)
	BEGIN
		INSERT INTO compra(id_cliente, id_empleado) VALUES (cliente, empleado);
        SET @id_insert = LAST_INSERT_ID();
        INSERT INTO producto_compra(id_compra, id_producto) VALUES(@id_insert,producto);
END  //
DELIMITER ;
CALL compra(2,6,21);CALL compra(8,2,1);CALL compra(12,16,7);

-- Procedimiento tipo while para mostrar la suma de los salarios de un rango de empleados
DELIMITER //
CREATE PROCEDURE salari_empleats (IN inicio INTEGER, fin INTEGER)
BEGIN
SET @var := inicio; 
SET @salari :=0;
	WHILE(@var<=fin) DO 
    SET @salari= @salari+(
    SELECT salario
		FROM empleado
        WHERE id_empleado = @var);
	SET @var = @var+1;
    END WHILE;
    SELECT @salari AS total_salario;
END //
DELIMITER ;

CALL salari_empleats(2,7); CALL salari_empleats(12,13); CALL salari_empleats(1,20);
-- Procedimiento tipo loop para contar el precio de un producto por x cantidad
DELIMITER //
CREATE PROCEDURE suma_precio(IN producte INTEGER, cantidad INTEGER)
BEGIN
SET @var = 0; SET @precio = 0;
	bucle: LOOP 
    SET @var = @var+1;
    SET @precio = @precio+(
		SELECT precio 
			FROM producto
            WHERE id_producto = producte
    );
    IF(@var=cantidad)THEN LEAVE bucle;
    END IF;
    END LOOP bucle;
    SELECT @precio AS precio_total;
END //
DELIMITER ;

CALL suma_precio(2,5); CALL suma_precio(12, 22); CALL suma_precio(5,3);

-- Procedimiento para consultar cuantos clientes atendio un empleado
DELIMITER //
CREATE PROCEDURE att_cliente (IN empleado INTEGER)
BEGIN
	SELECT COUNT(id_compra) AS cantidad_clientes_atendidos
		FROM compra
        WHERE id_empleado = empleado;
END //
DELIMITER ;
CALL att_cliente(5); CALL att_cliente(8); CALL att_cliente(1);

-- Procedimiento tipo repeat para realizar el procedimiento anterior pero en un rango de empleados
DELIMITER //
CREATE PROCEDURE att_cliente_rango (IN empleado_in INTEGER, empleado_final INTEGER)
BEGIN
SET @empleado_actual = empleado_in;
SET @contador := 0;
REPEAT 
	SET @contador = @contador+(SELECT COUNT(id_compra) AS cantidad_clientes_atendidos
		FROM compra
        WHERE id_empleado = @empleado_actual);
	SET @empleado_actual = @empleado_actual +1;
UNTIL(@empleado_actual = empleado_final)
END REPEAT;
SELECT @contador AS clientes_atendidos_rango;
END //
DELIMITER ;

CALL att_cliente_rango(3,7); CALL att_cliente_rango(1,2); CALL att_cliente_rango(1,20);

-- Procedimiento con case para insertar datos en la tabla comic, si no es en ella saldra un mensaje 
DELIMITER //
CREATE PROCEDURE datosComic(IN datoPrecio DECIMAL(6,2),datoCategoria ENUM ('L','F','C','V','P'),datoTitulo VARCHAR(40),datoEditorial VARCHAR(20),datoEdicion INTEGER(2))
BEGIN
    CASE datoCategoria 
    WHEN 'C' THEN 
    INSERT INTO producto (precio,categoria) VALUE(datoPrecio,datoCategoria);
    SET @id_insertar = LAST_INSERT_ID();
    INSERT INTO comic (id_producto_comic, titulo,edicion,editorial) VALUE (@id_insertar,datoTitulo,datoEdicion,datoEditorial);
    ELSE SET @mensaje = 'Solo se pueden insertar comics';
    END CASE;
    IF (datoCategoria) NOT LIKE 'C' THEN
    SELECT @mensaje;
    END IF;
END //
DELIMITER ;

CALL datosComic (13.50,'C','Lookism','Naver',8);
CALL datosComic(122.22, 'V','Lookism','Naver',6);

-- Procedimiento para contar la totalidad de los productos
DELIMITER //
CREATE PROCEDURE cuantitatProducte()
BEGIN
    SET @total = (SELECT count(id_producto) FROM producto);
    SELECT @total;
END //
DELIMITER ;
CALL cuantitatProducte();

-- Procedimiento para eliminar inserts de la compra
DELIMITER //
CREATE PROCEDURE eliminarCompra(IN idCompra INTEGER)
BEGIN
	DELETE FROM producto_compra WHERE id_compra = idCompra;
	DELETE FROM compra WHERE id_compra = idCompra;
END //
DELIMITER ; 
CALL eliminarCompra(21);CALL eliminarCompra(6);CALL eliminarCompra(2);