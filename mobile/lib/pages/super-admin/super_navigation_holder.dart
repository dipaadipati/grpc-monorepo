import 'package:flutter/material.dart';
import '../../gen/app.pbgrpc.dart';
import 'sa_tenant_page.dart'; // Halaman kelola semua tenant
import 'sa_license_page.dart'; // Halaman kelola lisensi / billing global

class SuperAdminNavigationHolder extends StatefulWidget {
  final UserProfile profile;
  const SuperAdminNavigationHolder({super.key, required this.profile});

  @override
  State<SuperAdminNavigationHolder> createState() =>
      _SuperAdminNavigationHolderState();
}

class _SuperAdminNavigationHolderState
    extends State<SuperAdminNavigationHolder> {
  int _currentIndex = 0;
  late List<Widget> _saPages;

  @override
  void initState() {
    super.initState();
    _saPages = [
      SATenantPage(profile: widget.profile),
      SALicensePage(profile: widget.profile),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar state halaman pusat tidak mereset saat pindah tab
      body: IndexedStack(index: _currentIndex, children: _saPages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        indicatorColor: const Color(0xFF4F46E5).withOpacity(0.1),
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.domain_outlined, color: Colors.grey),
            selectedIcon: const Icon(
              Icons.domain_rounded,
              color: Color(0xFF4F46E5),
            ),
            label: 'Kelola Tenant',
          ),
          NavigationDestination(
            icon: const Icon(Icons.gavel_outlined, color: Colors.grey),
            selectedIcon: const Icon(
              Icons.gavel_rounded,
              color: Color(0xFF4F46E5),
            ),
            label: 'Lisensi Global',
          ),
        ],
      ),
    );
  }
}
