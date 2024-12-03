// import elysia
import { Elysia, t } from "elysia";

// import controller
import {
    getFace,
    getFaceById,
    createFace,
    updateFace,
    deleteFace,
    unrecognizedFace,
} from "../controllers/FaceController";

const FaceRoutes = new Elysia({ prefix: "/faces" })

    // route to get all face
    .get("/", async () => {
        return await getFace();
    })

    // route to create a face
    .post(
        "/",
        async ({ body }) => {
            return await createFace({
                identity: body.identity,
                embedding: Buffer.from(body.embedding, "base64"),
                picture_full: body.picture_full ?? null,
                picture_single: body.picture_single ?? null,
                bounding_box: Buffer.from(body.bounding_box, "base64"),
            });
        },
        {
            body: t.Object({
                identity: t.Number(),
                embedding: t.String(),
                picture_full: t.Optional(t.Number()),
                picture_single: t.Optional(t.Number()),
                bounding_box: t.String(),
            }),
        }
    )

    // route to get face by id
    .get("/:id", async ({ params: { id } }) => {
        return await getFaceById(id);
    })

    .patch(
        "/:id",
        async (request: {
            params: { id: string };
            body: {
                identity?: number;
                embedding?: String;
                picture_full?: number | null;
                picture_single?: number | null;
                bounding_box?: String;
            };
        }) => {
            const { id } = request.params;
            const { body } = request;

            const updatedFaceData = {
                identity: body.identity,
                embedding: body.embedding
                    ? Buffer.from(body.embedding, "base64")
                    : undefined,
                picture_full: body.picture_full ?? undefined,
                picture_single: body.picture_single ?? undefined,
                bounding_box: body.bounding_box
                    ? Buffer.from(body.bounding_box, "base64")
                    : undefined,
            };

            return await updateFace(id, updatedFaceData);
        },
        {
            body: t.Object({
                identity: t.Number({ minLength: 1, maxLength: 100 }),
                embedding: t.String(),
                picture_full: t.Number({
                    minLength: 1,
                    maxLength: 100,
                    optional: true,
                }),
                picture_single: t.Number({
                    minLength: 1,
                    maxLength: 100,
                    optional: true,
                }),
                bounding_box: t.String(),
            }),
        }
    )

    // route to delete a face
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteFace(id);
    })

    .get("/unrecognized", async () => {
        return await unrecognizedFace();
    });

export default FaceRoutes;
