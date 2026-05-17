import { redirect } from '@sveltejs/kit';
import type { PageServerLoad, Actions } from './$types';
import { authClient } from '$lib/grpc-client';
import { create } from '@bufbuild/protobuf';
import { LoginRequestSchema } from '$gen/app_pb';

export const load: PageServerLoad = async ({ cookies }) => {
    const token = cookies.get('token');

    if (token) {
        throw redirect(303, '/dashboard');
    }

    return {};
};

export const actions: Actions = {
    default: async ({ request, cookies }) => {
        const formData = await request.formData();
        const email = formData.get('email') as string;
        const password = formData.get('password') as string;

        if (!email || !password) {
            return {
                success: false,
                error: 'Email dan password harus diisi'
            };
        }

        try {
            const req = create(LoginRequestSchema, { email, password });
            const res = await authClient.login(req);

            cookies.set('token', res.token, {
                path: '/',
                httpOnly: true,
                secure: false, // Set ke true jika production dengan HTTPS
                sameSite: 'strict',
                maxAge: 60 * 60 * 24 * 7
            });

            throw redirect(303, '/dashboard');
        } catch (err: any) {
            if (err.status === 303) {
                throw err;
            }

            console.error("Login error:", err);
            return {
                success: false,
                error: err.message || 'Gagal login. Periksa kembali email & password.'
            };
        }
    }
};