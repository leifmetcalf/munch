import { formDataToObject } from "$lib/utils.js";
import { redirect } from "@sveltejs/kit";
import { v4 as uuid } from "uuid";

export async function load({ params }) {
    return {
        challenge: crypto.getRandomValues(new Uint8Array(32)),
    };
}

export const actions = {
    register: async ({ request }) => {
        const form = formDataToObject(await request.formData());
        console.log(form);
        if (form.credential) {
            createUser(form.user_id, form.username, form.credential.id);
            return redirect(303, `/`);
        }
        return form
    }
}