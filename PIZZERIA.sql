create table USUARIO(
	CI varchar(10) primary key not null,
    NOMBRES varchar(150) not null,
    APELLIDOS varchar(150) not null,
    DIRECCION varchar(200) not null,
    TIPO int not null,
    TURNO int not null,
    CONTRASEÑA varchar(20)
);

create table MENU(
	COD_MENU int primary key auto_increment,
    DESCRIPCION varchar(150) not null,
    PRECIO decimal(8,3),
    TAMANO varchar(100)
);

create table CLIENTE(
	CI_NIT varchar(13) not null primary key,
    NOMBRES varchar(100) not null,
    APELLIDO varchar(100) not null,
    DIRECCION varchar(150) not null
);

create table VENTA
(
    COD_VENTA int primary key auto_increment not null,
    FECHA_VENTA date not null,
    CANTIDAD int not null,
    CI_USUARIO varchar(10),
    foreign key (CI_USUARIO) references USUARIO(CI),
    COD_MENU int not null,
    foreign key (COD_MENU) references MENU(COD_MENU),
    CI_NIT_CLIENTE varchar(13),
    foreign key(CI_NIT_CLIENTE) references CLIENTE(CI_NIT)
);

create view VISTA_EMPLEADO_MENU
as
	select * from Menu;
	
select * from VISTA_EMPLEADO_MENU;

select * from cliente;

create view VISTA_EMPLEADO_CLIENTE
as
	select * from cliente;


create view VISTA_ADMINISTRADOR_VENTA_REALIZADA_POR_ENCARGADOS
as
select usuario.CI,usuario.NOMBRES as NOMBRES_ENCARGADO,usuario.APELLIDOS as APELLIDOS_ENCARGADO,
	   menu.DESCRIPCION, menu.TAMANO,menu.PRECIO,
       cliente.CI_NIT, cliente.NOMBRES as NOMBRE_CLIENTE,cliente.APELLIDO as APELLIDOS_CLIENTE,
       venta.FECHA_VENTA, venta.CANTIDAD,
       (menu.PRECIO * venta.CANTIDAD) as MONTO_SUBTOTAL
from usuario,venta,menu,cliente
where
	usuario.CI=venta.CI_USUARIO and
    menu.COD_MENU = venta.COD_MENU and
    cliente.CI_NIT=venta.CI_NIT_CLIENTE;

alter table MENU add column IMAGEN varchar(300) not null;

create view VISTA_ADMINISTRADOR_MENU
as
	select * from Menu;

create view VISTA_ADMINISTRADOR_REGISTRO_USUARIOS
as
	select * from usuario;


create view VISTA_ADMINISTRADOR_CLIENTES
as
	select * from CLIENTES;

create table VENTAS_BORRADAS
(
    COD_VENTA int primary key auto_increment not null,
    FECHA_VENTA date not null,
    CANTIDAD int not null,
    CI_USUARIO varchar(10),
    COD_MENU int not null,
    CI_NIT_CLIENTE varchar(13)
);

create table VENTAS_EDITADAS
(
    COD_VENTA int primary key auto_increment not null,
    FECHA_VENTA date not null,
    CANTIDAD int not null,
    CI_USUARIO varchar(10),
    COD_MENU int not null,
    CI_NIT_CLIENTE varchar(13)
);

create view VISTA_ADMINISTRADOR_VENTAS_BORRADAS_POR_ENCARGADOS
as
select usuario.CI,usuario.NOMBRES as NOMBRES_ENCARGADO,usuario.APELLIDOS as APELLIDOS_ENCARGADO,
	   menu.DESCRIPCION, menu.TAMANO,menu.PRECIO,
       cliente.CI_NIT, cliente.NOMBRES as NOMBRE_CLIENTE,cliente.APELLIDO as APELLIDOS_CLIENTE,
       ventas_borradas.FECHA_VENTA, ventas_borradas.CANTIDAD,
       (menu.PRECIO * ventas_borradas.CANTIDAD) as MONTO_SUBTOTAL
from usuario,ventas_borradas,menu,cliente
where
	usuario.CI=ventas_borradas.CI_USUARIO and
    menu.COD_MENU = ventas_borradas.COD_MENU and
    cliente.CI_NIT=ventas_borradas.CI_NIT_CLIENTE;
    
create view VISTA_ADMINISTRADOR_PRODUCTOS_CON_MENOR_VENTA
as
	select * from venta
	where
	venta.cantidad<=3;
    


