import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class CommunityAddSheet extends StatefulWidget {
  const CommunityAddSheet({super.key});

  @override
  State<CommunityAddSheet> createState() => _CommunityAddSheetState();
}

class _CommunityAddSheetState extends State<CommunityAddSheet> {
  int _activeTab = 0; // 0 = Postingan, 1 = Pertandingan
  final TextEditingController _postDescController = TextEditingController();
  final TextEditingController _matchTitleController = TextEditingController();
  final TextEditingController _matchDescController = TextEditingController();
  String? _selectedCategory;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _locationLabel = 'Lokasi';
  int _slotCount = 10;
  String _genderLabel = 'Gender';

  @override
  void dispose() {
    _postDescController.dispose();
    _matchTitleController.dispose();
    _matchDescController.dispose();
    super.dispose();
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _pickDate() async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _DatePickerSheet(initialDate: _selectedDate ?? DateTime.now());
      },
    );
    if (picked == null) {
      return;
    }
    setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked == null) {
      return;
    }
    setState(() => _selectedTime = picked);
  }

  Future<void> _pickLocation() async {
    final controller = TextEditingController(text: _locationLabel);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Lokasi'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Masukkan lokasi'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, controller.text),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (result == null || result.trim().isEmpty) {
      return;
    }
    setState(() => _locationLabel = result.trim());
  }

  Future<void> _pickGender() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Pria'),
                onTap: () => Navigator.pop(sheetContext, 'Pria'),
              ),
              ListTile(
                title: const Text('Wanita'),
                onTap: () => Navigator.pop(sheetContext, 'Wanita'),
              ),
              ListTile(
                title: const Text('Campuran'),
                onTap: () => Navigator.pop(sheetContext, 'Campuran'),
              ),
            ],
          ),
        );
      },
    );
    if (result == null) {
      return;
    }
    setState(() => _genderLabel = result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 110,
                      height: 6,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9199A5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'TAMBAHKAN',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 28,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w800,
                        height: 1.29,
                        letterSpacing: -0.75,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _TabHeader(
                    activeIndex: _activeTab,
                    onTabChanged: (index) {
                      setState(() => _activeTab = index);
                    },
                  ),
                  const SizedBox(height: 18),
                  if (_activeTab == 0)
                    _AddPostForm(
                      descriptionController: _postDescController,
                      onPickMedia: () =>
                          _showInfo('Upload media belum dibuat.'),
                      onSubmit: () => _showInfo('Postingan dibuat.'),
                    )
                  else
                    _AddMatchForm(
                      selectedCategory: _selectedCategory,
                      onCategoryTap: (value) {
                        setState(() => _selectedCategory = value);
                      },
                      onPickMedia: () =>
                          _showInfo('Upload media belum dibuat.'),
                      titleController: _matchTitleController,
                      descriptionController: _matchDescController,
                      dateLabel: _selectedDate == null
                          ? 'Pilih Tanggal'
                          : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}',
                      timeLabel: _selectedTime == null
                          ? 'Pilih Jam'
                          : _selectedTime!.format(context),
                      locationLabel: _locationLabel,
                      onPickDate: _pickDate,
                      onPickTime: _pickTime,
                      onPickLocation: _pickLocation,
                      slotCount: _slotCount,
                      onDecrementSlot: () {
                        setState(() {
                          if (_slotCount > 1) {
                            _slotCount -= 1;
                          }
                        });
                      },
                      onIncrementSlot: () {
                        setState(() => _slotCount += 1);
                      },
                      genderLabel: _genderLabel,
                      onPickGender: _pickGender,
                      onSubmit: () => _showInfo('Pertandingan dibuat.'),
                      onSeeAllCategories: () =>
                          Get.toNamed(AppRoutes.sportsAll),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabHeader extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTabChanged;

  const _TabHeader({required this.activeIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFF808080), width: 0.8),
          bottom: BorderSide(color: Color(0xFF808080), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: 'Postingan',
              isActive: activeIndex == 0,
              onTap: () => onTabChanged(0),
            ),
          ),
          Container(width: 1, height: 44, color: const Color(0xFF808080)),
          Expanded(
            child: _TabButton(
              label: 'Pertandingan',
              isActive: activeIndex == 1,
              onTap: () => onTabChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF2563EB) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w800,
            height: 1.8,
            letterSpacing: -0.75,
          ),
        ),
      ),
    );
  }
}

class _AddPostForm extends StatelessWidget {
  final TextEditingController descriptionController;
  final VoidCallback onPickMedia;
  final VoidCallback onSubmit;

  const _AddPostForm({
    required this.descriptionController,
    required this.onPickMedia,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tambahkan Foto/Video',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w800,
            height: 2.4,
            letterSpacing: -0.75,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _UploadBox(onTap: onPickMedia),
            const SizedBox(width: 12),
            _PreviewThumb(),
          ],
        ),
        const SizedBox(height: 16),
        _TextArea(
          placeholder: 'Tambahkan Deskripsi',
          controller: descriptionController,
        ),
        const SizedBox(height: 20),
        _PrimaryButton(label: 'Buat Postingan', onTap: onSubmit),
      ],
    );
  }
}

