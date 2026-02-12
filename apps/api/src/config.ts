export const config = {
  port: Number(process.env.API_PORT) || 3000,
  host: process.env.API_HOST || "0.0.0.0",
  database: {
    host: process.env.DB_HOST || "localhost",
    port: Number(process.env.DB_PORT) || 5432,
    user: process.env.DB_USER || "kogowybrac",
    password: process.env.DB_PASSWORD || "kogowybrac",
    database: process.env.DB_NAME || "kogowybrac",
  },
  redis: {
    host: process.env.REDIS_HOST || "localhost",
    port: Number(process.env.REDIS_PORT) || 6379,
  },
} as const;

