<script>
    let { data } = $props();
</script>

<h1>{data.restaurant.name}</h1>
<p>{data.restaurant.address}</p>
<a href="/restaurants/{data.restaurant.id}/form">Edit</a>
