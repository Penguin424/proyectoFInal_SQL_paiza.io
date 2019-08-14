create database tienda;
use tienda;

create table fabricantes(
     clave_fabricante int not null,
     nombre_fabricante varchar(30) not null,
     constraint pk_cf primary key (clave_fabricante)
);

create table articulos(
     clave_articulo int not null,
     nombre_articulo varchar(30) not null,
     precio_articulo int not null,
     clave_fabricante1 int not null,
     constraint pk_ca primary key (clave_articulo),
     constraint fk_cf1 foreign key (clave_fabricante1) references fabricantes(clave_fabricante)
);

create table ventas(
     clave_venta int not null,
     monto_venta int,
     constraint pk_cv primary key (clave_venta)
);

create table articulos_ventas(
     clave_articulo1 int not null,
     cantidad int not null,
     clave_venta1 int not null,
     constraint fk_ca1 foreign key (clave_articulo1) references articulos(clave_articulo),
     constraint fk_cv1 foreign key (clave_venta1) references ventas(clave_venta)
);

insert into  fabricantes values (1,"kingston");
insert into  fabricantes values (2,"adata");
insert into  fabricantes values (3,"logitech");
insert into  fabricantes values (4,"lexar");
insert into  fabricantes values (5,"seagate");

insert into articulos values (1,"teclado",100,3);
insert into articulos values (2,"disco duro 300gb",500,5);
insert into articulos values (3,"mouse",80,3);
insert into articulos values (4,"memoria usb",140,4);
insert into articulos values (5,"memoria ram",290,1);
insert into articulos values (6,"disco duro extraible 250gb",650,5);
insert into articulos values (7,"memoria usb",279,1);
insert into articulos values (8,"dvd rom",450,2);
insert into articulos values (9,"cd rom",200,2);
insert into articulos values (10,"tarjeta de red",180,3);
insert into articulos values (11,"altavoces",120,2);


insert into articulos_ventas values (1,5,1);
insert into articulos_ventas values (2,3,2);
insert into articulos_ventas values (3,2,3);
insert into articulos_ventas values (4,1,2);
insert into articulos_ventas values (5,1,2);
insert into articulos_ventas values (6,3,5);
insert into articulos_ventas values (7,2,4);
insert into articulos_ventas values (8,4,4);
insert into articulos_ventas values (9,1,1);
insert into articulos_ventas values (10,6,3);

insert  into ventas (clave_venta) values (1);
insert  into ventas (clave_venta) values (2);
insert  into ventas (clave_venta) values (3);
insert  into ventas (clave_venta) values (4);
insert  into ventas (clave_venta) values (5);

delimiter // 
create procedure mostrar_productos ()
begin
select* from articulos;
end //
delimiter ;

delimiter // 
create procedure mostrar_nombre ()
begin
select nombre_articulo from articulos;
end //
delimiter ;

delimiter // 
create procedure mostrar_nombre_precio ()
begin
select nombre_articulo, precio_articulo from articulos;
end //
delimiter ;

delimiter // 
create procedure mostrar_nombre_PC (clave int)
begin
select  *from articulos where clave_articulo = clave;
end //
delimiter ;

delimiter // 
create procedure mostrar_nombre_PN (nombre varchar(30))
begin
select  *from articulos where nombre_articulo = nombre;
end //
delimiter ;

delimiter // 
create procedure articulos_vendidos_PC (articuloV int)
begin
select  *from articulos_ventas where  clave_articulo1 =articuloV;
end //
delimiter ;

delimiter // 
create procedure mostrar_sin_respetir()
begin
SELECT DISTINCT nombre_articulo FROM articulos;
end //
delimiter ;

delimiter //
create procedure articulos_vendidos(nombre varchar(50))
begin
select DISTINCT clave_articulo, nombre_articulo, cantidad from articulos inner join articulos_ventas on articulos.clave_articulo = articulos_ventas.clave_articulo1 where nombre_articulo=nombre;
end //
delimiter ;


delimiter //
create procedure monstrar_articulos_por_letra(l varchar(10))
begin
select * from articulos where nombre_articulo regexp(l|UPPER(l));
end //
delimiter ;

delimiter //
create procedure precio_mostrar(p int)
begin
select nombre_articulo from articulos where precio_articulo = p;
end //
delimiter ;

delimiter //
create procedure orden_precio()
begin
select * from articulos order by precio_articulo;
end //
delimiter ;

delimiter //
create procedure nombre_fabricante_ven()
begin
select DISTINCT clave_articulo, nombre_articulo, nombre_fabricante from articulos inner join fabricantes on articulos.clave_fabricante1 = fabricantes.clave_fabricante;
end //
delimiter ;

delimiter //
create procedure nombre_fabricante_prod(nombre varchar(50))
begin
select DISTINCT clave_articulo, nombre_articulo, precio_articulo,nombre_fabricante from articulos 
inner join fabricantes on articulos.clave_fabricante1 = fabricantes.clave_fabricante where nombre_fabricante = nombre order by nombre_articulo desc;
end //
delimiter ;

delimiter //
create procedure precio_fabricante_descv()
begin
select DISTINCT clave_articulo, nombre_articulo, precio_articulo,nombre_fabricante from articulos 
inner join fabricantes on articulos.clave_fabricante1 = fabricantes.clave_fabricante where nombre_fabricante = 'lexar' or nombre_fabricante = 'kingston' order by precio_articulo desc;
end //
delimiter ;

delimiter //
create function descuento_10() returns varchar(100)
begin
update articulos set precio_articulo = precio_articulo - (precio_articulo * 10/10);
return concat('todos los articulos con mas de 300 en precio se les aplico un 10% de descuento ');
end //
delimiter ;

delimiter //
create function descuento_10_300() returns varchar(100)
begin
update articulos set precio_articulo = precio_articulo - (precio_articulo * 10/10) where precio_articulo>300;
return concat('todos los articulos con mas de 300 en precio se les aplico un 10% de descuento ');
end //
delimiter ;

delimiter //
create function borrar(c int) returns varchar(50)
begin
delete from articulos where clave_articulo = c;
return concat('usuario con clave ' , c, ' borrado');
end //
delimiter ;

delimiter //
create procedure precio_medio()
begin
select  sum(precio_articulo)/(SELECT clave_articulo FROM articulos ORDER by clave_articulo desc LIMIT 1) from articulos order by clave_articulo desc;
end //
delimiter ;


call precio_medio();