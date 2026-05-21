<script lang="ts">
	import { page } from '$app/state';
	import { enhance } from '$app/forms';
	import { onMount } from 'svelte';

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

	const userInitials = $derived(
		user?.name
			? user.name
					.split(' ')
					.map((n: string) => n[0])
					.join('')
					.toUpperCase()
			: '??'
	);

	onMount(() => {
		if (MIDTRANS_CLIENT_KEY && !document.querySelector('script[src*="snap.js"]')) {
			const script = document.createElement('script');
			script.type = 'text/javascript';
			script.src = 'https://app.sandbox.midtrans.com/snap/snap.js';
			script.setAttribute('data-client-key', MIDTRANS_CLIENT_KEY);
			script.async = true;
			document.head.appendChild(script);
		}
	});

	// 🚪 Logika Aksi Logout Terproteksi SweetAlert2
	async function handleLogout() {
		const result = await (window as any).Swal.fire({
			title: 'Keluar',
			text: 'Apakah Anda yakin ingin keluar?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#3085d6',
			cancelButtonColor: '#d33',
			confirmButtonText: 'Ya, keluar!',
			cancelButtonText: 'Batal'
		});

		if (result.isConfirmed) {
			const form = document.getElementById('logoutForm') as HTMLFormElement;
			if (form) {
				form.submit();
			}
		}
	}
</script>

<div
	class="relative flex h-screen w-screen overflow-hidden bg-gray-50 font-sans text-gray-900 select-none"
>
	<aside
		class="relative z-20 flex h-full flex-col border-r border-slate-800 bg-slate-900 text-white transition-all duration-300 ease-in-out"
		class:w-64={isSidebarOpen}
		class:w-20={!isSidebarOpen}
	>
		<div class="flex h-20 shrink-0 items-center gap-4 border-b border-slate-800 px-5">
			<div
				class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-blue-500 shadow-md shadow-blue-500/20"
			>
				<i class="fas fa-dumbbell text-lg text-white"></i>
			</div>
			{#if isSidebarOpen}
				<span class="text-lg font-extrabold tracking-wider whitespace-nowrap text-slate-100"
					>GYM PRO</span
				>
			{/if}
		</div>

		<nav class="no-scrollbar flex-1 space-y-1.5 overflow-y-auto px-3 py-6">
			{#if user?.role === 'SUPER_ADMIN'}
				<a
					href="/superadmin/dashboard"
					class="flex items-center gap-4 rounded-xl px-4 py-3 transition-all duration-150"
					class:bg-purple-600={page.url.pathname === '/superadmin/dashboard'}
					class:text-white={page.url.pathname === '/superadmin/dashboard'}
					class:text-purple-300={page.url.pathname !== '/superadmin/dashboard'}
					class:hover:bg-purple-950={page.url.pathname !== '/superadmin/dashboard'}
				>
					<i class="fas fa-user-tie shrink-0 text-lg"></i>
					{#if isSidebarOpen}
						<span class="text-sm font-semibold tracking-wide">Super Admin Dashboard</span>
					{/if}
				</a>
				<div class="mx-2 my-3 h-px bg-slate-800"></div>
			{/if}

			{#each menuItems as item}
				<a
					href={item.path}
					class="group flex items-center gap-4 rounded-xl px-4 py-3 transition-all duration-200"
					class:bg-blue-600={page.url.pathname === item.path}
					class:text-white={page.url.pathname === item.path}
					class:text-slate-400={page.url.pathname !== item.path}
					class:hover:bg-slate-800={page.url.pathname !== item.path}
					class:hover:text-slate-200={page.url.pathname !== item.path}
				>
					<i class="fas {item.icon} shrink-0 text-lg transition-transform group-hover:scale-105"
					></i>
					{#if isSidebarOpen}
						<span class="text-sm font-medium tracking-wide">{item.name}</span>
					{/if}
				</a>
			{/each}
		</nav>

		<div class="shrink-0 border-t border-slate-800 p-4">
			<button
				onclick={handleLogout}
				class="flex w-full items-center gap-4 rounded-xl px-4 py-3 text-red-400 transition-all duration-200 hover:bg-red-500/10 hover:text-red-300"
			>
				<i class="fas fa-sign-out-alt text-lg"></i>
				{#if isSidebarOpen}
					<span class="text-sm font-semibold tracking-wide">Keluar</span>
				{/if}
			</button>
		</div>
	</aside>

	<div class="relative z-10 flex h-full min-w-0 flex-1 flex-col">
		<header
			class="flex h-20 shrink-0 items-center justify-between border-b border-gray-200 bg-white px-8 shadow-xs"
		>
			<div class="flex items-center gap-4">
				<button
					onclick={() => (isSidebarOpen = !isSidebarOpen)}
					aria-label="Toggle sidebar"
					class="rounded-xl p-2 text-gray-500 transition-colors hover:bg-gray-100 hover:text-gray-700 active:scale-95"
				>
					<i class="fas fa-bars text-lg"></i>
				</button>
				<h1 class="text-lg font-bold tracking-tight text-gray-800">
					{menuItems.find((i) => i.path === page.url.pathname)?.name || 'Admin Panel'}
				</h1>
			</div>

			<div class="flex items-center gap-6">
				<button
					class="relative p-2 text-gray-400 transition-colors hover:text-gray-600 focus:outline-hidden"
					aria-label="Notifications"
				>
					<i class="fas fa-bell text-lg"></i>
					<span
						class="absolute top-1.5 right-1.5 h-2 w-2 rounded-full border-2 border-white bg-red-500"
					></span>
				</button>

				<div class="flex items-center gap-3 border-l border-gray-100 pl-6">
					<div class="hidden text-right sm:block">
						<p class="text-sm leading-none font-bold text-gray-800">{user?.name || 'User Gym'}</p>
						<p class="mt-1 text-xs font-semibold tracking-wider text-gray-400 uppercase">
							{user?.tenantName || 'Cabang Aktif'}
						</p>
					</div>
					<div
						class="flex h-10 w-10 items-center justify-center rounded-full border border-gray-100 bg-linear-to-tr from-blue-600 to-indigo-600 font-bold tracking-wide text-white shadow-sm"
					>
						{userInitials}
					</div>
				</div>
			</div>
		</header>

		<main class="flex-1 overflow-y-auto bg-gray-50/50 p-8">
			<div class="mx-auto h-full max-w-7xl">
				{#key page.url.pathname}
					{@render children()}
				{/key}
			</div>
		</main>
	</div>

	<form id="logoutForm" method="POST" action="/logout" class="hidden" use:enhance></form>
</div>

<style>
	:global(.no-scrollbar::-webkit-scrollbar) {
		display: none;
	}
	:global(.no-scrollbar) {
		-ms-overflow-style: none;
		scrollbar-width: none;
	}
</style>
