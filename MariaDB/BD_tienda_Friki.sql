drop DATABASE tienda_friki;

CREATE DATABASE tienda_friki;
USE tienda_friki;

CREATE TABLE empleado(
	id_empleado INTEGER(2) AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    dni VARCHAR(9)NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(30),
    salario DECIMAL (6,2) NOT NULL,
    contrato DATE NOT NULL,
    jefe_dirige ENUM('S', 'N')DEFAULT ('N'),
    PRIMARY KEY (id_empleado),
    CONSTRAINT uk_empleado_dni UNIQUE(dni)
)ENGINE=InnoDB;

CREATE TABLE cliente(
	id_cliente INTEGER AUTO_INCREMENT,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20),
    clasificacion ENUM('F','N') DEFAULT 'N',
    dni VARCHAR(9) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(30),
    adreca VARCHAR(30),
    PRIMARY KEY (id_cliente),
    CONSTRAINT uk_cliente_dni UNIQUE(dni)
)ENGINE=InnoDB;
 
  CREATE TABLE almacen(
	id_almacen INTEGER(5) AUTO_INCREMENT,
    nombre VARCHAR (30) NOT NULL,
    direccion VARCHAR(20) NOT NULL,
    PRIMARY KEY(id_almacen)
  )ENGINE=InnoDB;
  
CREATE TABLE distribuidor(
	id_distribuidor INTEGER AUTO_INCREMENT, 
    nombre VARCHAR(40) NOT NULL,
    telefono VARCHAR(15) NOT NULL,
    email VARCHAR(30),
    id_almacen INTEGER(5),
    PRIMARY KEY (id_distribuidor),
    CONSTRAINT fk_distribuidor_almacen FOREIGN KEY(id_almacen) REFERENCES almacen(id_almacen)
)ENGINE=InnoDB;

CREATE TABLE producto(
	id_producto INTEGER(5) AUTO_INCREMENT NOT NULL,
    precio DECIMAL(6,2) NOT NULL,
    categoria ENUM('L','F','C','V','P'),
	PRIMARY KEY (id_producto)
)ENGINE=InnoDB;

CREATE TABLE compra(
	id_compra INTEGER AUTO_INCREMENT,
    id_cliente INTEGER,
    id_empleado INTEGER,
    PRIMARY KEY(id_compra, id_cliente, id_empleado),
    CONSTRAINT fk_compra_cliente FOREIGN KEY(id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_compra_empleado FOREIGN KEY(id_empleado) REFERENCES empleado(id_empleado)
)ENGINE=InnoDB;

CREATE TABLE producto_compra(
	id_producto INTEGER,
    id_compra INTEGER,
    PRIMARY KEY(id_producto, id_compra),
    CONSTRAINT fk_producto_compra_producto FOREIGN KEY(id_producto) REFERENCES producto(id_producto),
    CONSTRAINT fk_producto_compra_compra FOREIGN KEY (id_compra)REFERENCES compra(id_compra)
)ENGINE=InnoDB;

CREATE TABLE provee(
	id_provee INTEGER AUTO_INCREMENT,
    cantidad INTEGER NOT NULL,
	id_distribuidor INTEGER,
    id_producto INTEGER(5),
    PRIMARY KEY(id_provee, id_distribuidor, id_producto),
    CONSTRAINT fk_provee_distribuidor FOREIGN KEY (id_distribuidor) REFERENCES distribuidor(id_distribuidor),
    CONSTRAINT fk_provee_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
    CONSTRAINT uk_id_producto UNIQUE (id_producto)
)ENGINE=InnoDB;

CREATE TABLE comic(
	id_producto_comic INTEGER(5),
	titulo VARCHAR(40) NOT NULL,
    genero VARCHAR(15),
    edicion INTEGER(2) NOT NULL,
    editorial VARCHAR(20),
    PRIMARY KEY(id_producto_comic),
    CONSTRAINT fk_comic_producto FOREIGN KEY (id_producto_comic) REFERENCES producto(id_producto)
)ENGINE=InnoDB;

CREATE TABLE videojuego(
	id_producto_videojuego INTEGER(5),
	titulo VARCHAR(40)NOT NULL,
    genero VARCHAR(15),
    desarolladora VARCHAR(20),
    edicion ENUM("Basica","Deluxe"),
    anio_salida INTEGER(4),
    pegi TINYINT(2)NOT NULL DEFAULT(0),#restriccion de edad
    PRIMARY KEY(id_producto_videojuego),
	CONSTRAINT fk_videojuego_producto FOREIGN KEY (id_producto_videojuego) REFERENCES producto(id_producto),
	CONSTRAINT ck_videojuego_anio_salida CHECK(anio_salida > 2010 )
)ENGINE=InnoDB;

CREATE TABLE camiseta(
	id_producto_camiseta INTEGER(5),
	talla ENUM("S","L","XL") NOT NULL,
    modelo TINYINT(2),
    PRIMARY KEY (id_producto_camiseta),
	CONSTRAINT fk_camiseta_producto FOREIGN KEY (id_producto_camiseta) REFERENCES producto(id_producto)
)ENGINE=InnoDB;

CREATE TABLE figura(
	id_producto_figura INTEGER(5),
    edicion TINYINT(2),
    material ENUM("banpresto","resina"),
    PRIMARY KEY (id_producto_figura),
	CONSTRAINT fk_figura_producto FOREIGN KEY (id_producto_figura) REFERENCES producto(id_producto)
)ENGINE=InnoDB;

CREATE TABLE poster(
	id_producto_poster INTEGER(5),
    material ENUM ("tela","carton","plastico"),
    PRIMARY KEY(id_producto_poster),
	CONSTRAINT fk_poster_producto FOREIGN KEY (id_producto_poster) REFERENCES producto(id_producto)
)ENGINE=InnoDB;
 
  
ALTER TABLE empleado
	ADD INDEX ix_empleat_dni (dni);
    
ALTER TABLE cliente
	ADD INDEX ix_cliente_dni(dni);
    
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato,jefe_dirige,email) VALUE ('Roberto','Gonzalez','34672124L','666777888',1240.39,'1999-11-03','S','rgonzalez@gmail.com');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Belen','Gomez','35748764C','666768789',1100.10,'2009-10-23');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Camilo','Perez','36767867A','634976242',1080.10,'2010-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Helena','Principal','37890098D','687429876',1000.80,'2011-09-12');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Sergio','Garcia','38110924E',NULL,888.20,'2012-12-12');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Claudia','Santiago','39998761F',NULL,1090.20,'2017-01-09');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato, email) VALUE ('Mauri','Garcia','40121587G','634459768',909.20,'2000-01-01','mgarcia@gmail.com');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Maria','Milan','41879856H','680496864',1000.10,'2020-09-18');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Armando','Gepeto','42220987I',NULL,1200.89,'2022-09-19');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato,jefe_dirige,email) VALUE ('Nuria','Carolain','45879898J',NULL,1000.10,'1999-12-12','S','ncarolain@gmail.com');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Martin','Viñeda','24543231K','6389236470',1000.00,'1999-6-03');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato,jefe_dirige) VALUE ('Ana','Ramirez','37827653Z','6098901278',1300.50,'1991-11-03','S');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Magallanes','Cortes','23987654O','623009873',1111.20,'2020-11-03');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Eugenio','Martinez','20093499B','678943843',890.90,'1999-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Antonio','Perez','38849831I','623009873',999.90,'1999-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Saira','Gomez','32349831Y','623009273',1002.90,'2023-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Alejandro','Velez','32849831Q','698709873',760.90,'2009-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Lorena','Hernandez','38842831W','622209873',989.90,'2001-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Carlos','Lara','38849231E','623003273',900.90,'2010-11-30');
INSERT INTO empleado (nombre,apellido,dni,telefono,salario,contrato) VALUE ('Marina','Modesto','38849331S','623002373',890.90,'2009-02-22');


INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Dani','Ochoa','23987145A','612334567','dochoa@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('David','Llanos','24567890B','623456789');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Miriam','Montes','26673465C','600099900');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Camila','Luque','24987682D','657567567');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Fargan','Santiago','45879900E','654554123');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Jordi','Garcia','34567890F','678123890');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Ana','Alcudia','40506070G','656876643');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Maite','Galan','34345050H','678767689');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Carla','Bernabeu','33333333I',654555467,'cbernabeu@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Lisa','Galan','49490909J','686868686');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Ana','Galindo','49234909J','609282426');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Lisa','Martinez','40983909S','688722926','limartinez@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Angeles','Principal','42222909A','680923846','anprincipal@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Manuel','Santiago','48736209F','683434526');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Esteban','Urrutia','40983209F','623452556');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Mauricio','Bilches','49398209L','678358346','mabilches@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Julia','Azalea','40998809M','609487326','juazalea@gmail.com');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Daniel','Milan','47462809H','699847236');
INSERT INTO cliente (nombre,apellido,dni,telefono) VALUE ('Carlos','Ulloa','49987722J','672898496');
INSERT INTO cliente (nombre,apellido,dni,telefono,email) VALUE ('Carmen','Perez','49409209D','609999996','caperez@gmail.com');

INSERT INTO almacen(nombre, direccion) VALUE ('Grup Manga Almacenes', 'c/ undostres'),('Almacenes Novelas', 'c/ Franscesc'),('Almacen Roba','c/Ample');
INSERT INTO almacen(nombre, direccion) VALUE ('Almacenes Marta','c/ Calsina'),('Almacenes Videojuegos','c/ Castellar'),('Almacenes para Lectores','c/ Maria Aurelia'), ('FullGamers Almacen', 'c/ asdfg');

