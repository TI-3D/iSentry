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
            message: "List Data Face Item!",
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
    recognized: number;
    identity: number;
    landmarks: Buffer;
    picture_full: number;
    picture_single: number;
    bounding_box: Buffer;
}) {
    try {
        const faces = await prisma.face.create({
            data: {
                recognized: options.recognized,
                identity: options.identity,
                landmarks: options.landmarks,
                picture_full: options.picture_full,
                picture_single: options.picture_single,
                bounding_box: options.bounding_box,
            },
        });
        return {
            success: true,
            message: "Face Item Created Successfully!",
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
                message: "Face Item Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Face Item Details for ID: ${id}`,
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error getting face item: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a face
 */
export async function updateFace(
    id: string,
    options: {
        recognized?: number;
        identity?: number;
        landmarks?: Buffer;
        picture_full?: number;
        picture_single?: number;
        bounding_box?: Buffer;
    }
) {
    try {
        const faceId = parseInt(id);
        const {
            recognized,
            identity,
            landmarks,
            picture_full,
            picture_single,
            bounding_box,
        } = options;

        const faces = await prisma.face.update({
            where: { id: faceId },
            data: {
                ...(recognized ? { recognized } : {}),
                ...(identity ? { identity } : {}),
                ...(landmarks ? { landmarks } : {}),
                ...(picture_full ? { picture_full } : {}),
                ...(picture_single ? { picture_single } : {}),
                ...(bounding_box ? { bounding_box } : {}),
            },
        });

        return {
            success: true,
            message: "Face Item Updated Successfully!",
            data: faces,
        };
    } catch (e: unknown) {
        console.error(`Error updating gallery item: ${e}`);
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
