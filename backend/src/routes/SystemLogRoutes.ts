// import elysia
import { Elysia, t } from "elysia";

//import controller
import {
    getSystemLogs,
    getSystemLogById,
    createSystemLog,
    updateSystemLog,
    deleteSystemLog,
} from "../controllers/SystemLogController";

const SystemLogRoutes = new Elysia({ prefix: "/system-log" })

    //route get all identity
    .get("/", () => getSystemLogs())

    // route to create a identity
    .post(
        "/",
        async ({ body }) => {
            return await createSystemLog(
                body as {
                    message: string;
                }
            );
        },
        {
            body: t.Object({
                message: t.String({ minLength: 10, maxLength: 100 }),
            }),
        }
    )

    // route to get identity by id
    .get("/:id", async ({ params: { id } }) => {
        return await getSystemLogById(id);
    })

    // route to update a identity
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateSystemLog(
                id,
                body as {
                    message?: string;
                }
            );
        },
        {
            body: t.Object({
                message: t.Optional(
                    t.String({ minLength: 10, maxLength: 100 })
                ),
            }),
        }
    )

    // route to delete a identity
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteSystemLog(id);
    });

export default SystemLogRoutes;
