%{
// codigo de JS si fuese necesario
const Tipo = require('./simbolo/Tipo')
const Nativo = require('./expresiones/Nativo')
const Aritmeticas = require('./expresiones/Aritmeticas')
const AccesoVar = require('./expresiones/AccesoVar')
const Relacionales = require('./expresiones/Relacionales')

const Print = require('./instrucciones/Print')
const Declaracion = require('./instrucciones/Declaracion')
const AsignacionVar = require('./instrucciones/AsignacionVar')
const If = require('./instrucciones/If')
const While = require('./instrucciones/While')
const Break = require('./instrucciones/Break')
const Metodo = require('./instrucciones/Metodo')
const Run = require('./instrucciones/Run')
const Llamada = require('./instrucciones/Llamada')
%}

// analizador lexico

%lex
%options case-insensitive

%%

//palabras reservadas
"imprimir"              return 'IMPRIMIR'
"int"                   return 'INT'
"double"                return 'DOUBLE'
"string"                return 'STRING'
"true"                  return 'TRUE'
"false"                 return 'FALSE'
"if"                    return 'IF'
"bool"                  return 'BOOL'
"while"                 return 'WHILE'
"break"                 return 'BREAK'
"run"                   return 'RUN'
"void"                  return 'VOID'
// simbolos del sistema
";"                     return "PUNTOCOMA"
":"                     return "DOSPUNTOS"
","                     return "COMA"
"+"                     return "MAS"
"-"                     return "MENOS"
"("                     return "PAR1"
")"                     return "PAR2"
"="                     return "IGUAL"
"{"                     return "LLAVE1"
"}"                     return "LLAVE2"
"<"                     return 'MENOR'
[0-9]+"."[0-9]+         return "DECIMAL"
[0-9]+                  return "ENTERO"
[a-z][a-z0-9_]*         return "ID"
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
%left 'MENOR'
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
            | DECLARACION PUNTOCOMA          {$$=$1;}
            | ASIGNACION PUNTOCOMA           {$$=$1;}
            | SIF                            {$$=$1;}
            | SWHILE                         {$$=$1;}
            | SBREAK                         {$$=$1;}
            | METODO                         {$$=$1;}
            | EXECUTE PUNTOCOMA              {$$=$1;}
            | LLAMADA PUNTOCOMA              {$$=$1;}
;

IMPRESION : IMPRIMIR PAR1 EXPRESION PAR2    {$$= new Print.default($3, @1.first_line, @1.first_column);}
;

DECLARACION : TIPOS ID IGUAL EXPRESION      {$$ = new Declaracion.default($1, @1.first_line, @1.first_column, $2, $4);}
;

ASIGNACION : ID IGUAL EXPRESION             {$$ = new AsignacionVar.default($1, $3, @1.first_line, @1.first_column);}
;

SIF : IF PAR1 EXPRESION PAR2 LLAVE1 INSTRUCCIONES LLAVE2    {$$ = new If.default($3, $6, @1.first_line, @1.first_column );}
;

SWHILE : WHILE PAR1 EXPRESION PAR2 LLAVE1 INSTRUCCIONES LLAVE2      {$$ = new While.default($3, $6, @1.first_line, @1.first_column );}
;

SBREAK : BREAK PUNTOCOMA    {$$ = new Break.default(@1.first_line, @1.first_column);}
;

METODO : ID PAR1 PARAMS PAR2 DOSPUNTOS TIPOS LLAVE1 INSTRUCCIONES LLAVE2      {$$ = new Metodo.default($1, $6, $8, @1.first_line, @1.first_column, $3);}
       | ID PAR1 PAR2 DOSPUNTOS TIPOS LLAVE1 INSTRUCCIONES LLAVE2             {$$ = new Metodo.default($1, $5, $7, @1.first_line, @1.first_column, [] );}  
;

PARAMS : PARAMS COMA TIPOS ID       { $1.push({tipo:$3, id:$4}); $$=$1;} 
       | TIPOS ID                   {$$ = [{tipo:$1, id:$2}];}
;

EXECUTE : RUN ID PAR1 PARAMSCALL PAR2       {$$ = new Run.default($2,@1.first_line, @1.first_column, $4 );}
        | RUN ID PAR1 PAR2                  {$$ = new Run.default($2, @1.first_line, @1.first_column, [])}
;

// constructor(id: string, linea: number, col: number, parametros: Instruccion[]) {
LLAMADA : ID PAR1 PARAMSCALL PAR2           {$$ = new Llamada.default($1, @1.first_line, @1.first_column, $3);}
        | ID PAR1 PAR2                      {$$ = new Llamada.default($1, @1.first_line, @1.first_column, []);}
;

PARAMSCALL : PARAMSCALL COMA EXPRESION      {$1.push($3); $$=$1;}
           | EXPRESION                      {$$=[$1];}
;

EXPRESION : EXPRESION MAS EXPRESION          {$$ = new Aritmeticas.default(Aritmeticas.Operadores.SUMA, @1.first_line, @1.first_column, $1, $3);}
          | EXPRESION MENOS EXPRESION        {$$ = new Aritmeticas.default(Aritmeticas.Operadores.RESTA, @1.first_line, @1.first_column, $1, $3);}
          | EXPRESION MENOR EXPRESION        {$$ = new Relacionales.default(Relacionales.Relacional.MENOR, $1, $3, @1.first_line, @1.first_column);}
          | PAR1 EXPRESION PAR2              {$$ = $2;}
          | MENOS EXPRESION %prec UMENOS     {$$ = new Aritmeticas.default(Aritmeticas.Operadores.NEG, @1.first_line, @1.first_column, $2);}
          | ENTERO                           {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.ENTERO), $1, @1.first_line, @1.first_column );}
          | DECIMAL                          {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.DECIMAL), $1, @1.first_line, @1.first_column );}
          | CADENA                           {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.CADENA), $1, @1.first_line, @1.first_column );}
          | TRUE                             {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.BOOL), true, @1.first_line, @1.first_column ); }
          | FALSE                            {$$ = new Nativo.default(new Tipo.default(Tipo.tipoDato.BOOL), false, @1.first_line, @1.first_column ); }
          | ID                               {$$ = new AccesoVar.default($1, @1.first_line, @1.first_column);}      
;

TIPOS : INT             {$$ = new Tipo.default(Tipo.tipoDato.ENTERO);}
      | DOUBLE          {$$ = new Tipo.default(Tipo.tipoDato.DECIMAL);}
      | STRING          {$$ = new Tipo.default(Tipo.tipoDato.CADENA);}
      | BOOL            {$$ = new Tipo.default(Tipo.tipoDato.BOOL);}
      | VOID            {$$ = new Tipo.default(Tipo.tipoDato.VOID);}
;