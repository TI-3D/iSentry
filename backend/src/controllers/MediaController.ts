//import prisma client
import { Capture_method } from "@prisma/client";
import { Item_type } from "@prisma/client";
import prisma from "../../prisma/client";

/**
 * Getting all media
 */
export async function getMedia() {
    try {
        //get all media
        const media = await prisma.media.findMany({
            orderBy: { id: "asc" },
        });

        //return response json
        return {
            success: true,
            message: "List Data Media!",
            data: media,
        };
    } catch (e: unknown) {
        console.error(`Error getting media: ${e}`);
    }
}

/**
 * Creating a media
 */
export async function createMedia(options: {
    capture_method: Capture_method;
    type: Item_type;
    path: string;
}) {
    try {
        const media = await prisma.media.create({
            data: {
                capture_method: options.capture_method,
                type: options.type,
                path: options.path,
            },
        });
        return {
            success: true,
            message: "Media Created Successfully!",
            data: media,
        };
    } catch (e: unknown) {
        console.error(`Error creating media: ${e}`);
    }
}

/**
 * Getting a media by ID
 */
export async function getMediaById(id: string) {
    try {
        const mediaId = parseInt(id);
        const media = await prisma.media.findUnique({
            where: { id: mediaId },
        });

        if (!media) {
            return {
                success: false,
                message: "Media Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Media Details for ID: ${id}`,
            data: media,
        };
    } catch (e: unknown) {
        console.error(`Error getting media: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a media
 */
export async function updateMedia(
    id: string,
    options: {
        capture_method?: Capture_method;
        type?: Item_type;
        path?: string;
    }
) {
    try {
        const mediaId = parseInt(id);
        const { capture_method, type, path } = options;

        const media = await prisma.media.update({
            where: { id: mediaId },
            data: {
                ...(capture_method ? { capture_method } : {}),
                ...(type ? { type } : {}),
                ...(path ? { path } : {}),
            },
        });

        return {
            success: true,
            message: "Media Updated Successfully!",
            data: media,
        };
    } catch (e: unknown) {
        console.error(`Error updating media: ${e}`);
    }
}

/**
 * Deleting a media
 */
export async function deleteMedia(id: string) {
    try {
        const mediaId = parseInt(id);
        await prisma.media.delete({ where: { id: mediaId } });

        return {
            success: true,
            message: "Media Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting media: ${e}`);
    }
}
