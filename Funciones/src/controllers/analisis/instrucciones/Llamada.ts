import { Instruccion } from "../abstracto/Instruccion";
import Errores from "../excepciones/Errores";
import Arbol from "../simbolo/Arbol";
import tablaSimbolo from "../simbolo/tablaSimbolos";
import Tipo, { tipoDato } from "../simbolo/Tipo";
import AsignacionVar from "./AsignacionVar";
import Declaracion from "./Declaracion";
import Metodo from "./Metodo";

export default class Llamada extends Instruccion {

    private id: string
    private parametros: Instruccion[]

    constructor(id: string, linea: number, col: number, parametros: Instruccion[]) {
        super(new Tipo(tipoDato.VOID), linea, col)
        this.id = id
        this.parametros = parametros
    }

    interpretar(arbol: Arbol, tabla: tablaSimbolo) {
        let busqueda = arbol.getFuncion(this.id)
        if (busqueda == null) {
            return new Errores("SEMANTICO", "Funcion no existente", this.linea, this.col)
        }

        if (busqueda instanceof Metodo) {
            let newTabla = new tablaSimbolo(arbol.getTablaGlobal())
            newTabla.setNombre("LLAMADA METODO " + this.id)

            //validacion parametros
            if (busqueda.parametros.length != this.parametros.length) {
                return new Errores("SEMANTICO", "Parametros invalidos", this.linea, this.col)
            }

            // es igual al run en su mayoria :D
            for (let i = 0; i < busqueda.parametros.length; i++) {
                let declaracionParametro = new Declaracion(
                    busqueda.parametros[i].tipo, this.linea, this.col,
                    busqueda.parametros[i].id)

                // declaramos variable en el ambito de la funcion
                let resultado = declaracionParametro.interpretar(arbol, newTabla)
                if (resultado instanceof Errores) return resultado

                // interpretamos su valor
                let valor = this.parametros[i].interpretar(arbol, tabla)
                if (valor instanceof Errores) return valor

                let variable = newTabla.getVariable(busqueda.parametros[i].id)
                if (variable == null) return new Errores("Semantico", "algo salio mal", this.linea, this.col)
                if (variable.getTipo().getTipo() != this.parametros[i].tipoDato.getTipo()) {
                    return new Errores("Semantico", "algo salio mal", this.linea, this.col)
                }
                variable.setValor(valor)
                console.log(variable)
                console.log(valor)
            }
            // interpretar la funcion a llamar
            let resultadoFuncion: any = busqueda.interpretar(arbol, newTabla)
            if (resultadoFuncion instanceof Errores) return resultadoFuncion

        }
    }
}

/*
    La llamada funciona ligeramente diferente al run
    El run viene unicamente en el ambito global por lo
    que se puede interpretar el valor con la newTabla sin ningun inconveniente
    Ya que solo posee acceso al entorno local y global

    Pero la llamada normal se deben usar 2 entornos
    1. El entorno donde se llama a la funcion (tabla)
    2. El entorno que se crea para la función (newTabla)

    Entonces necesitamos que el valor del parametro se interprete con 
    el entorno "tabla", ya que podriamos pasar una variable que este en
    este entorno y poder pasar el valor a la funcion a llamar
    El parametro se declara siempre en la newTabla
    Y aqui no podemos colocar que la declaración se haga con el valor en newTabla
    ya que newTabla no tiene contacto con tabla
    newTabla solo tiene acceso al ambito global y al local, no a tabla


    Por eso es que declaro la variable con su valor por default en el ambito newTabla
    Luego interpreto el valor con tabla y finalmente hago la actualización del valor
*/