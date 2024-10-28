<script lang="ts">
    let { data } = $props();
</script>

<h1>{data.list.name}</h1>
<ul>
    {#each data.restaurants as restaurant}
        <li>{restaurant.name}, {restaurant.address}</li>
    {/each}
</ul>
<a href={`/lists/${data.list.id}/form`}>Edit</a>
