import 'package:flutter/material.dart';
import '../../grpc_service.dart';
import '../../gen/app.pbgrpc.dart';

class SATenantPage extends StatefulWidget {
  final UserProfile profile;
  const SATenantPage({super.key, required this.profile});

  @override
  State<SATenantPage> createState() => _SATenantPageState();
}

class _SATenantPageState extends State<SATenantPage> {
  List<Tenant> _allTenants = [];
  List<Tenant> _filteredTenants = [];
  bool _isLoadingData = true;

  String _searchQuery = '';
  String _selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    _loadTenantsData();
  }

  Future<void> _loadTenantsData() async {
    setState(() => _isLoadingData = true);
    try {
      final res = await GrpcService().tenantClient.getTenants(Empty());
      setState(() {
        _allTenants = res.tenants;
        _applyFilters();
      });
    } catch (e) {
      debugPrint('Gagal memuat tenant: $e');
      _showSnackBar('Gagal memuat data: $e', Colors.red);
    } finally {
      setState(() => _isLoadingData = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTenants = _allTenants.where((tenant) {
        final matchSearch =
            tenant.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            tenant.slug.toLowerCase().contains(_searchQuery.toLowerCase());

        if (_selectedStatus == 'Active') return matchSearch && tenant.isActive;
        if (_selectedStatus == 'Inactive')
          return matchSearch && !tenant.isActive;

        return matchSearch;
      }).toList();
    });
  }

  void _showTenantFormModal({Tenant? editingTenant}) {
    final nameCtrl = TextEditingController(text: editingTenant?.name ?? '');
    final slugCtrl = TextEditingController(text: editingTenant?.slug ?? '');
    final addressCtrl = TextEditingController(
      text: editingTenant?.address ?? '',
    );
    bool currentIsActive = editingTenant?.isActive ?? true;
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
            editingTenant != null ? 'Edit Cabang' : 'Daftarkan Cabang Baru',
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
                    labelText: 'Nama Cabang',
                    hintText: 'Contoh: Gym Center Jakarta',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: slugCtrl,
                        decoration: const InputDecoration(
                          labelText: 'URL Slug',
                          hintText: 'gym-jakarta',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<bool>(
                        value: currentIsActive,
                        decoration: const InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: true, child: Text('Aktif')),
                          DropdownMenuItem(
                            value: false,
                            child: Text('Non-Aktif'),
                          ),
                        ],
                        onChanged: (val) {
                          if (val != null)
                            setModalState(() => currentIsActive = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Alamat Lengkap',
                    hintText: 'Alamat operasional...',
                    border: OutlineInputBorder(),
                  ),
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
                      if (nameCtrl.text.trim().isEmpty ||
                          slugCtrl.text.trim().isEmpty)
                        return;
                      setModalState(() => isSubmitting = true);

                      try {
                        if (editingTenant != null) {
                          // 🚀 UPDATE TENANT EXECUTION
                          await GrpcService().tenantClient.updateTenant(
                            UpdateTenantRequest()
                              ..id = editingTenant.id
                              ..name = nameCtrl.text.trim()
                              ..slug = slugCtrl.text.trim()
                              ..address = addressCtrl.text.trim()
                              ..isActive = currentIsActive,
                          );
                          _showSnackBar(
                            'Cabang berhasil diperbarui.',
                            Colors.green,
                          );
                        } else {
                          await GrpcService().tenantClient.addTenant(
                            AddTenantRequest()
                              ..name = nameCtrl.text.trim()
                              ..slug = slugCtrl.text.trim()
                              ..address = addressCtrl.text.trim()
                              ..isActive = currentIsActive,
                          );
                          _showSnackBar(
                            'Cabang baru berhasil didaftarkan.',
                            Colors.green,
                          );
                        }

                        Navigator.pop(ctx);
                        _loadTenantsData();
                      } catch (e) {
                        debugPrint('Gagal memproses tenant: $e');
                        _showSnackBar('Gagal menyimpan: $e', Colors.red);
                      } finally {
                        setModalState(() => isSubmitting = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
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

  void _showDeleteConfirmation(Tenant tenant) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Hapus Cabang?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Seluruh data member dan staff di cabang "${tenant.name}" akan ikut terhapus permanen dari sistem!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              setState(() => _isLoadingData = true);
              try {
                await GrpcService().tenantClient.deleteTenant(
                  GetTenantRequest()..tenantId = tenant.id,
                );
                _showSnackBar('Cabang telah sukses dihapus.', Colors.green);
                _loadTenantsData();
              } catch (e) {
                setState(() => _isLoadingData = false);
                _showSnackBar('Gagal menghapus: $e', Colors.red);
              }
            },
            child: const Text(
              'Ya, Hapus Cabang',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String msg, Color? bg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: bg));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manajemen Cabang',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF4F46E5),
          ),
        ),
        backgroundColor: const Color(0xFFF5F3FF),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF4F46E5)),
            onPressed: _loadTenantsData,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTenantFormModal(),
        backgroundColor: const Color(0xFF4F46E5),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: const Text(
          'Tambah Cabang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search, color: Colors.grey),
                      hintText: 'Cari nama cabang atau slug...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onChanged: (val) {
                      _searchQuery = val;
                      _applyFilters();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _selectedStatus,
                  elevation: 4,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('Semua Status')),
                    DropdownMenuItem(value: 'Active', child: Text('Aktif')),
                    DropdownMenuItem(
                      value: 'Inactive',
                      child: Text('Non-Aktif'),
                    ),
                  ],
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

          Expanded(
            child: _isLoadingData
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF4F46E5)),
                  )
                : _filteredTenants.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.gavel_rounded, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Cabang tidak ditemukan.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredTenants.length,
                    itemBuilder: (context, index) {
                      final tenant = _filteredTenants[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                        ),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(
                              0xFFE0E7FF,
                            ), // Indigo-100
                            child: const Icon(
                              Icons.store_rounded,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                          title: Text(
                            tenant.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tenant.slug,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 11,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: tenant.isActive
                                      ? const Color(0xFFD1FAE5)
                                      : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: tenant.isActive
                                            ? Colors.green
                                            : Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      tenant.isActive ? 'Aktif' : 'Non-Aktif',
                                      style: TextStyle(
                                        color: tenant.isActive
                                            ? Colors.green[800]
                                            : Colors.red[800],
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Alamat Cabang:\n${tenant.address.isNotEmpty ? tenant.address : "-"}',
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(
                                          Icons.edit_note_rounded,
                                          color: Color(0xFF4F46E5),
                                        ),
                                        onPressed: () => _showTenantFormModal(
                                          editingTenant: tenant,
                                        ),
                                        tooltip: 'Edit Cabang',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_sweep_rounded,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            _showDeleteConfirmation(tenant),
                                        tooltip: 'Hapus Cabang',
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
