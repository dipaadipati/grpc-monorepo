import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../gen/app.pbgrpc.dart';

class FinancePage extends StatefulWidget {
  final UserProfile profile;
  const FinancePage({super.key, required this.profile});

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  final _transactionService = TransactionDataService();

  // State Pengelola Data Keuangan
  FinanceSummary? _summary;
  List<Transaction> _allTransactions = [];
  List<Transaction> _filteredTransactions = [];

  bool _isLoading = true;
  String _searchQuery = '';
  String _filterMethod = 'All';
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadFinanceData();
  }

  // 📥 Fungsi Memuat Data Gabungan (Summary + List Transaksi)
  Future<void> _loadFinanceData() async {
    setState(() => _isLoading = true);
    try {
      // Menjalankan request secara bersamaan seperti Promise.all di Svelte kamu
      final results = await Future.wait([
        _transactionService.fetchFinanceSummary(),
        _transactionService.fetchTransactions(),
      ]);

      setState(() {
        _summary = results[0] as FinanceSummary;
        _allTransactions = results[1] as List<Transaction>;
        _applyFilters();
      });
    } catch (e) {
      debugPrint('Gagal memuat data keuangan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // 🔍 Logika Filter Berantai Persis Nilai $derived Svelte Kamu
  void _applyFilters() {
    setState(() {
      _filteredTransactions = _allTransactions.where((trx) {
        final matchesSearch =
            trx.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (trx.hasMemberName() &&
                trx.memberName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                )) ||
            (trx.hasPlanName() &&
                trx.planName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                )) ||
            (trx.hasOfferingName() &&
                trx.offeringName.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ));

        final matchesMethod =
            _filterMethod == 'All' || trx.method == _filterMethod;
        final matchesStatus =
            _filterStatus == 'All' || trx.status == _filterStatus;

        return matchesSearch && matchesMethod && matchesStatus;
      }).toList();
    });
  }

  // 💵 Helper Formatter Rupiah Indonesia
  String _formatIDR(dynamic amount) {
    final value = amount.toString();
    return "Rp ${value.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // 📆 Format Tanggal Protobuf Helper
  String _formatProtoTimestamp(dynamic timestamp) {
    if (timestamp == null) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds.toInt() * 1000,
    );
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
  }

  // 🎨 Helper Badge Status Warna Transaksi
  Map<String, dynamic> _getStatusStyle(String status) {
    if (status == 'SETTLEMENT') {
      return {
        'label': 'LUNAS',
        'bg': const Color(0xFFD1FAE5),
        'text': const Color(0xFF065F46),
      };
    } else if (status == 'PENDING') {
      return {
        'label': 'PENDING',
        'bg': const Color(0xFFFFEDD5),
        'text': const Color(0xFF9A3412),
      };
    } else {
      return {
        'label': status,
        'bg': const Color(0xFFFEE2E2),
        'text': const Color(0xFF991B1B),
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard Keuangan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: _isLoading ? Colors.blue : Colors.grey,
            ),
            onPressed: _isLoading ? null : _loadFinanceData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF059669)),
            )
          : RefreshIndicator(
              onRefresh: _loadFinanceData,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Text(
                    'Laporan pendapatan cabang ${widget.profile.tenantName}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ==========================================
                  // 📊 1. CARDS SUMMARY GRID (Total Revenue, Transaksi, Member)
                  // ==========================================
                  Card(
                    color: const Color(0xFF10B981), // Emerald 500
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'TOTAL PENDAPATAN',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white24,
                                size: 28,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatIDR(_summary?.totalRevenue ?? 0),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xE5E7EB)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'TRANSAKSI SUKSES',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_summary?.totalTransactions ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.check_circle_outline_rounded,
                                      color: Colors.blue,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Settlement',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: Color(0xE5E7EB)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MEMBER AKTIF',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_summary?.activeMemberships ?? 0}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: const [
                                    Icon(
                                      Icons.card_membership_rounded,
                                      color: Colors.orange,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Berlangganan',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // 🔍 2. BAR FILTER INPUT & DROPDOWNS
                  // ==========================================
                  Card(
                    elevation: 0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),
                              hintText: 'Cari Order ID, Nama Member...',
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              _searchQuery = val;
                              _applyFilters();
                            },
                          ),
                          const Divider(height: 1),
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _filterMethod,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'All',
                                        child: Text(
                                          'Semua Metode',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'CASH',
                                        child: Text(
                                          'Cash',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'QRIS',
                                        child: Text(
                                          'QRIS / Online',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _filterMethod = val);
                                        _applyFilters();
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 24,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _filterStatus,
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'All',
                                        child: Text(
                                          'Semua Status',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'SETTLEMENT',
                                        child: Text(
                                          'Lunas',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'PENDING',
                                        child: Text(
                                          'Pending',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() => _filterStatus = val);
                                        _applyFilters();
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ==========================================
                  // 🎰 3. LIST HISTORI TRANSAKSI
                  // ==========================================
                  const Text(
                    'RIWAYAT TRANSAKSI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  _filteredTransactions.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.0),
                          child: Center(
                            child: Text(
                              'Data transaksi tidak ditemukan.',
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final trx = _filteredTransactions[index];
                            final style = _getStatusStyle(trx.status);

                            // Logika penamaan produk/paket sesuai kodingan Svelte kamu
                            final productName =
                                trx.hasPlanId() && trx.planId != 0
                                ? trx.planName
                                : trx.offeringName;
                            final productColor =
                                trx.hasPlanId() && trx.planId != 0
                                ? Colors.purple
                                : Colors.blueGrey;

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                side: const BorderSide(
                                  color: Color(0xFFF3F4F6),
                                ),
                              ),
                              child: ExpansionTile(
                                leading: CircleAvatar(
                                  backgroundColor: (style['bg'] as Color),
                                  child: Icon(
                                    Icons.receipt_long_rounded,
                                    color: (style['text'] as Color),
                                  ),
                                ),
                                title: Text(
                                  trx.hasMemberName()
                                      ? trx.memberName
                                      : 'No Name',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  _formatProtoTimestamp(trx.createdAt),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _formatIDR(trx.amount),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (style['bg'] as Color),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        style['label'],
                                        style: TextStyle(
                                          color: (style['text'] as Color),
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Order ID:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              '#${trx.id}',
                                              style: const TextStyle(
                                                fontFamily: 'monospace',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Item/Paket:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Text(
                                              productName,
                                              style: TextStyle(
                                                color: productColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Metode Pembayaran:',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                trx.method,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (trx.status == 'PENDING' &&
                                            trx.qrisUrl.isNotEmpty) ...[
                                          const Divider(height: 24),
                                          Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () => _showQrisPopup(
                                                context,
                                                trx.qrisUrl,
                                              ),
                                              icon: const Icon(Icons.qr_code_2),
                                              label: const Text(
                                                'Tampilkan QRIS Pembayaran',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }

  // Helper untuk membuka modal QRIS jika ada transaksi Midtrans pending
  void _showQrisPopup(BuildContext ctx, String url) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text(
          'Scan QRIS',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Image.network(
          url,
          width: 240,
          height: 240,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.qr_code_rounded, size: 150),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}
