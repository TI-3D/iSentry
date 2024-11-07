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
            // return await createFace(
            //     body as {
            //         recognized: boolean;
            //         identity: number;
            //         landmarks: Buffer;
            //         picture_full: number;
            //         picture_single: number;
            //         bounding_box: Buffer;
            //     }
            // );
            return await createFace({
                recognized: body.recognized,
                identity: body.identity,
                landmarks: Buffer.from(body.landmarks, "base64"), // Konversi dari base64 ke Buffer
                picture_full: body.picture_full,
                picture_single: body.picture_single,
                bounding_box: Buffer.from(body.bounding_box, "base64"), // Konversi dari base64 ke Buffer
            });
        },
        {
            body: t.Object({
                recognized: t.Number(),
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

    // route to update a face
    // .patch(
    //     "/:id",
    //     async ({ params: { id }, body }) => {
    //         return await updateFace(
    //             id,
    //             body as {
    //                 recognized?: boolean;
    //                 identity?: number;
    //                 landmarks?: Buffer;
    //                 picture_full?: number;
    //                 picture_single?: number;
    //                 bounding_box?: Buffer;
    //             }
    //         );
    //     },
    //     {
    //         body: t.Object({
    //             recognized: t.Boolean(),
    //             identity: t.Number({ minLength: 1, maxLength: 100 }),
    //             landmarks: t.String(),
    //             picture_full: t.Number({ minLength: 1, maxLength: 100 }),
    //             picture_single: t.Number({ minLength: 1, maxLength: 100 }),
    //             bounding_box: t.String(),
    //         }),
    //     }
    // )

    .patch(
        "/:id",
        async (request: {
            params: { id: string };
            body: {
                recognized?: number;
                identity?: number;
                landmarks?: string;
                picture_full?: number;
                picture_single?: number;
                bounding_box?: string;
            };
        }) => {
            const { id } = request.params;
            const { body } = request;
            // Mengonversi dari base64 ke Buffer jika ada
            const updatedFaceData = {
                recognized: body.recognized,
                identity: body.identity,
                landmarks: body.landmarks
                    ? Buffer.from(body.landmarks, "base64")
                    : undefined, // Konversi dari base64 ke Buffer jika ada
                picture_full: body.picture_full,
                picture_single: body.picture_single,
                bounding_box: body.bounding_box
                    ? Buffer.from(body.bounding_box, "base64")
                    : undefined, // Konversi dari base64 ke Buffer jika ada
            };

            return await updateFace(id, updatedFaceData);
        },
        {
            body: t.Object({
                recognized: t.Number(), // Menggunakan optional agar tidak semua field wajib
                identity: t.Number({ minLength: 1, maxLength: 100 }),
                landmarks: t.String({ minLength: 5, maxLength: 100 }), // Diterima sebagai base64 string
                picture_full: t.Number({ minLength: 1, maxLength: 100 }),
                picture_single: t.Number({ minLength: 1, maxLength: 100 }),
                bounding_box: t.String({ minLength: 5, maxLength: 100 }), // Diterima sebagai base64 string
            }),
        }
    )

    // route to delete a face
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteFace(id);
    });

export default FaceRoutes;