delimiter $$
create procedure INSERTAR_USUARIO
(
	in CI_ENT VARCHAR(10),
    in NOMBRES_ENT varchar(150),
    in APELLIDOS_ENT varchar(150),
    in DIRECCION_ENT varchar(200),
    in TIPO_ENT int,
    in TURNO_ENT int,
    in CONTRASENA_ENT varchar(20),
    out mensaje varchar(50)
)
begin
	if not exists(select * from USUARIO where USUARIO.CI=CI_ENT) then
		insert into usuario values
        (CI_ENT,NOMBRES_ENT,APELLIDOS_ENT,DIRECCION_ENT,TIPO_ENT,TURNO_ENT,CONTRASENA_ENT);
        set mensaje='ESTA INSERCION SE REALIZOO CORRECTAMENTE';
    else
		set mensaje='ESTE USUSARIO YA ESTA REGISTRADO';
    end if;
end$$
delimiter ;


delimiter $$
create procedure EDICION_USUARIO
(
	in CI_ENT VARCHAR(10),
    in NOMBRES_ENT varchar(150),
    in APELLIDOS_ENT varchar(150),
    in DIRECCION_ENT varchar(200),
    in TIPO_ENT int,
    in TURNO_ENT int,
    in CONTRASENA_ENT varchar(20),
    out mensaje varchar(50)
)
begin
	if exists(select * from USUARIO where USUARIO.CI=CI_ENT) then
		update usuario
        set
			NOMBRES=NOMBRES_ENT,
            APELLIDOS=APELLIDOS_ENT,
            DIRECCION=DIRECCION_ENT,
            TIPO=TIPO_ENT,
            TURNO=TURNO_ENT,
            CONTRASEÑA=CONTRASENA_ENT
		where
			usuario.CI=CI_ENT;
        
        set mensaje='ESTE USUARIO SE EDITO CORRECTAMENTE';
    else
		set mensaje='ESTE USUSARIO YA NO ESTA REGISTRADO';
    end if;
end$$
delimiter ;


delimiter $$
create procedure INSERTAR_VENTA
(
    in CANTIDAD_ENT int,
    in CI_USUARIO_ENT varchar(10),
    in COD_MENU_ENT int,
    in CI_NIT_CLIENTE_ENT varchar(13),
    out mensaje varchar(50)
)
begin
	insert into venta
    (
		FECHA_VENTA,
        CANTIDAD,
        CI_USUARIO,
        COD_MENU,
        CI_NIT_CLIENTE
    )
    values
	(now(),CANTIDAD_ENT,CI_USUARIO_ENT, COD_MENU_ENT, CI_NIT_CLIENTE_ENT);
    set mensaje='VENTA REGISTRADA CORRACTAMENTE';
end$$
delimiter ;


delimiter $$
create procedure EDITAR_VENTA
(
    in COD_VENTA_ENT int,
    in CANTIDAD_ENT int,
    in CI_USUARIO_ENT varchar(10),
    in COD_MENU_ENT int,
    in CI_NIT_CLIENTE_ENT varchar(13),
    out mensaje varchar(50)
)
begin
	if exists(select * from venta where venta.cod_venta=cod_venta_ent) then
		update venta
		set
			FECHA_VENTA=now(),
			CANTIDAD=CANTIDAD_ENT,
			CI_USUARIO=CI_USUARIO_ENT,
			COD_MENU=COD_MENU_ENT,
			CI_NIT_CLIENTE=CI_NIT_CLIENTE_ENT
		where
			venta.COD_VENTA=COD_VENTA_ENT;
		set mensaje='SE ACTUALIZO VENTA CORRECTAMENTE';
	else
		set mensaje='LA VENTA NO EXISTE';
	end if;
end$$
delimiter ;


delimiter $$
create procedure ELIMINAR_VENTA
(
    in COD_VENTA_ENT int,
    out mensaje varchar(50)
)
begin
	if exists(select * from venta where venta.cod_venta=cod_venta_ent) then
		delete from venta
		where
			venta.COD_VENTA=COD_VENTA_ENT;
		set mensaje='SE BORRO LA VENTA CORRECTAMENTE';
	else
		set mensaje='LA VENTA SELECCIONADA NO EXISTE';
	end if;
end$$
delimiter ;


delimiter $$
create procedure INSERTAR_MENU
(
	in DESCRIPCION_ENT varchar(150),
    in PRECIO_ENT decimal(8,3),
    in TAMANO_ENT varchar(100),
    in IMAGEN_ENT varchar(300),
    out mensaje varchar(50)
)
begin
	insert into menu
    (
		DESCRIPCION,
        PRECIO,
        TAMANO,
        IMAGEN
    )
    values
    (DESCRIPCION_ENT,PRECIO_ENT,TAMANO_ENT,IMAGEN_ENT);
    set mensaje='MENU INSERTADO CORRECTAMENTE';
end$$
delimiter ;


