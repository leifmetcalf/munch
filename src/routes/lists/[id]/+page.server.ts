import { getList } from "$lib/lists";
import type { List, Item } from "$lib/lists";
import type { Restaurant } from "$lib/restaurants";

export async function load({ params }) {
    return {
        list: await getList(params.id) as List & { items: (Item & { restaurant: Restaurant })[] },

    };
}