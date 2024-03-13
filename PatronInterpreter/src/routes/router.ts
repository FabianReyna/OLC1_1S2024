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
    }
}


const indexRouter=new router();
export default indexRouter.router;