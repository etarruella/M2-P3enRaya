use 3enRaya;

insert into PARTIDA (idPartida, jugador1, jugador2) values(8, 'rojo', 'azul');

call hacer_movimiento(8, 'rojo', 'red', 2, 'C', @movimiento);
select @movimiento; # OK jugador rojo, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'azul', 'blue', 2, 'A', @movimiento);
select @movimiento; # OK jugador azul, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'rojo', 'red', 2, 'B', @movimiento);
select @movimiento; # OK jugador rojo, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'azul', 'blue', 3, 'C', @movimiento);
select @movimiento; # OK jugador azul, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'rojo', 'red', 1, 'B', @movimiento);
select @movimiento; # OK jugador rojo, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'azul', 'blue', 1, 'A', @movimiento);
select @movimiento; # OK jugador rojo, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'rojo', 'red', 3, 'B', @movimiento);
select @movimiento; # OK jugador rojo, movimiento realizado.
call mostrar_tablero(8);

call hacer_movimiento(8, 'azul', 'blue', 3, 'A', @movimiento);
select @movimiento; # ERROR: NO es ESTADO de turno de NINGUN jugador en partida 8 segun tabla PARTIDA.
call mostrar_tablero(8);

select * from PARTIDA;
select * from TABLERO;
select * from JUGADORES;

delete from PARTIDA where idPartida = 8;