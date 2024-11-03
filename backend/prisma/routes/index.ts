// import elysia
import { Elysia } from "elysia";

// import routes
import UserRoutes from "./UserRoutes";
import IdentityRoutes from "./IdentityRoutes";

const Routes = new Elysia().use(UserRoutes).use(IdentityRoutes);

// Export Routes sebagai default
export default Routes;
