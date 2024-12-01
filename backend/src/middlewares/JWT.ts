import jwt from "@elysiajs/jwt";
import Elysia, { t } from "elysia";
import prisma from "../../prisma/client";

const JWT = new Elysia()
    .use(
        jwt({
            name: "jwt",
            secret: "Skibidi_Sigma_Mewing_Rizz_Gyatt_inOhio_+1000Aura",
            exp: "1d",
        })
    )
    .guard({
        body: t.Object({
            token: t.String(),
        })
    })
    .onBeforeHandle(async ( { body, jwt }) => {
    const profile = await jwt.verify(body.token);
    if (!profile) {
        return {
            success: false,
            message: "Token not valid",
        };
    }

    const currentTime = Math.floor(Date.now() / 1000); // Current time in seconds
    if (profile.exp && profile.exp < currentTime) {
        return {
            success: false,
            message: "Token has expired",
        };
    
    }

    const token = await prisma.token.findUnique({
        where: { token: body.token },
    });

    if (!token) {
        return {
            success: false,
            message: "Token not found in database",
        };
    }

    return {
        success: true,
        message: "Token valid",
    };
    })