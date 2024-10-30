import { z } from "zod";
import sql from "./db";

export const User = z.object({
    id: z.string(),
    name: z.string(),
    webauthn_id: z.string(),
});

export type User = z.infer<typeof User>;

export async function createUser(user_id: string, username: string, webauthn_id: string) {
    const user = User.parse({ id: user_id, name: username, webauthn_id });
    await sql`insert into users ${sql(user)}`;
}
