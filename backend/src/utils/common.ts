export function serializeBigInt(obj: any): any {
    if (obj === null || obj === undefined) return obj;

    if (typeof obj === 'bigint') {
        return Number(obj);
    }

    if (Array.isArray(obj)) {
        return obj.map(serializeBigInt);
    }

    if (typeof obj === 'object') {
        const sanitized: any = {};
        for (const key in obj) {
            if (Object.prototype.hasOwnProperty.call(obj, key)) {
                sanitized[key] = serializeBigInt(obj[key]);
            }
        }
        return sanitized;
    }

    return obj;
}