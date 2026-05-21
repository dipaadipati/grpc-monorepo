<script lang="ts">
	import type { Tenant } from '@/gen/app_pb';
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { onMount } from 'svelte';

	let { data } = $props();
	const sessionId = $derived(data.sessionId);
	const tenantClient = $derived(createAuthenticatedClients(sessionId).tenantClient);

	let searchQuery = $state('');
	let selectedStatus = $state('All');

	let showModal = $state(false);
	let editingTenant = $state<Tenant | null>(null);

	// Form States
	let name = $state('');
	let slug = $state('');
	let address = $state('');
	let isActive = $state(true);

	let isLoadingData = $state(true);
	let isSubmitting = $state(false);
	let tenants = $state<Tenant[]>([]);

	async function loadTenants() {
		tenants = [];
		isLoadingData = true;
		try {
			const getTenants = await tenantClient.getTenants({});
			tenants = getTenants.tenants;
		} catch (err) {
			console.error('Stream error:', err);
		} finally {
			isLoadingData = false;
		}
	}

	onMount(() => {
		loadTenants();
	});

	let filteredTenants = $derived(
		tenants.filter((t) => {
			const matchSearch =
				t.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
				t.slug.toLowerCase().includes(searchQuery.toLowerCase());

			if (selectedStatus === 'Active') return matchSearch && t.isActive;
			if (selectedStatus === 'Inactive') return matchSearch && !t.isActive;

			return matchSearch;
		})
	);

	function openEditModal(tenant: Tenant) {
		editingTenant = tenant;
		name = tenant.name;
		slug = tenant.slug;
		address = tenant.address;
		isActive = tenant.isActive;
		showModal = true;
	}

	function resetForm() {
		editingTenant = null;
		name = '';
		slug = '';
		address = '';
		isActive = true;
	}

	async function handleSubmitTenant(e: SubmitEvent) {
		e.preventDefault();
		const swal = (window as any).Swal;

		try {
			isSubmitting = true;
			if (editingTenant) {
				await tenantClient.updateTenant({
					id: editingTenant.id,
					name,
					slug,
					address,
					isActive
				});
				await swal.fire('Berhasil!', 'Cabang berhasil diperbarui.', 'success');
			} else {
				await tenantClient.addTenant({ name, slug, address, isActive });
				await swal.fire('Berhasil!', 'Cabang baru berhasil didaftarkan.', 'success');
			}

			showModal = false;
			loadTenants();
		} catch (err: any) {
			await swal.fire('Error!', err.message, 'error');
		} finally {
			isSubmitting = false;
		}
	}

	async function handleDeleteTenant(tenantId: number) {
		const swal = (window as any).Swal;
		const result = await swal.fire({
			title: 'Hapus Cabang?',
			text: 'Seluruh data member dan staff di cabang ini akan ikut terhapus!',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: 'Ya, Hapus Cabang!',
			confirmButtonColor: '#ef4444'
		});

		if (result.isConfirmed) {
			try {
				await tenantClient.deleteTenant({ tenantId });
				await swal.fire('Terhapus!', 'Cabang telah dihapus.', 'success');
				loadTenants();
			} catch (err: any) {
				await swal.fire('Error!', err.message, 'error');
			}
		}
	}
</script>

<div class="space-y-6">
	<div class="flex flex-col justify-between gap-4 md:flex-row md:items-center">
		<div>
			<h2 class="text-2xl font-bold text-gray-900">Manajemen Cabang</h2>
			<p class="text-sm text-gray-500">Kelola semua unit bisnis (Tenants)</p>
		</div>
		<button
			class="flex items-center gap-2 rounded-xl bg-indigo-600 px-5 py-2.5 font-semibold text-white shadow-lg shadow-indigo-600/20 transition-all hover:bg-indigo-700"
			onclick={() => {
				resetForm();
				showModal = true;
			}}
		>
			<i class="fas fa-building"></i>
			Tambah Cabang
		</button>
	</div>

	<div
		class="flex flex-col gap-4 rounded-2xl border border-gray-100 bg-white p-4 shadow-sm md:flex-row"
	>
		<div class="relative flex-1">
			<i class="fas fa-search absolute top-1/2 left-4 -translate-y-1/2 text-gray-400"></i>
			<input
				type="text"
				placeholder="Cari nama cabang atau slug..."
				bind:value={searchQuery}
				class="w-full rounded-xl border border-gray-200 bg-gray-50 py-2.5 pr-4 pl-11 transition-all outline-none focus:ring-2 focus:ring-indigo-500"
			/>
		</div>
		<select
			bind:value={selectedStatus}
			class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-2.5 transition-all outline-none focus:ring-2 focus:ring-indigo-500"
		>
			<option value="All">Semua Status</option>
			<option value="Active">Aktif</option>
			<option value="Inactive">Non-Aktif</option>
		</select>
	</div>

	<div class="overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm">
		<div class="overflow-x-auto">
			<table class="w-full border-collapse text-left">
				<thead>
					<tr class="border-b border-gray-100 bg-gray-50">
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Cabang</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase">Slug</th>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Status</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Alamat</th
						>
						<th
							class="px-6 py-4 text-right text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Aksi</th
						>
					</tr>
				</thead>
				<tbody class="divide-y divide-gray-50">
					{#each filteredTenants as tenant}
						<tr class="group transition-colors hover:bg-indigo-50/30">
							<td class="px-6 py-4">
								<div class="flex items-center gap-3">
									<div
										class="flex h-10 w-10 items-center justify-center rounded-xl bg-indigo-100 font-bold text-indigo-600"
									>
										<i class="fas fa-store text-sm"></i>
									</div>
									<p class="font-bold text-gray-900">{tenant.name}</p>
								</div>
							</td>
							<td class="px-6 py-4">
								<span class="rounded bg-gray-100 px-2 py-1 font-mono text-xs text-gray-600"
									>{tenant.slug}</span
								>
							</td>
							<td class="px-6 py-4">
								<span
									class="inline-flex items-center gap-1.5 rounded-full px-2.5 py-0.5 text-xs font-medium {tenant.isActive
										? 'bg-green-100 text-green-700'
										: 'bg-red-100 text-red-700'}"
								>
									<span
										class="h-1.5 w-1.5 rounded-full {tenant.isActive
											? 'bg-green-600'
											: 'bg-red-600'}"
									></span>
									{tenant.isActive ? 'Aktif' : 'Non-Aktif'}
								</span>
							</td>
							<td class="max-w-xs truncate px-6 py-4 text-sm text-gray-500">
								{tenant.address || '-'}
							</td>
							<td class="px-6 py-4 text-right">
								<div
									class="flex justify-end gap-2 opacity-0 transition-opacity group-hover:opacity-100"
								>
									<button
										class="rounded-lg border border-transparent p-2 text-indigo-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
										aria-label="Edit Tenant"
										onclick={() => openEditModal(tenant)}
									>
										<i class="fas fa-edit"></i>
									</button>
									<button
										class="rounded-lg border border-transparent p-2 text-red-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
										aria-label="Delete Tenant"
										onclick={() => handleDeleteTenant(tenant.id)}
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
			<div class="py-20 text-center">
				<div
					class="inline-block h-8 w-8 animate-spin rounded-full border-4 border-solid border-indigo-600 border-r-transparent align-[-0.125em] motion-reduce:animate-[spin_1.5s_linear_infinite]"
				></div>
				<p class="mt-4 font-medium text-gray-500">Loading...</p>
			</div>
		{:else if filteredTenants.length === 0}
			<div class="py-20 text-center">
				<i class="fas fa-building-circle-exclamation mb-3 text-4xl text-gray-200"></i>
				<p class="text-gray-500">Cabang tidak ditemukan.</p>
			</div>
		{/if}
	</div>
