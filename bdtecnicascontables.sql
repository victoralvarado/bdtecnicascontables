CREATE DATABASE bdtecnicascontables
CHARACTER SET utf8
COLLATE utf8_spanish_ci;

use reto;


create table Usuario(
 id int unsigned AUTO_INCREMENT primary key,
 nombre varchar(50),
 usuario varchar(25),
 contra varchar(25),
 intentos int unsigned default 5,
 estado enum('activo','desactivado','bloqueado')
);



create table Producto(
 id int unsigned AUTO_INCREMENT primary key,
  nombre varchar(50),
  existencias int unsigned default 0,
  precio decimal(10,4),
  costo decimal(10,4),
  descripcion varchar(255),
  imagen varchar(255),
  codigo varchar(15)
) ENGINE=INNODB;



create table Movimiento(
 id int unsigned AUTO_INCREMENT primary key,
 producto int unsigned,
 cantidad int unsigned,
 ultima_existencia int unsigned default 0,
 precio decimal(10,4),
 costo decimal(10,4),
 ultimo_costo decimal(10,4),
 descripcion varchar(255),
 constraint fk_move_product Foreign key (producto) references Producto(Id) on update cascade on delete no action
) ENGINE=INNODB;




create table Cliente(
 id int unsigned AUTO_INCREMENT primary key,
 nombre varchar(255),
 clasificacion enum('ninguno', 'pequeño', 'mediano', 'gran contribuyente'),
 direccion varchar(255),
 nit varchar(15),
 nrc varchar(10),
 razon_social varchar(255),
 giro varchar(255),
 telefono varchar(12)
) ENGINE=INNODB;



create table Documento_serie(
 id int unsigned AUTO_INCREMENT primary key,
 inicia_desde int unsigned,
 termina_en int unsigned,
 serie varchar(25),
 tipo enum('fcf', 'ccf', 'fex', 'nr', 'nc', 'nd')
) ENGINE=INNODB;



create table Documento(
 id int unsigned AUTO_INCREMENT primary key,
 numero int unsigned,
 serie int unsigned,
 cliente int unsigned,
 fecha datetime,
 documento_anterior int unsigned null,
 anulada_por varchar(50) null,
 anulada_en datetime null,
 motivo_anulacion varchar(255) null,
 afectas decimal(12,2),
 exentas decimal(12,2),
 iva int default 13,
 retencion int default 0,
 condiciones int unsigned default 0,
 datos_cliente text,
 nota_remision int unsigned null,
 creacion datetime,
 creado_por varchar(50),
 caso enum('afectas', 'exentas'),
 constraint fk_document_serie Foreign key (serie) references Documento_serie(Id) on update cascade on delete no action,
 constraint fk_document_client Foreign key (cliente) references Cliente(Id) on update cascade on delete no action
) ENGINE=INNODB;



create table Detalle_Documento(
 id int unsigned AUTO_INCREMENT primary key,
 documento int unsigned not null,
 producto int unsigned null,
 cant int unsigned not null,
 price decimal(10,2),
 constraint fk_document_detail Foreign key (documento) references Documento(Id) on update cascade on delete no action,
 constraint fk_detail_product Foreign key (producto) references Producto(Id) on update cascade on delete no action
) ENGINE=INNODB;



create table Proveedor(
 id int unsigned AUTO_INCREMENT primary key,
 tipo enum('local', 'extranjero'),
 clasificacion enum('ninguno', 'pequeño', 'mediano', 'gran contribuyente'),
 nit varchar(15),
 nrc varchar(10),
 nombre varchar(255),
 razon_social varchar(255),
 direccion varchar(255),
 telefono varchar(12)
) ENGINE=INNODB;



create table Compra(
 id int unsigned AUTO_INCREMENT primary key,
 afectas decimal(12,2),
 iva decimal(10,2),
 retencion decimal(10,2),
 proveedor int unsigned,
 fecha datetime,
 registrado_por varchar(50),
 condiciones int unsigned default 0,
 constraint fk_purchase_supplier Foreign key (proveedor) references Proveedor(Id) on update cascade on delete no action
) ENGINE=INNODB;



create table Detalle_Compra(
 id int unsigned AUTO_INCREMENT primary key,
 compra int unsigned not null,
 producto int unsigned null,
 cant int unsigned not null,
 price decimal(10,2),
 constraint fk_purchase_detail_product Foreign key (producto) references Producto(Id) on update cascade on delete no action,
 constraint fk_purchase_detail Foreign key (compra) references Compra(Id) on update cascade on delete no action
) ENGINE=INNODB;



create table c_Cuentas(
 id int unsigned AUTO_INCREMENT primary key,
 rubro enum('ACTIVO', 'PASIVO', 'CAPITAL', 'COSTOS y GASTOS', 'INGRESOS'),
 agrupacion enum('Activo corriente', 'Activo no corriente', 'Pasivo Corriente', 'Pasivo no Corriente'),
 cuenta int unsigned not null,
 nombre varchar(255),
 codigo varchar(10),
 debe decimal (12,2),
 haber decimal (12,2),
 tipo_saldo enum('deudor', 'acreedor'),
 cuenta_padre int unsigned null
) ENGINE=INNODB;





create table c_Partida(
 id int unsigned AUTO_INCREMENT primary key,
 fecha datetime,
 debe decimal (12,2),
 haber decimal (12,2),
 descripcion varchar(255),
 compra_relacionada int unsigned null,
 venta_relacionada int unsigned null,
 plantilla_predeterminada int unsigned null,
 partida_reversion int unsigned null,
 partida_revertida int unsigned null
) ENGINE=INNODB;



create table c_detallePartida(
 id int unsigned AUTO_INCREMENT primary key,
 partidaId int unsigned not null,
 cuentaId int unsigned not null,
 debe decimal(12,2),
 haber decimal(12,2),
 parcial decimal(12,2),
 padre int unsigned,
 constraint fk_partida_detalle foreign key (partidaId) references c_Partida(Id) on update cascade on delete no action,
 constraint fk_detalle_cuenta foreign key (cuentaId) references c_Cuentas(Id) on update cascade on delete no action
) ENGINE = INNODB;



create table c_Saldo(
 id int unsigned primary key AUTO_INCREMENT,
 cuentaId int unsigned not null,
 debe decimal(12,2),
 haber decimal(12,2) default 0.00,
 hasta datetime not null,
 constraint fk_saldo_cuenta foreign key (cuentaId) references c_Cuentas(Id) on update cascade on delete no action
) ENGINE = INNODB;