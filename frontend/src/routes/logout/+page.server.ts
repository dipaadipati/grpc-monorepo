// src/routes/logout/+page.server.ts
import { redirect } from '@sveltejs/kit';
import type { Actions } from './$types';
import { createAuthenticatedClients } from '$lib/grpc-client';

export const actions: Actions = {
    default: async ({ cookies }) => {
        const sessionId = cookies.get('token');


        if (sessionId) {
            try {
                const { authClient } = createAuthenticatedClients(sessionId);
                await authClient.logout({}, {
                    headers: { 'Authorization': `Bearer ${sessionId}` }
                });
            } catch (err) {
                console.error("Gagal menghapus session di Redis:", err);
            }
        }

        cookies.delete('token', { path: '/' });

        throw redirect(303, '/login');
    }
};