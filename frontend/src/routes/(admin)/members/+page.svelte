<script lang="ts">
	import type { Offering, UserProfile } from '@/gen/app_pb';
	import { createAuthenticatedClients } from '$lib/grpc-client';
	import { timestampDate } from '@bufbuild/protobuf/wkt';

	const formatIDR = (amount: number) => {
		return 'Rp ' + amount.toLocaleString('id-ID');
	};

	let { data } = $props();
	const user = $derived(data.user);
	const sessionId = $derived(data.sessionId);
	const memberClient = $derived(createAuthenticatedClients(sessionId).memberClient);
	const planClient = $derived(createAuthenticatedClients(sessionId).planClient);
	const transactionClient = $derived(createAuthenticatedClients(sessionId).transactionClient);
	const offeringClient = $derived(createAuthenticatedClients(sessionId).offeringClient);

	let searchQuery = $state('');
	let selectedStatus = $state('All');

	let showModal = $state(false);
	let editingMember = $state<UserProfile | null>(null);
	let name = $state('');
	let email = $state('');
	let password = $state('');
	let isLoadingMember = $state(true);
	let isLoading = $state(false);

	let showPayModal = $state(false);
	let isPayProcessing = $state(false);
	let selectedMember = $state<UserProfile | null>(null);
	let availablePlans = $state<any[]>([]);
	let selectedPlanId = $state<number | null>(null);
	let paymentMethod = $state<'CASH' | 'QRIS'>('CASH'); // Default CASH

	async function openPayModal(member: UserProfile) {
		selectedMember = member;
		availablePlans = [];
		for await (const plan of planClient.getPlans({})) {
			availablePlans.push(plan);
		}
		showPayModal = true;
	}

	async function processPayment() {
		if (!selectedPlanId || !selectedMember) return;
		isPayProcessing = true;
		const swal = (window as any).Swal;

		try {
			const res = await transactionClient.createTransaction({
				memberId: selectedMember.id,
				planId: selectedPlanId,
				method: paymentMethod
			});

			if (paymentMethod === 'QRIS') {
				swal
					.fire({
						title: 'Pembayaran QRIS',
						html: `<p>Scan QR code diatas untuk membayar:</p>`,
						imageUrl: res.qrisUrl,
						imageWidth: 300,
						imageHeight: 300,
						showCancelButton: true,
						confirmButtonText: 'Saya sudah bayar',
						cancelButtonText: 'Batal'
					})
					.then((result: any) => {
						if (result.isConfirmed) {
							swal.fire(
								'Berhasil!',
								'Pembayaran akan diproses secara otomatis oleh sistem.',
								'success'
							);
							showPayModal = false;
							loadMembers();
						}
					});
			} else {
				swal.fire('Berhasil!', 'Pembayaran Cash dicatat, membership aktif.', 'success');
				showPayModal = false;
				loadMembers();
			}
		} catch (err: any) {
			swal.fire('Gagal!', err.message, 'error');
		} finally {
			isPayProcessing = false;
		}
	}

	let members = $state<UserProfile[]>([]);

	async function loadMembers() {
		members = [];
		try {
			for await (const member of memberClient.getMembers({})) {
				members.push(member);
			}
		} catch (err) {
			console.error('Stream error:', err);
		}
		isLoadingMember = false;
	}

	$effect(() => {
		loadMembers();
	});

	let filteredMembers = $derived(
		members.filter((m) => {
			const matchSearch =
				m.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
				m.email.toLowerCase().includes(searchQuery.toLowerCase());
			if (selectedStatus === 'Active') {
				return matchSearch && m.membership?.status === 'ACTIVE';
			} else if (selectedStatus === 'Expired') {
				return (
					matchSearch &&
					m.membership?.endDate &&
					new Date(timestampDate(m.membership.endDate)) < new Date()
				);
			} else if (selectedStatus === 'Pending') {
				return (
					matchSearch &&
					(!m.membership?.endDate || new Date(timestampDate(m.membership.endDate)) >= new Date()) &&
					m.membership?.status !== 'ACTIVE'
				);
			}
			return matchSearch;
		})
	);

	function openEditModal(member: UserProfile) {
		editingMember = member;
		name = member.name;
		email = member.email;
		showModal = true;
	}

	async function handleSubmitMember(e: SubmitEvent) {
		e.preventDefault();

		try {
			isLoading = true;
			if (editingMember) {
				await memberClient.updateMember({
					id: editingMember.id,
					name,
					email
				});
				await (window as any).Swal.fire('Berhasil!', 'Member berhasil diperbarui.', 'success');
			} else {
				await memberClient.registerMember({ name, email, password: '...' });
				await (window as any).Swal.fire('Berhasil!', 'Member berhasil ditambah.', 'success');
			}

			showModal = false;
			loadMembers();
		} catch (err: any) {
			await (window as any).Swal.fire('Error!', err.message, 'error');
		} finally {
			isLoading = false;
		}
	}

	async function handleDeleteMember(memberId: number) {
		const result = await await (window as any).Swal.fire({
			title: 'Hapus Member?',
			text: 'Data tidak bisa dikembalikan!',
			icon: 'warning',
			showCancelButton: true,
			confirmButtonText: 'Ya, Hapus!'
		});

		if (result.isConfirmed) {
			try {
				await memberClient.deleteMember({ memberId });
				await await (window as any).Swal.fire('Terhapus!', 'Member berhasil dihapus.', 'success');
				loadMembers();
			} catch (err: any) {
				await (window as any).Swal.fire('Error!', err.message, 'error');
			}
		}
	}

	let showOfferingModal = $state(false);
	let isOfferingProcessing = $state(false);
	let availableOfferings = $state<Offering[]>([]);
	let selectedOfferingId = $state<number | null>(null);

	async function openOfferingModal(member: UserProfile) {
		selectedMember = member;
		availableOfferings = [];
		try {
			for await (const item of offeringClient.getOfferings({})) {
				availableOfferings.push(item);
			}
			showOfferingModal = true;
		} catch (err) {
			console.error(err);
		}
	}

	async function processOfferingPayment() {
		if (!selectedOfferingId || !selectedMember) return;
		isOfferingProcessing = true;
		const swal = (window as any).Swal;

		try {
			const res = await transactionClient.createTransaction({
				memberId: selectedMember.id,
				offeringId: selectedOfferingId,
				method: paymentMethod
			});

			if (paymentMethod === 'QRIS') {
				swal
					.fire({
						title: 'Pembayaran QRIS',
						html: `<p>Scan QR code diatas untuk membayar:</p>`,
						imageUrl: res.qrisUrl,
						imageWidth: 300,
						imageHeight: 300,
						showCancelButton: true,
						confirmButtonText: 'Saya sudah bayar',
						cancelButtonText: 'Batal'
					})
					.then((result: any) => {
						if (result.isConfirmed) {
							swal.fire(
								'Berhasil!',
								'Pembayaran akan diproses secara otomatis oleh sistem.',
								'success'
							);
							showOfferingModal = false;
							loadMembers();
						}
					});
			} else {
				await swal.fire('Berhasil!', 'Pembelian produk/layanan berhasil dicatat.', 'success');
				showOfferingModal = false;
				loadMembers();
			}
		} catch (err: any) {
			swal.fire('Gagal!', err.message, 'error');
		} finally {
			isOfferingProcessing = false;
			paymentMethod = 'CASH';
		}
	}
