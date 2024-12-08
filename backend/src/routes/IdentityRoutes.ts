// import elysia
import { Elysia, t } from "elysia";

//import controller
import {
    getIdentities,
    createIdentity,
    getIdentityById,
    updateIdentity,
    deleteIdentity,
    getIdentitiesWithoutUserRelation,
    createIdentityAndUpdateFace,
} from "../controllers/IdentityController";

const IdentityRoutes = new Elysia({ prefix: "/identities" })

    //route get all identity
    .get("/", () => getIdentities())

    .get("/no-account", () => getIdentitiesWithoutUserRelation())
    // route to create a identity

    .post(
        "/",
        async ({ body }) => {
            return await createIdentityAndUpdateFace(
                body as {
                    name: string;
                    faceIds: number[];
                }
            );
        },
        {
            body: t.Object({
                name: t.String({ minLength: 3, maxLength: 100 }),
                faceIds: t.Array(t.Number(), { minLength: 0, maxLength: 100 }),
            }),
        }
    )

    // route to get identity by id
    .get("/:id", async ({ params: { id } }) => {
        return await getIdentityById(id);
    })

    // route to update a identity
    .patch(
        "/:id",
        async ({ params: { id }, body }) => {
            return await updateIdentity(
                id,
                body as {
                    name?: string;
                }
            );
        },
        {
            body: t.Object({
                name: t.Optional(t.String({ minLength: 3, maxLength: 100 })),
            }),
        }
    )

    // route to delete a identity
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteIdentity(id);
    });

export default IdentityRoutes;
