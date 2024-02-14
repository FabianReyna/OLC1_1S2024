
package analisis;

//importaciones si fuese necesario
import java_cup.runtime.Symbol;

%%

// codigo de usuario
%{
    String cadena="";
%}

%init{ 
    yyline = 1; 
    yycolumn = 1; 
%init} 

//caracteristicas propias de jflex
%cup
%class scanner //nombre de la clase
%public // tipo de la clase
%line // conteo de lineas
%char // conteo de caracteres
%column // conteo de columnas
%full // reconocimiento de caracteres
%debug
%ignorecase // insensitive case

// creacion de estados si fuese necesario
%state CADENA

// simbolos
LLAVE1 = "{"
LLAVE2 = "}"
FINCADENA = ";"
MULT = "*"
DIV = "/"
MAS = "+"
MENOS = "-"
PAR1 = "("
PAR2 = ")"
BLANCOS = [\ \r\t\f\n]+
NUMEROS = [0-9]+("."[0-9]+)?


// palabras reservadas
TKEVALUAR = "evaluar"
TKIMP = "imprimir"
TKROUND = "redondear"

%%
<YYINITIAL> {TKEVALUAR}     {return new Symbol(sym.TKEVALUAR,yyline,yycolumn,yytext());}
<YYINITIAL> {TKIMP}         {return new Symbol(sym.TKIMP,yyline,yycolumn,yytext());}
<YYINITIAL> {TKROUND}       {return new Symbol(sym.TKROUND,yyline,yycolumn,yytext());}
<YYINITIAL> {NUMEROS}       {return new Symbol(sym.NUMEROS,yyline,yycolumn,yytext());}
<YYINITIAL> {LLAVE1}        {return new Symbol(sym.LLAVE1,yyline,yycolumn,yytext());}
<YYINITIAL> {LLAVE2}        {return new Symbol(sym.LLAVE2,yyline,yycolumn,yytext());}
<YYINITIAL> {FINCADENA}     {return new Symbol(sym.FINCADENA,yyline,yycolumn,yytext());}

<YYINITIAL> {MULT}          {return new Symbol(sym.MULT,yyline,yycolumn,yytext());}
<YYINITIAL> {DIV}           {return new Symbol(sym.DIV,yyline,yycolumn,yytext());}
<YYINITIAL> {MAS}           {return new Symbol(sym.MAS,yyline,yycolumn,yytext());}
<YYINITIAL> {MENOS}         {return new Symbol(sym.MENOS,yyline,yycolumn,yytext());}
<YYINITIAL> {PAR1}          {return new Symbol(sym.PAR1,yyline,yycolumn,yytext());}
<YYINITIAL> {PAR2}          {return new Symbol(sym.PAR2,yyline,yycolumn,yytext());}
<YYINITIAL> {BLANCOS}       {}

<YYINITIAL> [\"]            {yybegin(CADENA);cadena="";}

<CADENA>                    {
    [\"]    {String tmp=cadena; cadena=""; yybegin(YYINITIAL); return new Symbol(sym.CADENA, yycolumn,yyline,tmp);}
    [^\"]   {cadena+=yytext();}
}
