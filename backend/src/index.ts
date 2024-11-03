import { Elysia } from "elysia";
import Routes from "./routes";

const app = new Elysia();

app.get("/", () => "Hello Elysia!");
app.group("/api", (app) => app.use(Routes));
app.listen(3000);

console.log(
    `🦊 Elysia is running at ${app.server?.hostname}:${app.server?.port}`
);
