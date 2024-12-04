//import prisma client
import prisma from "../../prisma/client";
import { deleteUser } from "./UserController";

/**
 * Getting all identity
 */
export async function getIdentities() {
    try {
        //get all identity
        const identities = await prisma.identity.findMany({
            orderBy: { id: "asc" },
        });

        //return response json
        return {
            success: true,
            message: "List Data Identity!",
            data: identities,
        };
    } catch (e: unknown) {
        console.error(`Error getting identity: ${e}`);
    }
}

/**
 * Creating a identity
 */
export async function createIdentity(options: { name: string }) {
    try {
        const identities = await prisma.identity.create({
            data: {
                name: options.name,
            },
        });
        return {
            success: true,
            message: "Identity Created Successfully!",
            data: identities,
        };
    } catch (e: unknown) {
        console.error(`Error creating identity: ${e}`);
    }
}

/**
 * Getting a identity by ID
 */
export async function getIdentityById(id: string) {
    try {
        const identityId = parseInt(id);
        const identities = await prisma.identity.findUnique({
            where: { id: identityId },
        });

        if (!identities) {
            return {
                success: false,
                message: "Identity Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Identity Details for ID: ${id}`,
            data: identities,
        };
    } catch (e: unknown) {
        console.error(`Error getting identity: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a identity
 */
export async function updateIdentity(
    id: string,
    options: {
        name?: string;
    }
) {
    try {
        const identityId = parseInt(id);
        const { name } = options;

        const identities = await prisma.identity.update({
            where: { id: identityId },
            data: {
                ...(name ? { name } : {}),
            },
        });

        return {
            success: true,
            message: "Identity Updated Successfully!",
            data: identities,
        };
    } catch (e: unknown) {
        console.error(`Error updating identity: ${e}`);
    }
}

/**
 * Deleting a identity
 */
export async function deleteIdentity(id: string) {
    try {
        const identityId = parseInt(id);
        const user = await prisma.user.findFirst({
            where: { identityId: identityId },
        });
        if (user) {
            await deleteUser(user.id.toString());
        }
        await prisma.identity.delete({ where: { id: identityId } });

        return {
            success: true,
            message: "Identity Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting identity: ${e}`);
    }
}
