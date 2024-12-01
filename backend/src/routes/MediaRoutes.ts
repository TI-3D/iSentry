// import elysia
import { Elysia, t } from "elysia";

// import controller
import {
    getMedia,
    createMedia,
    getMediaById,
    updateMedia,
    deleteMedia,
} from "../controllers/MediaController";
import { Capture_method } from "@prisma/client";
import { Item_type } from "@prisma/client";

const MediaRoutes = new Elysia({ prefix: "/medias" })

    // route to get all media
    .get("/", async () => {
        return await getMedia();
    })

    // route to create a media
    .post(
        "/",
        async ({ body }) => {
            return await createMedia(
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

    // route to get media by id
    .get("/:id", async ({ params: { id } }) => {
        return await getMediaById(id);
    })

    // route to update a media
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateMedia(
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

    // route to delete a media
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteMedia(id);
    });

export default MediaRoutes;
