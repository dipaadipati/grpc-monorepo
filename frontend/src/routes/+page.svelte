<script lang="ts">
	import { authClient } from '$lib/grpc-client';

	let email = $state('');
	let password = $state('');
	let heroId = $state(1);
	let heroName = $state('');
	let loading = $state(false);

	async function handleLogin() {
		loading = true;
		try {
			const res = await authClient.login({ email, password });
			localStorage.setItem('token', res.token);
			alert('Login Berhasil!');
		} catch (err: any) {
			alert('Login Gagal: ' + err.message);
		} finally {
			loading = false;
		}
	}

	async function getHero() {
		try {
			let token = localStorage.getItem('token');
		} catch (err: any) {
			alert('Error: ' + err.message);
		}
	}
</script>

<div class="flex max-w-md flex-col gap-4 p-5">
	<h2 class="text-xl font-bold">Login</h2>
	<input bind:value={email} type="email" placeholder="Email" class="rounded border p-2" />
	<input bind:value={password} type="password" placeholder="Password" class="rounded border p-2" />

	<button
		onclick={handleLogin}
		disabled={loading}
		class="rounded bg-blue-500 p-2 text-white disabled:bg-gray-400"
	>
		{loading ? 'Logging in...' : 'Login'}
	</button>

	<hr class="my-4" />

	<h2 class="text-xl font-bold">Cari Hero</h2>
	<div class="flex gap-2">
		<input bind:value={heroId} type="number" class="w-20 rounded border p-2" />
		<button onclick={getHero} class="rounded bg-green-500 p-2 text-white">Cari</button>
	</div>

	{#if heroName}
		<p class="mt-2">Hasil: <span class="font-bold text-green-600">{heroName}</span></p>
	{/if}
</div>
