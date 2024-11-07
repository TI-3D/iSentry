// import elysia
import { Elysia } from "elysia";

// import routes
import UserRoutes from "./UserRoutes";
import IdentityRoutes from "./IdentityRoutes";
import SystemLogRoutes from "./SystemLogRoutes";
import DetectionLogRoutes from "./DetectionLogRoutes";
import GalleryItemRoutes from "./GalleryItemRoutes";

const Routes = new Elysia()
    .use(UserRoutes)
    .use(IdentityRoutes)
    .use(SystemLogRoutes)
    .use(DetectionLogRoutes)
    .use(GalleryItemRoutes);

// Export Routes sebagai default
export default Routes;
