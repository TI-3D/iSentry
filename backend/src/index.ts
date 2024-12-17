import { Elysia } from "elysia";
import Routes from "./routes";
import swagger from "@elysiajs/swagger";
import { staticPlugin } from "@elysiajs/static";
import { logger } from "@grotto/logysia";
import { rateLimit } from "elysia-rate-limit";

const app = new Elysia();
const homepath =
    process.env.HOME ?? process.env.HOMEPATH ?? process.env.USERPROFILE ?? "";
app.use(
    staticPlugin({ assets: `${homepath}/isentry/medias`, prefix: "/public" })
);
app.use(
    logger({
        logIP: false,
        writer: {
            write(msg: string) {
                console.log(msg);
            },
        },
    })
);
app.use(swagger());
app.get("/", () => "Hello Elysia!");
app.group("/api", (app) => app.use(Routes));
app.use(rateLimit({ duration: 1000, max: 3 }));
app.listen({
    hostname: "0.0.0.0",
    port: 3000,
});

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
