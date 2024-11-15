import { Elysia } from "elysia";
import { login } from "../controllers/AuthControllers";

const AuthRoutes = new Elysia({ prefix: "/auth" }).post(
    "/login",
    async ({ body }) => {
        return await login(
            body as {
                username: string;
                password: string;
            }
        );
    }
);

export default AuthRoutes;
