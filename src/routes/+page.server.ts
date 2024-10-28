import sql from "$lib/db";

export async function load() {
    return {
        lists: await sql`select * from lists`
    };
}