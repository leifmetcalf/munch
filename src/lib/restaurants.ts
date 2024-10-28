import { z } from "zod";
import sql from "./db";

export const searchRestaurants = async (query: string) => {
    return await sql`
        select * from restaurants 
        where name ilike ${`%${query}%`} 
        or address ilike ${`%${query}%`}
    `;
};

export const createRestaurant = async (restaurant: z.infer<typeof Restaurant>) => {
    return await sql`
        insert into restaurants (name, address) values (${restaurant.name}, ${restaurant.address})
    `;
};
