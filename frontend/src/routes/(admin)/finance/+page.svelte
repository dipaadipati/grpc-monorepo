<script lang="ts">
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { timestampDate } from '@bufbuild/protobuf/wkt';
	import { onMount } from 'svelte';

	let { data } = $props();
	const user = $derived(data.user);
	const sessionId = $derived(data.sessionId);
	const transactionClient = $derived(createAuthenticatedClients(sessionId).transactionClient);

	let summary = $state({
		totalRevenue: '0',
		totalTransactions: 0,
		activeMemberships: 0
	});

	let allTransactions = $state<any[]>([]);
	let searchQuery = $state('');
	let filterMethod = $state('All');
	let filterStatus = $state('All');
	let isLoading = $state(true);
	let currentPage = $state(1);
	let itemsPerPage = $state(5);

	async function loadFinanceData() {
		isLoading = true;
		try {
			const summaryRes = await transactionClient.getFinanceSummary({});
			summary = {
				totalRevenue: String(summaryRes.totalRevenue),
				totalTransactions: summaryRes.totalTransactions,
				activeMemberships: summaryRes.activeMemberships
			};

			allTransactions = [];
			const getTransactions = await transactionClient.getTransactions({});
			allTransactions = getTransactions.transactions;
		} catch (err) {
			console.error('Gagal memuat data keuangan:', err);
		} finally {
			isLoading = false;
		}
	}

	onMount(() => {
		loadFinanceData();
	});

	let filteredTransactions = $derived(
		allTransactions.filter((trx) => {
			const matchesSearch =
				trx.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
				trx.memberName.toLowerCase().includes(searchQuery.toLowerCase()) ||
				trx.planName.toLowerCase().includes(searchQuery.toLowerCase());

			const matchesMethod = filterMethod === 'All' || trx.method === filterMethod;

			const matchesStatus = filterStatus === 'All' || trx.status === filterStatus;

			return matchesSearch && matchesMethod && matchesStatus;
		})
	);

	let totalPages = $derived(Math.ceil(filteredTransactions.length / itemsPerPage) || 1);

	let paginatedTransactions = $derived.by(() => {
		// Reset to first page if current page exceeds total pages
		if (currentPage > totalPages) {
			currentPage = 1;
		}
		const startIndex = (currentPage - 1) * itemsPerPage;
		const endIndex = startIndex + itemsPerPage;
		return filteredTransactions.slice(startIndex, endIndex);
	});

	// Reset to page 1 when filters change
	$effect(() => {
		searchQuery;
		filterMethod;
		filterStatus;
		currentPage = 1;
	});

	const formatIDR = (val: string | number) => {
		return new Intl.NumberFormat('id-ID', {
			style: 'currency',
			currency: 'IDR',
			maximumFractionDigits: 0
		}).format(Number(val));
	};
</script>

