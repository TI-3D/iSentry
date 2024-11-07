// import elysia
import { Elysia, t } from "elysia";

// import controller
import {
    getGalleryItem,
    getGalleryItemById,
    createGalleryItem,
    updateGalleryItem,
    deleteGalleryItem,
} from "../controllers/GalleryItemController";
import { Capture_method } from "@prisma/client";
import { Item_type } from "@prisma/client";

const GalleryItemRoutes = new Elysia({ prefix: "/gallery-items" })

    // route to get all gallery item
    .get("/", async () => {
        return await getGalleryItem();
    })

    // route to create a gallery item
    .post(
        "/",
        async ({ body }) => {
            return await createGalleryItem(
                body as {
                    capture_method: Capture_method;
                    type: Item_type;
                    path: string;
                }
            );
        },
        {
            body: t.Object({
                capture_method: t.Enum(Capture_method),
                type: t.Enum(Item_type),
                path: t.String({ minLength: 5, maxLength: 100 }),
            }),
        }
    )

    // route to get gallery item by id
    .get("/:id", async ({ params: { id } }) => {
        return await getGalleryItemById(id);
    })

    // route to update a gallery item
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateGalleryItem(
                id,
                body as {
                    capture_method?: Capture_method;
                    type?: Item_type;
                    path?: string;
                }
            );
        },
        {
            body: t.Object({
                capture_method: t.Enum(Capture_method),
                type: t.Enum(Item_type),
                path: t.String({ minLength: 5, maxLength: 100 }),
            }),
        }
    )

    // route to delete a gallery item
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteGalleryItem(id);
    });

export default GalleryItemRoutes;
