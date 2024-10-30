<script lang="ts">
    import type { Restaurant } from "$lib/restaurants";
    import type { Item } from "$lib/lists";
    import Sortable from "sortablejs";
    let { data } = $props();
    let items = $state([...data.list.items]);
    let restaurant_results: Restaurant[] = $state([]);

    function addItem(restaurant: Restaurant) {
        items.push({
            id: crypto.randomUUID(),
            list_id: data.list.id,
            restaurant_id: restaurant.id,
            restaurant,
            position: items.length
        });
    }

    function removeItem(item: Item) {
        items = items.filter(i => i.id !== item.id);
    }

    async function searchRestaurants(q: string) {
        const response = await fetch(`/api/restaurants/search?q=${q}`);
        restaurant_results = (await response.json()).restaurants;
    }
</script>

<h1>Edit {data.list.name}</h1>
<form method="POST" action="?/update">
    <div>
        <input type="hidden" id="id" name="id" value={data.list.id} />
        <label for="name">Name</label>
        <input type="text" id="name" name="name" value={data.list.name} />
    </div>
    <div>
        {#each items as item, index}
            <div>
                <input type="hidden" id={`items.${index}.id`} name={`items.${index}.id`} value={item.id} />
                <div>
                    <label for={`items.${index}.restaurant_id`}>{item.restaurant.name}</label>
                    <input type="hidden" id={`items.${index}.restaurant_id`} name={`items.${index}.restaurant_id`} value={item.restaurant.id} />
            </div>
            <button type="button" onclick={() => removeItem(item)}>Remove</button>
        </div>
        {/each}
    </div>
    <button type="submit">Save</button>
</form>

<input
    type="text"
    name="restaurant_search"
    oninput={(e: Event) =>
        searchRestaurants((e.target as HTMLInputElement).value)
    }
/>
{#each restaurant_results as restaurant}
    <p>
        <button type="button" onclick={() => addItem(restaurant)}>
            {restaurant.name}
        </button>
    </p>
{/each}
