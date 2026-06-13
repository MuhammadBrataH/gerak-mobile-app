import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class DeleteAccountView extends StatefulWidget {
  const DeleteAccountView({super.key});

  @override
  State<DeleteAccountView> createState() => _DeleteAccountViewState();
}

class _DeleteAccountViewState extends State<DeleteAccountView> {
  int _selectedReason = -1;
  int _currentStep = 1;

  final List<String> _reasons = [
    'Masalah keamanan atau privasi',
    'Kesulitan dalam memulai penggunaan akun',
    'Alasan lainnya',
  ];

  void _selectReason(int index) {
    setState(() {
      _selectedReason = index;
    });
  }

  void _goToNextStep() {
    setState(() {
      _currentStep = 2;
    });
  }

  void _goBackToStep1() {
    setState(() {
      _currentStep = 1;
    });
  }

  void _goBackToProfile() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final displayName = authController.displayName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _currentStep == 2 ? _goBackToStep1 : () => Get.back(),
        ),
        title: const Text(
          'Hapus Akun',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _currentStep == 1 ? _buildStep1() : _buildStep2(displayName),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Sebelum anda pergi, ada yang bisa kami bantu?',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'Beri tahu kami alasan Anda ingin menghapus akun agar kami dapat membantu mengatasi masalah umum dan meningkatkan aplikasi bagi komunitas. Anda dapat melewatkan langkah ini.',
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        ..._reasons.asMap().entries.map((entry) {
          final index = entry.key;
          final reason = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ReasonOption(
              text: reason,
              isSelected: _selectedReason == index,
              onTap: () => _selectReason(index),
            ),
          );
        }),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _goToNextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Lanjut',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2(String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '$displayName: hapus akun ini',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            style: TextStyle(fontSize: 14, color: Colors.grey),
            children: [
              TextSpan(text: 'Jika kamu menghapus akunmu:\n'),
              TextSpan(
                text:
                    '• Anda tidak akan dapat masuk dan menggunakan layanan apa pun di GERAK dengan akun tersebut.\n',
              ),
              TextSpan(text: '• lorem ipsum\n'),
              TextSpan(text: '• lorem ipsum\n\n'),
              TextSpan(text: 'Anda yakin ingin menghapus akun?'),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _goBackToProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Hapus Akun',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReasonOption extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _ReasonOption({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.blue : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.black,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.blue : const Color(0xFFE2E8F0),
                  width: 2,
                ),
                color: isSelected ? Colors.blue : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
