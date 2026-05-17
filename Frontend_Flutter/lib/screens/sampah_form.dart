import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../core/constants/colors.dart';

class SampahFormPage extends StatefulWidget {
  final Map<String, dynamic>? sampah;

  const SampahFormPage({super.key, this.sampah});

  @override
  State<SampahFormPage> createState() => _SampahFormPageState();
}

class _SampahFormPageState extends State<SampahFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.sampah != null) {
      _controller.text = widget.sampah!['nama_sampah'];
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (pickedFile != null) {
        setState(() => _image = File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal mengambil gambar: $e",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            backgroundColor: AppColors.accentPink,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: AppColors.borderColor, width: 2),
            ),
          ),
        );
      }
    }
  }

  void _saveData() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      bool success = await ApiService().saveSampah(
        _controller.text.trim(),
        _image,
        id: widget.sampah?['id'],
      );

      if (mounted) {
        setState(() => _isLoading = false);

        if (success) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "✓ Berhasil disimpan",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              backgroundColor: AppColors.accentYellow,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.borderColor, width: 2),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "✗ Gagal menyimpan data",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: AppColors.accentPink,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: AppColors.borderColor, width: 2),
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.sampah != null;

    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isEdit ? AppColors.accentYellow : AppColors.primaryGreen,
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
              child: Icon(
                isEdit ? Icons.edit : Icons.add,
                size: 18,
                color: isEdit ? AppColors.borderColor : Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isEdit ? "EDIT DATA" : "TAMBAH DATA",
              style: const TextStyle(
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3),
          child: Container(height: 3, color: AppColors.borderColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label section
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
                child: const Text(
                  "INFORMASI SAMPAH",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Input nama sampah
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardColor,
                  border: Border.all(color: AppColors.borderColor, width: 3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.borderColor,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _controller,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.borderColor,
                  ),
                  decoration: const InputDecoration(
                    labelText: "NAMA SAMPAH",
                    labelStyle: TextStyle(
                      color: Color(0xFF666666),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    prefixIcon: Icon(
                      Icons.recycling,
                      color: AppColors.borderColor,
                      size: 22,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    errorStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentPink,
                    ),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? "Nama harus diisi"
                      : null,
                ),
              ),
              const SizedBox(height: 24),

              // Label foto
              const Text(
                "FOTO SAMPAH",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),

              // Area foto neobrutalism
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
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
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(11),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.bgColor,
                                border: Border.all(
                                  color: AppColors.borderColor,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 30,
                                color: AppColors.borderColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "TAP UNTUK PILIH FOTO",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Color(0xFF888888),
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 36),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 56,
                child: GestureDetector(
                  onTap: _isLoading ? null : _saveData,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    decoration: BoxDecoration(
                      color: _isLoading
                          ? AppColors.primaryGreen.withValues(alpha: 0.7)
                          : AppColors.primaryGreen,
                      border: Border.all(
                        color: AppColors.borderColor,
                        width: 3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.borderColor,
                          offset: _isLoading
                              ? const Offset(1, 1)
                              : const Offset(5, 5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              "SIMPAN DATA →",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
