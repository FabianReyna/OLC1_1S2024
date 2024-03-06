import { Router } from 'express'
import { indexController } from '../Controllers/indexController'

class router {
    public router: Router = Router();
    constructor() {
        this.config();
    }

    config(): void {
        this.router.get('/', indexController.prueba);
        this.router.post('/post', indexController.metodoPost);
        this.router.post('/analizar', indexController.Analizar);
    }
}

const indexRouter = new router();
export default indexRouter.router; 


/*
Modelo-Vista-Controlador
Cliente - Servidor - DB

Web -> Servidor -> get (recuperar datos)
    <-            <-

Web -> Servidor -> post (enviar datos) {usuario, constraseña, correo, etc}
Web -> Servidor -> put (actualizar datos) {usuario, datosAactualizar}
Web -> Servidor -> delete (eliminar datos) {usuario}
Web -> Servidor -> patch (actualizar datos) {usuario, datosAactualizar}

Peticion HTTP

*/