<script lang="ts">
    let { data } = $props();
</script>

<h1>Munch</h1>
<h2>Lists</h2>
<ul>
    {#each data.lists as list}
        <li>
            <a href="/lists/{list.id}">{list.name}</a>
        </li>
    {/each}
</ul>
<a href="/lists/new">New List</a>

<h2>Restaurants</h2>
<table>
    <thead>
        <tr>
            <th>Name</th>
            <th>Address</th>
        </tr>
    </thead>
    <tbody>
        {#each data.restaurants as restaurant}
            <tr>
                <td
                    ><a href="/restaurants/{restaurant.id}">{restaurant.name}</a
                    ></td
                >
                <td>{restaurant.address}</td>
                <td><a href="/restaurants/{restaurant.id}/form">Edit</a></td>
            </tr>
        {/each}
    </tbody>
</table>
