import { buildApp } from "./app.js";
import { config } from "./config.js";

async function main() {
  const app = await buildApp();

  try {
    await app.listen({ port: config.port, host: config.host });
    console.log(`🚀 API running at http://${config.host}:${config.port}`);
    console.log(
      `📖 Swagger UI at http://${config.host}:${config.port}/docs`
    );
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
}

main();

