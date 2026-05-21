<script lang="ts">
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { onMount } from 'svelte';
	import { type Offering } from '@/gen/app_pb';

	let { data } = $props();
	const { user, sessionId } = $derived(data);
	const offeringClient = $derived(createAuthenticatedClients(sessionId).offeringClient);

	let searchQuery = $state('');
	let showModal = $state(false);
	let editingOffering = $state<Offering | null>(null);

	// Form States
	let name = $state('');
	let price = $state<number>(0);
	let type = $state('MEMBERSHIP'); // "MEMBERSHIP", "PRODUCT", "SERVICE"
	let duration = $state<number | undefined>(30); // Khusus Membership
	let quota = $state<number | undefined>(0); // Khusus Service/PT
	let stock = $state<number | undefined>(0); // Khusus Product

	let isLoadingData = $state(true);
	let isSubmitting = $state(false);
	let offerings = $state<Offering[]>([]);

	async function loadOfferings() {
		offerings = [];
		isLoadingData = true;
		try {
			const getOfferings = await offeringClient.getOfferings({});
			offerings = getOfferings.offerings;
		} catch (err) {
			console.error('Stream error:', err);
		} finally {
			isLoadingData = false;
		}
	}

	onMount(loadOfferings);

	let filteredOfferings = $derived(
		offerings.filter((o) => o.name.toLowerCase().includes(searchQuery.toLowerCase()))
	);

	function openEditModal(item: Offering) {
		editingOffering = item;
		name = item.name;
		price = Number(item.price);
		type = item.type;
		duration = item.duration;
		quota = item.quota;
		stock = item.stock;
		showModal = true;
	}

	function resetForm() {
		editingOffering = null;
		name = '';
		price = 0;
		type = 'MEMBERSHIP'; // "MEMBERSHIP", "PRODUCT", "SERVICE"
		duration = 30;
		quota = 0;
		stock = 0;
	}

	async function handleSubmit(e: SubmitEvent) {
		e.preventDefault();
		const swal = (window as any).Swal;
		isSubmitting = true;

		try {
			const payload = {
				name,
				price: BigInt(price),
				type,
				duration: type === 'MEMBERSHIP' ? duration : undefined,
				quota: type === 'SERVICE' ? quota : undefined,
				stock: type === 'PRODUCT' ? stock : undefined,
				tenantId: user.tenantId
			};

			if (editingOffering) {
				await offeringClient.updateOffering({ id: editingOffering.id, ...payload });
				await swal.fire('Berhasil!', 'Penawaran diperbarui.', 'success');
			} else {
				await offeringClient.addOffering(payload);
				await swal.fire('Berhasil!', 'Penawaran baru ditambahkan.', 'success');
			}
			showModal = false;
			loadOfferings();
		} catch (err: any) {
			await swal.fire('Error!', err.message, 'error');
		} finally {
			isSubmitting = false;
		}
	}

	const formatIDR = (amount: number) => {
		return new Intl.NumberFormat('id-ID', {
			style: 'currency',
			currency: 'IDR',
			maximumFractionDigits: 0
		}).format(amount);
	};

	const getTypeLabel = (t: string) => {
		switch (t) {
			case 'MEMBERSHIP':
				return { label: 'Membership', color: 'bg-blue-50 text-blue-700' };
			case 'PRODUCT':
				return { label: 'Produk', color: 'bg-orange-50 text-orange-700' };
			case 'SERVICE':
				return { label: 'Layanan PT', color: 'bg-purple-50 text-purple-700' };
			default:
				return { label: 'Unknown', color: 'bg-gray-50' };
		}
	};
</script>

