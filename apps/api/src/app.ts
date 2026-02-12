import Fastify from "fastify";
import cors from "@fastify/cors";
import swagger from "@fastify/swagger";
import swaggerUi from "@fastify/swagger-ui";
import { healthRoutes } from "./adapters/health.js";
import { districtRoutes } from "./adapters/districts.js";

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
          "Transparentna platforma danych publicznych o kandydatach wyborczych",
        version: "0.1.0",
      },
      servers: [{ url: "http://localhost:3000" }],
      tags: [
        { name: "health", description: "Health check" },
        { name: "districts", description: "Okręgi wyborcze" },
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

  return app;
}

