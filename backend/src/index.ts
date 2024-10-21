import swagger from "@elysiajs/swagger";
import { Elysia } from "elysia";

function main() {
  const app = new Elysia()
    .use(swagger())
    .get("/", () => "Hello Elysia")
    .listen({
      port: "3000",
      // tls: {
      //   key: Bun.file(import.meta.dir + "/../self_signed_certs/key.pem"),
      //   cert: Bun.file(import.meta.dir + "/../self_signed_certs/cert.pem"),
      // }
    });

  console.log(
    `🦊 iSentry-web-server is running at ${app.server?.hostname}:${app.server?.port}`
  );
}

main()

