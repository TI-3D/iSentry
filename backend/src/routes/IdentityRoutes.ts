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
    addFaceToIdentity,
    removeFaceFromIdentity,
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
                    key: boolean;
                }
            );
        },
        {
            body: t.Object({
                name: t.String({ minLength: 3, maxLength: 100 }),
                faceIds: t.Array(t.Number(), { minLength: 0, maxLength: 100 }),
                key: t.Boolean(),
            }),
        }
    )

    // route add face to identity
    .post(
        "/:id/face",
        async ({ params: { id }, body }) => {
            return await addFaceToIdentity({
                identityId: Number(id),
                faceId: (body as { faceId: number }).faceId,
            });
        },
        {
            body: t.Object({
                faceId: t.Number(),
            }),
        }
    )

    // route remove face from identity
    .delete("/:id/face/:faceId", async ({ params: { faceId } }) => {
        return await removeFaceFromIdentity({
            faceId: Number(faceId),
        });
    })

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
                    key?: boolean;
                }
            );
        },
        {
            body: t.Object({
                name: t.Optional(t.String({ minLength: 3, maxLength: 100 })),
                key: t.Optional(t.Boolean()),
            }),
        }
    )

    // route to delete a identity
    .delete("/:id", async ({ params: { id } }) => {
        return await deleteIdentity(id);
    });

export default IdentityRoutes;
