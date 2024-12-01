import prisma from "../../prisma/client";
import { JWTPayloadSpec } from "@elysiajs/jwt";

export type JwtParameter = {
    readonly sign: (
        morePayload: Record<string, string | number> & JWTPayloadSpec
    ) => Promise<string>;
    readonly verify: (
        jwt?: string
    ) => Promise<false | (Record<string, string | number> & JWTPayloadSpec)>;
};

export const verify = async (body: { token: string }, jwt: JwtParameter) => {
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
};
