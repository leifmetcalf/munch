import { getRestaurant } from "$lib/restaurants";

export async function load({ params }) {
    return {
        restaurant: await getRestaurant(params.id)
    }
}