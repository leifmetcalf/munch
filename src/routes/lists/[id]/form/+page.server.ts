import { formDataToObject } from "$lib/utils";
import { getList, saveList, ListWithItems } from "$lib/lists";
import type { ListWithRestaurants } from "$lib/lists";
import { redirect } from "@sveltejs/kit";

export async function load({ params }) {
    return {
        list: await getList(params.id) as ListWithRestaurants
    };
}

export const actions = {
    create: async ({ request, params }) => {
        const formData = await request.formData();
        const { name, items } = formDataToObject(formData) as
            { name: string, items: Record<string, { id: string, restaurant_id: string }> };
        const list_id = params.id;
        const list = ListWithItems.parse(
            {
                id: list_id,
                name,
                items: (Object.entries(items)).map(([index, item]) => ({ ...item, list_id, position: parseInt(index) }))
            }
        )
        await saveList(list);
        return redirect(303, `/lists/${list_id}`);
    }
};
