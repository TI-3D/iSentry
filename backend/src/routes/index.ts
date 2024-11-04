// import elysia
import { Elysia } from "elysia";

// import routes
import UserRoutes from "./UserRoutes";

const Routes = new Elysia().use(UserRoutes);

// Export Routes sebagai default
export default Routes;
