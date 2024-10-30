import { sql } from "./db";
import { z } from "zod";

export const Session = z.object({
    id: z.string(),
    user_id: z.string(),
});

export type Session = z.infer<typeof Session>;
