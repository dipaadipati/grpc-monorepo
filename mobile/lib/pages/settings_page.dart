import 'package:flutter/material.dart';
import 'package:mobile/pages/super-admin/super_navigation_holder.dart';
import '../grpc_service.dart';
import '../gen/app.pbgrpc.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  final UserProfile profile;
  const SettingsPage({super.key, required this.profile});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // 💻 State Lokal Aplikasi (Disimpan di memori RAM, tidak menembak gRPC)
  bool _printerConnected = false;
  bool _autoPrintReceipt = true;
  bool _soundEffectsEnabled = true;
  bool _realtimeNotification = true;
  String _selectedLanguage = 'Bahasa Indonesia';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan Sistem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ==========================================
          // 👑 1. SECTION IDENTITAS MULTI-TENANT (READ-ONLY)
          // ==========================================
          _buildSectionTitle('INFORMASI LISENSI CABANG'),
          const SizedBox(height: 8),
          Card(
            elevation: 0,
            color: Colors.purple[50]?.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.purple[100]!),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.business_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.profile.tenantName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Tenant ID: #${widget.profile.tenantId}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: widget.profile.tenantIsActive
                                ? Colors.green[100]
                                : Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.profile.tenantIsActive
                                ? 'LISENSI AKTIF'
                                : 'LISENSI NON-AKTIF',
                            style: TextStyle(
                              color: widget.profile.tenantIsActive
                                  ? Colors.green[800]
                                  : Colors.red[800],
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // 🖨️ 2. SECTION HARDWARE INTEGRATION (SIMULASI)
          // ==========================================
          _buildSectionTitle('PERANGKAT KASIR (HARDWARE)'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.print_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Printer Struk Thermal',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    _printerConnected
                        ? 'Terhubung (Bluetooth Thermal)'
                        : 'Printer terputus',
                  ),
                  value: _printerConnected,
                  onChanged: (val) {
                    setState(() => _printerConnected = val);
                    _showToast(
                      val
                          ? 'Mencari & menghubungkan ke printer...'
                          : 'Printer dinonaktifkan.',
                    );
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Cetak Struk Otomatis',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Otomatis cetak setelah transaksi lunas',
                  ),
                  value: _autoPrintReceipt,
                  onChanged: (val) => setState(() => _autoPrintReceipt = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // 📱 3. SECTION PREFERENSI APLIKASI (SIMULASI)
          // ==========================================
          _buildSectionTitle('PENGATURAN APLIKASI MOBILE'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(
                    Icons.notifications_active_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Notifikasi Real-time',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Beritahu jika ada member scan QRIS online',
                  ),
                  value: _realtimeNotification,
                  onChanged: (val) =>
                      setState(() => _realtimeNotification = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(
                    Icons.volume_up_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Efek Suara Konsol',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: const Text('Suara "Beep" konfirmasi sukses kasir'),
                  value: _soundEffectsEnabled,
                  onChanged: (val) =>
                      setState(() => _soundEffectsEnabled = val),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.translate_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Bahasa Aplikasi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(_selectedLanguage),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  onTap: () => _showLanguageDialog(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ==========================================
          // 🏢 4. SECTION INFORMASI VERSI SYSTEM & LOGOUT
          // ==========================================
          _buildSectionTitle('SISTEM & AKSI KASIR'),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blueGrey,
                  ),
                  title: const Text(
                    'Versi Aplikasi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: const Text(
                    'v2.1.0-Beta',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (widget.profile.role == 'SUPER_ADMIN') ...[
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Colors.amber,
                    ),
                    title: const Text(
                      'Beralih ke Super Admin',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'Masuk ke pusat kendali seluruh tenant/cabang',
                    ),
                    trailing: const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: Color(0xFF4F46E5),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SuperAdminNavigationHolder(
                            profile: widget.profile,
                          ),
                        ),
                      );
                    },
                  ),
                ],
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Kelola Akun / Keluar Sesi',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _handleLogoutAction(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Helper Pembuat Judul Kategori Section
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 4.0),
      child: Text(
        title,
        // 🚀 2. Pindahkan parameter 'style' ke dalam widget Text yang tepat
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Toast feedback bar kecil bawah layar
  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  // Modal Dialog Pilihan Bahasa Aplikasi (Simulasi State)
  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Bahasa Indonesia'),
              value: 'Bahasa Indonesia',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(ctx);
              },
            ),
            RadioListTile<String>(
              title: const Text('English (US)'),
              value: 'English (US)',
              groupValue: _selectedLanguage,
              onChanged: (val) {
                setState(() => _selectedLanguage = val!);
                Navigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Logika Keluar Sesi Mengosongkan Token & Redirect halaman login
  void _handleLogoutAction() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Keluar Aplikasi?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari konsol kasir cabang ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // tutup dialog
              GrpcService().clearToken(); // hapus token biner global
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const GymLoginPage()),
              );
            },
            child: const Text(
              'Ya, Keluar',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
