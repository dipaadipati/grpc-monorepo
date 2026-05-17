<script lang="ts">
	import { enhance } from '$app/forms';
	import type { SubmitFunction } from './$types';

	let isLoading = $state(false);
	let errorMessage = $state('');

	const handleSubmit: SubmitFunction = async ({ formData, action, cancel }) => {
		isLoading = true;
		errorMessage = '';

		return async ({ result, update }) => {
			// if (result.type === 'failure') {
			// 	errorMessage = result.data?.error || 'Login gagal';
			// } else if (result.type === 'error') {
			// 	errorMessage = result.error.message || 'Terjadi kesalahan';
			// }

			await update();
			isLoading = false;
		};
	};
</script>

<div class="flex min-h-screen items-center justify-center bg-gray-50 px-4">
	<div class="w-full max-w-md space-y-8 rounded-2xl border border-gray-100 bg-white p-10 shadow-xl">
		<div class="text-center">
			<div
				class="mb-4 inline-flex h-16 w-16 items-center justify-center rounded-xl bg-blue-600 shadow-lg shadow-blue-200"
			>
				<span class="text-3xl font-bold text-white">G</span>
			</div>
			<h2 class="text-3xl font-extrabold tracking-tight text-gray-900">Gym Management</h2>
			<p class="mt-2 text-sm text-gray-500">Silakan masuk ke panel administrasi</p>
		</div>

		<form class="mt-8 space-y-6" method="POST" use:enhance={handleSubmit}>
			<div class="space-y-4">
				<div>
					<label for="email" class="block text-sm font-medium text-gray-700">Email Address</label>
					<input
						id="email"
						type="email"
						name="email"
						required
						class="mt-1 block w-full rounded-lg border border-gray-300 bg-gray-50 px-4 py-3 text-gray-900 transition-all outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
						placeholder="admin@gym.com"
					/>
				</div>

				<div>
					<label for="password" class="block text-sm font-medium text-gray-700">Password</label>
					<input
						id="password"
						type="password"
						name="password"
						required
						class="mt-1 block w-full rounded-lg border border-gray-300 bg-gray-50 px-4 py-3 text-gray-900 transition-all outline-none focus:border-blue-500 focus:ring-2 focus:ring-blue-500"
						placeholder="••••••••"
					/>
				</div>
			</div>

			{#if errorMessage}
				<div class="animate-pulse border-l-4 border-red-500 bg-red-50 p-4 text-sm text-red-700">
					{errorMessage}
				</div>
			{/if}

			<div>
				<button
					type="submit"
					disabled={isLoading}
					class="group relative flex w-full justify-center rounded-lg border border-transparent bg-blue-600 px-4 py-3 text-sm font-semibold text-white transition-all hover:bg-blue-700 focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 focus:outline-none disabled:cursor-not-allowed disabled:opacity-50"
				>
					{#if isLoading}
						<span class="mr-2 inline-block animate-spin">🌀</span> Memproses...
					{:else}
						Masuk ke Dashboard
					{/if}
				</button>
			</div>
		</form>

		<div class="text-center">
			<p class="text-xs text-gray-400">&copy; 2026 Gym Enterprise Solution. All rights reserved.</p>
		</div>
	</div>
</div>
