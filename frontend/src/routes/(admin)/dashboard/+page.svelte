<script lang="ts">
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { onMount } from 'svelte';
	import { timestampDate } from '@bufbuild/protobuf/wkt';

	let { data } = $props();
	const user = $derived(data.user);
	const sessionId = $derived(data.sessionId);
	const transactionClient = $derived(createAuthenticatedClients(sessionId).transactionClient);

	let stats = $state([
		{
			name: 'Total Member',
			value: '0',
			trend: '...',
			icon: 'fa-users',
			color: 'text-blue-600',
			bg: 'bg-blue-100'
		},
		{
			name: 'Pendapatan',
			value: 'Rp 0',
			trend: '...',
			icon: 'fa-money-bill-wave',
			color: 'text-emerald-600',
			bg: 'bg-emerald-100'
		},
		{
			name: 'Transaksi Sukses',
			value: '0',
			trend: '...',
			icon: 'fa-receipt',
			color: 'text-amber-600',
			bg: 'bg-amber-100'
		},
		{
			name: 'Member Aktif',
			value: '0',
			trend: '...',
			icon: 'fa-user-check',
			color: 'text-purple-600',
			bg: 'bg-purple-100'
		}
	]);

	let recentActivities = $state<any[]>([]);
	let isLoading = $state(true);

	// Helper format mata uang
	const formatIDR = (val: string | number) => {
		return new Intl.NumberFormat('id-ID', {
			style: 'currency',
			currency: 'IDR',
			maximumFractionDigits: 0
		}).format(Number(val));
	};

	// Fungsi Load Data Nyata
	async function loadDashboardData() {
		isLoading = true;
		try {
			const summary = await transactionClient.getFinanceSummary({});

			stats[0].value = summary.totalTransactions.toString();
			stats[1].value = formatIDR(String(summary.totalRevenue));
			stats[2].value = summary.totalTransactions.toString();
			stats[3].value = summary.activeMemberships.toString();

			recentActivities = [];
			const getTransactions = await transactionClient.getTransactions({});
			recentActivities = getTransactions.transactions.map((trx, i) => {
				return {
					id: trx.id,
					user: trx.memberName,
					action: `Membeli ${trx.planId ? `paket ${trx.planName}` : `penawaran ${trx.offeringName}`} via ${trx.method === 'CASH' ? 'Cash' : 'QRIS'}`,
					time: timestampDate(trx.createdAt!).toLocaleTimeString('id-ID', {
						hour: '2-digit',
						minute: '2-digit'
					}),
					status: trx.status === 'SETTLEMENT' ? 'Success' : 'Pending'
				};
			});
		} catch (err) {
			console.error('Gagal memuat dashboard:', err);
		} finally {
			isLoading = false;
		}
	}

	onMount(() => {
		loadDashboardData();
	});
</script>

<div class="space-y-8 p-6">
	<div class="flex items-center justify-between">
		<div>
			<h2 class="text-2xl font-bold tracking-tight text-gray-900">Halo, {user?.name} 👋</h2>
			<p class="text-sm font-medium text-gray-500">
				Berikut adalah performa {user?.tenantName} hari ini.
			</p>
		</div>
		<button
			onclick={loadDashboardData}
			aria-label="Refresh Dashboard"
			class="p-2 text-gray-400 transition-colors hover:text-blue-600"
		>
			<i class="fas fa-sync-alt {isLoading ? 'animate-spin' : ''}"></i>
		</button>
	</div>

	<div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
		{#each stats as stat}
			<div
				class="rounded-3xl border border-gray-100 bg-white p-6 shadow-sm transition-all hover:shadow-md"
			>
				<div class="flex items-center justify-between">
					<div class="rounded-2xl p-3 {stat.bg} {stat.color}">
						<i class="fas {stat.icon} text-xl"></i>
					</div>
				</div>
				<div class="mt-4">
					<p class="text-xs font-bold tracking-wider text-gray-400 uppercase">{stat.name}</p>
					<h3 class="mt-1 text-2xl font-black text-gray-900">
						{isLoading ? '...' : stat.value}
					</h3>
				</div>
			</div>
		{/each}
	</div>

	<div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
		<div class="rounded-3xl border border-gray-100 bg-white p-8 shadow-sm lg:col-span-2">
			<div class="mb-8 flex items-center justify-between">
				<div>
					<h3 class="text-lg font-bold text-gray-900">Grafik Kunjungan</h3>
					<p class="text-sm text-gray-500">Live data</p>
				</div>
			</div>

			<div
				class="flex h-64 w-full items-center justify-center rounded-4xl border-2 border-dashed border-gray-100 bg-slate-50/50"
			>
				<div class="text-center">
					<i class="fas fa-chart-line mb-2 text-4xl text-blue-200"></i>
					<p class="text-sm font-medium text-gray-400">Integrasi Chart.js segera hadir</p>
				</div>
			</div>
		</div>

		<div class="rounded-3xl border border-gray-100 bg-white p-8 shadow-sm">
			<h3 class="mb-6 text-lg font-bold text-gray-900">Aktivitas Terbaru</h3>
			<div class="flow-root">
				<ul class="-mb-8">
					{#if isLoading && recentActivities.length === 0}
						<li class="py-10 text-center text-sm text-gray-400 italic">
							Menarik data aktivitas...
						</li>
					{:else}
						{#each recentActivities as activity, i}
							<li>
								<div class="relative pb-8">
									{#if i !== recentActivities.length - 1}
										<span class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-100"></span>
									{/if}
									<div class="relative flex space-x-4">
										<div>
											<span
												class="h-8 w-8 rounded-full {activity.status === 'Success'
													? 'bg-emerald-500'
													: 'bg-orange-400'} flex items-center justify-center shadow-sm ring-4 ring-white"
											>
												<i
													class="fas {activity.status === 'Success'
														? 'fa-check'
														: 'fa-clock'} text-[10px] text-white"
												></i>
											</span>
										</div>
										<div class="flex min-w-0 flex-1 justify-between space-x-4 pt-1.5">
											<div>
												<p class="text-xs text-gray-500">
													<span class="mb-0.5 block font-bold text-gray-900">{activity.user}</span>
													{activity.action}
												</p>
											</div>
											<div class="text-right text-[10px] font-bold text-gray-300">
												{activity.time}
											</div>
										</div>
									</div>
								</div>
							</li>
						{/each}
					{/if}
				</ul>
			</div>
		</div>
	</div>
</div>