</div>

{#if showModal}
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<button
			type="button"
			class="absolute inset-0 bg-slate-900/60 backdrop-blur-sm"
			aria-label="Close Modal"
			onclick={() => (showModal = false)}
		></button>

		<div
			class="z-10 w-full max-w-lg overflow-hidden rounded-3xl bg-white shadow-2xl transition-all"
		>
			<div class="border-b border-gray-100 bg-gray-50/50 px-8 py-5">
				<h3 class="text-xl font-bold text-gray-900">
					{editingTenant ? 'Edit Cabang' : 'Daftarkan Cabang Baru'}
				</h3>
			</div>

			<form onsubmit={handleSubmitTenant} class="space-y-5 p-8">
				<div class="grid grid-cols-2 gap-4">
					<div class="col-span-2">
						<label for="name" class="mb-1.5 block text-sm font-bold text-gray-700"
							>Nama Cabang</label
						>
						<input
							id="name"
							bind:value={name}
							type="text"
							placeholder="Contoh: Gym Center Jakarta"
							class="w-full rounded-xl border border-gray-200 px-4 py-3 outline-none focus:ring-2 focus:ring-indigo-500"
							required
						/>
					</div>

					<div>
						<label for="slug" class="mb-1.5 block text-sm font-bold text-gray-700">URL Slug</label>
						<input
							id="slug"
							bind:value={slug}
							type="text"
							placeholder="gym-jakarta"
							class="w-full rounded-xl border border-gray-200 px-4 py-3 font-mono text-sm outline-none focus:ring-2 focus:ring-indigo-500"
							required
						/>
					</div>

					<div>
						<label for="isActive" class="mb-1.5 block text-sm font-bold text-gray-700">Status</label
						>
						<select
							id="isActive"
							bind:value={isActive}
							class="w-full rounded-xl border border-gray-200 px-4 py-3 outline-none focus:ring-2 focus:ring-indigo-500"
						>
							<option value={true}>Aktif</option>
							<option value={false}>Non-Aktif</option>
						</select>
					</div>
				</div>

				<div>
					<label for="address" class="mb-1.5 block text-sm font-bold text-gray-700"
						>Alamat Lengkap</label
					>
					<textarea
						id="address"
						bind:value={address}
						rows="3"
						placeholder="Alamat lengkap operasional cabang..."
						class="w-full rounded-xl border border-gray-200 px-4 py-3 outline-none focus:ring-2 focus:ring-indigo-500"
					></textarea>
				</div>

				<div class="flex gap-3 pt-2">
					<button
						type="button"
						onclick={() => (showModal = false)}
						class="flex-1 rounded-xl border border-gray-200 py-3 font-bold text-gray-600 transition-all hover:bg-gray-50"
					>
						Batal
					</button>
					<button
						type="submit"
						disabled={isSubmitting}
						class="flex-1 rounded-xl bg-indigo-600 py-3 font-bold text-white shadow-lg shadow-indigo-600/20 transition-all hover:bg-indigo-700 disabled:opacity-50"
					>
						{isSubmitting
							? 'Memproses...'
							: editingTenant
								? 'Simpan Perubahan'
								: 'Daftarkan Cabang'}
					</button>
				</div>
			</form>
		</div>
	</div>
{/if}