INSERT INTO distribuidor (nombre,telefono,id_almacen) VALUE ('Roba i mes','650122345',3),('Clothing','650122346',4),('games R','650122454',5),('4gamers','650122435',7),('ComicsNews','650122666',1);
INSERT INTO distribuidor (nombre,telefono, id_almacen) VALUE ('Lectors','650122234',1),('Comics Fundation','650122342',2),('Comic SL','650122356',1),('Mega Comics','650122111',6),('Frikomics','650122222',6);
INSERT INTO distribuidor (nombre,telefono, id_almacen) VALUE ('Lectors Horror','611313344',2),('Videojuegos Indiegame','609284512',7),('Comic SL','610928452',2),('Todo tallas','612241415',3),('Figuras SL','650132141',7);
INSERT INTO distribuidor (nombre,telefono, id_almacen) VALUE ('Para Lectores','650256667',6),('Clothing For','661361717',4),('Roba SL','652151521',3),('Resina i Banpresto','651251251',1),('Mercha tallas','651241551',4);

INSERT INTO producto (precio,categoria) VALUE (14.99,'L'),(18.99,'L'),(20.99,'L'),(25.99,'P'),(30.50,'P'),(10.99,'P'),(12.99,'C'),(12.99,'C');
INSERT INTO producto (precio,categoria) VALUE (13.99,'C'),(49.99,'F'),(1499.90,'F'),(124.99,'F'),(79.99,'V'),(99.99,'V'),(129.99,'V');
INSERT INTO producto (precio,categoria) VALUE (13.99,'L'),(49.99,'V'),(90.50,'P'),(190.99,'F'),(79.99,'V'),(24.99,'C'),(4.59,'P'),(35.50,'P'),(5.40,'F'),(13.02,'F');


INSERT INTO comic (id_producto_comic, titulo,edicion,editorial) VALUE (1,'BOKU NO HERO ACADEMIA',1,'Planeta Cómic ');
INSERT INTO comic (id_producto_comic,titulo,edicion,editorial) VALUE (2,'ONE PIECE NOVELA',1,'Planeta Cómic ');
INSERT INTO comic (id_producto_comic,titulo,edicion,editorial) VALUE (3,'NARUTO ',3,'Planeta Cómic ');
INSERT INTO comic (id_producto_comic,titulo,edicion,editorial) VALUE (4,'Dragon Ball',4,'Planeta Cómic ');
INSERT INTO comic (id_producto_comic,titulo,edicion,editorial) VALUE (5,'Universo Marvel',6,'Planeta Cómic ');

INSERT INTO camiseta (id_producto_camiseta,talla,modelo) VALUE (21,'S',1),(22,'L',2),(23,'S',3),(24,'L',5),(25,'XL',4);

INSERT INTO figura (id_producto_figura,edicion,material) VALUE (11,1,'banpresto'),(12,NULL,'resina'),(13,1,'banpresto'),(14,2,'banpresto'),(15,3,'banpresto');

INSERT INTO poster (id_producto_poster,material) VALUE (6,'tela'),(7,'plastico'),(8,'tela'),(9,'plastico'),(10,'tela');

INSERT INTO videojuego (id_producto_videojuego,titulo,genero,desarolladora,edicion,anio_salida,pegi) VALUE (16,'Minecraft','Sandbox','Mojang Studios','Basica',2011,7);
INSERT INTO videojuego (id_producto_videojuego,titulo,genero,desarolladora,edicion,anio_salida,pegi) VALUE (17,'Elden Ring','Rol de accion','FromSoftware','Basica',2022,16);
INSERT INTO videojuego (id_producto_videojuego,titulo,genero,desarolladora,edicion,anio_salida,pegi) VALUE (18,'Stray','Aventura','BlueTwelve Studio','Basica',2022,12);
INSERT INTO videojuego (id_producto_videojuego,titulo,genero,desarolladora,edicion,anio_salida,pegi) VALUE (19,'Pokemon','Aventura','Game Freak','Basica',2022,12);
INSERT INTO videojuego (id_producto_videojuego,titulo,genero,desarolladora,edicion,anio_salida,pegi) VALUE (20,'Fifa','Deportes','Electronic Arts','Basica',2022,12);

INSERT INTO compra(id_cliente,id_empleado) VALUE (4,5),(3,4),(2,5),(4,2),(7,2),(9,7),(3,6),(4,10),(1,1),(1,9);
INSERT INTO compra(id_cliente,id_empleado) VALUE (10,5),(16,4),(18,5),(4,19),(1,2),(9,8),(3,9),(11,10),(12,1),(4,9),(3,1);


INSERT INTO producto_compra (id_producto,id_compra) VALUE (7,1),(17,2),(2,3),(1,4),(22,4),(23,5),(3,6),(1,7),(3,8),(2,9),(2,10),(13,11),(25,12),(11,13),(2,14),
(25,15),(11,16),(12,17),(5,18),(3,19),(12,20),(14,21);


INSERT INTO provee (cantidad,id_distribuidor,id_producto) VALUE (5,1,2),(3,2,1),(6,3,4),(20,4,6),(32,5,10),(11,6,3),(10,7,13),(34,8,14),(22,9,19),(11,10,20);
INSERT INTO provee (cantidad,id_distribuidor,id_producto) VALUE (1,1,12),(10,2,11),(70,3,22),(35,4,24),(110,5,18),(13,6,5),(22,7,8),(22,8,9),(34,9,21),(50,10,25);

