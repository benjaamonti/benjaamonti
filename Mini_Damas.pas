program Mini_Damas;
uses Crt;

{Este programa es para jugar a las "MiniDamas", una version simplificada y modificada del clásico juego "Damas".
El objetivo es capturar todas las fichas del oponente o dejarlo sin movimientos, utilizando movimientos diagonales y comiendo sus fichas.}

// Definición de constantes y tipos //

const
  FILAS = 8;
  COLUMNAS = 8;
  BLANCA = 'x';
  NEGRA = 'o';
  VACIO =' ';
  CANT_FICHAS = 12;
  C: array[1..8] of string = ('┐', '┌', '┘', '└', '─', '│', VACIO, '┼');

type
  matriz= array[1..FILAS, 1..COLUMNAS] of char;

// Definición de funciones y procedimientos //

function FondoNegro(fila,col:integer):boolean;
// Retorna verdadero/falso dependiendo del fondo que tiene la celda (damero).
begin
    FondoNegro := (((fila+col) mod 2) = 1);
end;

function CantFichasEnTablero(mat:matriz; color:char):integer;
var cant, fila, columna:integer;
begin
    cant := 0;
    for fila := 1 to FILAS do
        for columna := 1 to COLUMNAS do
            if mat[fila,columna] = color then
                cant := cant + 1;
    CantFichasEnTablero := cant;
end;

procedure InicMatriz(var mat:matriz);
// Inicializa la matriz con las 64 celdas en blanco.
var
  i, j: integer;
begin
for i:=1 to FILAS do 
    for j:=1 to COLUMNAS do
        mat[i,j] := VACIO;
end;

procedure CargarFichas(var mat:matriz; color:char; cantidad:integer);
// Carga la matriz con las 16 fichas en su posición inicial.
var fila_inicial: integer;
    incremento:integer;
    fila, columna:integer;
    fichas: integer;
begin
    if color=NEGRA then 
        begin
            fila_inicial := 1;
            incremento := 1;
            columna := 2;
        end 
    else 
        begin
            fila_inicial := FILAS;
            incremento := -1;
            columna := 1;
        end;
    fila := fila_inicial;
    for fichas:= 1 to CANT_FICHAS do begin
        if not(FondoNegro(fila, columna)) then
            columna := columna + 1;
        mat[fila, columna] := color;
        columna := columna + 2;
        if columna > COLUMNAS then begin
            columna := 1;
            fila := fila + incremento;
        end;
    end;
end;

procedure DibujarMatriz(mat:matriz);
// Muestra la matriz por pantalla.
var
  i, j: integer;
begin
    ClrScr;  // Blanquea la pantalla.
    write(VACIO,C[2]);
    for j:=1 to COLUMNAS do write(C[5],C[5],C[5]);
    writeln(C[1]);
    for i:=1 to FILAS do begin
        write(i,C[6]);
        for j:=1 to COLUMNAS do begin
            if not(FondoNegro(i,j)) then
                write(C[7],C[7],C[7])
            else
                write(VACIO,mat[i,j],VACIO);
        end;
        writeln(C[6]);
    end;
    write(VACIO,C[4]);
    for j:=1 to COLUMNAS do write(C[5],C[5],C[5]);
    writeln(C[3]);
    write(' ');
    for j:=1 to COLUMNAS do write(' ',' ',j); writeln();
    for i := 1 to CANT_FICHAS - CantFichasEnTablero(mat,NEGRA) do write(NEGRA); writeln();
    for i := 1 to CANT_FICHAS - CantFichasEnTablero(mat,BLANCA) do write(BLANCA); writeln();
end;

procedure Pedirpos(var posfil:integer; var poscol:integer);
// Pide posicion y revisa que sea dentro del tablero, en caso de no serla, la pide de nuevo
begin
    write('fila: ');
    readln(posfil);
    while (posfil>8) or (posfil<1) do
    begin
        writeln('Ingrese una fila valida');
        write('fila: ');
        readln(posfil);
    end;
    write('columna: ');
    readln(poscol);
    while (poscol>8) or (poscol<1) do
    begin
        writeln('Ingrese una columna valida');
        write('columna: ');
        readln(poscol);
    end;
end;

procedure Pedirorigen(mat:matriz; var posfil:integer; var poscol:integer; color:char);
// Pide la posicion de origen y revisa que sea valida la posicion elegida, en caso de no serla, la pide nuevamente
begin
    writeln('Elija la ficha que quiere mover ingresando la fila y columna');
    Pedirpos(posfil,poscol);
    while (mat[posfil,poscol] = VACIO) or (mat[posfil,poscol] <> color) do
    begin
        DibujarMatriz(mat);
        writeln('Posición invalida');
        writeln('Elija la ficha que quiere mover ingresando la fila y columna');
        Pedirpos(posfil,poscol);
    end;
