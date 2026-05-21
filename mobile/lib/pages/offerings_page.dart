import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart'; // Pengendali tipe data harga Int64 biner Protobuf
import '../grpc_service.dart';
import '../services/offering_service.dart';
import '../gen/app.pbgrpc.dart';

class OfferingsPage extends StatefulWidget {
  final UserProfile profile;
  const OfferingsPage({super.key, required this.profile});

  @override
  State<OfferingsPage> createState() => _OfferingsPageState();
}

class _OfferingsPageState extends State<OfferingsPage> {
  final _offeringService = OfferingDataService();

  // State Pengelola Data
  List<Offering> _allOfferings = [];
  List<Offering> _filteredOfferings = [];
  bool _isLoadingData = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadOfferingsData();
  }

  // 📥 Memuat List Data Offering dari Database gRPC VPS
  Future<void> _loadOfferingsData() async {
    setState(() => _isLoadingData = true);
    try {
      final data = await _offeringService.fetchOfferings();
      setState(() {
        _allOfferings = data;
        _applySearchFilter();
      });
    } catch (e) {
      debugPrint('Error load offerings: $e');
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  // 🔍 Filter Pencarian Reaktif
  void _applySearchFilter() {
    setState(() {
      _filteredOfferings = _allOfferings
          .where(
            (item) =>
                item.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    });
  }

  // 💵 Helper Formatter Rupiah Indonesia
  String _formatIDR(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // 🏷️ Pemetaan Label Warna Tipe Persis Seperti Logika getTypeLabel Svelte Kamu
  Map<String, dynamic> _getTypeLabelData(String type) {
    switch (type) {
      case 'MEMBERSHIP':
        return {'label': 'Membership', 'color': Colors.blue};
      case 'PRODUCT':
        return {'label': 'Produk', 'color': Colors.orange};
      case 'SERVICE':
        return {'label': 'Layanan PT', 'color': Colors.purple};
      default:
        return {'label': 'Unknown', 'color': Colors.grey};
    }
  }

  // ==========================================
  // 🎭 MODAL DIALOG REAKTIF FORM OFFERING
  // ==========================================
  void _showOfferingFormModal({Offering? editingOffering}) {
    final nameCtrl = TextEditingController(text: editingOffering?.name ?? '');
    final priceCtrl = TextEditingController(
      text: editingOffering != null ? editingOffering.price.toString() : '0',
    );

    // Default form states
    String selectedType = editingOffering?.type ?? 'MEMBERSHIP';
    final durationCtrl = TextEditingController(
      text: editingOffering != null
          ? editingOffering.duration.toString()
          : '30',
    );
    final stockCtrl = TextEditingController(
      text: editingOffering != null ? editingOffering.stock.toString() : '0',
    );
    final quotaCtrl = TextEditingController(
      text: editingOffering != null ? editingOffering.quota.toString() : '0',
    );

    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            editingOffering != null ? 'Edit Item' : 'Tambah Item Baru',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown Tipe Penawaran
                const Text(
                  'TIPE PENAWARAN',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'MEMBERSHIP',
                      child: Text('Membership (Durasi)'),
                    ),
                    DropdownMenuItem(
                      value: 'PRODUCT',
                      child: Text('Produk Fisik (Stok)'),
                    ),
                    DropdownMenuItem(
                      value: 'SERVICE',
                      child: Text('Layanan PT (Kuota Sesi)'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => selectedType = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Input Nama Item
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Item',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Form Grid Dinamis Mengikuti State Tipe Yang Dipilih
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Harga (IDR)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Input Kondisional Persis Blok {#if} Milik Svelte Kamu
                    if (selectedType == 'MEMBERSHIP')
                      Expanded(
                        child: TextField(
                          controller: durationCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Durasi (Hari)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    else if (selectedType == 'PRODUCT')
                      Expanded(
                        child: TextField(
                          controller: stockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stok Awal',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    else if (selectedType == 'SERVICE')
                      Expanded(
                        child: TextField(
                          controller: quotaCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Kuota Sesi',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isSubmitting
                  ? null
                  : () async {
                      if (nameCtrl.text.trim().isEmpty) return;
                      setModalState(() => isSubmitting = true);

                      try {
                        final parsedPrice = int.tryParse(priceCtrl.text) ?? 0;

                        // Siapkan payload dengan validasi tipe data kosong/null aman
                        final reqName = nameCtrl.text.trim();
                        final reqPrice = Int64(parsedPrice);
                        final reqDuration = selectedType == 'MEMBERSHIP'
                            ? (int.tryParse(durationCtrl.text) ?? 0)
                            : 0;
                        final reqStock = selectedType == 'PRODUCT'
                            ? (int.tryParse(stockCtrl.text) ?? 0)
                            : 0;
                        final reqQuota = selectedType == 'SERVICE'
                            ? (int.tryParse(quotaCtrl.text) ?? 0)
                            : 0;

                        if (editingOffering != null) {
                          // EXECUTE UPDATE VIA CLIENT DIRECTLY
                          await GrpcService().offeringClient.updateOffering(
                            UpdateOfferingRequest()
                              ..id = editingOffering.id
                              ..name = reqName
                              ..price = reqPrice
                              ..type = selectedType
                              ..duration = reqDuration
                              ..stock = reqStock
                              ..quota = reqQuota,
                          );
                        } else {
                          // EXECUTE ADD VIA CLIENT DIRECTLY
                          await GrpcService().offeringClient.addOffering(
                            AddOfferingRequest()
                              ..name = reqName
                              ..price = reqPrice
                              ..type = selectedType
                              ..duration = reqDuration
                              ..stock = reqStock
                              ..quota = reqQuota
                              ..tenantId = widget.profile.tenantId,
                          );
                        }

                        Navigator.pop(ctx);
                        _loadOfferingsData(); // Refresh data utama setelah sukses menyimpan
                      } catch (e) {
                        debugPrint('Gagal memproses penawaran: $e');
                      } finally {
                        setModalState(() => isSubmitting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF4F46E5,
                ), // Indigo-600 Khas Tema Penawaran Kamu
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Simpan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🌲 CANVAS UI UTAMA SCREEN
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Penawaran (Offerings)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadOfferingsData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showOfferingFormModal(),
        backgroundColor: const Color(0xFF4F46E5), // Tema Indigo
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_circle_outline_rounded),
        label: const Text(
          'Tambah Item',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 🔍 INPUT FILTER PENCARIAN PENAWARAN ITEM
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Cari penawaran...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              onChanged: (val) {
                _searchQuery = val;
                _applySearchFilter();
              },
            ),
          ),

          // 🎰 AREA LIST VIEW MASTER DATA ITEM OFFERING
          Expanded(
            child: _isLoadingData
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  )
                : _filteredOfferings.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada item produk/layanan tambahan.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredOfferings.length,
                    itemBuilder: (context, index) {
                      final item = _filteredOfferings[index];
                      final labelData = _getTypeLabelData(item.type);
                      final labelColor = labelData['color'] as Color;

                      // Ekstraksi teks spesifikasi detail baris item
                      String detailText = '';
                      if (item.type == 'MEMBERSHIP') {
                        detailText = '${item.duration} Hari';
                      } else if (item.type == 'PRODUCT') {
                        detailText = 'Stok: ${item.stock}';
                      } else if (item.type == 'SERVICE') {
                        detailText = '${item.quota} Sesi PT';
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: Colors.grey[200] ?? Colors.black12,
                          ),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: labelColor.withOpacity(0.1),
                            child: Icon(
                              item.type == 'PRODUCT'
                                  ? Icons.shopping_bag_rounded
                                  : item.type == 'SERVICE'
                                  ? Icons.psychology_rounded
                                  : Icons.badge_rounded,
                              color: labelColor,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: labelColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  labelData['label'],
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                detailText,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Text(
                            _formatIDR(item.price.toInt()),
                            style: const TextStyle(
                              color: Color(0xFF4F46E5),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 16.0,
                                bottom: 12.0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // ✏️ Tombol Edit (Sudah Ada)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: Color(0xFF4F46E5),
                                    ),
                                    onPressed: () => _showOfferingFormModal(
                                      editingOffering: item,
                                    ),
                                    tooltip: 'Edit Item',
                                  ),
                                  const SizedBox(width: 8),
                                  // 🗑️ Tambah Tombol Delete Baru
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Hapus Item',
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text(
                                            'Hapus Item?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            'Apakah Anda yakin ingin menghapus "${item.name}" dari daftar penawaran?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                              child: const Text(
                                                'Batal',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                setState(
                                                  () => _isLoadingData = true,
                                                );
                                                try {
                                                  await _offeringService
                                                      .deleteOffering(item.id);
                                                  _loadOfferingsData();
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Item berhasil dihapus.',
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  setState(
                                                    () =>
                                                        _isLoadingData = false,
                                                  );
                                                  debugPrint(
                                                    'Gagal menghapus item: $e',
                                                  );
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Gagal menghapus: $e',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text(
                                                'Ya, Hapus',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                ),
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
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
