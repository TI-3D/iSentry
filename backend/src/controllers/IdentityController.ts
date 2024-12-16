//import prisma client
import { fa } from "@faker-js/faker/.";
import prisma from "../../prisma/client";
import { deleteUser } from "./UserController";
const path = require("path");
import { Role } from "@prisma/client";

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

export async function getIdentitiesWithoutUserRelation() {
    try {
        // Get identities without a relation in the User table
        const identities = await prisma.identity.findMany({
            where: {
                id: {
                    notIn: (
                        await prisma.user.findMany({
                            select: {
                                identityId: true,
                            },
                        })
                    )
                        .map((user) => user.identityId)
                        .filter((id): id is number => id !== null), // Extract identityIds from users and filter out null values
                },
            },
            orderBy: { id: "asc" },
        });

        // Return response JSON
        return {
            success: true,
            message: "List Data Identity Without User Relation!",
            data: identities,
        };
    } catch (e: unknown) {
        console.error(`Error getting identities without relation: ${e}`);
        throw new Error("Failed to get identities without user relation.");
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

export async function createIdentityAndUpdateFace(options: {
    name: string;
    faceIds: number[];
}) {
    const { name, faceIds } = options;
    if (!faceIds || faceIds.length === 0) {
        return {
            success: false,
            message: "faceIds cannot be empty",
        };
    }
    try {
        const result = await prisma.$transaction(async (prisma) => {
            const identity = await prisma.identity.create({
                data: {
                    name,
                },
            });

            const updatedFaces = await prisma.face.updateMany({
                where: {
                    id: {
                        in: faceIds,
                    },
                },
                data: {
                    identity: identity.id,
                },
            });

            return { identity, updatedFaces };
        });

        return {
            success: true,
            message: "Identity Created and Faces Updated Successfully!",
            data: {
                identityName: result.identity.name,
                updatedFaceIds: faceIds,
            },
        };
    } catch (e: unknown) {
        console.error(`Error creating identity and updating faces: ${e}`);
        return {
            success: false,
            message: "Failed to create identity and update faces",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

export async function addFaceToIdentity(options: {
    identityId: number;
    faceId: number;
}) {
    try {
        const { identityId, faceId } = options;

        const updatedFace = await prisma.face.update({
            where: { id: faceId },
            data: {
                identity: identityId,
            },
        });

        return {
            success: true,
            message: "Face Updated Successfully!",
            data: updatedFace,
        };
    } catch (e: unknown) {
        console.error(`Error updating face: ${e}`);
        return {
            success: false,
            message: "Failed to update face",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

export async function removeFaceFromIdentity(options: { faceId: number }) {
    try {
        const { faceId } = options;

        const updatedFace = await prisma.face.update({
            where: { id: faceId },
            data: {
                identity: null,
            },
        });

        return {
            success: true,
            message: "Face Deleted Successfully!",
            data: updatedFace,
        };
    } catch (e: unknown) {
        console.error(`Error updating face: ${e}`);
        return {
            success: false,
            message: "Failed to deleted face",
            error: e instanceof Error ? e.message : String(e),
        };
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
            select: {
                id: true,
                name: true,
                faces: {
                    select: {
                        id: true,
                        singlePictures: {
                            select: {
                                path: true,
                            },
                        },
                    },
                },
                key: true,
                createdAt: true,
                updatedAt: true,
            },
        });

        if (!identities) {
            return {
                success: false,
                message: "Identity Not Found!",
                data: null,
            };
        }

        for (const face of identities.faces) {
            if (!face.singlePictures) {
                continue;
            }
            const fileName = path.basename(face.singlePictures.path);
            face.singlePictures.path = `/public/${fileName}`;
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
        key?: boolean;
    }
) {
    try {
        const identityId = parseInt(id);
        const { name, key } = options;

        const identities = await prisma.identity.update({
            where: { id: identityId },
            data: {
                ...(name ? { name } : {}),
                ...(key !== undefined ? { key } : {}),
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
            where: { identityId: identityId, role: Role.RESIDENT },
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