class _AddMatchForm extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String> onCategoryTap;
  final VoidCallback onPickMedia;
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String dateLabel;
  final String timeLabel;
  final String locationLabel;
  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final VoidCallback onPickLocation;
  final int slotCount;
  final VoidCallback onDecrementSlot;
  final VoidCallback onIncrementSlot;
  final String genderLabel;
  final VoidCallback onPickGender;
  final VoidCallback onSubmit;
  final VoidCallback onSeeAllCategories;

  const _AddMatchForm({
    required this.selectedCategory,
    required this.onCategoryTap,
    required this.onPickMedia,
    required this.titleController,
    required this.descriptionController,
    required this.dateLabel,
    required this.timeLabel,
    required this.locationLabel,
    required this.onPickDate,
    required this.onPickTime,
    required this.onPickLocation,
    required this.slotCount,
    required this.onDecrementSlot,
    required this.onIncrementSlot,
    required this.genderLabel,
    required this.onPickGender,
    required this.onSubmit,
    required this.onSeeAllCategories,
  });

  @override
  Widget build(BuildContext context) {
    final categories = <_ChipData>[
      _ChipData('SEPAK BOLA', 'assets/icons/soccer.svg'),
      _ChipData('BASKET', 'assets/icons/basketball.svg'),
      _ChipData('BADMINTON', 'assets/icons/badminton.svg'),
      _ChipData('LARI', 'assets/icons/run.svg'),
      _ChipData('PADEL', 'assets/icons/padel.svg'),
      _ChipData('FUTSAL', 'assets/icons/futsal.svg'),
      _ChipData('VOLLEY', 'assets/icons/volley.svg'),
      _ChipData('MINI SOCCER', 'assets/icons/mini_soccer.svg'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'KATEGORI',
              style: TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 24,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: -0.6,
              ),
            ),
            TextButton(
              onPressed: onSeeAllCategories,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'LIHAT SEMUA',
                style: TextStyle(
                  color: Color(0xFF2563EB),
                  fontSize: 12,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map(
                (chip) => _CategoryChip(
                  label: chip.label,
                  icon: chip.icon,
                  isActive: selectedCategory == chip.label,
                  onTap: () => onCategoryTap(chip.label),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Tambahkan Foto/Video',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w800,
            height: 2.4,
            letterSpacing: -0.75,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _UploadBox(onTap: onPickMedia),
            const SizedBox(width: 12),
            _PreviewThumb(),
          ],
        ),
        const SizedBox(height: 16),
        _TextField(placeholder: 'Tambahkan Judul', controller: titleController),
        const SizedBox(height: 12),
        _TextArea(
          placeholder: 'Tambahkan Deskripsi',
          controller: descriptionController,
        ),
        const SizedBox(height: 14),
        _RowItem(
          icon: Icons.calendar_today_outlined,
          label: dateLabel,
          onTap: onPickDate,
        ),
        const SizedBox(height: 10),
        _RowItem(icon: Icons.schedule, label: timeLabel, onTap: onPickTime),
        const SizedBox(height: 10),
        _RowItem(
          icon: Icons.location_on_outlined,
          label: locationLabel,
          onTap: onPickLocation,
        ),
        const SizedBox(height: 12),
        _SlotRow(
          label: 'Jumlah Slot',
          value: slotCount,
          onDecrement: onDecrementSlot,
          onIncrement: onIncrementSlot,
        ),
        const SizedBox(height: 10),
        _RowItem(icon: Icons.wc, label: genderLabel, onTap: onPickGender),
        const SizedBox(height: 20),
        _PrimaryButton(label: 'Buat Pertandingan', onTap: onSubmit),
      ],
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final background = isActive
        ? const LinearGradient(
            begin: Alignment(0, 0.5),
            end: Alignment(1, 0.5),
            colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          )
        : null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? null : const Color(0xFF475569),
          gradient: background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
              colorFilter: const ColorFilter.mode(
                Color(0xFFFAFBFF),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFAFBFF),
                fontSize: 10,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadBox extends StatelessWidget {
  final VoidCallback onTap;

  const _UploadBox({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 97,
        height: 97,
        decoration: BoxDecoration(
          color: const Color(0x33A19C9C),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF7A7777)),
        ),
        child: const Icon(Icons.add_a_photo_outlined, color: Color(0xFF7A7777)),
      ),
    );
  }
}

