<script lang="ts">
    import { v4 as uuid, parse as uuidParse } from "uuid";
    let { data, form } = $props();
    let user_id = $state(form?.user_id || uuid());
    let username = $state(form?.username || "");
    let credential = $state("");
    async function submit(e: SubmitEvent) {
        e.preventDefault();
        let formData = new FormData(e.target as HTMLFormElement);
        let user_id = formData.get("user_id") as string;
        let username = formData.get("username") as string;
        let publicKeyCredentialCreationOptions = {
            publicKey: {
                challenge: data.challenge,
                pubKeyCredParams: [
                    { type: "public-key" as const, alg: -7 },
                    { type: "public-key" as const, alg: -257 },
                ],
                rp: {
                    name: "Munchie Zone",
                },
                user: {
                    id: uuidParse(user_id),
                    name: username,
                    displayName: username,
                },
            },
        };
        credential = JSON.stringify(
            await navigator.credentials.create(
                publicKeyCredentialCreationOptions,
            ),
        );
        console.log(credential);
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "credential";
        input.value = credential;
        let form = document.getElementById("register-form") as HTMLFormElement;
        form.appendChild(input);
        form.submit();
    }
</script>

<h1>Register</h1>
<form
    id="register-form"
    method="POST"
    action="?/register"
    onsubmit={(e) => submit(e as SubmitEvent)}
>
    <input type="hidden" id="user_id" name="user_id" bind:value={user_id} />
    <label for="username">Username</label>
    <input type="text" id="username" name="username" bind:value={username} />
    <button> Register </button>
</form>
