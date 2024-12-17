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
app.use(rateLimit({ duration: 1000, max: 20 }));
app.group("/api", (app) => app.use(Routes));

if (process.env.NODE_ENV == "production") {
    app.listen({
        hostname: "0.0.0.0",
        port: 3000,
        tls: {
          key: Bun.file(`${import.meta.dir}/../ssl/key.pem`),
          cert: Bun.file(`${import.meta.dir}/../ssl/cert.pem`),
          passphrase: "kocaggeming"
        },
    });
} else {
    app.listen({
        hostname: "0.0.0.0",
        port: 3000,
    });
}

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
