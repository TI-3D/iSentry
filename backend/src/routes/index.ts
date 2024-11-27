// import elysia
import { Elysia } from "elysia";

// import routes
import UserRoutes from "./UserRoutes";
import IdentityRoutes from "./IdentityRoutes";
import SystemLogRoutes from "./SystemLogRoutes";
import DetectionLogRoutes from "./DetectionLogRoutes";
import MediaRoutes from "./MediaRoutes";
import FaceRoutes from "./FaceRoutes";
import AuthRoutes from "./AuthRoutes";

const Routes = new Elysia()
    .use(UserRoutes)
    .use(IdentityRoutes)
    .use(SystemLogRoutes)
    .use(DetectionLogRoutes)
    .use(MediaRoutes)
    .use(FaceRoutes)
    .use(AuthRoutes);

// Export Routes sebagai default
export default Routes;
