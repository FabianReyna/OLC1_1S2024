import { Instruccion } from "../abstracto/Instruccion";
import Errores from "../excepciones/Errores";
import Arbol from "../simbolo/Arbol";
import Simbolo from "../simbolo/Simbolo";
import tablaSimbolo from "../simbolo/tablaSimbolos";
import Tipo, { tipoDato } from '../simbolo/Tipo'

export default class Declaracion extends Instruccion {
    private identificador: string
    private valor: Instruccion | undefined

    constructor(tipo: Tipo, linea: number, col: number, id: string, valor?: Instruccion) {
        super(tipo, linea, col)
        this.identificador = id
        this.valor = valor
    }

    interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        if (this.valor) {
            let valorFinal = this.valor?.interpretar(arbol, tabla)
            if (valorFinal instanceof Errores) return valorFinal

            if (this.valor.tipoDato.getTipo() != this.tipoDato.getTipo()) {
                return new Errores("SEMANTICO", "No se puede declarar variable", this.linea, this.col)
            }
            console.log("validacion1")
            if (!tabla.setVariable(new Simbolo(this.tipoDato, this.identificador, valorFinal))) {
                return new Errores("SEMANTICO", "No se puede declarar variable porque ya existia", this.linea, this.col)
            }
        } else {
            if (!tabla.setVariable(new Simbolo(this.tipoDato, this.identificador, this.valoresDefault(this.tipoDato.getTipo())))) {
                return new Errores("SEMANTICO", "No se puede declarar variable porque ya existia", this.linea, this.col)
            }
        }

    }

    //valores por default
    valoresDefault(tipo: tipoDato) {
        switch (tipo) {
            case tipoDato.BOOL:
                return true;
            case tipoDato.CARACTER:
                return ''
            case tipoDato.ENTERO:
                return 0
            case tipoDato.DECIMAL:
                return 0.0
        }
    }

}