end;

procedure Pedirdestino(mat:matriz; var posfil:integer; var poscol:integer);
// Pide la posicion de destino y revisa que sea valida la posicion elegida, en caso de no serla, la pide nuevamente
begin
    writeln('Elija donde quiere mover ingresando la fila y columna');
    Pedirpos(posfil,poscol);
    while mat[posfil,poscol] <> VACIO do
    begin
        DibujarMatriz(mat);
        writeln('Posición invalida');
        writeln('Elija donde quiere mover ingresando la fila y columna');
        Pedirpos(posfil,poscol);
    end;
end;

function colorcontrario(mat:matriz;posfil:integer;poscol:integer):char;
//Devuelve el color contrario al que se encuentra en la posicion especificada
begin
    if mat[posfil,poscol]=BLANCA then
        colorcontrario:=NEGRA
    else
        colorcontrario:=BLANCA;
end;

function comervalido(mat:matriz;filorg:integer; colorg:integer; fildes:integer; coldes:integer):boolean;
// Retorna verdadero/falso dependiendo de si puede comer una ficha o no
var
    color:char;
begin
    comervalido:=false;
    color:=colorcontrario(mat,filorg,colorg);
    
    if (fildes=filorg-2) and (coldes=colorg-2) and (mat[filorg-1,colorg-1]=color) then
        comervalido:=true;
        
    if (fildes=filorg-2) and (coldes=colorg+2) and (mat[filorg-1,colorg+1]=color) then
        comervalido:=true;
        
    if (fildes=filorg+2) and (coldes=colorg-2) and (mat[filorg+1,colorg-1]=color) then
        comervalido:=true;
        
    if (fildes=filorg+2) and (coldes=colorg+2) and (mat[filorg+1,colorg+1]=color) then
        comervalido:=true;
end;

procedure mover(var mat:matriz;filorg:integer;colorg:integer;fildes:integer;coldes:integer);
// Mueve la ficha a la posicion especificada
begin
    mat[fildes,coldes]:= mat[filorg,colorg];
    mat[filorg,colorg]:= VACIO;
    DibujarMatriz(mat);
end;

procedure comer(var mat:matriz;filorg:integer;colorg:integer;fildes:integer;coldes:integer);
// Mueve la ficha a la posicion especificada y elimina la ficha del contrario que se encuentra en el medio
begin
    if (fildes=filorg-2) and (coldes=colorg-2) then
        mat[filorg-1,colorg-1]:= VACIO;
        
    if (fildes=filorg-2) and (coldes=colorg+2) then
        mat[filorg-1,colorg+1]:= VACIO;
        
    if (fildes=filorg+2) and (coldes=colorg-2) then
        mat[filorg+1,colorg-1]:= VACIO;
        
    if (fildes=filorg+2) and (coldes=colorg+2) then
        mat[filorg+1,colorg+1]:= VACIO;
    mover(mat,filorg,colorg,fildes,coldes);
end;

procedure movimiento(var mat:matriz; filorg:integer; colorg:integer; fildes:integer; coldes:integer);
// Mueve la ficha o come una ficha dependiendo de la posicion de destino. En caso de ser un movimiento invalido, el usuario pierde el turno
var
    restafila,restacolumna,resultado:integer;
    seguircomiendo,color:char;
begin
    restafila:= fildes-filorg; 
    restacolumna:= abs(coldes-colorg);
    seguircomiendo:='s';
    color:= mat[filorg,colorg];
    if color=NEGRA then
        resultado:=1
    else
        resultado:=-1;
    
    if (restafila=resultado) and (restacolumna=1) then
        mover(mat,filorg,colorg,fildes,coldes)
    else
    begin
        restafila:=abs(restafila);
        while seguircomiendo='s' do
        begin
            if (restafila=2) and (restacolumna=2) and comervalido(mat,filorg,colorg,fildes,coldes) then
            begin
                comer(mat,filorg,colorg,fildes,coldes);
                write('Desea comer de nuevo? (s/n) ');
                readln(seguircomiendo);
                if seguircomiendo='s' then
                begin
                    filorg:=fildes;
                    colorg:=coldes;
                    Pedirdestino(mat,fildes,coldes);
                end;
            end
            else
            begin
                seguircomiendo:='n';
                DibujarMatriz(mat);
                writeln('movimiento invalido, usted pierde el turno');
            end;
        end;
    end;
