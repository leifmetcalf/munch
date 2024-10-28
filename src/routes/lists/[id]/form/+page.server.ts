import sql from "$lib/db";

export async function load({ params }) {
    return {
        list: (await sql`select * from lists where id = ${params.id}`)[0],
        items: await sql`select * from items where list_id = ${params.id}`
    };
}

export const actions = {
    create: async ({ request }) => {
        const formData = await request.formData();
        console.log(formData);
    }
};
