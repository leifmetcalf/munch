<script lang="ts">
    let { data } = $props();
</script>

<h1>{data.list.name}</h1>
<ul>
    {#each data.list.items as item}
        <li>{item.restaurant.name}, {item.restaurant.address}</li>
    {/each}
</ul>
<a href={`/lists/${data.list.id}/form`}>Edit</a>