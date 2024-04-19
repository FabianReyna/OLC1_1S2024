import { Router } from "express";
import { indexController } from "../controllers/indexController";


class router {
    public router: Router = Router();;
    constructor() {
        this.config();
    }


    config(): void {
        this.router.get('/', indexController.prueba);
        this.router.post('/interpretar', indexController.interpretar)
        this.router.get('/getAST', indexController.ast)
    }
}


const indexRouter = new router();
export default indexRouter.router;