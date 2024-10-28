import sql from "$lib/db";

export async function load({ params }) {
    return {
        list: (await sql`select * from lists where id = ${params.id}`)[0],
        restaurants: await sql`
            select r.* from items i
            join restaurants r on r.id = i.restaurant_id 
            where i.list_id = ${params.id}
        `
    };
}