<div class="space-y-6">
	<div class="flex flex-col justify-between gap-4 md:flex-row md:items-center">
		<div>
			<h2 class="text-2xl font-bold text-gray-900">Daftar Penawaran (Offerings)</h2>
			<p class="text-sm text-gray-500">
				Kelola paket member, produk fisik, dan jasa PT di {user?.tenantName}
			</p>
		</div>
		<button
			class="flex items-center gap-2 rounded-xl bg-indigo-600 px-5 py-2.5 font-semibold text-white shadow-lg shadow-indigo-600/20 transition-all hover:bg-indigo-700"
			onclick={() => {
				resetForm();
				showModal = true;
			}}
		>
			<i class="fas fa-plus-circle"></i> Tambah Item
		</button>
	</div>

	<div class="rounded-2xl border border-gray-100 bg-white p-4 shadow-sm">
		<div class="relative">
			<i class="fas fa-search absolute top-1/2 left-4 -translate-y-1/2 text-gray-400"></i>
			<input
				type="text"
				placeholder="Cari penawaran..."
				bind:value={searchQuery}
				class="w-full rounded-xl border border-gray-200 bg-gray-50 py-2.5 pr-4 pl-11 outline-none focus:ring-2 focus:ring-indigo-500"
			/>
		</div>
	</div>

	<div class="overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm">
		<div class="overflow-x-auto">
			<table class="w-full text-left">
				<thead>
					<tr class="border-b border-gray-100 bg-gray-50">
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Item</th>
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Tipe</th>
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Detail</th>
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Harga</th>
						<th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Aksi</th>
					</tr>
				</thead>
				<tbody class="divide-y divide-gray-50">
					{#each filteredOfferings as item}
						<tr class="group transition-colors hover:bg-indigo-50/30">
							<td class="px-6 py-4 font-bold text-gray-900">{item.name}</td>
							<td class="px-6 py-4">
								<span
									class="rounded-full px-3 py-1 text-[10px] font-black tracking-wider uppercase {getTypeLabel(
										item.type
									).color}"
								>
									{getTypeLabel(item.type).label}
								</span>
							</td>
							<td class="px-6 py-4 text-sm text-gray-500">
								{#if item.type === 'MEMBERSHIP'}
									{item.duration} Hari
								{:else if item.type === 'PRODUCT'}
									Stok: {item.stock}
								{:else if item.type === 'SERVICE'}
									{item.quota} Sesi PT
								{/if}
							</td>
							<td class="px-6 py-4 font-bold text-indigo-600">{formatIDR(Number(item.price))}</td>
							<td class="px-6 py-4 text-right">
								<div class="flex justify-end gap-2">
									<button
										onclick={() => openEditModal(item)}
										aria-label="Edit Item"
										class="text-gray-400 hover:text-indigo-600"><i class="fas fa-edit"></i></button
									>
								</div>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>
	</div>
</div>

{#if showModal}
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<button
			class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm"
			aria-label="Close modal"
			onclick={() => (showModal = false)}
		></button>
		<div class="z-10 w-full max-w-md overflow-hidden rounded-3xl bg-white shadow-2xl">
			<div class="border-b border-gray-100 bg-gray-50 px-6 py-4">
				<h3 class="font-bold text-gray-900">
					{editingOffering ? 'Edit Item' : 'Tambah Item Baru'}
				</h3>
			</div>
			<form onsubmit={handleSubmit} class="space-y-4 p-6">
				<div>
					<label for="type" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
						>Tipe Penawaran</label
					>
					<select
						id="type"
						bind:value={type}
						class="w-full rounded-xl border border-gray-200 p-3 outline-none focus:ring-2 focus:ring-indigo-500"
					>
						<option value="MEMBERSHIP">Membership (Durasi)</option>
						<option value="PRODUCT">Produk Fisik (Stok)</option>
						<option value="SERVICE">Layanan PT (Kuota Sesi)</option>
					</select>
				</div>

				<div>
					<label for="name" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
						>Nama Item</label
					>
					<input
						id="name"
						bind:value={name}
						type="text"
						class="w-full rounded-xl border border-gray-200 p-3"
						required
					/>
				</div>

				<div class="grid grid-cols-2 gap-4">
					<div>
						<label for="price" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
							>Harga (IDR)</label
						>
						<input
							id="price"
							bind:value={price}
							type="number"
							class="w-full rounded-xl border border-gray-200 p-3"
							required
						/>
					</div>

					{#if type === 'MEMBERSHIP'}
						<div>
							<label for="duration" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
								>Durasi (Hari)</label
							>
							<input
								id="duration"
								bind:value={duration}
								type="number"
								class="w-full rounded-xl border border-gray-200 p-3"
							/>
						</div>
					{:else if type === 'PRODUCT'}
						<div>
							<label for="stock" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
								>Stok Awal</label
							>
							<input
								id="stock"
								bind:value={stock}
								type="number"
								class="w-full rounded-xl border border-gray-200 p-3"
							/>
						</div>
					{:else if type === 'SERVICE'}
						<div>
							<label for="quota" class="mb-1 block text-xs font-bold text-gray-400 uppercase"
								>Kuota Sesi</label
							>
							<input
								id="quota"
								bind:value={quota}
								type="number"
								class="w-full rounded-xl border border-gray-200 p-3"
							/>
						</div>
					{/if}
				</div>

				<div class="mt-6 flex gap-3">
					<button
						type="button"
						onclick={() => (showModal = false)}
						class="flex-1 rounded-xl py-3 font-bold text-gray-400 hover:bg-gray-50">Batal</button
					>
					<button
						type="submit"
						disabled={isSubmitting}
						class="flex-1 rounded-xl bg-indigo-600 py-3 font-bold text-white shadow-lg shadow-indigo-200"
					>
						{isSubmitting ? '...' : 'Simpan'}
					</button>
				</div>
			</form>
		</div>
	</div>
{/if}
