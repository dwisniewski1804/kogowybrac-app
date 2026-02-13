import type { FastifyInstance } from "fastify";

// TODO: Replace with actual database query to exposures
// For now, stub data matching the schema

const assetDeclarationSchema = {
  type: "object",
  properties: {
    declaration_id: { type: "string", format: "uuid" },
    person_id: { type: "string" },
    person_name: { type: "string" },
    year: { type: "number" },
    asset_type: { type: "string" },
    asset_description: { type: "string" },
    asset_value: { type: "number" },
    currency: { type: "string" },
  },
} as const;

export async function assetDeclarationRoutes(app: FastifyInstance) {
  app.get<{ Querystring: { person_id?: string; year?: number } }>(
    "/asset-declarations",
    {
      schema: {
        tags: ["asset-declarations"],
        description: "List asset declarations",
        querystring: {
          type: "object",
          properties: {
            person_id: { type: "string" },
            year: { type: "number" },
          },
        },
        response: {
          200: {
            type: "object",
            properties: {
              data: {
                type: "array",
                items: assetDeclarationSchema,
              },
              total: { type: "number" },
            },
          },
        },
      },
    },
    async (request) => {
      // TODO: Query from exposures_asset_declarations
      // For now, return empty array
      return { data: [], total: 0 };
    }
  );

  app.get<{ Params: { id: string } }>(
    "/asset-declarations/:id",
    {
      schema: {
        tags: ["asset-declarations"],
        description: "Get asset declaration details",
        params: {
          type: "object",
          properties: {
            id: { type: "string", format: "uuid" },
          },
        },
        response: {
          200: assetDeclarationSchema,
          404: {
            type: "object",
            properties: {
              error: { type: "string" },
            },
          },
        },
      },
    },
    async (request, reply) => {
      // TODO: Query from exposures_asset_declarations
      return reply.status(404).send({ error: "Declaration not found" });
    }
  );
}

