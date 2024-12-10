// import elysia
import { Elysia, t } from "elysia";

//import controller
import {
    getDetectionLogs,
    getDetectionLogById,
    createDetectionLog,
    updateDetectionLog,
    deleteDetectionLog,
    getDetailDetectionLogs,
    createManyDetectionLog,
    getDetectionLogIdentity,
} from "../controllers/DetectionLogController";

const DetectionLogRoutes = new Elysia({ prefix: "/detection-logs" })

    //route get all detection log
    .get("/", () => getDetectionLogs())

    .get("/detail", () => getDetailDetectionLogs())

    // route to create a detection log
    .post(
        "/",
        async ({ body }) => {
            return await createDetectionLog(
                body as {
                    face: number;
                }
            );
        },
        {
            body: t.Object({
                face: t.Number({ minLength: 1, maxLength: 100 }),
            }),
        }
    )

    .post(
        "/create-many",
        async ({ body }) => {
            return await createManyDetectionLog(
                body as {
                    face: number[];
                }
            );
        },
        {
            body: t.Object({
                face: t.Array(t.Number({ minLength: 1, maxLength: 100 })),
            }),
        }
    )

    .get("/by-identity/:id", async ({ params: { id } }) => {
        return await getDetectionLogIdentity(id);
    })

    // route to get detection log by id
    .get("/:id", async ({ params: { id } }) => {
        return await getDetectionLogById(id);
    })

    // route to update a detection log
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateDetectionLog(
                id,
                body as {
                    face?: number;
                }
            );
        },
        {
            body: t.Object({
                face: t.Optional(t.Number({ minLength: 1, maxLength: 100 })),
            }),
        }
    )

    // route to delete a detection log
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteDetectionLog(id);
    });

export default DetectionLogRoutes;
