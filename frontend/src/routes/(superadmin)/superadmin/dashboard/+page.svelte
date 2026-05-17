<script lang="ts">
	const stats = [
		{
			name: 'Total Member',
			value: '1,284',
			trend: '+12%',
			icon: 'fa-users',
			color: 'text-blue-600',
			bg: 'bg-blue-100'
		},
		{
			name: 'Pendapatan Bulan Ini',
			value: 'Rp 42.5M',
			trend: '+8.2%',
			icon: 'fa-money-bill-wave',
			color: 'text-emerald-600',
			bg: 'bg-emerald-100'
		},
		{
			name: 'Check-in Hari Ini',
			value: '156',
			trend: '-2%',
			icon: 'fa-user-check',
			color: 'text-amber-600',
			bg: 'bg-amber-100'
		},
		{
			name: 'Member Baru',
			value: '24',
			trend: '+18%',
			icon: 'fa-user-plus',
			color: 'text-purple-600',
			bg: 'bg-purple-100'
		}
	];

	const recentActivities = [
		{
			id: 1,
			user: 'Budi Santoso',
			action: 'Mendaftar Member Baru',
			time: '2 menit yang lalu',
			status: 'Success'
		},
		{
			id: 2,
			user: 'Siti Aminah',
			action: 'Perpanjangan Paket Platinum',
			time: '15 menit yang lalu',
			status: 'Success'
		},
		{
			id: 3,
			user: 'Rian Perdana',
			action: 'Check-in via QR',
			time: '1 jam yang lalu',
			status: 'Success'
		},
		{
			id: 4,
			user: 'Agus Setiawan',
			action: 'Gagal Pembayaran',
			time: '3 jam yang lalu',
			status: 'Failed'
		}
	];
</script>

<div class="space-y-8">
	<div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-4">
		{#each stats as stat}
			<div
				class="rounded-2xl border border-gray-100 bg-white p-6 shadow-sm transition-shadow hover:shadow-md"
			>
				<div class="flex items-center justify-between">
					<div class="rounded-xl p-3 {stat.bg} {stat.color}">
						<i class="fas {stat.icon} text-xl"></i>
					</div>
					<span
						class="rounded-full px-2 py-1 text-xs font-bold {stat.trend.startsWith('+')
							? 'bg-emerald-50 text-emerald-600'
							: 'bg-red-50 text-red-600'}"
					>
						{stat.trend}
					</span>
				</div>
				<div class="mt-4">
					<p class="text-sm font-medium text-gray-500">{stat.name}</p>
					<h3 class="mt-1 text-2xl font-bold text-gray-900">{stat.value}</h3>
				</div>
			</div>
		{/each}
	</div>

	<div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
		<div class="rounded-2xl border border-gray-100 bg-white p-8 shadow-sm lg:col-span-2">
			<div class="mb-8 flex items-center justify-between">
				<div>
					<h3 class="text-lg font-bold text-gray-900">Grafik Kunjungan</h3>
					<p class="text-sm text-gray-500">7 Hari terakhir di HQ Jakarta</p>
				</div>
				<select class="rounded-lg border border-gray-200 bg-gray-50 p-2 text-sm outline-none">
					<option>Minggu Ini</option>
					<option>Bulan Ini</option>
				</select>
			</div>

			<div
				class="flex h-64 w-full items-center justify-center rounded-xl border-2 border-dashed border-gray-200 bg-slate-50"
			>
				<div class="text-center">
					<i class="fas fa-chart-line mb-2 text-4xl text-gray-300"></i>
					<p class="text-sm text-gray-400">Visualisasi Data akan muncul di sini</p>
				</div>
			</div>
		</div>

		<div class="rounded-2xl border border-gray-100 bg-white p-8 shadow-sm">
			<h3 class="mb-6 text-lg font-bold text-gray-900">Aktivitas Terbaru</h3>
			<div class="flow-root">
				<ul class="-mb-8">
					{#each recentActivities as activity, i}
						<li>
							<div class="relative pb-8">
								{#if i !== recentActivities.length - 1}
									<span
										class="absolute top-4 left-4 -ml-px h-full w-0.5 bg-gray-200"
										aria-hidden="true"
									></span>
								{/if}
								<div class="relative flex space-x-3">
									<div>
										<span
											class="h-8 w-8 rounded-full {activity.status === 'Success'
												? 'bg-emerald-500'
												: 'bg-red-500'} flex items-center justify-center ring-8 ring-white"
										>
											<i
												class="fas {activity.status === 'Success'
													? 'fa-check'
													: 'fa-times'} text-xs text-white"
											></i>
										</span>
									</div>
									<div class="flex min-w-0 flex-1 justify-between space-x-4 pt-1.5">
										<div>
											<p class="text-sm text-gray-500">
												<span class="font-bold text-gray-900">{activity.user}</span>
												{activity.action}
											</p>
										</div>
										<div class="text-right text-xs whitespace-nowrap text-gray-400">
											<time>{activity.time}</time>
										</div>
									</div>
								</div>
							</div>
						</li>
					{/each}
				</ul>
			</div>
		</div>
	</div>
</div>
