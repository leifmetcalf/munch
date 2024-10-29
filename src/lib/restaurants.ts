import { z } from "zod";
import sql from "./db";

export const Restaurant = z.object({
    id: z.string(),
    name: z.string(),
    address: z.string(),
});

export type Restaurant = z.infer<typeof Restaurant>;

export const searchRestaurants = async (query: string): Promise<Restaurant[]> => {
    return await sql`
        select * from restaurants 
        where name ilike ${`%${query}%`} 
        or address ilike ${`%${query}%`}
    `;
};