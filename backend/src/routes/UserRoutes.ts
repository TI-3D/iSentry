// import elysia
import { Elysia, t } from "elysia";

// import controller
import {
    getUsers,
    createUser,
    getUserById,
    updateUser,
    deleteUser,
} from "../controllers/UserController";
import { Role } from "@prisma/client";

const UserRoutes = new Elysia({ prefix: "/users" })

    // route to get all users
    .get("/", async () => {
        return await getUsers();
    })

    // route to create a user
    .post(
        "/",
        async ({ body }) => {
            return await createUser(
                body as {
                    username: string;
                    name: string;
                    password: string;
                    role: Role;
                    identityId?: number | null;
                }
            );
        },
        {
            body: t.Object({
                username: t.String({ minLength: 5, maxLength: 100 }),
                name: t.String({ minLength: 3, maxLength: 100 }),
                password: t.String({ minLength: 7, maxLength: 15 }),
                role: t.Enum(Role),
                identityId: t.Optional(t.Number()),
            }),
        }
    )

    // route to get user by id
    .get("/:id", async ({ params: { id } }) => {
        return await getUserById(id);
    })

    // route to update a user
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateUser(
                id,
                body as {
                    username?: string;
                    name?: string;
                    password?: string;
                    role?: Role;
                    identityId?: number | null;
                }
            );
        },
        {
            body: t.Object({
                username: t.Optional(
                    t.String({ minLength: 5, maxLength: 100 })
                ),
                name: t.Optional(t.String({ minLength: 3, maxLength: 100 })),
                password: t.Optional(t.String({ minLength: 7, maxLength: 15 })),
                role: t.Optional(t.Enum(Role)),
                identityId: t.Number({ optional: true }),
            }),
        }
    )

    // route to delete a user
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteUser(id);
    });

export default UserRoutes;
