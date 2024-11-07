// import prisma client
import { Role } from "@prisma/client";
import prisma from "../../prisma/client";

/**
 * Getting all users
 */
export async function getUsers() {
    try {
        const users = await prisma.user.findMany({
            orderBy: { id: "asc" },
        });
        return {
            success: true,
            message: "List Data Users!",
            data: users,
        };
    } catch (e: unknown) {
        console.error(`Error getting users: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Creating a user
 */
export async function createUser(options: {
    name: string;
    email: string;
    password: string;
    role: Role;
}) {
    try {
        const users = await prisma.user.create({
            data: {
                name: options.name,
                email: options.email,
                password: options.password,
                role: options.role,
            },
        });
        return {
            success: true,
            message: "User Created Successfully!",
            data: users,
        };
    } catch (e: unknown) {
        console.error(`Error creating user: ${e}`);
    }
}

/**
 * Getting a user by ID
 */
export async function getUserById(id: string) {
    try {
        const userId = parseInt(id);
        const users = await prisma.user.findUnique({
            where: { id: userId },
        });

        if (!users) {
            return {
                success: false,
                message: "User Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `User Details for ID: ${id}`,
            data: users,
        };
    } catch (e: unknown) {
        console.error(`Error getting user: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a user
 */
export async function updateUser(
    id: string,
    options: {
        name?: string;
        email?: string;
        password?: string;
        role?: Role;
    }
) {
    try {
        const userId = parseInt(id);
        const { name, email, password, role } = options;

        const users = await prisma.user.update({
            where: { id: userId },
            data: {
                ...(name ? { name } : {}),
                ...(email ? { email } : {}),
                ...(password ? { password } : {}),
                ...(role ? { role } : {}),
            },
        });

        return {
            success: true,
            message: "User Updated Successfully!",
            data: users,
        };
    } catch (e: unknown) {
        console.error(`Error updating user: ${e}`);
    }
}

/**
 * Deleting a user
 */
export async function deleteUser(id: string) {
    try {
        const userId = parseInt(id);
        await prisma.user.delete({ where: { id: userId } });

        return {
            success: true,
            message: "User Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting user: ${e}`);
    }
}