end;
// abs(x) = valor absoluto de x. fuente:https://aprendeaprogramar.com/referencia/view.php?f=abs&leng=Pascal//

function movimientolegal(mat:matriz;posfil:integer;poscol:integer):boolean;
// Retorna verdadero/falso dependiendo de si la ficha tiene al menos 1 movimiento legal
var 
    color:char;
begin
    movimientolegal:=false;
    color:=colorcontrario(mat,posfil,poscol);
    
    if color=NEGRA then
    begin
        if (mat[posfil-1,poscol+1]=VACIO) or (mat[posfil-1,poscol-1]=VACIO) then
            movimientolegal:=true;
    end
    else
    begin
        if (mat[posfil+1,poscol+1]=VACIO) or (mat[posfil+1,poscol-1]=VACIO) then
            movimientolegal:=true;
    end;

    if (mat[posfil-1,poscol+1]=color) and (mat[posfil-2,poscol+2]=VACIO) then
        movimientolegal:=true;
    
    if (mat[posfil-1,poscol-1]=color) and (mat[posfil-2,poscol-2]=VACIO) then
        movimientolegal:=true;
    
    if (mat[posfil+1,poscol+1]=color) and (mat[posfil+2,poscol+2]=VACIO) then
        movimientolegal:=true;
        
    if (mat[posfil+1,poscol-1]=color) and (mat[posfil+2,poscol-2]=VACIO) then
        movimientolegal:=true;
end;

function MovimientoPosibleColor(mat:matriz;color:char):boolean;
// Retorna verdadero/falso dependiendo de si hay al menos una ficha con un movimiento legal del color especificado
var
    posfil,poscol:integer;
begin
    MovimientoPosibleColor:=false;
    posfil:=1;
    while (posfil<=FILAS) and (not MovimientoPosibleColor) do
    begin
        poscol:=1;
        while (poscol<=COLUMNAS) and (not MovimientoPosibleColor) do
        begin
            if mat[posfil,poscol] = color then
                MovimientoPosibleColor:= movimientolegal(mat,posfil,poscol);
            poscol:=poscol+1;
        end;
        posfil:=posfil+1;
    end;
end;

function movimientoposibles(mat:matriz):boolean;
// Retorna verdadero/falso dependiendo de si ambos colores tienen movimientos posibles
begin
    if MovimientoPosibleColor(mat,BLANCA) and MovimientoPosibleColor(mat,NEGRA) then
        movimientoposibles:=true
    else
        movimientoposibles:=false;
end;

function fichasdisponibles(mat:matriz):boolean;
// Retorna verdadero/falso dependiendo de si ambos jugadores tienen fichas o no.
begin
    if (CantFichasEnTablero(mat, NEGRA) >0) and (CantFichasEnTablero(mat, BLANCA) >0) then
        fichasdisponibles:= true
    else
        fichasdisponibles:= false;
end;

procedure IniciarJuego(var mat:matriz);
// Inicializa el juego, cargando las fichas y dibujando el tablero.
begin
    InicMatriz(mat);
    CargarFichas(mat, BLANCA, CANT_FICHAS);
    CargarFichas(mat, NEGRA, CANT_FICHAS);
    DibujarMatriz(mat);
end;

procedure Jugar(var mat:matriz);
// Procedimiento principal que controla todo el juego.
var
   filorg,colorg,fildes,coldes:integer; // (filorg,colorg = fila,columna origen, fildes,coldes = fila,columna destino)
   color:char;
begin
    color:=BLANCA;
    while fichasdisponibles(mat) and movimientoposibles(mat) do 
    begin
        if color = BLANCA then
            writeln('TURNO DE LAS BLANCAS (x)')
        else
            writeln('TURNO DE LAS NEGRAS (o)');
        
        Pedirorigen(mat,filorg,colorg,color);
        Pedirdestino(mat,fildes,coldes);
        movimiento(mat,filorg,colorg,fildes,coldes);
        
        if color = BLANCA then
            color:= NEGRA
        else
            color:= BLANCA;
    end;

    if (CantFichasEnTablero(mat, NEGRA)>0) or (not MovimientoPosibleColor(mat,BLANCA)) then
        writeln('FELICIDADES NEGRO')
    else
        writeln('FELICIDADES BLANCO');
end;

// Programa Principal //

var
    mat: matriz;
begin
    IniciarJuego(mat);
    Jugar(mat);
end.