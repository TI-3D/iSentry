import prisma from "../../prisma/client";
import { error } from "elysia";
import { JWTPayloadSpec } from "@elysiajs/jwt";

export type JwtParameter = {
    readonly sign: (
        morePayload: Record<string, string | number> & JWTPayloadSpec
    ) => Promise<string>;
    readonly verify: (
        jwt?: string
    ) => Promise<false | (Record<string, string | number> & JWTPayloadSpec)>;
};

export const verify = async (token: string, jwt: JwtParameter) => {
    const profile = await jwt.verify(token);
    if (!profile) {
        return error(403, {
            success: false,
            message: "Token not valid",
        });
    }

    const currentTime = Math.floor(Date.now() / 1000); // Current time in seconds
    if (profile.exp && profile.exp < currentTime) {
        return error(403, {
            success: false,
            message: "Token has expired",
        });
    }

    const token_from_db = await prisma.token.findUnique({
        where: { token: token },
    });

    if (!token_from_db) {
        return error(403, {
            success: false,
            message: "Token not found in database",
        });
    }
};

export const renew = async (
    refresh_token: string,
    jwt: JwtParameter,
    jwt_refresh: JwtParameter
) => {
    const profile = await jwt_refresh.verify(refresh_token);
    if (!profile) {
        return error(403, {
            success: false,
            message: "Token not valid",
        });
    }

    const currentTime = Math.floor(Date.now() / 1000); // Current time in seconds
    if (profile.exp && profile.exp < currentTime) {
        return error(403, {
            success: false,
            message: "Token has expired",
        });
    }

    const token_from_db = await prisma.token.findUnique({
        where: { token: refresh_token },
    });

    if (token_from_db?.type !== "REFRESH") {
        return error(403, {
            success: false,
            message: "Token cannot be used",
        });
    }

    if (!token_from_db) {
        return error(403, {
            success: false,
            message: "Token not found in database",
        });
    }

    const token = await jwt.sign({
        id: profile.id,
        username: profile.username,
        type: "access",
    });
    const token_refresh = await jwt_refresh.sign({
        id: profile.id,
        username: profile.username,
        type: "refresh",
    });

    await prisma.token.deleteMany({
        where: { userId: Number(profile.id) },
    });

    await prisma.token.createMany({
        data: [
            { token, userId: Number(profile.id), type: "ACCESS" },
            {
                token: token_refresh,
                userId: Number(profile.id),
                type: "REFRESH",
            },
        ],
    });

    return {
        success: true,
        message: "Token renewed",
        data: {
            token,
            token_refresh,
        },
    };
};