<div class="space-y-8 p-6">
	<div class="flex items-end justify-between">
		<div>
			<h2 class="text-3xl font-black tracking-tight text-gray-900">Dashboard Keuangan</h2>
			<p class="font-medium text-gray-500">Laporan pendapatan cabang {user?.tenantName}</p>
		</div>
		<button
			onclick={loadFinanceData}
			class="rounded-2xl border border-gray-200 bg-white p-3 shadow-sm transition-all hover:bg-gray-50"
			title="Refresh Data"
		>
			<i class="fas fa-sync-alt {isLoading ? 'animate-spin text-blue-600' : 'text-gray-400'}"></i>
		</button>
	</div>

	<div class="grid grid-cols-1 gap-6 md:grid-cols-3">
		<div
			class="relative overflow-hidden rounded-4xl bg-linear-to-br from-emerald-500 to-emerald-600 p-8 text-white shadow-xl shadow-emerald-200"
		>
			<i class="fas fa-wallet absolute -right-4 -bottom-4 text-9xl opacity-10"></i>
			<p class="text-xs font-bold tracking-wider text-emerald-100 uppercase">Total Pendapatan</p>
			<h3 class="mt-2 text-4xl font-black">{formatIDR(summary.totalRevenue)}</h3>
		</div>

		<div class="relative overflow-hidden rounded-4xl border border-gray-100 bg-white p-8 shadow-sm">
			<p class="text-xs font-bold tracking-wider text-gray-400 uppercase">Transaksi Sukses</p>
			<h3 class="mt-2 text-4xl font-black text-gray-900">{summary.totalTransactions}</h3>
			<div class="mt-4 flex items-center text-sm font-bold text-blue-600">
				<i class="fas fa-check-double mr-2"></i> Settlement Terverifikasi
			</div>
		</div>

		<div class="relative overflow-hidden rounded-4xl border border-gray-100 bg-white p-8 shadow-sm">
			<p class="text-xs font-bold tracking-wider text-gray-400 uppercase">Member Aktif</p>
			<h3 class="mt-2 text-4xl font-black text-gray-900">{summary.activeMemberships}</h3>
			<div class="mt-4 flex items-center text-sm font-bold text-orange-500">
				<i class="fas fa-user-check mr-2"></i> Berlangganan Paket
			</div>
		</div>
	</div>

	<div
		class="flex flex-col gap-4 rounded-3xl border border-gray-100 bg-white p-4 shadow-sm md:flex-row"
	>
		<div class="relative flex-1">
			<i class="fas fa-search absolute top-1/2 left-5 -translate-y-1/2 text-gray-400"></i>
			<input
				type="text"
				placeholder="Cari Order ID, Nama Member, atau Paket..."
				bind:value={searchQuery}
				class="w-full rounded-2xl border-0 bg-gray-50 py-4 pr-6 pl-14 font-medium transition-all outline-none focus:ring-2 focus:ring-emerald-500"
			/>
		</div>
		<select
			bind:value={filterMethod}
			class="rounded-2xl border-0 bg-gray-50 px-6 py-4 font-bold text-gray-600 outline-none focus:ring-2 focus:ring-emerald-500"
		>
			<option value="All">Semua Metode</option>
			<option value="CASH">Cash</option>
			<option value="QRIS">QRIS / Online</option>
		</select>
		<select
			bind:value={filterStatus}
			class="rounded-2xl border-0 bg-gray-50 px-6 py-4 font-bold text-gray-600 outline-none focus:ring-2 focus:ring-emerald-500"
		>
			<option value="All">Semua Status</option>
			<option value="SETTLEMENT">Lunas</option>
			<option value="PENDING">Pending</option>
		</select>
	</div>

	<div class="overflow-hidden rounded-4xl border border-gray-100 bg-white shadow-sm">
		<div class="overflow-x-auto">
			<table class="w-full text-left">
				<thead>
					<tr class="bg-gray-50/50 text-[10px] font-black tracking-[0.2em] text-gray-400 uppercase">
						<th class="px-8 py-5">Order ID</th>
						<th class="px-8 py-5">Informasi Member</th>
						<th class="px-8 py-5">Paket/Produk</th>
						<th class="px-8 py-5 text-right">Nominal</th>
						<th class="px-8 py-5 text-center">Status</th>
					</tr>
				</thead>
				<tbody class="divide-y divide-gray-50">
					{#each paginatedTransactions as trx (trx.id)}
						<tr class="group transition-colors hover:bg-gray-50/80">
							<td class="px-8 py-5">
								<span
									class="font-mono text-xs text-gray-400 transition-colors group-hover:text-emerald-600"
								>
									#{trx.id}
								</span>
							</td>
							<td class="px-8 py-5">
								<p class="font-bold text-gray-900">{trx.memberName}</p>
								<p class="text-[10px] tracking-tighter text-gray-400 uppercase">
									{timestampDate(trx.createdAt).toLocaleString('id-ID')}
								</p>
							</td>
							<td class="px-8 py-5">
								<p
									class="text-sm font-semibold {trx.planId ? 'text-purple-700' : 'text-slate-700'}"
								>
									{trx.planId ? trx.planName : trx.offeringName}
								</p>
								<span
									class="mt-1 inline-block rounded-md bg-gray-100 px-2 py-0.5 text-[10px] font-black text-gray-500"
								>
									{trx.method}
								</span>
							</td>
							<td class="px-8 py-5 text-right">
								<p class="font-black text-gray-900">{formatIDR(Number(trx.amount))}</p>
							</td>
							<td class="px-8 py-5">
								<div class="flex justify-center">
									{#if trx.status === 'SETTLEMENT'}
										<span
											class="rounded-full bg-emerald-100 px-4 py-1.5 text-[10px] font-black text-emerald-700 shadow-sm shadow-emerald-100"
										>
											LUNAS
										</span>
									{:else if trx.status === 'PENDING'}
										<span
											class="rounded-full bg-orange-100 px-4 py-1.5 text-[10px] font-black text-orange-700 shadow-sm shadow-orange-100"
										>
											PENDING
										</span>
									{:else}
										<span
											class="rounded-full bg-red-50 px-4 py-1.5 text-[10px] font-black text-red-400 italic"
										>
											{trx.status}
										</span>
									{/if}
								</div>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>

		{#if paginatedTransactions.length === 0 && !isLoading}
			<div class="py-24 text-center">
				<div class="mb-4 inline-block rounded-full bg-gray-50 p-6">
					<i class="fas fa-search-minus text-4xl text-gray-200"></i>
				</div>
				<p class="font-medium text-gray-400">Data transaksi tidak ditemukan.</p>
			</div>
		{/if}

		{#if filteredTransactions.length > 0}
			{#key [itemsPerPage, currentPage, totalPages]}
				<div
					class="flex flex-col items-center justify-between gap-4 border-t border-gray-100 px-4 py-6 sm:px-8 lg:flex-row lg:gap-0"
				>
					<div class="order-1 flex items-center gap-4 lg:order-0">
						<span class="text-sm font-medium text-gray-600">
							Tampilkan
							<select
								bind:value={itemsPerPage}
								onchange={() => (currentPage = 1)}
								class="mx-2 rounded border border-gray-300 bg-white px-3 py-1 font-semibold text-gray-900 outline-none focus:ring-2 focus:ring-emerald-500"
							>
								<option value={5}>5</option>
								<option value={10}>10</option>
								<option value={25}>25</option>
								<option value={50}>50</option>
							</select>
							dari {filteredTransactions.length} transaksi
						</span>
					</div>

					<div class="order-2 flex items-center gap-2 lg:order-0">
						<button
							onclick={() => (currentPage = Math.max(1, currentPage - 1))}
							disabled={currentPage === 1}
							aria-label="Previous Page"
							class="rounded-lg border border-gray-300 bg-white px-3 py-2 font-semibold text-gray-700 transition-all hover:enabled:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50 sm:px-4"
						>
							<i class="fas fa-chevron-left text-sm"></i>
						</button>

						<div class="hidden gap-1 sm:flex">
							{#each Array.from({ length: totalPages }, (_, i) => i + 1) as pageNumber}
								<button
									onclick={() => (currentPage = pageNumber)}
									class="rounded-lg px-3 py-2 font-semibold transition-all {currentPage ===
									pageNumber
										? 'bg-emerald-500 text-white shadow-md shadow-emerald-200'
										: 'border border-gray-300 bg-white text-gray-700 hover:bg-gray-50'}"
								>
									{pageNumber}
								</button>
							{/each}
						</div>

						<div
							class="block rounded-lg border border-gray-300 bg-white px-3 py-2 font-semibold text-gray-700 sm:hidden"
						>
							{currentPage} / {totalPages}
						</div>

						<button
							onclick={() => (currentPage = Math.min(totalPages, currentPage + 1))}
							disabled={currentPage === totalPages}
							aria-label="Next Page"
							class="rounded-lg border border-gray-300 bg-white px-3 py-2 font-semibold text-gray-700 transition-all hover:enabled:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-50 sm:px-4"
						>
							<i class="fas fa-chevron-right text-sm"></i>
						</button>
					</div>

					<div class="order-3 text-sm font-medium text-gray-600 lg:order-0">
						<span>Halaman {currentPage} dari {totalPages}</span>
					</div>
				</div>
			{/key}
		{/if}
	</div>
</div>