</script>

<div class="space-y-6">
	<div class="flex flex-col justify-between gap-4 md:flex-row md:items-center">
		<div>
			<h2 class="text-2xl font-bold text-gray-900">Kelola Member</h2>
			<p class="text-sm text-gray-500">Daftar pelanggan {user?.tenantName}</p>
		</div>
		<button
			class="flex items-center gap-2 rounded-xl bg-blue-600 px-5 py-2.5 font-semibold text-white shadow-lg shadow-blue-600/20 transition-all hover:bg-blue-700"
			onclick={() => {
				showModal = true;
				editingMember = null;
				name = '';
				email = '';
				password = '';
			}}
		>
			<i class="fas fa-plus"></i>
			Tambah Member
		</button>
	</div>

	<div
		class="flex flex-col gap-4 rounded-2xl border border-gray-100 bg-white p-4 shadow-sm md:flex-row"
	>
		<div class="relative flex-1">
			<i class="fas fa-search absolute top-1/2 left-4 -translate-y-1/2 text-gray-400"></i>
			<input
				type="text"
				placeholder="Cari nama atau email..."
				bind:value={searchQuery}
				class="w-full rounded-xl border border-gray-200 bg-gray-50 py-2.5 pr-4 pl-11 transition-all outline-none focus:ring-2 focus:ring-blue-500"
			/>
		</div>
		<select
			bind:value={selectedStatus}
			class="rounded-xl border border-gray-200 bg-gray-50 px-4 py-2.5 transition-all outline-none focus:ring-2 focus:ring-blue-500"
		>
			<option value="All">Semua Status</option>
			<option value="Active">Active</option>
			<option value="Expired">Expired</option>
			<option value="Pending">Pending</option>
		</select>
	</div>

	<div class="overflow-hidden rounded-2xl border border-gray-100 bg-white shadow-sm">
		<div class="overflow-x-auto">
			<table class="w-full border-collapse text-left">
				<thead>
					<tr class="border-b border-gray-100 bg-gray-50">
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Member</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Status</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Tanggal Daftar</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Tanggal Mulai Membership</th
						>
						<th class="px-6 py-4 text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Tanggal Berakhir Membership</th
						>
						<th
							class="px-6 py-4 text-right text-xs font-bold tracking-wider text-gray-500 uppercase"
							>Aksi</th
						>
					</tr>
				</thead>
				<tbody class="divide-y divide-gray-50">
					{#each filteredMembers as member}
						<tr
							class={`group transition-colors hover:bg-blue-50/30 ${member.membership?.status === 'ACTIVE' ? 'bg-green-50/50' : ''}`}
						>
							<td class="px-6 py-4">
								<div class="flex items-center gap-3">
									<div
										class="flex h-10 w-10 items-center justify-center rounded-full bg-slate-100 font-bold text-slate-500"
									>
										{member.name.charAt(0)}
									</div>
									<div>
										<p class="font-bold text-gray-900">{member.name}</p>
										<p class="text-xs text-gray-500">{member.email}</p>
									</div>
								</div>
							</td>
							<td class="px-6 py-4 text-sm text-gray-500">
								{member.membership?.status === 'ACTIVE'
									? 'Aktif'
									: member.membership?.endDate &&
										  timestampDate(member.membership.endDate) < new Date()
										? 'Expired'
										: 'Pending'}
							</td>
							<td class="px-6 py-4 text-sm text-gray-500">
								{timestampDate(member.createdAt!).toLocaleDateString('id-ID', {
									day: '2-digit',
									month: 'short',
									year: 'numeric'
								})}
							</td>
							<td class="px-6 py-4 text-sm text-gray-500">
								{member.membership?.startDate
									? timestampDate(member.membership.startDate).toLocaleDateString('id-ID', {
											day: '2-digit',
											month: 'short',
											year: 'numeric'
										})
									: '-'}
							</td>
							<td class="px-6 py-4 text-sm text-gray-500">
								{member.membership?.endDate
									? timestampDate(member.membership.endDate).toLocaleDateString('id-ID', {
											day: '2-digit',
											month: 'short',
											year: 'numeric'
										})
									: '-'}
							</td>
							<td class="px-6 py-4 text-right">
								<div
									class="flex justify-end gap-2 opacity-0 transition-opacity group-hover:opacity-100"
								>
									<button
										class="rounded-lg border border-transparent p-2 text-orange-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
										title="Beli Produk / Jasa PT"
										onclick={() => openOfferingModal(member)}
									>
										<i class="fas fa-shopping-basket"></i>
									</button>
									{#if member.membership?.status !== 'ACTIVE'}
										<button
											class="rounded-lg border border-transparent p-2 text-green-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
											aria-label="Process Payment"
											onclick={() => openPayModal(member)}
										>
											<i class="fas fa-cash-register"></i>
										</button>
									{/if}
									<button
										class="rounded-lg border border-transparent p-2 text-blue-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
										aria-label="Edit Member"
										onclick={() => openEditModal(member)}
									>
										<i class="fas fa-edit"></i>
									</button>
									<button
										class="rounded-lg border border-transparent p-2 text-red-600 shadow-sm transition-all hover:border-gray-100 hover:bg-white"
										aria-label="Delete Member"
										onclick={() => handleDeleteMember(member.id)}
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

		{#if isLoadingMember}
			<div class="py-20 text-center">
				<i class="fas fa-spinner mb-3 animate-spin text-4xl text-gray-200"></i>
				<p class="text-gray-500">Memuat data member...</p>
			</div>
		{:else if filteredMembers.length === 0}
			<div class="py-20 text-center">
				<i class="fas fa-user-slash mb-3 text-4xl text-gray-200"></i>
				<p class="text-gray-500">Member tidak ditemukan.</p>
			</div>
		{/if}
	</div>
</div>

{#if showModal}
	<div class="fixed inset-0 z-50 flex items-center justify-center p-4">
		<div
			class="absolute inset-0 bg-slate-900/40 backdrop-blur-sm transition-opacity"
			aria-label="Close modal"
			aria-hidden="true"
			onclick={() => (showModal = false)}
		></div>

		<div
			class="z-10 w-full max-w-md scale-100 transform overflow-hidden rounded-2xl bg-white opacity-100 shadow-2xl transition-all"
		>
			<div
				class="flex items-center justify-between border-b border-gray-100 bg-gray-50/50 px-6 py-4"
			>
				<h3 class="text-lg font-bold text-gray-900">
					{editingMember ? 'Edit Member' : 'Tambah Member Baru'}
				</h3>
				<button
					onclick={() => (showModal = false)}
					class="text-gray-400 hover:text-gray-600"
					aria-label="Close modal"
					aria-hidden="true"
				>
					<i class="fas fa-times"></i>
				</button>
			</div>

			<form onsubmit={handleSubmitMember} class="space-y-4 p-6">
				<div>
					<label for="name" class="mb-1 block text-sm font-semibold text-gray-700"
						>Nama Lengkap</label
					>
					<input
						bind:value={name}
						type="text"
						placeholder="Contoh: John Doe"
						class="w-full rounded-xl border border-gray-200 px-4 py-2.5 transition-all outline-none focus:ring-2 focus:ring-blue-500"
						required
					/>
				</div>

				<div>
					<label for="email" class="mb-1 block text-sm font-semibold text-gray-700"> Email </label>
					<input
						bind:value={email}
						type="email"
						placeholder="john@example.com"
						class="w-full rounded-xl border border-gray-200 px-4 py-2.5 transition-all outline-none focus:ring-2 focus:ring-blue-500"
						required
					/>
				</div>

				<div>
					<label for="password" class="mb-1 block text-sm font-semibold text-gray-700">
						Password {editingMember ? '(Kosongkan jika tidak ingin mengubah)' : ''}
					</label>
					<input
						bind:value={password}
						type="password"
						placeholder="••••••••"
						class="w-full rounded-xl border border-gray-200 px-4 py-2.5 transition-all outline-none focus:ring-2 focus:ring-blue-500"
						required={!editingMember}
					/>
				</div>

				<div class="flex gap-3 pt-4">
					<button
						type="button"
						onclick={() => (showModal = false)}
						class="flex-1 rounded-xl border border-gray-200 px-4 py-2.5 font-semibold text-gray-600 transition-all hover:bg-gray-50"
					>
						Batal
					</button>
					<button
						type="submit"
						disabled={isLoading}
						class="flex-1 rounded-xl bg-blue-600 px-4 py-2.5 font-semibold text-white shadow-md shadow-blue-600/20 transition-all hover:bg-blue-700 disabled:opacity-50"
					>
						{isLoading ? 'Menyimpan...' : 'Simpan Member'}
					</button>
				</div>
			</form>
		</div>
	</div>
{/if}

{#if showPayModal}
	<div class="fixed inset-0 z-60 flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm">
		<div class="w-full max-w-md overflow-hidden rounded-3xl bg-white shadow-2xl">
			<div class="border-b p-6">
				<h3 class="text-xl font-bold">Pilih Paket Membership</h3>
				<p class="text-sm text-gray-500">Member: {selectedMember?.name}</p>
			</div>

			<div class="space-y-4 p-6">
				<div class="space-y-2">
					{#each availablePlans as plan}
						<label
							class="flex cursor-pointer items-center rounded-2xl border p-4 transition-all hover:bg-gray-50 {selectedPlanId ===
							plan.id
								? 'border-blue-600 bg-blue-50'
								: ''}"
						>
							<input type="radio" bind:group={selectedPlanId} value={plan.id} class="hidden" />
							<div class="flex-1">
								<p class="font-bold">{plan.name}</p>
								<p class="text-xs text-gray-500">{plan.duration} Hari</p>
							</div>
							<p class="font-bold text-blue-600">Rp {Number(plan.price).toLocaleString()}</p>
						</label>
					{/each}
				</div>

				<div class="grid grid-cols-2 gap-3">
					<button
						onclick={() => (paymentMethod = 'CASH')}
						class="rounded-xl border-2 py-3 font-bold transition-all {paymentMethod === 'CASH'
							? 'border-blue-600 text-blue-600'
							: 'text-gray-400'}"
					>
						CASH
					</button>
					<button
						onclick={() => (paymentMethod = 'QRIS')}
						class="rounded-xl border-2 py-3 font-bold transition-all {paymentMethod === 'QRIS'
							? 'border-blue-600 text-blue-600'
							: 'text-gray-400'}"
					>
						QRIS / ONLINE
					</button>
				</div>

				<button
					onclick={processPayment}
					disabled={!selectedPlanId || isPayProcessing}
					class="w-full cursor-pointer rounded-2xl bg-blue-600 py-4 font-bold text-white shadow-lg shadow-blue-600/30 disabled:opacity-50"
				>
					{isPayProcessing ? 'Memproses...' : 'Bayar Sekarang'}
				</button>
				<button
					onclick={() => (showPayModal = false)}
					class="w-full text-sm font-bold text-gray-400">Batal</button
				>
			</div>
		</div>
	</div>
{/if}

{#if showOfferingModal}
	<div class="fixed inset-0 z-60 flex items-center justify-center bg-black/50 p-4 backdrop-blur-sm">
		<div class="w-full max-w-md overflow-hidden rounded-3xl bg-white shadow-2xl">
			<div class="border-b bg-orange-50 p-6">
				<h3 class="text-xl font-bold text-orange-900">Beli Produk / Jasa</h3>
				<p class="text-sm text-orange-700">Member: {selectedMember?.name}</p>
			</div>

			<div class="max-h-[60vh] space-y-3 overflow-y-auto p-6">
				{#each availableOfferings as item}
					<label
						class="flex cursor-pointer items-center rounded-2xl border p-4 transition-all hover:bg-gray-50 {selectedOfferingId ===
						item.id
							? 'border-orange-600 bg-orange-50'
							: ''}"
					>
						<input type="radio" bind:group={selectedOfferingId} value={item.id} class="hidden" />
						<div class="flex-1">
							<div class="flex items-center gap-2">
								<p class="font-bold">{item.name}</p>
								<span
									class="rounded border bg-white px-2 py-0.5 text-[10px] font-bold text-gray-400 uppercase"
								>
									{item.type === 'PRODUCT'
										? 'Produk'
										: item.type === 'MEMBERSHIP'
											? 'MEMBERSHIP'
											: 'PT'}
								</span>
							</div>
							<p class="text-xs text-gray-500">
								{item.type === 'PRODUCT'
									? `Stok: ${item.stock}`
									: item.type === 'MEMBERSHIP'
										? `${item.duration} Hari`
										: `${item.quota} Sesi`}
							</p>
						</div>
						<p class="font-bold text-orange-600">{formatIDR(Number(item.price))}</p>
					</label>
				{/each}

				{#if availableOfferings.length === 0}
					<p class="py-10 text-center text-gray-400">Tidak ada produk/layanan tersedia.</p>
				{/if}
			</div>

			<div class="space-y-3 p-6 pt-0">
				<div class="grid grid-cols-2 gap-3">
					<button
						onclick={() => (paymentMethod = 'CASH')}
						class="rounded-xl border-2 py-3 font-bold transition-all {paymentMethod === 'CASH'
							? 'border-blue-600 text-blue-600'
							: 'text-gray-400'}"
					>
						CASH
					</button>
					<button
						onclick={() => (paymentMethod = 'QRIS')}
						class="rounded-xl border-2 py-3 font-bold transition-all {paymentMethod === 'QRIS'
							? 'border-blue-600 text-blue-600'
							: 'text-gray-400'}"
					>
						QRIS / ONLINE
					</button>
				</div>
				<button
					onclick={processOfferingPayment}
					disabled={!selectedOfferingId || isOfferingProcessing}
					class="w-full cursor-pointer rounded-2xl bg-orange-600 py-4 font-bold text-white shadow-lg shadow-orange-600/30 disabled:opacity-50"
				>
					{isOfferingProcessing ? 'Memproses...' : 'Konfirmasi Pembelian'}
				</button>
				<button
					onclick={() => (showOfferingModal = false)}
					class="w-full text-sm font-bold text-gray-400">Batal</button
				>
			</div>
		</div>
	</div>
{/if}
