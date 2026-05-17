<script lang="ts">
	import { page } from '$app/state';
	import { enhance } from '$app/forms';

	let { data, children } = $props();
	const user = $derived(data.user);
	const MIDTRANS_CLIENT_KEY = $derived(user?.MIDTRANS_CLIENT_KEY || '');
	let isSidebarOpen = $state(true);

	const menuItems = [
		{ name: 'Dashboard', path: '/dashboard', icon: 'fa-chart-pie' },
		{ name: 'Kelola Paket', path: '/plans', icon: 'fa-id-card-clip' },
		{ name: 'Kelola Penawaran', path: '/offerings', icon: 'fa-tags' },
		{ name: 'Kelola Member', path: '/members', icon: 'fa-users' },
		{ name: 'Keuangan', path: '/finance', icon: 'fa-wallet' },
		{ name: 'Pengaturan', path: '/settings', icon: 'fa-cog' }
	];

	async function handleLogout() {
		const result = await (window as any).Swal.fire({
			title: 'Keluar',
			text: 'Apakah Anda yakin ingin keluar?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: 'Ya, keluar!'
		});

		if (result.isConfirmed) {
			const form = document.getElementById('logoutForm') as HTMLFormElement;
			if (form) {
				form.submit();
			}
		}
	}
</script>

<div class="flex h-screen bg-gray-50 font-sans text-gray-900">
	<aside
		class="flex flex-col border-r border-slate-800 bg-slate-900 text-white transition-all duration-300"
		class:w-64={isSidebarOpen}
		class:w-20={!isSidebarOpen}
	>
		<div class="flex h-20 items-center gap-4 border-b border-slate-800 px-6">
			<div
				class="flex h-10 w-10 shrink-0 items-center justify-center rounded-lg bg-blue-500 shadow-lg shadow-blue-500/20"
			>
				<i class="fas fa-dumbbell text-xl"></i>
			</div>
			{#if isSidebarOpen}
				<span class="overflow-hidden text-xl font-bold tracking-tight whitespace-nowrap"
					>GYM PRO</span
				>
			{/if}
		</div>

		<nav class="flex-1 space-y-1 px-3 py-6">
			{#if user?.role === 'SUPER_ADMIN'}
				<a
					href="/superadmin/dashboard"
					class="group flex items-center gap-4 rounded-xl bg-purple-600 px-4 py-3 text-white! transition-all duration-200 hover:bg-purple-700!"
					class:bg-blue-600={page.url.pathname === '/superadmin/dashboard'}
					class:text-white={page.url.pathname === '/superadmin/dashboard'}
					class:text-slate-400={page.url.pathname !== '/superadmin/dashboard'}
					class:hover:bg-slate-800={page.url.pathname !== '/superadmin/dashboard'}
				>
					<i class="fas fa-user-tie shrink-0 text-lg transition-transform group-hover:scale-110"
					></i>
					{#if isSidebarOpen}
						<span class="font-medium"> Super Admin Dashboard </span>
					{/if}
				</a>
			{/if}
			{#each menuItems as item}
				<a
					href={item.path}
					class="group flex items-center gap-4 rounded-xl px-4 py-3 transition-all duration-200"
					class:bg-blue-600={page.url.pathname === item.path}
					class:text-white={page.url.pathname === item.path}
					class:text-slate-400={page.url.pathname !== item.path}
					class:hover:bg-slate-800={page.url.pathname !== item.path}
				>
					<i class="fas {item.icon} shrink-0 text-lg transition-transform group-hover:scale-110"
					></i>
					{#if isSidebarOpen}
						<span class="font-medium">{item.name}</span>
					{/if}
				</a>
			{/each}
		</nav>

		<div class="border-t border-slate-800 p-4">
			<button
				onclick={handleLogout}
				class="flex w-full items-center gap-4 rounded-xl px-4 py-3 text-red-400 transition-colors hover:bg-red-500/10"
			>
				<i class="fas fa-sign-out-alt text-lg"></i>
				{#if isSidebarOpen}
					<span class="font-medium">Keluar</span>
				{/if}
			</button>
		</div>
	</aside>

	<div class="flex min-w-0 flex-1 flex-col overflow-hidden">
		<header
			class="flex h-20 shrink-0 items-center justify-between border-b border-gray-200 bg-white px-8"
		>
			<div class="flex items-center gap-4">
				<button
					onclick={() => (isSidebarOpen = !isSidebarOpen)}
					aria-label="Toggle sidebar"
					class="rounded-lg p-2 text-gray-500 transition-colors hover:bg-gray-100"
				>
					<i class="fas fa-bars text-lg"></i>
				</button>
				<h1 class="text-xl font-semibold text-gray-800">
					{menuItems.find((i) => i.path === page.url.pathname)?.name || 'Admin Panel'}
				</h1>
			</div>

			<div class="flex items-center gap-6">
				<button
					class="relative p-2 text-gray-400 transition-colors hover:text-gray-600"
					aria-label="Notifications"
				>
					<i class="fas fa-bell text-xl"></i>
					<span class="absolute top-1 right-1 h-2 w-2 rounded-full border-2 border-white bg-red-500"
					></span>
				</button>

				<div class="flex items-center gap-3 border-l border-gray-200 pl-6">
					<div class="hidden text-right sm:block">
						<p class="text-sm leading-none font-bold text-gray-900">{user?.name}</p>
						<p class="mt-1 text-xs tracking-wider text-gray-500 uppercase">{user?.tenantName}</p>
					</div>
					<div
						class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-white bg-linear-to-tr from-blue-600 to-indigo-600 font-bold text-white shadow-sm"
					>
						{user?.name
							.split(' ')
							.map((n) => n[0])
							.join('')
							.toUpperCase()}
					</div>
				</div>
			</div>
		</header>

		<main class="flex-1 overflow-y-auto p-8">
			<div class="mx-auto max-w-7xl">
				{@render children()}
			</div>
		</main>
	</div>
	<script
		type="text/javascript"
		src="https://app.sandbox.midtrans.com/snap/snap.js"
		data-client-key={MIDTRANS_CLIENT_KEY}
	>
	</script>

	<form id="logoutForm" method="POST" action="/logout" use:enhance></form>
</div>

<style>
	aside::-webkit-scrollbar {
		display: none;
	}
</style>
