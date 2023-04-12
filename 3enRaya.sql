# 3enRaya

drop database if exists 3enRaya;
create database 3enRaya;
use 3enRaya;

create table JUGADOR (
	loginJugador varchar(50),
    pass varchar(50),
	ganadas int default 0,
    perdidas int default 0,
    empatadas int default 0,
	primary key (loginJugador)
);

create table PARTIDA (
	idPartida int,
	jugador1 varchar(50),
	jugador2 varchar(50),
    estado varchar(50) default 'TURNO JUGADOR1', # Los valores posibles para el estado son: 'TURNO JUGADOR1', 'TURNO JUGADOR2', 'EMPATE', 'GANADOR JUGADOR1' y 'GANADOR JUGADOR2'.
	primary key (idPartida)
	);

create table TABLERO (
    idPartida int,
	fila int, # Los valores posibles para las filas son: 1, 2 y 3
	columnaA char(1)  default ' ', # Los valores posibles para las casillas (columnaA, columnaB y columnaC) son: ' ' para casilla en blanco, 'X' para casilla marcada por jugador1 y 'O' para casilla marcada por jugador2
    columnaB char(1)  default ' ',
	columnaC char(1)  default ' ',
	primary key (idPartida, fila)
	);

alter table PARTIDA add constraint fk_partida_jugador1 foreign key (jugador1) references JUGADOR(loginJugador) on update cascade on delete cascade;
alter table PARTIDA add constraint fk_partida_jugador2 foreign key (jugador2) references JUGADOR(loginJugador) on update cascade on delete cascade;
alter table TABLERO add constraint fk_tablero_idPartida foreign key (idPartida) references PARTIDA(idPartida) on update cascade on delete cascade;

# Trigger crear_tablero after insert on PARTIDA for each row
# Disparador para crear un tablero en blanco para cada partida nueva
delimiter ;)
create trigger crear_tablero after insert on PARTIDA for each row
begin
	insert into TABLERO (idPartida, fila) values(new.idPartida, 1);
	insert into TABLERO (idPartida, fila) values(new.idPartida, 2);
	insert into TABLERO (idPartida, fila) values(new.idPartida, 3);
end;)
delimiter ;

# Procedure mostrar_tablero(in idPartidaP int)
# Procedimiento para mostrar el tablero de la partida especificada como parametro (NO respeta MVC, pero resulta comodo)
delimiter ;)
create procedure mostrar_tablero(in idPartidaP int)
begin
	select fila as 'Partida', columnaA as 'A', columnaB as 'B', columnaC as 'C' from TABLERO where idPartida = idPartidaP order by fila;
end;)
delimiter ;

# Function tablero_lleno(idPartidaP int) returns varchar(50)
# Funcion para averiguar si el tablero de la partida especificada como parametro esta lleno (no quedan casillas en blanco ' ') y por tanto retorna 'CIERTO', o retorna 'FALSO' en caso contrario
#
delimiter ;)
create function tablero_lleno(idPartidaP int) returns varchar(50)
begin
	declare lleno varchar(50);
    declare A, B, C char(1);
    declare filaV int;
    
    set lleno = 'CIERTO';
    set filaV = 1;
    while filaV <= 3 do
		select columnaA into A from TABLERO where idPartida = idPartidaP and fila = filaV;
		select columnaB into B from TABLERO where idPartida = idPartidaP and fila = filaV;
		select columnaC into C from TABLERO where idPartida = idPartidaP and fila = filaV;
        if A = ' ' or B = ' ' or C = ' ' then
			set lleno = 'FALSO';
        end if;
		set filaV = filaV + 1;
    end while;
    return lleno;
end;)
delimiter ;

insert into JUGADOR (loginJugador, pass) values('rojo', 'red');
insert into JUGADOR (loginJugador, pass) values('azul', 'blue');
insert into JUGADOR (loginJugador, pass) values('verde', 'green');
insert into JUGADOR (loginJugador, pass) values('amarillo', 'yellow');

insert into PARTIDA (idPartida, jugador1, jugador2) values(1, 'rojo', 'azul');
insert into PARTIDA (idPartida, jugador1, jugador2) values(2, 'verde', 'amarillo');
insert into PARTIDA (idPartida, jugador1, jugador2) values(3, 'rojo', 'amarillo');
insert into PARTIDA (idPartida, jugador1, jugador2) values(4, 'rojo', 'azul');
insert into PARTIDA (idPartida, jugador1, jugador2) values(5, 'rojo', 'azul');
insert into PARTIDA (idPartida, jugador1, jugador2) values(6, 'rojo', 'azul');
insert into PARTIDA (idPartida, jugador1, jugador2) values(7, 'rojo', 'azul');

# Partida 2 estado 'GANADOR JUGADOR1'
update TABLERO set columnaA='X', columnaB='X', columnaC='X' where idPartida = 2 and fila = 1;
update TABLERO set columnaA='O', columnaB='O', columnaC='X' where idPartida = 2 and fila = 2;
update TABLERO set columnaA='O', columnaB='X', columnaC='O' where idPartida = 2 and fila = 3;
update PARTIDA set estado = 'GANADOR JUGADOR1' where idPartida = 2;
update JUGADOR set ganadas = ganadas + 1 where loginJugador = 'verde';
update JUGADOR set perdidas = perdidas + 1 where loginJugador = 'amarillo';

