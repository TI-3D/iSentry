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

export const verify = async (token: string , jwt: JwtParameter) => {
    const profile = await jwt.verify(token);
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

    const token_from_db = await prisma.token.findUnique({
        where: { token: token },
    });

    if (!token_from_db) {
        return {
            success: false,
            message: "Token not found in database",
        };
    }
};

type VerifyResponse = {
    success: boolean;
    message: string;
};