<script lang="ts">
    let { data } = $props();
</script>

<h1>Welcome to SvelteKit</h1>
<p>
    Visit <a href="https://svelte.dev/docs/kit">svelte.dev/docs/kit</a> to read the
    documentation
</p>
<h2>Lists</h2>
<ul>
    {#each data.lists as list}
        <a href="/lists/{list.id}">{list.name}</a>
    {/each}
</ul>
