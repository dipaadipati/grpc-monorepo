export function sanitizeNull<T>(obj: T): any {
    if (obj === null || obj === undefined) return undefined;

    if (Array.isArray(obj)) {
        return obj.map(item => sanitizeNull(item));
    }

    if (typeof obj === 'object' && !(obj instanceof Date)) {
        const sanitized: any = {};
        for (const key in obj) {
            if (Object.prototype.hasOwnProperty.call(obj, key)) {
                sanitized[key] = sanitizeNull(obj[key]);
            }
        }
        return sanitized;
    }

    return obj;
}