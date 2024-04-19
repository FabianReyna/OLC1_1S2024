%{
// codigo de JS si fuese necesario
const Tipo = require('./simbolo/Tipo')
const Nativo = require('./expresiones/Nativo')
const Aritmeticas = require('./expresiones/Aritmeticas')

const Print = require('./instrucciones/Print')
%}

// analizador lexico

%lex
%options case-insensitive

%%

//palabras reservadas
"imprimir"              return 'IMPRIMIR'

// simbolos del sistema
";"                     return "PUNTOCOMA"
"+"                     return "MAS"
"-"                     return "MENOS"
"("                     return "PAR1"
")"                     return "PAR2"
[0-9]+"."[0-9]+         return "DECIMAL"
[0-9]+                  return "ENTERO"
[\"][^\"]*[\"]          {yytext=yytext.substr(1,yyleng-2); return 'CADENA'}

//blancos
[\ \r\t\f\t]+           {}
[\ \n]                  {}

// simbolo de fin de cadena
<<EOF>>                 return "EOF"


%{
    // CODIGO JS SI FUESE NECESARIO
%}

/lex

//precedencias
%left 'MAS' 'MENOS'
%right 'UMENOS'

// simbolo inicial
%start INICIO

%%

INICIO : INSTRUCCIONES EOF                  {return $1;}
;

INSTRUCCIONES : INSTRUCCIONES INSTRUCCION   {$1.push($2); $$=$1;}
              | INSTRUCCION                 {$$=[$1];}
;

INSTRUCCION : IMPRESION PUNTOCOMA            {$$=$1;}
;

IMPRESION : IMPRIMIR PAR1 EXPRESION PAR2    {$$= new Print.default($3, @1.first_line, @1.first_column);}
;

EXPRESION : EXPRESION MAS EXPRESION          {$$ = new Aritmeticas.default(Aritmeticas.Operadores.SUMA, @1.first_line, @1.first_column, $1, $3);}
          | EXPRESION MENOS EXPRESION        {$$ = new Aritmeticas.default(Aritmeticas.Operadores.RESTA, @1.first_line, @1.first_column, $1, $3);}
          | PAR1 EXPRESION PAR2              {$$ = $2;}
          | MENOS EXPRESION %prec UMENOS     {$$ = new Aritmeticas.default(Aritmeticas.Operadores.NEG, @1.first_line, @1.first_column, $2);}
          | ENTERO                           {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.ENTERO), $1, @1.first_line, @1.first_column );}
          | DECIMAL                          {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.DECIMAL), $1, @1.first_line, @1.first_column );}
          | CADENA                           {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.CADENA), $1, @1.first_line, @1.first_column );}      
;