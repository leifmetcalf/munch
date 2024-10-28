<script lang="ts">
    let { data } = $props();
</script>

<h1>New List</h1>
<form method="POST" action="?/save">
    <input type="text" name="name" />
    <button type="submit">Create</button>
</form>
