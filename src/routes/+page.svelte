<script lang="ts">
    let { data } = $props();
</script>

<h1>Lists</h1>
<ul>
    {#each data.lists as list}
        <a href="/lists/{list.id}">{list.name}</a>
    {/each}
</ul>
