import { searchRestaurants } from "$lib/restaurants";
import { json } from "@sveltejs/kit";

export async function GET({ url }) {
    const q = url.searchParams.get("q") ?? "";
    const restaurants = await searchRestaurants(q);
    return json({ restaurants });
}