delimiter $$
create procedure EDITAR_MENU
(
	in COD_MENU_ENT int,
	in DESCRIPCION_ENT varchar(150),
    in PRECIO_ENT decimal(8,3),
    in TAMANO_ENT varchar(100),
    in IMAGEN_ENT varchar(300),
    out mensaje varchar(50)
)
begin
	if exists(select * from menu where menu.COD_MENU=COD_MENU_ENT) then
		update menu
		set
			DESCRIPCION=DESCRIPCION_ENT,
			PRECIO=PRECIO_ENT,
			TAMANO=TAMANO_ENT,
			IMAGEN=IMAGEN_ENT
		where
			menu.COD_MENU=COD_MENU_ENT;
		set mensaje='MENU EDITADO CORRECTAMENTE';
	else
		set mensaje='EL MENU QUE DESEAS EDITAR  NO EXISTE';
	end if;
end$$
delimiter ;

delimiter $$
create procedure ELIMINAR_MENU
(
	in cod_menu_datos int,
    out mensaje varchar(40)
)
begin
	if exists (select * from menu where menu.cod_menu=cod_menu_datos) then
		delete from menu
		where cod_menu=cod_menu_datos;
        set mensaje ="BORRADO EXITOSO";
	else
		set mensaje="NO EXISTE ELEMENTO EN LA BASE DE DATOS";
	end if;
end$$
delimiter ;

delimiter $$
create procedure INSERTAR_CLIENTE
(
	in CI_NIT_ENT VARCHAR(13),
    in NOMBRES_ENT varchar(150),
    in APELLIDOS_ENT varchar(150),
    in DIRECCION_ENT varchar(200),
    out mensaje varchar(50)
)
begin
	if not exists(select * from cliente where cliente.CI_NIT=CI_NIT_ENT) then
		insert into cliente values
        (CI_NIT_ENT,NOMBRES_ENT,APELLIDOS_ENT,DIRECCION_ENT);
        set mensaje='EL CLIENTE SE INSERTO CORRECTAMENTE';
    else
		set mensaje='ESTE CLIENTE YA ESTA REGISTRADO';
    end if;
end$$
delimiter ;


delimiter $$
create procedure EDICION_CLIENTE
(
	in CI_NIT_ENT VARCHAR(10),
    in NOMBRES_ENT varchar(150),
    in APELLIDOS_ENT varchar(150),
    in DIRECCION_ENT varchar(200),
    out mensaje varchar(50)
)
begin
	if exists(select * from cliente where cliente.CI_NIT=CI_NIT_ENT) then
		update cliente
        set
			NOMBRES=NOMBRES_ENT,
            APELLIDO=APELLIDOS_ENT,
            DIRECCION=DIRECCION_ENT
		where
			cliente.CI_NIT=CI_NIT_ENT;
        
        set mensaje='ESTE CLIENTE SE EDITO CORRECTAMENTE';
    else
		set mensaje='ESTE CLIENTE YA NO ESTA REGISTRADO';
    end if;
end$$
delimiter ;


alter table venta modify CI_NIT_CLIENTE varchar(13) null; 

alter table ventas_borradas add column Fecha_borrada datetime not null;

alter table venta drop column Fecha_borrada;

delimiter $$
create trigger VENTA_BORRADA
after delete on venta
for each row
begin
	insert into ventas_borradas
    (
		FECHA_VENTA,
        CANTIDAD,
        CI_USUARIO,
        COD_MENU,
        CI_NIT_CLIENTE,
        Fecha_borrada
    )
    values
    (old.fecha_venta,old.cantidad,old.CI_USUARIO,old.COD_MENU,old.CI_NIT_CLIENTE,now());
end$$
delimiter ;


delimiter $$
create trigger VENTA_EDITADA
BEFORE update on venta
for each row
begin
	insert into ventas_editadas
    (
		FECHA_VENTA,
        CANTIDAD,
        CI_USUARIO,
        COD_MENU,
        CI_NIT_CLIENTE,
        FECHA_EDICION
    )
    values
    (old.fecha_venta,old.cantidad,old.CI_USUARIO,old.COD_MENU,old.CI_NIT_CLIENTE,now());
end$$
delimiter ;

alter table ventas_editadas add column FECHA_EDICION datetime not null;

delimiter $$
create procedure VALIDATE_USER
(
	in NUMERO_USUARIO varchar(10),
    in CONTRASENA varchar(20),
    out mensaje varchar(2)
)
begin
	if exists (select * from usuario  where usuario.CI=NUMERO_USUARIO and usuario.CONTRASEÑA=CONTRASENA) then
		set mensaje='si';
	else
		set mensaje='no';
	end if;
end$$
delimiter ;

call INSERTAR_USUARIO('10454645','FELIPE','MAMANI','CALLE ALONZO S/N',2,2,'123456789',@mensaje);
