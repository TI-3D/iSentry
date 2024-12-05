import { error } from "elysia";
import prisma from "../../prisma/client";
import { JwtParameter } from "./JWTControllers";

export const login = async (
    body: { username: string; password: string },
    jwt: JwtParameter,
    jwt_refresh: JwtParameter
) => {
    try {
        // Memeriksa apakah pengguna ada di database
        const user = (
            await prisma.user.findMany({
                where: { username: body.username },
            })
        )[0];

        if (!user) {
            return error(404, { success: false, message: "User not found" });
        }

        const token = await jwt.sign({
            id: user.id,
            username: user.username,
            type: "access",
        });
        const token_refresh = await jwt_refresh.sign({
            id: user.id,
            username: user.username,
            type: "refresh",
        });

        await prisma.token.createMany({
            data: [
                { token, userId: user.id, type: "ACCESS" },
                { token: token_refresh, userId: user.id, type: "REFRESH" },
            ],
        });

        // Memverifikasi password
        const isPasswordValid = await Bun.password.verify(
            body.password,
            user.password
        );
        if (!isPasswordValid) {
            return error(404, { success: false, message: "User not found" });
        }

        // Mengirimkan respons sukses dengan data pengguna
        return {
            success: true,
            message: "Login successful",
            data: {
                user: {
                    id: user.id,
                    username: user.username,
                    name: user.name,
                    role: user.role,
                },
                token,
                token_refresh,
            },
        };
    } catch (err) {
        console.error("Login error:", err);
        return error(500, { success: false, message: "Internal Server Error" });
    }
};

export const logout = async (id: string) => {
    try {
        const idUser = parseInt(id);
        const checkId = await prisma.user.findUnique({
            where: { id: idUser },
        });

        if (!checkId) {
            return error(404, { success: false, message: "User not found" });
        }

        const checkToken = await prisma.token.findMany({
            where: { userId: idUser },
        });

        if (!checkToken) {
            return error(404, { success: false, message: "Token not found" });
        }

        await prisma.token.deleteMany({
            where: { userId: idUser },
        });

        // Mengirimkan respons sukses
        return {
            success: true,
            message: "Logout successful",
        };
    } catch (err) {
        console.error("Logout error:", err);
        return error(500, { success: false, message: "Internal Server Error" });
    }
};
