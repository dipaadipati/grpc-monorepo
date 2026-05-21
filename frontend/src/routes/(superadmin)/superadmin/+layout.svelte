<script lang="ts">
	import { page } from '$app/state';
	import { enhance } from '$app/forms';

	let { data, children } = $props();
	const user = $derived(data.user);
	let isSidebarOpen = $state(true);

	const menuItems = [
		{ name: 'Dashboard', path: '/superadmin/dashboard', icon: 'fa-chart-pie' },
		{ name: 'Kelola Tenant', path: '/superadmin/tenants', icon: 'fa-building-columns' },
		{ name: 'Pengaturan', path: '/superadmin/settings', icon: 'fa-cog' }
	];

	const userInitials = $derived(
		user?.name
			? user.name
					.split(' ')
					.map((n: string) => n[0])
					.join('')
					.toUpperCase()
			: 'SA'
	);

	async function handleLogout() {
		const result = await (window as any).Swal.fire({
			title: 'Keluar',
			text: 'Apakah Anda yakin ingin keluar?',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonColor: '#8b5cf6',
			cancelButtonColor: '#ef4444',
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

<div class="flex h-screen w-screen overflow-hidden bg-gray-50 font-sans text-gray-900">
	<aside
		class="flex h-full shrink-0 flex-col border-r border-slate-800 bg-slate-900 text-white transition-all duration-300"
		class:w-64={isSidebarOpen}
		class:w-20={!isSidebarOpen}
	>
		<div class="flex h-20 shrink-0 items-center gap-4 border-b border-slate-800 px-6">
			<div
				class="flex h-10 w-10 shrink-0 items-center justify-center rounded-xl bg-purple-600 shadow-lg shadow-purple-600/30"
			>
				<i class="fas fa-crown text-lg text-white"></i>
			</div>
			{#if isSidebarOpen}
				<div class="flex flex-col overflow-hidden">
					<span class="text-base font-extrabold tracking-wider whitespace-nowrap text-slate-100"
						>GYM PRO</span
					>
					<span class="text-[10px] font-bold tracking-widest text-purple-400 uppercase"
						>Super Admin</span
					>
				</div>
			{/if}
		</div>

		<nav class="no-scrollbar flex-1 space-y-1 overflow-y-auto px-3 py-6">
			<a
				href="/dashboard"
				class="flex items-center gap-4 rounded-xl bg-slate-800 px-4 py-3 text-slate-200 transition-colors hover:bg-slate-700 hover:text-white"
			>
				<i class="fas fa-building shrink-0 text-lg text-purple-400"></i>
				{#if isSidebarOpen}
					<span class="text-sm font-medium">Tenant Dashboard</span>
				{/if}
			</a>

			<div class="mx-2 my-4 h-px bg-slate-800"></div>

			{#each menuItems as item}
				<a
					href={item.path}
					class="relative flex items-center gap-4 rounded-xl px-4 py-3 transition-all duration-150"
					class:bg-purple-600={page.url.pathname === item.path}
					class:text-white={page.url.pathname === item.path}
					class:text-slate-400={page.url.pathname !== item.path}
					class:hover:bg-slate-800={page.url.pathname !== item.path}
					class:hover:text-slate-200={page.url.pathname !== item.path}
				>
					{#if page.url.pathname === item.path}
						<div class="absolute left-0 h-5 w-1 rounded-r-md bg-white"></div>
					{/if}

					<i class="fas {item.icon} shrink-0 text-lg"></i>
					{#if isSidebarOpen}
						<span class="text-sm font-medium">{item.name}</span>
					{/if}
				</a>
			{/each}
		</nav>

		<div class="shrink-0 border-t border-slate-800 p-4">
			<button
				onclick={handleLogout}
				class="flex w-full items-center gap-4 rounded-xl px-4 py-3 text-red-400 transition-colors hover:bg-red-500/10"
			>
				<i class="fas fa-sign-out-alt text-lg"></i>
				{#if isSidebarOpen}
					<span class="text-sm font-medium">Keluar</span>
				{/if}
			</button>
		</div>
	</aside>

	<div class="flex min-w-0 flex-1 flex-col overflow-hidden">
		<header
			class="flex h-20 shrink-0 items-center justify-between border-b border-purple-100 bg-linear-to-r from-purple-50 via-white to-white px-8"
		>
			<div class="flex items-center gap-4">
				<button
					onclick={() => (isSidebarOpen = !isSidebarOpen)}
					aria-label="Toggle sidebar"
					class="rounded-xl border border-slate-200 bg-white p-2 text-slate-500 shadow-xs transition-colors hover:bg-gray-50 hover:text-slate-800"
				>
					<i class="fas fa-bars text-base"></i>
				</button>
				<div class="flex flex-col">
					<h1 class="text-base leading-none font-bold tracking-tight text-gray-800">
						{menuItems.find((i) => i.path === page.url.pathname)?.name || 'Super Admin Panel'}
					</h1>
					<span class="mt-1 text-[10px] font-bold tracking-wider text-purple-500 uppercase"
						>Console Master</span
					>
				</div>
			</div>

			<div class="flex items-center gap-6">
				<button
					class="relative p-2 text-gray-400 transition-colors hover:text-gray-600 focus:outline-none"
					aria-label="Notifications"
				>
					<i class="fas fa-bell text-xl"></i>
					<span
						class="absolute top-1 right-1 h-2 w-2 rounded-full border-2 border-white bg-purple-500"
					></span>
				</button>

				<div class="flex items-center gap-3 border-l border-gray-200 pl-6">
					<div class="hidden text-right sm:block">
						<p class="text-sm leading-none font-bold text-gray-900">{user?.name || 'Root'}</p>
						<span
							class="mt-1 inline-flex items-center rounded-md bg-purple-50 px-2 py-0.5 text-[9px] font-extrabold tracking-widest text-purple-700 uppercase ring-1 ring-purple-700/10"
						>
							SUPER ADMIN
						</span>
					</div>
					<div
						class="flex h-10 w-10 items-center justify-center rounded-full border-2 border-white bg-linear-to-tr from-purple-600 to-indigo-600 font-bold text-white shadow-sm"
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
