import { error } from "elysia";
import prisma from "../../prisma/client";

export const login = async (body: { username: string; password: string }) => {
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

        // Memverifikasi password
        const isPasswordValid = body.password == user.password;
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
            },
        };
    } catch (err) {
        console.error("Login error:", err);
        return error(500, { success: false, message: "Internal Server Error" });
    }
};
