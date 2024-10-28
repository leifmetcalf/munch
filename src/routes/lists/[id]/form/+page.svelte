<script lang="ts">
    let { data } = $props();
    let items = $state([...data.items]);
    let restaurants = $state([]);
    let restaurantSearch = $state("");

    function addItem(restaurant_id: string) {
        items = [...items, { restaurant_id: restaurant_id }];
    }

    async function searchRestaurants() {
        const response = await fetch(
            `/api/restaurants/search?q=${restaurantSearch}`,
        );
        restaurants = (await response.json()).restaurants;
    }

    $effect(() => {
        searchRestaurants();
    });
</script>

<h1>Edit {data.list.name}</h1>
<form method="POST" action="?/create">
    <p><input type="text" name="name" value={data.list.name} /></p>
    {#each items as item}
        <p>
            <input type="text" name="item[]" value={item.restaurant_id} />
        </p>
    {/each}
    <button type="submit">Save</button>
</form>

<input type="text" name="restaurant_search" bind:value={restaurantSearch} />
{#each restaurants as restaurant}
    <p>
        <button type="button" onclick={() => addItem(restaurant.id)}>
            {restaurant.name}
        </button>
    </p>
{/each}
