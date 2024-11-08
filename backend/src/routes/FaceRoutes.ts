// import elysia
import { Elysia, t } from "elysia";

// import controller
import {
    getFace,
    getFaceById,
    createFace,
    updateFace,
    deleteFace,
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
                landmarks: Buffer.from(body.landmarks, "base64"),
                picture_full: body.picture_full,
                picture_single: body.picture_single,
                bounding_box: Buffer.from(body.bounding_box, "base64"),
            });
        },
        {
            body: t.Object({
                identity: t.Number(),
                landmarks: t.String(),
                picture_full: t.Number(),
                picture_single: t.Number(),
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
                landmarks?: String;
                picture_full?: number;
                picture_single?: number;
                bounding_box?: String;
            };
        }) => {
            const { id } = request.params;
            const { body } = request;

            const updatedFaceData = {
                identity: body.identity,
                landmarks: body.landmarks
                    ? Buffer.from(body.landmarks, "base64")
                    : undefined,
                picture_full: body.picture_full,
                picture_single: body.picture_single,
                bounding_box: body.bounding_box
                    ? Buffer.from(body.bounding_box, "base64")
                    : undefined,
            };

            return await updateFace(id, updatedFaceData);
        },
        {
            body: t.Object({
                identity: t.Number({ minLength: 1, maxLength: 100 }),
                landmarks: t.String(),
                picture_full: t.Number({ minLength: 1, maxLength: 100 }),
                picture_single: t.Number({ minLength: 1, maxLength: 100 }),
                bounding_box: t.String(),
            }),
        }
    )

    // route to delete a face
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteFace(id);
    });

export default FaceRoutes;
