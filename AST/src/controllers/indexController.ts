import { Request, Response } from 'express';
import Arbol from './analisis/simbolo/Arbol';
import tablaSimbolo from './analisis/simbolo/tablaSimbolos';
import Contador from './analisis/simbolo/Contador';
import Errores from './analisis/excepciones/Errores';

var AstDot: string

class controller {
    public prueba(req: Request, res: Response) {
        res.json({ "funciona": "la api" });
    }

    public interpretar(req: Request, res: Response) {
        try {
            AstDot = ""
            let parser = require('./analisis/analizador')
            let ast = new Arbol(parser.parse(req.body.entrada))
            let tabla = new tablaSimbolo()
            tabla.setNombre("Ejemplo1")
            ast.setTablaGlobal(tabla)
            ast.setConsola("")
            for (let i of ast.getInstrucciones()) {
                console.log(i)
                var resultado = i.interpretar(ast, tabla)
                console.log(resultado)
            }
            let contador = Contador.getInstancia()
            let cadena = "digraph ast{\n"
            cadena += "nINICIO[label=\"INICIO\"];\n"
            cadena += "nINSTRUCCIONES[label=\"INSTRUCCIONES\"];\n"
            cadena += "nINICIO->nINSTRUCCIONES;\n"

            for (let i of ast.getInstrucciones()) {
                if (i instanceof Errores) continue
                let nodo = `n${contador.get()}`
                cadena += `${nodo}[label=\"INSTRUCCION\"];\n`
                cadena += `nINSTRUCCIONES->${nodo};\n`
                cadena += i.getAST(nodo)
            }
            cadena += "\n}"
            AstDot = cadena

            res.send({ "Respuesta": ast.getConsola() })
        } catch (err: any) {
            console.log(err)
            res.send({ "Error": "Ya no sale compi1" })
        }
    }

    public ast(req: Request, res: Response) {
        res.json({ AST: AstDot })
    }
}


export const indexController = new controller();