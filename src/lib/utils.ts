export function formDataToObject(formData: FormData) {
    const result: Record<string, any> = {};

    for (const [key, value] of formData.entries()) {
        const path = key.split(".");
        let acc = result;
        for (const key of path.slice(0, -1)) {
            if (!acc[key]) acc[key] = {};
            acc = acc[key];
        }
        acc[path.at(-1)!] = value;
    }

    return result;
}
