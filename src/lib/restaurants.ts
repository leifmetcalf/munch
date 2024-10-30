import { z } from "zod";
import sql from "./db";

export const Restaurant = z.object({
    id: z.string(),
    name: z.string(),
    address: z.string(),
});

export type Restaurant = z.infer<typeof Restaurant>;

export async function searchRestaurants(query: string): Promise<Restaurant[]> {
    return await sql`
        select id, name, address from restaurants 
        where name ilike ${`%${query}%`} 
        or address ilike ${`%${query}%`}
    `;
}

export async function getRestaurants(): Promise<Restaurant[]> {
    return await sql`select id, name, address from restaurants`;
}

export async function getRestaurant(id: string): Promise<Restaurant> {
    const [restaurant]: [Restaurant] = await sql`select id, name, address from restaurants where id = ${id}`;
    return restaurant;
}

export async function saveRestaurant(restaurant: Restaurant): Promise<void> {
    await sql`
        insert into restaurants ${sql(restaurant, 'id', 'name', 'address')}
        on conflict (id) do update set ${sql(restaurant, 'name', 'address')}
    `;
}
