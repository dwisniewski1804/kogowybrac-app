import type { FastifyInstance } from "fastify";

// Stub data — will be replaced by query to exposures in MVP
const DISTRICTS = [
  { id: 1, name: "Okręg nr 1", city: "Legnica", seats: 12 },
  { id: 2, name: "Okręg nr 2", city: "Wałbrzych", seats: 8 },
  { id: 3, name: "Okręg nr 3", city: "Wrocław", seats: 14 },
  { id: 4, name: "Okręg nr 4", city: "Bydgoszcz", seats: 12 },
  { id: 5, name: "Okręg nr 5", city: "Toruń", seats: 13 },
];

const districtSchema = {
  type: "object",
  properties: {
    id: { type: "number" },
    name: { type: "string" },
    city: { type: "string" },
    seats: { type: "number" },
  },
} as const;

export async function districtRoutes(app: FastifyInstance) {
  app.get(
    "/districts",
    {
      schema: {
        tags: ["districts"],
        description: "List of electoral districts",
        response: {
          200: {
            type: "object",
            properties: {
              data: {
                type: "array",
                items: districtSchema,
              },
              total: { type: "number" },
            },
          },
        },
      },
    },
    async () => {
      return { data: DISTRICTS, total: DISTRICTS.length };
    }
  );

  app.get<{ Params: { id: string } }>(
    "/districts/:id",
    {
      schema: {
        tags: ["districts"],
        description: "Electoral district details",
        params: {
          type: "object",
          properties: {
            id: { type: "number" },
          },
        },
        response: {
          200: districtSchema,
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
      const district = DISTRICTS.find((d) => d.id === Number(request.params.id));
      if (!district) {
        return reply.status(404).send({ error: "District not found" });
      }
      return district;
    }
  );
}

