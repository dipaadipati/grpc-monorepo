import 'package:flutter/material.dart';
import '../grpc_service.dart';
import '../services/member_service.dart';
import '../services/plan_service.dart';
import '../services/offering_service.dart';
import '../services/transaction_service.dart';
import '../gen/app.pbgrpc.dart';

class MembersPage extends StatefulWidget {
  final UserProfile profile;
  const MembersPage({super.key, required this.profile});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  // Instance Services Layer
  final _memberService = MemberDataService();
  final _planService = PlanDataService();
  final _offeringService = OfferingDataService();
  final _transactionService = TransactionDataService();

  // State Kontrol Data
  List<UserProfile> _allMembers = [];
  List<UserProfile> _filteredMembers = [];
  bool _isLoadingMembers = true;

  // State Filter & Pencarian
  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadMembersData();
  }

  // 📥 Fungsi Memuat Data Member (Unary Array murni)
  Future<void> _loadMembersData() async {
    setState(() => _isLoadingMembers = true);
    try {
      final data = await _memberService.fetchAllMembers();
      setState(() {
        _allMembers = data;
        _applyFilters();
      });
    } catch (e) {
      debugPrint('Error load members: $e');
    } finally {
      setState(() => _isLoadingMembers = false);
    }
  }

  // 🔍 Logika Filter Persis Seperti Algoritma $derived Svelte Kamu
  void _applyFilters() {
    final now = DateTime.now();
    setState(() {
      _filteredMembers = _allMembers.where((member) {
        final matchSearch =
            member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            member.email.toLowerCase().contains(_searchQuery.toLowerCase());

        final hasMembership = member.hasMembership();
        final status = hasMembership ? member.membership.status : '';

        DateTime? endDate;
        if (hasMembership && member.membership.hasEndDate()) {
          endDate = DateTime.fromMillisecondsSinceEpoch(
            member.membership.endDate.seconds.toInt() * 1000,
          );
        }

        if (_selectedStatus == 'Active') {
          return matchSearch && status == 'ACTIVE';
        } else if (_selectedStatus == 'Expired') {
          return matchSearch && endDate != null && endDate.isBefore(now);
        } else if (_selectedStatus == 'Pending') {
          final isNotActive = status != 'ACTIVE';
          final isNotExpired =
              endDate == null ||
              endDate.isAfter(now) ||
              endDate.isAtSameMomentAs(now);
          return matchSearch && isNotActive && isNotExpired;
        }

        return matchSearch;
      }).toList();
    });
  }

  // 📝 Format Tanggal Helper
  String _formatProtoTimestamp(dynamic timestamp) {
    if (timestamp == null) return '-';
    final date = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds.toInt() * 1000,
    );
    return "${date.day.toString().padLeft(2, '0')} ${['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'][date.month - 1]} ${date.year}";
  }

  // ==========================================
  // 🎭 MODAL DIALOGS (TAMBAH, EDIT, BAYAR PAKET, BUY OFFERING)
  // ==========================================

  // 1. Modal Dialog Form Member (Tambah / Edit)
  void _showMemberFormModal({UserProfile? editingMember}) {
    final nameCtrl = TextEditingController(text: editingMember?.name ?? '');
    final emailCtrl = TextEditingController(text: editingMember?.email ?? '');
    final passwordCtrl = TextEditingController();
    bool isSaving = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            editingMember != null ? 'Edit Member' : 'Tambah Member Baru',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Lengkap',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: editingMember != null
                        ? 'Password (Kosongkan jika tak diubah)'
                        : 'Password',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: isSaving
                  ? null
                  : () async {
                      setModalState(() => isSaving = true);
                      try {
                        if (editingMember != null) {
                          await GrpcService().memberClient.updateMember(
                            UpdateMemberRequest()
                              ..id = editingMember.id
                              ..name = nameCtrl.text
                              ..email = emailCtrl.text
                              ..password = passwordCtrl.text,
                          );
                        } else {
                          await _memberService.registerNewMember(
                            nameCtrl.text,
                            emailCtrl.text,
                            passwordCtrl.text.isEmpty
                                ? '...'
                                : passwordCtrl.text,
                          );
                        }
                        Navigator.pop(ctx);
                        _loadMembersData();
                      } catch (e) {
                        debugPrint('$e');
                      } finally {
                        setModalState(() => isSaving = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Modal Pembayaran Paket Membership
  void _showPayModal(UserProfile member) async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    List<Plan> plans = [];
    try {
      plans = await _planService.fetchPlans();
    } catch (e) {
      debugPrint('$e');
    }
    if (!mounted) return;
    Navigator.pop(context); // Tutup loading spinner

    int? selectedPlanId;
    String paymentMethod = 'CASH';
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Paket Membership',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                'Member: ${member.name}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ...plans.map(
                  (plan) => RadioListTile<int>(
                    title: Text(
                      plan.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${plan.duration} Hari'),
                    secondary: Text(
                      'Rp ${plan.price}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: plan.id,
                    groupValue: selectedPlanId,
                    onChanged: (val) =>
                        setModalState(() => selectedPlanId = val),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setModalState(() => paymentMethod = 'CASH'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: paymentMethod == 'CASH'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('CASH'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setModalState(() => paymentMethod = 'QRIS'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: paymentMethod == 'QRIS'
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('QRIS / ONLINE'),
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
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: (selectedPlanId == null || isProcessing)
                  ? null
                  : () async {
                      setModalState(() => isProcessing = true);
                      try {
                        final tx = await _transactionService.createInvoice(
                          memberId: member.id,
                          planId: selectedPlanId,
                          paymentMethod: paymentMethod,
                        );
                        Navigator.pop(ctx);
                        if (paymentMethod == 'QRIS' && tx.qrisUrl.isNotEmpty) {
                          _showQrisPopup(tx.qrisUrl);
                        } else {
                          _showSuccessSnackBar(
                            'Pembayaran Cash dicatat, membership aktif.',
                          );
                        }
                        _loadMembersData();
                      } catch (e) {
                        debugPrint('$e');
                      } finally {
                        setModalState(() => isProcessing = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Bayar Sekarang'),
            ),
          ],
        ),
      ),
    );
  }

  // 3. Modal Beli Produk / Jasa PT (Offering)
  void _showOfferingModal(UserProfile member) async {
    showDialog(
      context: context,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    List<Offering> offerings = [];
    try {
      offerings = await _offeringService.fetchOfferings();
    } catch (e) {
      debugPrint('$e');
    }
    if (!mounted) return;
    Navigator.pop(context);

    int? selectedOfferingId;
    String paymentMethod = 'CASH';
    bool isProcessing = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Beli Produk / Jasa PT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              Text(
                'Member: ${member.name}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                ...offerings.map(
                  (item) => RadioListTile<int>(
                    title: Row(
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.type,
                            style: const TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      item.type == 'PRODUCT'
                          ? 'Stok: ${item.stock}'
                          : item.type == 'SERVICE'
                          ? '${item.quota} Sesi'
                          : '${item.duration} Hari',
                    ),
                    secondary: Text(
                      'Rp ${item.price}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: item.id,
                    groupValue: selectedOfferingId,
                    onChanged: (val) =>
                        setModalState(() => selectedOfferingId = val),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setModalState(() => paymentMethod = 'CASH'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: paymentMethod == 'CASH'
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('CASH'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () =>
                            setModalState(() => paymentMethod = 'QRIS'),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: paymentMethod == 'QRIS'
                                ? Colors.orange
                                : Colors.grey,
                          ),
                        ),
                        child: const Text('QRIS / ONLINE'),
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
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: (selectedOfferingId == null || isProcessing)
                  ? null
                  : () async {
                      setModalState(() => isProcessing = true);
                      try {
                        final tx = await _transactionService.createInvoice(
                          memberId: member.id,
                          offeringId: selectedOfferingId,
                          paymentMethod: paymentMethod,
                        );
                        Navigator.pop(ctx);
                        if (paymentMethod == 'QRIS' && tx.qrisUrl.isNotEmpty) {
                          _showQrisPopup(tx.qrisUrl);
                        } else {
                          _showSuccessSnackBar(
                            'Pembelian produk/layanan berhasil dicatat.',
                          );
                        }
                        _loadMembersData();
                      } catch (e) {
                        debugPrint('$e');
                      } finally {
                        setModalState(() => isProcessing = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('Konfirmasi'),
            ),
          ],
        ),
      ),
    );
  }

  // 🖼️ Pembungkus Gambar QR Code untuk Skenario Pembayaran Midtrans QRIS Online
  void _showQrisPopup(String url) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Scan QRIS Midtrans',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              url,
              width: 250,
              height: 250,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.qr_code_2, size: 200),
            ),
            const SizedBox(height: 12),
            const Text(
              'Scan QR code di atas untuk membayar',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showSuccessSnackBar(
                  'Pembayaran dikonfirmasi! Akan diproses otomatis.',
                );
              },
              child: const Text('Saya Sudah Bayar'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green[800]),
    );
  }

  // ==========================================
  // 🌲 CANVAS WIDGET INTERFACE utama SCREEN
  // ==========================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kelola Member',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMembersData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showMemberFormModal(),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Member'),
      ),
      body: Column(
        children: [
          // 📊 INPUT CARDS BAR FILTER PENCARIAN & STATUS
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Cari nama atau email...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['All', 'Active', 'Expired', 'Pending']
                      .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      _selectedStatus = val;
                      _applyFilters();
                    }
                  },
                ),
              ],
            ),
          ),

          // 🎰 AREA LIST VIEW DATA MEMBER TABLE REPLACEMENT
          Expanded(
            child: _isLoadingMembers
                ? const Center(child: CircularProgressIndicator())
                : _filteredMembers.isEmpty
                ? const Center(child: Text('Member tidak ditemukan.'))
                : ListView.builder(
                    itemCount: _filteredMembers.length,
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      final isActive =
                          member.hasMembership() &&
                          member.membership.status == 'ACTIVE';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        color: isActive
                            ? const Color(0xFFF0FDF4)
                            : Colors
                                  .white, // Efek highlight warna hijau persis Svelte kamu
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple[100],
                            child: Text(
                              member.name.isNotEmpty
                                  ? member.name[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                          title: Text(
                            member.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(member.email),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Daftar: ${_formatProtoTimestamp(member.createdAt)}',
                                  ),
                                  Text(
                                    'Mulai Member: ${member.hasMembership() ? _formatProtoTimestamp(member.membership.startDate) : '-'}',
                                  ),
                                  Text(
                                    'Akhir Member: ${member.hasMembership() ? _formatProtoTimestamp(member.membership.endDate) : '-'}',
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.shopping_basket,
                                          color: Colors.orange,
                                        ),
                                        onPressed: () =>
                                            _showOfferingModal(member),
                                      ),
                                      if (!isActive)
                                        IconButton(
                                          icon: const Icon(
                                            Icons.point_of_sale_rounded,
                                            color: Colors.green,
                                          ),
                                          onPressed: () =>
                                              _showPayModal(member),
                                        ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () => _showMemberFormModal(
                                          editingMember: member,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () async {
                                          await _memberService.removeMember(
                                            member.id,
                                          );
                                          _loadMembersData();
                                        },
                                      ),
                                    ],
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