# Partida 3 estado 'EMPATE'
update TABLERO set columnaA='X', columnaB='O', columnaC='X' where idPartida = 3 and fila = 1;
update TABLERO set columnaA='O', columnaB='O', columnaC='X' where idPartida = 3 and fila = 2;
update TABLERO set columnaA='X', columnaB='X', columnaC='O' where idPartida = 3 and fila = 3;
update PARTIDA set estado = 'EMPATE' where idPartida = 3;
update JUGADOR set empatadas = empatadas + 1 where loginJugador = 'rojo';
update JUGADOR set empatadas = empatadas + 1 where loginJugador = 'amarillo';

# Partida 4 estado 'TURNO JUGADOR1', si mueve en A3 futuro 'EMPATE'
update TABLERO set columnaA='X', columnaB='X', columnaC='O' where idPartida = 4 and fila = 1;
update TABLERO set columnaA='O', columnaB='O', columnaC='X' where idPartida = 4 and fila = 2;
update TABLERO set               columnaB='O', columnaC='X' where idPartida = 4 and fila = 3;

# Partida 5 estado 'TURNO JUGADOR2', si mueve en A2 futuro 'GANADOR JUGADOR2'
update TABLERO set columnaA='X', columnaB='O', columnaC='X' where idPartida = 5 and fila = 1;
update TABLERO set               columnaB='O', columnaC='O' where idPartida = 5 and fila = 2;
update TABLERO set               columnaB='X', columnaC='X' where idPartida = 5 and fila = 3;

# Partida 6 estado 'TURNO JUGADOR1', si mueve en C2 futuro 'GANADOR JUGADOR1'
update TABLERO set               columnaB='O', columnaC='X' where idPartida = 6 and fila = 1;
update TABLERO set columnaA='X', columnaB='X'               where idPartida = 6 and fila = 2;
update TABLERO set columnaA='O', columnaB='O'               where idPartida = 6 and fila = 3;

# Partida 7 estado 'TURNO JUGADOR1', si mueve en A3 futuro 'GANADOR JUGADOR1'
update TABLERO set columnaA='X', columnaB='X', columnaC='O' where idPartida = 7 and fila = 1;
update TABLERO set columnaA='X', columnaB='O', columnaC='O' where idPartida = 7 and fila = 2;
update TABLERO set               columnaB='O', columnaC='X' where idPartida = 7 and fila = 3;

select * from JUGADOR;
select * from PARTIDA;
select * from TABLERO;

call mostrar_tablero(1);
select tablero_lleno(1);
call mostrar_tablero(2);
select tablero_lleno(2);
call mostrar_tablero(3);
select tablero_lleno(3);
call mostrar_tablero(4);
select tablero_lleno(4);
call mostrar_tablero(5);
select tablero_lleno(5);
call mostrar_tablero(6);
select tablero_lleno(6);
call mostrar_tablero(7);
select tablero_lleno(7);


# Function tablero_ganador_FAKE(idPartidaP int) returns varchar(50)
# Funcion que permite crear el trigger modificar_estado aunque no se haya completado la funcion tablero_ganador
#
delimiter ;)
create function tablero_ganador_FAKE(idPartidaP int) returns varchar(50)
begin
	declare ganador varchar(50);
    
    case idPartidaP
    when 1 then
		set ganador = 'FALSO';
    when 2 then
		set ganador = 'GANADOR JUGADOR1';
    when 3 then
		set ganador = 'FALSO';
    when 4 then
		set ganador = 'FALSO';
    when 5 then
		set ganador = 'GANADOR JUGADOR2';
    when 6 then
		set ganador = 'GANADOR JUGADOR1';
    when 7 then
		set ganador = 'GANADOR JUGADOR1';
	else
		set ganador = 'FALSO';
	end case;
    return ganador;
end;)
delimiter ;

# TEST tablero_ganador_FAKE
call mostrar_tablero(1);
select tablero_ganador_FAKE(1); # FALSO
call mostrar_tablero(2);
select tablero_ganador_FAKE(2); # GANADOR JUGADOR1
call mostrar_tablero(3);
select tablero_ganador_FAKE(3); # FALSO
call mostrar_tablero(4);
select tablero_ganador_FAKE(4); # FALSO para el futuro test del trigger, si mueve en A3
call mostrar_tablero(5);
select tablero_ganador_FAKE(5); # GANADOR JUGADOR2 para el futuro test del trigger, si mueve en A2
call mostrar_tablero(6);
select tablero_ganador_FAKE(6); # GANADOR JUGADOR1 para el futuro test del trigger, si mueve en C2
call mostrar_tablero(7);
select tablero_ganador_FAKE(7); # GANADOR JUGADOR1 para el futuro test del trigger, si mueve en A3