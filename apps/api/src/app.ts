import Fastify from "fastify";
import cors from "@fastify/cors";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";
import { healthRoutes } from "./adapters/health.js";
import { districtRoutes } from "./adapters/districts.js";
import { assetDeclarationRoutes } from "./adapters/asset_declarations.js";

export async function buildApp() {
  const app = Fastify({
    logger: {
      level: "info",
      transport: {
        target: "pino-pretty",
        options: { colorize: true },
      },
    },
  });

  await app.register(cors, { origin: true });

  await app.register(swagger, {
    openapi: {
      info: {
        title: "kogowybrac.app API",
        description:
          "Transparent platform for public data about electoral candidates",
        version: "0.1.0",
      },
      servers: [{ url: "http://localhost:3000" }],
      tags: [
        { name: "health", description: "Health check" },
        { name: "districts", description: "Electoral districts" },
        { name: "asset-declarations", description: "Asset declarations" },
      ],
    },
  });

  await app.register(swaggerUi, {
    routePrefix: "/docs",
    uiConfig: {
      docExpansion: "list",
      deepLinking: true,
    },
  });

  await app.register(healthRoutes);
  await app.register(districtRoutes, { prefix: "/api/v1" });
  await app.register(assetDeclarationRoutes, { prefix: "/api/v1" });

  return app;
}

