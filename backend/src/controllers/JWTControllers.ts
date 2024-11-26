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

    const token = await prisma.token.findUnique({
        where: { token: body.token },
    });

    if (!token) {
        return {
            success: false,
            message: "Token not found",
        };
    }

    if (token.createdAt.getSeconds() + token.duration < Date.now()) {
        return {
            success: false,
            message: "Token Expired",
        };
    }

    return {
        success: true,
        message: "Token valid",
    };
};
