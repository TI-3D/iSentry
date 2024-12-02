// import elysia
import { Elysia, t } from "elysia";

// import routes
import UserRoutes from "./UserRoutes";
import IdentityRoutes from "./IdentityRoutes";
import SystemLogRoutes from "./SystemLogRoutes";
import DetectionLogRoutes from "./DetectionLogRoutes";
import MediaRoutes from "./MediaRoutes";
import FaceRoutes from "./FaceRoutes";
import AuthRoutes from "./AuthRoutes";
import { verify } from "../controllers/JWTControllers";

const Routes = new Elysia()
    .use(AuthRoutes)
    .guard({
        headers: t.Object({
            authorization: t.String({ error: "Authorization is required" }),
        }),
    })
    .onBeforeHandle(async ({ headers, jwt }) => {
        const token = headers.authorization.split(" ")[1];
        const response = await verify(token, jwt);
        if (response) {
            return response;
        }
    })
    .use(UserRoutes)
    .use(IdentityRoutes)
    .use(SystemLogRoutes)
    .use(DetectionLogRoutes)
    .use(MediaRoutes)
    .use(FaceRoutes);

// Export Routes sebagai default
export default Routes;
