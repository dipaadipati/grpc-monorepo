import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';
import { createAuthenticatedClients } from '$lib/grpc-client';

export const load: LayoutServerLoad = async ({ cookies }) => {
    const sessionId = cookies.get('token');

    if (!sessionId) {
        throw redirect(303, '/login');
    }

    try {
        console.log("🔍 [Admin Layout] Getting profile with token:", sessionId.substring(0, 8) + "...");

        const { authClient } = createAuthenticatedClients(sessionId);
        const user = await authClient.getProfile({});

        console.log("✅ [Admin Layout] Profile fetched successfully:", user.email);

        return {
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
                role: user.role,
                tenantId: user.tenantId,
                tenantName: user.tenantName,
                MIDTRANS_CLIENT_KEY: user.midtransClientKey
            },
            sessionId
        };
    } catch (err: any) {
        console.error("❌ [Admin Layout] Session invalid:", err.message);
        cookies.delete('token', { path: '/' });
        throw redirect(303, '/login');
    }
};