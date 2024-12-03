import { Elysia } from "elysia";
import Routes from "./routes";
import swagger from "@elysiajs/swagger";
import { staticPlugin } from "@elysiajs/static";

const app = new Elysia();
app.use(staticPlugin({ assets: "assets", prefix: "/public" }));
app.use(swagger());
app.get("/", () => "Hello Elysia!");
app.group("/api", (app) => app.use(Routes));
app.listen({
    hostname: "localhost", // change sesuai IP address
    port: 3000,
});

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
