<script lang="ts">
	import type { Plan } from '$gen/app_pb';
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { onMount } from 'svelte';

	let { data } = $props();
	const user = $derived(data.user);
	const sessionId = $derived(data.sessionId);
	const planClient = $derived(createAuthenticatedClients(sessionId).planClient);

	let searchQuery = $state('');
	let showModal = $state(false);
	let editingPlan = $state<Plan | null>(null);

	// Form States
	let name = $state('');
	let price = $state<number>(0);
	let duration = $state<number>(30); // Default 30 hari

	let isLoadingData = $state(true);
	let isSubmitting = $state(false);
	let plans = $state<Plan[]>([]);

	async function loadPlans() {
		plans = [];
		isLoadingData = true;
		try {
			for await (const plan of planClient.getPlans({})) {
				plans.push(plan);
			}
		} catch (err) {
			console.error('Stream error:', err);
		} finally {
			isLoadingData = false;
		}
	}

	onMount(() => {
		loadPlans();
	});

	let filteredPlans = $derived(
		plans.filter((p) => p.name.toLowerCase().includes(searchQuery.toLowerCase()))
	);

	function openEditModal(plan: Plan) {
		editingPlan = plan;
		name = plan.name;
		price = Number(plan.price);
		duration = plan.duration;
		showModal = true;
	}

	function resetForm() {
		editingPlan = null;
		name = '';
		price = 0;
		duration = 30;
	}

	async function handleSubmit(e: SubmitEvent) {
		e.preventDefault();
		const swal = (window as any).Swal;

		try {
			isSubmitting = true;
			if (editingPlan) {
				await planClient.updatePlan({
					id: editingPlan.id,
					name,
					price: BigInt(price),
					duration
				});
				await swal.fire('Berhasil!', 'Paket berhasil diperbarui.', 'success');
			} else {
				await planClient.addPlan({
					name,
					price: BigInt(price),
					duration,
					tenantId: user.tenantId
				});
				await swal.fire('Berhasil!', 'Paket baru telah ditambahkan.', 'success');
			}
			showModal = false;
			loadPlans();
		} catch (err: any) {
			await swal.fire('Error!', err.message, 'error');
		} finally {
			isSubmitting = false;
		}
	}

	async function handleDelete(planId: number) {
		const swal = (window as any).Swal;
		const result = await swal.fire({
			title: 'Hapus Paket?',
			text: 'Member yang menggunakan paket ini mungkin akan terdampak!',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: 'Ya, Hapus!',
			confirmButtonColor: '#ef4444'
		});

		if (result.isConfirmed) {
			try {
				await planClient.deletePlan({ planId });
				await swal.fire('Terhapus!', 'Paket telah dihapus.', 'success');
				loadPlans();
			} catch (err: any) {
				await swal.fire('Error!', err.message, 'error');
			}
		}
	}

	// Helper format Rupiah
	const formatIDR = (amount: number) => {
		return new Intl.NumberFormat('id-ID', {
			style: 'currency',
			currency: 'IDR',
			maximumFractionDigits: 0
		}).format(amount);
	};
</script>

