import { formDataToObject } from "$lib/utils";
import { getList, saveList, ListWithItems } from "$lib/lists";
import { redirect } from "@sveltejs/kit";

export async function load({ params }) {
    return {
        list: await getList(params.id)
    };
}

export const actions = {
    update: async ({ request }) => {
        const formData = await request.formData();
        const { items, ...rest } = formDataToObject(formData) as
            { id: string, name: string, items: Record<string, { id: string, restaurant_id: string }> };
        const list = ListWithItems.parse(
            {
                ...rest,
                items: (Object.entries(items)).map(([index, item]) => ({ ...item, list_id: rest.id, position: parseInt(index) }))
            }
        )
        await saveList(list);
        return redirect(303, `/lists/${list.id}`);
    }
};
