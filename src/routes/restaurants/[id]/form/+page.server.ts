import { getRestaurant, saveRestaurant } from "$lib/restaurants";
import { formDataToObject } from "$lib/utils";

export async function load({ params }) {
    return {
        restaurant: await getRestaurant(params.id)
    }
}

export const actions = {
    update: async ({ request }) => {
        const formData = await request.formData();
        const { id, name, address } = formDataToObject(formData) as
            { id: string, name: string, address: string };
        await saveRestaurant({ id, name, address });
    }
}
