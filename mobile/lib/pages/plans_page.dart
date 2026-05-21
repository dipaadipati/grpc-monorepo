import 'package:flutter/material.dart';
import 'package:fixnum/fixnum.dart'; // 🚀 Wajib untuk menghandel biner Int64 harga paket
import '../grpc_service.dart';
import '../services/plan_service.dart';
import '../gen/app.pbgrpc.dart';

class PlansPage extends StatefulWidget {
  final UserProfile profile;
  const PlansPage({super.key, required this.profile});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final _planService = PlanDataService();

  // State Pengelola Data
  List<Plan> _allPlans = [];
  List<Plan> _filteredPlans = [];
  bool _isLoadingData = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadPlansData();
  }

  // 📥 Fungsi Ambil Paket Gym dari Database VPS
  Future<void> _loadPlansData() async {
    setState(() => _isLoadingData = true);
    try {
      final data = await _planService.fetchPlans();
      setState(() {
        _allPlans = data;
        _applySearchFilter();
      });
    } catch (e) {
      debugPrint('Error load plans: $e');
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  // 🔍 Fungsi Filter Pencarian (Sama dengan algoritma $derived Svelte kamu)
  void _applySearchFilter() {
    setState(() {
      _filteredPlans = _allPlans
          .where(
            (plan) =>
                plan.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    });
  }

  // 💵 Helper Formatter Uang Rupiah Manual di Flutter
  String _formatIDR(int amount) {
    return "Rp ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // ==========================================
  // 🎭 MODAL DIALOG FORM (CREATE / UPDATE PAKET)
  // ==========================================
  void _showPlanFormModal({Plan? editingPlan}) {
    final nameCtrl = TextEditingController(text: editingPlan?.name ?? '');
    final priceCtrl = TextEditingController(
      text: editingPlan != null ? editingPlan.price.toString() : '0',
    );
    final durationCtrl = TextEditingController(
      text: editingPlan != null ? editingPlan.duration.toString() : '30',
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
            editingPlan != null ? 'Update Paket' : 'Buat Paket Baru',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Paket',
                    hintText: 'Contoh: Member Bulanan Pro',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
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
                    Expanded(
                      child: TextField(
                        controller: durationCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Durasi (Hari)',
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
                        final parsedDuration =
                            int.tryParse(durationCtrl.text) ?? 30;

                        if (editingPlan != null) {
                          // 🚀 UPDATE PLAN EXECUTION
                          await GrpcService().planClient.updatePlan(
                            UpdatePlanRequest()
                              ..id = editingPlan.id
                              ..name = nameCtrl.text.trim()
                              ..price = Int64(parsedPrice)
                              ..duration = parsedDuration,
                          );
                        } else {
                          // 🚀 ADD NEW PLAN EXECUTION
                          await _planService.addNewPlan(
                            nameCtrl.text.trim(),
                            parsedPrice,
                            parsedDuration,
                            widget.profile.tenantId,
                          );
                        }

                        Navigator.pop(ctx);
                        _loadPlansData(); // Refresh list data setelah mutasi sukses
                      } catch (e) {
                        debugPrint('Gagal menyimpan paket: $e');
                      } finally {
                        setModalState(() => isSubmitting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF059669,
                ), // Emerald-600 Tailwind
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
                      'Simpan Paket',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 🌲 INTERFACE CANVAS UI UTAMA
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Paket Membership',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadPlansData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showPlanFormModal(),
        backgroundColor: const Color(0xFF059669), // Hijau Emerald Khas GMS
        foregroundColor: Colors.white,
        icon: const Icon(Icons.local_offer),
        label: const Text(
          'Buat Paket Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // 🔍 INPUT BAR PENCARIAN PAKET
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                hintText: 'Cari nama paket...',
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

          // 🎰 AREA LIST VIEW DAFTAR HARGA MEMBERSHIP
          Expanded(
            child: _isLoadingData
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF059669)),
                  )
                : _filteredPlans.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.label_off_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Belum ada paket membership.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredPlans.length,
                    itemBuilder: (context, index) {
                      final plan = _filteredPlans[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        color: const Color(
                          0xFFF0FDF4,
                        ), // Emerald-50 light highlight
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ExpansionTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFD1FAE5),
                            child: Icon(
                              Icons.star_rounded,
                              color: Color(0xFF059669),
                            ),
                          ),
                          title: Text(
                            plan.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            _formatIDR(plan.price.toInt()),
                            style: const TextStyle(
                              color: Color(0xFF059669),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 14,
                                  color: Colors.blue[700],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${plan.duration} Hari',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
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
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_note_rounded,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        _showPlanFormModal(editingPlan: plan),
                                    tooltip: 'Edit Paket',
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                    onPressed: () async {
                                      await _planService.deletePlan(plan.id);
                                      _loadPlansData(); // Reload setelah dihapus
                                    },
                                    tooltip: 'Hapus Paket',
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
