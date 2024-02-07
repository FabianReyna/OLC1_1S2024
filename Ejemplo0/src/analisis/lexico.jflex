package analisis;

// importaciones si fuese necesario
import java_cup.runtime.Symbol;

%%

// codigo de usuario
%{
    String cadena = "";
%}

%init{ 
    yyline = 1; 
    yycolumn = 1; 
%init} 

// caracteristicas propias de jflex
%cup
%class scanner
%public
%line
%char
%column
%full
%ignorecase

%state CADENA

// simbolos
MENOR = "<"
MAYOR = ">"
LLAVE1 = "{"
LLAVE2 = "}"
PAR1 = "("
PAR2 = ")"
DIV = "/"
PUNTO = "."
BLANCOS = [\ \r\t\f\n]+
ENTEROS = [0-9]+
FINCADENA = ";"
COMA = ","

// palabras reservadas
TK_EJEMPLO = "ejemplo"
TK_SYSTEM = "system"
TK_PRINT = "print"
TK_LINE = "line"
TK_CONCAT = "concatenar"

%%
<YYINITIAL> {TK_EJEMPLO}    {return new Symbol(sym.TK_EJEMPLO,yyline,yycolumn,yytext());}
<YYINITIAL> {TK_SYSTEM}     {return new Symbol(sym.TK_SYSTEM,yyline,yycolumn,yytext());}
<YYINITIAL> {TK_PRINT}      {return new Symbol(sym.TK_PRINT,yyline,yycolumn,yytext());}
<YYINITIAL> {TK_LINE}       {return new Symbol(sym.TK_LINE,yyline,yycolumn,yytext());}
<YYINITIAL> {TK_CONCAT}     {return new Symbol(sym.TK_CONCAT,yyline,yycolumn,yytext());}

<YYINITIAL> {MENOR}      {return new Symbol(sym.MENOR,yyline,yycolumn,yytext());}
<YYINITIAL> {MAYOR}      {return new Symbol(sym.MAYOR,yyline,yycolumn,yytext());}
<YYINITIAL> {LLAVE1}     {return new Symbol(sym.LLAVE1,yyline,yycolumn,yytext());}
<YYINITIAL> {LLAVE2}     {return new Symbol(sym.LLAVE2,yyline,yycolumn,yytext());}
<YYINITIAL> {PAR1}       {return new Symbol(sym.PAR1,yyline,yycolumn,yytext());}
<YYINITIAL> {PAR2}       {return new Symbol(sym.PAR2,yyline,yycolumn,yytext());}
<YYINITIAL> {DIV}        {return new Symbol(sym.DIV,yyline,yycolumn,yytext());}
<YYINITIAL> {PUNTO}      {return new Symbol(sym.PUNTO,yyline,yycolumn,yytext());}
<YYINITIAL> {ENTEROS}    {return new Symbol(sym.ENTEROS,yyline,yycolumn,yytext());}
<YYINITIAL> {FINCADENA}    {return new Symbol(sym.FINCADENA,yyline,yycolumn,yytext());}
<YYINITIAL> {COMA}    {return new Symbol(sym.COMA,yyline,yycolumn,yytext());}

<YYINITIAL> {BLANCOS}    {}

<YYINITIAL> [\"]         {yybegin(CADENA);cadena="";}

<CADENA>    {
            [\"]         {String tmp=cadena; cadena=""; yybegin(YYINITIAL);
                         return new Symbol(sym.CADENA,yyline,yycolumn,tmp);}
            [^\"]        {cadena+=yytext();}
}










