import { getLists } from "$lib/lists";
import { getRestaurants } from "$lib/restaurants";

export async function load() {
    return {
        lists: await getLists(),
        restaurants: await getRestaurants()
    };
}