//import prisma client
import { Capture_method } from "@prisma/client";
import { Item_type } from "@prisma/client";
import prisma from "../../prisma/client";

/**
 * Getting all gallery item
 */
export async function getGalleryItem() {
    try {
        //get all gallery item
        const galleryItems = await prisma.gallery_Item.findMany({
            orderBy: { id: "asc" },
        });

        //return response json
        return {
            success: true,
            message: "List Data Gallery Item!",
            data: galleryItems,
        };
    } catch (e: unknown) {
        console.error(`Error getting gallery item: ${e}`);
    }
}

/**
 * Creating a gallery item
 */
export async function createGalleryItem(options: {
    capture_method: Capture_method;
    type: Item_type;
    path: string;
}) {
    try {
        const galleryItems = await prisma.gallery_Item.create({
            data: {
                capture_method: options.capture_method,
                type: options.type,
                path: options.path,
            },
        });
        return {
            success: true,
            message: "Gallery Item Created Successfully!",
            data: galleryItems,
        };
    } catch (e: unknown) {
        console.error(`Error creating gallery item: ${e}`);
    }
}

/**
 * Getting a gallery item by ID
 */
export async function getGalleryItemById(id: string) {
    try {
        const galleryItemId = parseInt(id);
        const galleryItems = await prisma.gallery_Item.findUnique({
            where: { id: galleryItemId },
        });

        if (!galleryItems) {
            return {
                success: false,
                message: "Gallery Item Not Found!",
                data: null,
            };
        }

        return {
            success: true,
            message: `Gallery Item Details for ID: ${id}`,
            data: galleryItems,
        };
    } catch (e: unknown) {
        console.error(`Error getting gallery item: ${e}`);
        return { success: false, message: "Internal Server Error" };
    }
}

/**
 * Updating a gallery item
 */
export async function updateGalleryItem(
    id: string,
    options: {
        capture_method?: Capture_method;
        type?: Item_type;
        path?: string;
    }
) {
    try {
        const galleryItemId = parseInt(id);
        const { capture_method, type, path } = options;

        const galleryItems = await prisma.gallery_Item.update({
            where: { id: galleryItemId },
            data: {
                ...(capture_method ? { capture_method } : {}),
                ...(type ? { type } : {}),
                ...(path ? { path } : {}),
            },
        });

        return {
            success: true,
            message: "Gallery Item Updated Successfully!",
            data: galleryItems,
        };
    } catch (e: unknown) {
        console.error(`Error updating gallery item: ${e}`);
    }
}

/**
 * Deleting a gallery Item
 */
export async function deleteGalleryItem(id: string) {
    try {
        const galleryItemId = parseInt(id);
        await prisma.gallery_Item.delete({ where: { id: galleryItemId } });

        return {
            success: true,
            message: "Gallery Item Deleted Successfully!",
        };
    } catch (e: unknown) {
        console.error(`Error deleting gallery item: ${e}`);
    }
}
