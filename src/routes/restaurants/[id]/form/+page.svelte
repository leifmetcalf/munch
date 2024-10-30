<script lang="ts">
    let { data } = $props();
</script>

<h1>Edit {data.restaurant.name}</h1>
<form method="POST" action="?/update">
    <input type="hidden" id="id" name="id" value={data.restaurant.id} />
    <label for="name">Name</label>
    <input type="text" id="name" name="name" value={data.restaurant.name} />
    <label for="address">Address</label>
    <input
        type="text"
        id="address"
        name="address"
        value={data.restaurant.address}
    />
    <button type="submit">Save</button>
</form>
