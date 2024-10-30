import { getList } from "$lib/lists";

export async function load({ params }) {
    return {
        list: await getList(params.id)
    };
}