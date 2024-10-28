import postgres from "postgres";

const sql = postgres("postgres://postgres@localhost:5432/munch_svelte");

export default sql;