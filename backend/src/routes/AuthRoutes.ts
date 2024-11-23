import { Elysia } from "elysia";
import { login } from "../controllers/AuthControllers";
import jwt from "@elysiajs/jwt";

const AuthRoutes = new Elysia({ prefix: "/auth" })
    .use(
        jwt({
            name: "jwt",
            secret: "Skibidi_Sigma_Mewing_Rizz_Gyatt_inOhio_+1000Aura",
            exp: "1d",
        })
    )
    .use(
        jwt({
            name: "jwt_refresh",
            secret: "Skibidi_Sigma_Mewing_Rizz_Gyatt_inOhio_+1000Aura",
            exp: "1m",
        })
    )
    .post("/login", async ({ jwt, jwt_refresh, body }) => {
        return await login(
            body as {
                username: string;
                password: string;
            },
            jwt,
            jwt_refresh
        );
    });

export default AuthRoutes;
