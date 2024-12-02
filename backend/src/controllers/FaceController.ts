//import prisma client
import prisma from "../../prisma/client";

/**
 * Getting all face
 */
export async function getFace() {
    try {
        //get all face
        const faces = await prisma.face.findMany({
            orderBy: { id: "asc" },
        });

        //return response json
        return {
            success: true,
            message: "List Data Face!",
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error getting face : ${e}`);
    }
}

/**
 * Creating a face
 */
export async function createFace(options: {
    identity: number;
    embedding: Buffer;
    picture_full: number | null;
    picture_single: number | null;
    bounding_box: Buffer;
}) {
    try {
        const faces = await prisma.face.create({
            data: {
                identity: options.identity,
                embedding: options.embedding,
                picture_full: options.picture_full ?? null,
                picture_single: options.picture_single ?? null,
                bounding_box: options.bounding_box,
            },
        });
        return {
            success: true,
            message: "Face Created Successfully!",
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error creating face : ${e}`);
        return {
            success: false,
            message: "Failed to create face",
            error: e instanceof Error ? e.message : String(e),
        };
    }
}

/**
 * Getting a face by ID
 */
export async function getFaceById(id: string) {
    try {
        const faceId = parseInt(id);
        const faces = await prisma.face.findUnique({
            where: { id: faceId },
        });

        if (!faces) {
            return {
                success: false,
                message: "Face Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Face Details for ID: ${id}`,
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error getting face : ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a face
 */
export async function updateFace(
    id: string,
    options: {
        identity?: number;
        embedding?: Buffer;
        picture_full?: number;
        picture_single?: number;
        bounding_box?: Buffer;
    }
) {
    try {
        const faceId = parseInt(id);
        const {
            identity,
            embedding,
            picture_full,
            picture_single,
            bounding_box,
        } = options;

        const faces = await prisma.face.update({
            where: { id: faceId },
            data: {
                ...(identity ? { identity } : {}),
                ...(embedding ? { embedding } : {}),
                ...(picture_full ? { picture_full } : {}),
                ...(picture_single ? { picture_single } : {}),
                ...(bounding_box ? { bounding_box } : {}),
            },
        });

        return {
            success: true,
            message: "Face Updated Successfully!",
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error updating face: ${e}`);
    }
}

/**
 * Deleting a face
 */
export async function deleteFace(id: string) {
    try {
        const faceId = parseInt(id);
        await prisma.face.delete({ where: { id: faceId } });

        return {
            success: true,
            message: "Face Item Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting face item: ${e}`);
    }
}

export async function validateFace(face: File) {
    try {
        const respons = await fetch("http://localhost:3001/validate-face");
        const responseBody = await respons.json();
        if (responseBody.success === false) {
            return {
                success: false,
                message: "Face validation failed",
                error: responseBody.error,
            };
        } else {
            return {
                success: true,
                message: "Face validation success",
                face_id: responseBody.face_id,
            };
        }
    } catch (e: unknown) {
        console.error(`Error validating face : ${e}`);
    }
}