<div class="space-y-6">
	<div class="flex flex-col justify-between gap-4 md:flex-row md:items-center">
		<div>
			<h2 class="text-2xl font-bold text-gray-900">Paket Membership</h2>
			<p class="text-sm text-gray-500">
				Kelola daftar harga dan durasi langganan di {user?.tenantName}
			</p>
		</div>
		<button
			class="flex items-center gap-2 rounded-xl bg-emerald-600 px-5 py-2.5 font-semibold text-white shadow-lg shadow-emerald-600/20 transition-all hover:bg-emerald-700"
			onclick={() => {
				resetForm();
				showModal = true;
			}}
		>
			<i class="fas fa-tags"></i>
			Buat Paket Baru
		</button>
	</div>

	<div class="rounded-2xl border border-gray-100 bg-white p-4 shadow-sm">
		<div class="relative">
			<i class="fas fa-search absolute top-1/2 left-4 -translate-y-1/2 text-gray-400"></i>
			<input
				type="text"
				placeholder="Cari nama paket..."
				bind:value={searchQuery}
				class="w-full rounded-xl border border-gray-200 bg-gray-50 py-2.5 pr-4 pl-11 outline-none focus:ring-2 focus:ring-emerald-500"
			/>
		</div>
	</div>

	<div class="overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm">
		<div class="overflow-x-auto">
			<table class="w-full text-left">
				<thead>
					<tr class="border-b border-gray-100 bg-gray-50">
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Nama Paket</th>
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Harga</th>
						<th class="px-6 py-4 text-xs font-bold text-gray-500 uppercase">Durasi</th>
						<th class="px-6 py-4 text-right text-xs font-bold text-gray-500 uppercase">Aksi</th>
					</tr>
				</thead>
				<tbody class="divide-y divide-gray-50">
					{#each filteredPlans as plan}
						<tr class="group transition-colors hover:bg-emerald-50/30">
							<td class="px-6 py-4">
								<p class="font-bold text-gray-900">{plan.name}</p>
							</td>
							<td class="px-6 py-4">
								<span class="font-bold text-emerald-600">{formatIDR(Number(plan.price))}</span>
							</td>
							<td class="px-6 py-4">
								<span
									class="inline-flex items-center gap-1 rounded-full bg-blue-50 px-2 py-1 text-xs font-medium text-blue-700"
								>
									<i class="far fa-clock"></i>
									{plan.duration} Hari
								</span>
							</td>
							<td class="px-6 py-4 text-right">
								<div
									class="flex justify-end gap-2 opacity-0 transition-opacity group-hover:opacity-100"
								>
									<button
										class="rounded-lg border border-transparent p-2 text-emerald-600 shadow-sm hover:border-gray-100 hover:bg-white"
										aria-label="Edit Paket"
										onclick={() => openEditModal(plan)}
									>
										<i class="fas fa-edit"></i>
									</button>
									<button
										class="rounded-lg border border-transparent p-2 text-red-600 shadow-sm hover:border-gray-100 hover:bg-white"
										aria-label="Hapus Paket"
										onclick={() => handleDelete(plan.id)}
									>
										<i class="fas fa-trash"></i>
									</button>
								</div>
							</td>
						</tr>
					{/each}
				</tbody>
			</table>
		</div>

		{#if isLoadingData}
			<div class="py-20 text-center text-gray-400">
				<i class="fas fa-circle-notch mb-2 animate-spin text-3xl"></i>
				<p>Loading...</p>
			</div>
		{:else if filteredPlans.length === 0}
			<div class="py-20 text-center text-gray-400">
				<i class="fas fa-tag mb-2 text-4xl opacity-20"></i>
				<p>Belum ada paket membership.</p>
			</div>
		{/if}
	</div>
</div>

{#if showModal}
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<button
			class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm"
			aria-label="Tutup Modal"
			onclick={() => (showModal = false)}
		></button>
		<div class="z-10 w-full max-w-md overflow-hidden rounded-3xl bg-white shadow-2xl">
			<div class="border-b border-gray-100 bg-gray-50/50 px-6 py-4">
				<h3 class="text-lg font-bold text-gray-900">
					{editingPlan ? 'Update Paket' : 'Buat Paket Baru'}
				</h3>
			</div>
			<form onsubmit={handleSubmit} class="space-y-4 p-6">
				<div>
					<label for="name" class="mb-1 block text-sm font-bold text-gray-700">Nama Paket</label>
					<input
						id="name"
						bind:value={name}
						type="text"
						placeholder="Contoh: Member Bulanan Pro"
						class="w-full rounded-xl border border-gray-200 px-4 py-2.5 outline-none focus:ring-2 focus:ring-emerald-500"
						required
					/>
				</div>
				<div class="grid grid-cols-2 gap-4">
					<div>
						<label for="price" class="mb-1 block text-sm font-bold text-gray-700">Harga (IDR)</label
						>
						<input
							id="price"
							bind:value={price}
							type="number"
							class="w-full rounded-xl border border-gray-200 px-4 py-2.5 outline-none focus:ring-2 focus:ring-emerald-500"
							required
						/>
					</div>
					<div>
						<label for="duration" class="mb-1 block text-sm font-bold text-gray-700"
							>Durasi (Hari)</label
						>
						<input
							id="duration"
							bind:value={duration}
							type="number"
							class="w-full rounded-xl border border-gray-200 px-4 py-2.5 outline-none focus:ring-2 focus:ring-emerald-500"
							required
						/>
					</div>
				</div>
				<div class="flex gap-3 pt-4">
					<button
						type="button"
						onclick={() => (showModal = false)}
						class="flex-1 rounded-xl py-2.5 font-bold text-gray-500 hover:bg-gray-50">Batal</button
					>
					<button
						type="submit"
						disabled={isSubmitting}
						class="flex-1 rounded-xl bg-emerald-600 py-2.5 font-bold text-white shadow-lg shadow-emerald-600/20 hover:bg-emerald-700 disabled:opacity-50"
					>
						{isSubmitting ? 'Menyimpan...' : 'Simpan Paket'}
					</button>
				</div>
			</form>
		</div>
	</div>
{/if}
