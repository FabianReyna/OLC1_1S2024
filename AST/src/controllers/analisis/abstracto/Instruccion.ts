import Arbol from "../simbolo/Arbol";
import tablaSimbolos from "../simbolo/tablaSimbolos";
import Tipo from "../simbolo/Tipo";

export abstract class Instruccion {
    public tipoDato: Tipo
    public linea: number
    public col: number

    constructor(tipo: Tipo, linea: number, col: number) {
        this.tipoDato = tipo
        this.linea = linea
        this.col = col
    }

    abstract interpretar(arbol: Arbol, tabla: tablaSimbolos): any
    abstract getAST(anterior: string): string

}