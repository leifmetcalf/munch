import { z } from "zod";
import sql from "./db";
import { Restaurant } from "./restaurants";

export const Item = z.object({
    id: z.string(),
    list_id: z.string(),
    restaurant_id: z.string(),
    position: z.number(),
});
export type Item = z.infer<typeof Item>;

export const ItemWithRestaurant = Item.extend({
    restaurant: Restaurant,
});
export type ItemWithRestaurant = z.infer<typeof ItemWithRestaurant>;


export const List = z.object({
    id: z.string(),
    name: z.string(),
});
export type List = z.infer<typeof List>;

export const ListWithItems = List.extend({
    items: z.array(Item),
});
export type ListWithItems = z.infer<typeof ListWithItems>;

export const ListWithRestaurants = List.extend({
    items: z.array(ItemWithRestaurant),
});
export type ListWithRestaurants = z.infer<typeof ListWithRestaurants>;

export async function getList(id: string): Promise<ListWithRestaurants> {
    const [list]: [ListWithRestaurants] = await sql`
        select 
            l.id,
            l.name,
            jsonb_agg(
                jsonb_build_object(
                    'id', i.id,
                    'list_id', i.list_id,
                    'position', i.position,
                    'restaurant_id', i.restaurant_id,

                    'restaurant', json_build_object(
                        'id', r.id,
                        'name', r.name,
                        'address', r.address
                    )
                )
            ) as items
        from lists l
        left join items i on i.list_id = l.id 
        left join restaurants r on r.id = i.restaurant_id
        where l.id = ${id}
        group by l.id
    `
    return list;
}

export async function getLists(): Promise<List[]> {
    const lists: [List] = await sql`select * from lists`
    return lists;
}

export async function saveList(list: ListWithItems) {
    console.log(list);
    await sql.begin(async sql => {
        await sql`
            insert into lists ${sql(list, 'id', 'name')}
            on conflict (id) do update set name = ${list.name}
        `
        await sql`delete from items where list_id = ${list.id}`
        await sql`insert into items ${sql(list.items, 'id', 'list_id', 'restaurant_id', 'position')}`
    })
}