class _PreviewThumb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            'assets/sample 1.jpg',
            width: 74,
            height: 85,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          right: 4,
          bottom: 4,
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              '1',
              style: TextStyle(
                color: Color(0xFF2563EB),
                fontSize: 8,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TextField extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;

  const _TextField({required this.placeholder, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        hintStyle: const TextStyle(
          color: Color(0x7F0F172A),
          fontSize: 15,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w800,
          height: 2.4,
          letterSpacing: -0.75,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFC0C0C0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
    );
  }
}

class _TextArea extends StatelessWidget {
  final String placeholder;
  final TextEditingController controller;

  const _TextArea({required this.placeholder, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        hintText: placeholder,
        contentPadding: const EdgeInsets.all(12),
        hintStyle: const TextStyle(
          color: Color(0xFF878789),
          fontSize: 13,
          fontFamily: 'Lexend',
          fontWeight: FontWeight.w300,
          height: 2.77,
          letterSpacing: -0.75,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFC0C0C0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563EB)),
        ),
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _RowItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF0F172A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 15,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.w500,
                height: 2.4,
                letterSpacing: -0.75,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF0F172A)),
        ],
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _SlotRow({
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person, size: 20, color: Color(0xFF0F172A)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 15,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
              height: 2.4,
              letterSpacing: -0.75,
            ),
          ),
        ),
        _IconCircleButton(icon: Icons.remove, onTap: onDecrement),
        const SizedBox(width: 8),
        Text(
          '$value',
          style: const TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 15,
            fontFamily: 'Lexend',
            fontWeight: FontWeight.w500,
            height: 2.4,
            letterSpacing: -0.75,
          ),
        ),
        const SizedBox(width: 8),
        _IconCircleButton(icon: Icons.add, onTap: onIncrement),
      ],
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconCircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9999),
      child: Container(
        width: 25,
        height: 25,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF0F172A)),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;

  const _DatePickerSheet({required this.initialDate});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late DateTime _selectedDate;
  late DateTime _visibleMonth;
  late DateTime _currentMonth;

  static const _monthNames = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const _dayNames = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _visibleMonth = DateTime(_selectedDate.year, _selectedDate.month);
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
  }

  bool get _canGoPrev {
    return _visibleMonth.isAfter(_currentMonth);
  }

  void _goPrevMonth() {
    if (!_canGoPrev) return;
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month - 1);
    });
  }

  void _goNextMonth() {
    setState(() {
      _visibleMonth = DateTime(_visibleMonth.year, _visibleMonth.month + 1);
    });
  }

  int _daysInMonth(DateTime month) {
    final nextMonth = DateTime(month.year, month.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1)).day;
  }

  String _formatHeader(DateTime date) {
    final dayNames = [
      'Minggu',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];
    final dayName = dayNames[date.weekday % 7];
    final monthName = _monthNames[date.month - 1];
    return '$dayName, $monthName ${date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _daysInMonth(_visibleMonth);
    final firstWeekday = DateTime(
      _visibleMonth.year,
      _visibleMonth.month,
      1,
    ).weekday;
    final leadingEmpty = firstWeekday % 7;
    final totalCells = leadingEmpty + daysInMonth;

    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(22, 8, 22, 16),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 102,
                      height: 7,
                      decoration: BoxDecoration(
                        color: const Color(0xFF9199A5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Pilih Tanggal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w300,
                      height: 2.4,
                      letterSpacing: -0.75,
                    ),
                  ),
                  Text(
                    _formatHeader(_selectedDate),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontFamily: 'Lexend',
                      fontWeight: FontWeight.w700,
                      height: 1.29,
                      letterSpacing: -0.75,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            '${_monthNames[_visibleMonth.month - 1]} ${_visibleMonth.year}',
                            style: const TextStyle(
                              color: Color(0xFF0F172A),
                              fontSize: 17,
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.w400,
                              height: 2.12,
                              letterSpacing: -0.75,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: _canGoPrev ? _goPrevMonth : null,
                            icon: Icon(
                              Icons.chevron_left,
                              color: _canGoPrev
                                  ? const Color(0xFF0F172A)
                                  : const Color(0x660F172A),
                            ),
                          ),
                          IconButton(
                            onPressed: _goNextMonth,
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _dayNames
                            .map(
                              (day) => SizedBox(
                                width: 36,
                                child: Text(
                                  day,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xB20F172A),
                                    fontSize: 15,
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.w400,
                                    height: 2.4,
                                    letterSpacing: -0.75,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: totalCells,
                        itemBuilder: (context, index) {
                          if (index < leadingEmpty) {
                            return const SizedBox.shrink();
                          }
                          final day = index - leadingEmpty + 1;
                          final date = DateTime(
                            _visibleMonth.year,
                            _visibleMonth.month,
                            day,
                          );
                          final isSelected =
                              date.year == _selectedDate.year &&
                              date.month == _selectedDate.month &&
                              date.day == _selectedDate.day;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = date;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xCC0F172A),
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 2.4,
                                  letterSpacing: -0.75,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontSize: 20,
                                fontFamily: 'Lexend',
                                fontWeight: FontWeight.w400,
                                height: 1.8,
                                letterSpacing: -0.75,
                              ),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                              ),
                              onPressed: () => Get.back(result: _selectedDate),
                              child: const Text(
                                'SIMPAN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w400,
                                  height: 1.8,
                                  letterSpacing: -0.75,
                                ),
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
          ],
        ),
      ),
    );
  }
}

class _ChipData {
  final String label;
  final String icon;

  const _ChipData(this.label, this.icon);
}
