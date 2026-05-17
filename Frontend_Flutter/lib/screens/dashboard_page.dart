import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import 'chat_page.dart';
import 'sampah_form.dart';
import '../core/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<dynamic> allSampah = [];
  List<dynamic> filteredSampah = [];
  final TextEditingController searchController = TextEditingController();

  void refreshData() async {
    final data = await ApiService().fetchSampah();
    if (mounted) {
      setState(() {
        allSampah = data;
        filteredSampah = data;
      });
    }
  }

  void filterData(String query) {
    setState(() {
      filteredSampah = allSampah
          .where(
            (item) => item['nama_sampah'].toString().toLowerCase().contains(
              query.toLowerCase(),
            ),
          )
          .toList();
    });
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _buildNeoBrutalDialog(
        title: "LOGOUT",
        content: "Apakah yakin ingin keluar dari aplikasi?",
        confirmText: "KELUAR",
        confirmColor: AppColors.accentPink,
        onConfirm: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          if (ctx.mounted) {
            Navigator.pushNamedAndRemoveUntil(ctx, '/', (route) => false);
          }
        },
      ),
    );
  }

  void _confirmDelete(int id, String nama) {
    showDialog(
      context: context,
      builder: (ctx) => _buildNeoBrutalDialog(
        title: "HAPUS DATA",
        content: "Apakah yakin ingin menghapus '$nama'?",
        confirmText: "HAPUS",
        confirmColor: AppColors.accentPink,
        onConfirm: () async {
          bool success = await ApiService().deleteSampah(id);
          if (ctx.mounted) {
            Navigator.pop(ctx);
            if (success && mounted) {
              refreshData();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "✓ Data berhasil dihapus",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  backgroundColor: AppColors.accentPink,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(
                      color: AppColors.borderColor,
                      width: 2,
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Widget _buildNeoBrutalDialog({
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.borderColor, width: 3),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.borderColor,
              offset: Offset(5, 5),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.borderColor,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.bgColor,
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.borderColor,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "BATAL",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: confirmColor,
                        border: Border.all(
                          color: AppColors.borderColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.borderColor,
                            offset: Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                border: Border.all(color: AppColors.borderColor, width: 2),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.borderColor,
                    offset: Offset(2, 2),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.recycling, size: 18, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              "BANK SAMPAH",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.bgColor,
        foregroundColor: AppColors.borderColor,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => _confirmLogout(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accentPink,
                  border: Border.all(color: AppColors.borderColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.borderColor,
                      offset: Offset(2, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Icon(Icons.logout, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppColors.borderColor),
        ),
      ),
      body: Column(
        children: [
          // Search bar neobrutalism
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.cardColor,
                border: Border.all(color: AppColors.borderColor, width: 2.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.borderColor,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: filterData,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: "Cari jenis sampah...",
                  hintStyle: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Icon(Icons.search, color: AppColors.borderColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          // Header jumlah data
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentYellow,
                    border: Border.all(color: AppColors.borderColor, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.borderColor,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Text(
                    "${filteredSampah.length} DATA",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // List data
          Expanded(
            child: filteredSampah.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.bgColor,
                            border: Border.all(
                              color: AppColors.borderColor,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.borderColor,
                                offset: Offset(4, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.inbox_outlined,
                            size: 36,
                            color: AppColors.borderColor,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Belum ada data",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF888888),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredSampah.length,
                    itemBuilder: (context, index) {
                      final item = filteredSampah[index];
                      return _buildSampahCard(item);
                    },
                  ),
          ),
        ],
      ),
      // FAB neobrutalism
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Tombol Chat
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatPage()),
            ),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.accentBlue,
                border: Border.all(color: AppColors.borderColor, width: 2.5),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.borderColor,
                    offset: Offset(3, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.smart_toy, size: 22, color: Colors.white),
            ),
          ),
          const SizedBox(height: 12),
          // Tombol Tambah
          GestureDetector(
            onTap: () async {
              bool? added = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SampahFormPage()),
              );
              if (added == true) refreshData();
            },
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                border: Border.all(color: AppColors.borderColor, width: 3),
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.borderColor,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.add, size: 28, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampahCard(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardColor,
        border: Border.all(color: AppColors.borderColor, width: 2.5),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.borderColor,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        children: [
          // Gambar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderColor, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item['pic'] != null
                  ? Image.network(
                      "${ApiService().baseUrl}/uploads/${item['pic']}",
                      fit: BoxFit.cover,
                    )
                  : Container(
                      color: AppColors.accentYellow.withValues(alpha: 0.3),
                      child: const Icon(
                        Icons.recycling,
                        color: AppColors.primaryGreen,
                        size: 28,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          // Nama
          Expanded(
            child: Text(
              item['nama_sampah'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: AppColors.borderColor,
              ),
            ),
          ),
          // Action buttons
          _buildActionBtn(Icons.edit, AppColors.accentBlue, () async {
            bool? updated = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SampahFormPage(sampah: item)),
            );
            if (updated == true) refreshData();
          }),
          const SizedBox(width: 8),
          _buildActionBtn(
            Icons.delete_outline,
            AppColors.accentPink,
            () => _confirmDelete(item['id'], item['nama_sampah']),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: AppColors.borderColor, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.borderColor,
              offset: Offset(2, 2),
              blurRadius: 0,
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      ),
    );
  }
}
