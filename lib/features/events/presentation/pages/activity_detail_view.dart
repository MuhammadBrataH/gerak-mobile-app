import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/widgets/media_source_image.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/event_model.dart';
import '../controllers/event_controller.dart';

class ActivityDetailView extends StatefulWidget {
  const ActivityDetailView({
    super.key,
    this.event,
    this.eventId = '',
    required this.title,
    required this.label,
    required this.labelColor,
    required this.time,
    required this.location,
    required this.address,
    required this.community,
    required this.description,
    required this.price,
    required this.participants,
    required this.adminPhone,
  });

  final EventModel? event;
  final String eventId;
  final String title;
  final String label;
  final Color labelColor;
  final String time;
  final String location;
  final String address;
  final String community;
  final String description;
  final String price;
  final String participants;
  final String adminPhone;

  @override
  State<ActivityDetailView> createState() => _ActivityDetailViewState();
}

class _ActivityDetailViewState extends State<ActivityDetailView> {
  late RxInt editableTotalSlots;
  late RxInt editableJoinedCount;
  final isUpdatingSlots = false.obs;

  @override
  void initState() {
    super.initState();
    editableTotalSlots = RxInt(_initialTotalSlots);
    editableJoinedCount = RxInt(_joinedCount);
  }

  bool get _isCommunityCreator {
    if (!Get.isRegistered<AuthController>() || widget.event == null) {
      return false;
    }
    final authController = Get.find<AuthController>();
    final currentUserId = authController.user.value?.id;
    return authController.isCommunityAccount &&
        currentUserId != null &&
        currentUserId.isNotEmpty &&
        widget.event!.createdBy == currentUserId;
  }

  String get _displayTitle =>
      widget.event?.name.isNotEmpty == true ? widget.event!.name : widget.title;

  String get _displayDescription =>
      widget.event?.description != null &&
          widget.event!.description!.trim().isNotEmpty
      ? widget.event!.description!.trim()
      : widget.description;

  String get _displayLocation => widget.event?.location.isNotEmpty == true
      ? widget.event!.location
      : widget.location;

  String get _displayAddress {
    if (widget.event == null) {
      return widget.address;
    }
    final districtPart =
        widget.event!.district != null && widget.event!.district!.isNotEmpty
        ? ', ${widget.event!.district}'
        : '';
    return '${widget.event!.location}, ${widget.event!.city}$districtPart';
  }

  String get _displayOrganizerName {
    final organizer = widget.event?.creatorName?.trim();
    if (organizer != null && organizer.isNotEmpty) {
      return organizer;
    }
    return widget.community;
  }

  String get _displayOrganizerPhoto => widget.event?.organizerLogo ?? '';

  String get _heroImageSource => widget.event?.imageUrl ?? '';

  int get _joinedCount => widget.event?.joinedUsers.length ?? 0;

  int get _initialTotalSlots {
    final total = widget.event?.totalSlots;
    if (total != null && total > 0) {
      return total;
    }
    final match = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(widget.participants);
    if (match != null) {
      return int.tryParse(match.group(2) ?? '') ?? 1;
    }
    return 1;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get _dateLabel {
    final start = widget.event?.startTime;
    if (start != null) {
      return _formatDate(start);
    }

    final parts = widget.time.split(',').map((part) => part.trim()).toList();
    if (parts.isNotEmpty) {
      return parts.first;
    }

    return 'Friday, April 17';
  }

  String get _timeLabel {
    final start = widget.event?.startTime;
    final end = widget.event?.endTime;
    if (start != null && end != null) {
      return '${_formatTime(start)} - ${_formatTime(end)}';
    }

    final parts = widget.time.split(',').map((part) => part.trim()).toList();
    if (parts.length >= 3) {
      return parts[2];
    }

    return '20:00 - 22:00';
  }

  Future<void> _openWhatsApp() async {
    String normalizePhone(String raw) {
      var s = raw.replaceAll(RegExp(r'[^0-9+]'), '');
      if (s.startsWith('+')) {
        s = s.substring(1);
      }
      if (s.startsWith('0')) {
        // Indonesian local numbers like 0812... -> 62812...
        s = '62${s.substring(1)}';
      } else if (s.startsWith('8')) {
        // Missing leading zero (e.g. 812...) -> assume Indonesian
        s = '62$s';
      }
      return s;
    }

    final organizerPhone = normalizePhone(
      widget.event?.adminPhone ?? widget.adminPhone,
    );
    if (organizerPhone.isEmpty) {
      Get.snackbar('WhatsApp', 'Nomor organizer belum tersedia');
      return;
    }

    final userName = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>().displayName
        : 'peserta';
    final message = Uri.encodeComponent(
      'Halo, saya $userName ingin join "$_displayTitle".',
    );
    final uri = Uri.parse('https://wa.me/$organizerPhone?text=$message');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      Get.snackbar('WhatsApp', 'Gagal membuka WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<EventController>();
    final editableTotalSlots = RxInt(_initialTotalSlots);
    final editableJoinedCount = RxInt(_joinedCount);
    final isUpdatingSlots = false.obs;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(Icons.arrow_back, size: 24),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.snackbar('Favorit', 'Ditambahkan ke favorit'),
                      child: const Icon(Icons.favorite_outline, size: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Hero Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image(
                    image: buildImageProviderFromSource(
                      _heroImageSource,
                      fallbackAsset: 'assets/Gimmick League Poster.jpeg',
                    ),
                    width: double.infinity,
                    height: 280,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _displayTitle,
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 32,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Main Info Box containing Organizer, Description, Date, and Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x0A000000),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Organizer section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: const Color(0xFFF1F5F9),
                              backgroundImage:
                                  _displayOrganizerPhoto.trim().isNotEmpty
                                  ? buildImageProviderFromSource(
                                      _displayOrganizerPhoto,
                                    )
                                  : null,
                              child: _displayOrganizerPhoto.trim().isEmpty
                                  ? const Icon(
                                      Icons.groups_rounded,
                                      size: 24,
                                      color: Color(0xFF94A3B8),
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Diselenggarakan oleh',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.event?.communityName.isNotEmpty ==
                                            true
                                        ? widget.event!.communityName
                                        : _displayOrganizerName,
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 15,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Description section
                        Text(
                          _displayDescription,
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w400,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Date Box
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x080F172A),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                color: Color(0xFF2563EB),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'TANGGAL',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _dateLabel,
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Time Box
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x080F172A),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                color: Color(0xFF2563EB),
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'WAKTU',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _timeLabel,
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 16,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Location
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lokasi',
                      style: TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 20,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Peta lokasi belum tersedia',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _displayLocation,
                      style: const TextStyle(
                        color: Color(0xFF0F172A),
                        fontSize: 16,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _displayAddress,
                      style: const TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 14,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x080F172A),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Obx(() {
                    final totalSlots = editableTotalSlots.value;
                    final availableSlots =
                        (totalSlots - editableJoinedCount.value).clamp(
                          0,
                          totalSlots,
                        );
                    final isCreator = _isCommunityCreator;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Slot:',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 14,
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$availableSlots / $totalSlots',
                                    style: const TextStyle(
                                      color: Color(0xFF0F172A),
                                      fontSize: 20,
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isCreator)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Row 1: Kapasitas Total
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Kapasitas:',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFDBEAFE),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed:
                                                  totalSlots <=
                                                      editableJoinedCount.value
                                                  ? null
                                                  : () {
                                                      editableTotalSlots.value =
                                                          totalSlots - 1;
                                                    },
                                              icon: const Icon(
                                                Icons.remove_rounded,
                                                size: 18,
                                              ),
                                              color: const Color(0xFF2563EB),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                              constraints: const BoxConstraints(
                                                minWidth: 32,
                                                minHeight: 32,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Text(
                                                totalSlots.toString(),
                                                style: const TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 15,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                editableTotalSlots.value =
                                                    totalSlots + 1;
                                              },
                                              icon: const Icon(
                                                Icons.add_rounded,
                                                size: 18,
                                              ),
                                              color: const Color(0xFF2563EB),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                              constraints: const BoxConstraints(
                                                minWidth: 32,
                                                minHeight: 32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Row 2: Pemain Terisi
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Terisi:',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 11,
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEFF6FF),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFDBEAFE),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              onPressed:
                                                  editableJoinedCount.value <= 0
                                                  ? null
                                                  : () {
                                                      editableJoinedCount
                                                              .value =
                                                          editableJoinedCount
                                                              .value -
                                                          1;
                                                    },
                                              icon: const Icon(
                                                Icons.remove_rounded,
                                                size: 18,
                                              ),
                                              color: const Color(0xFF2563EB),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                              constraints: const BoxConstraints(
                                                minWidth: 32,
                                                minHeight: 32,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                              child: Text(
                                                editableJoinedCount.value
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xFF0F172A),
                                                  fontSize: 15,
                                                  fontFamily: 'Lexend',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              onPressed:
                                                  editableJoinedCount.value >=
                                                      totalSlots
                                                  ? null
                                                  : () {
                                                      editableJoinedCount
                                                              .value =
                                                          editableJoinedCount
                                                              .value +
                                                          1;
                                                    },
                                              icon: const Icon(
                                                Icons.add_rounded,
                                                size: 18,
                                              ),
                                              color: const Color(0xFF2563EB),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 6,
                                                  ),
                                              constraints: const BoxConstraints(
                                                minWidth: 32,
                                                minHeight: 32,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (isCreator) ...[
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: isUpdatingSlots.value
                                  ? null
                                  : () async {
                                      isUpdatingSlots.value = true;
                                      final updated = await eventController
                                          .updateEventSlots(
                                            widget.event!.id,
                                            maxSlots: editableTotalSlots.value,
                                            totalSlots:
                                                editableTotalSlots.value,
                                          );
                                      if (updated != null) {
                                        editableTotalSlots.value =
                                            updated.totalSlots ??
                                            editableTotalSlots.value;
                                        editableJoinedCount.value =
                                            updated.joinedUsers.length;
                                      }
                                      isUpdatingSlots.value = false;
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              icon: const Icon(Icons.save_rounded, size: 20),
                              label: Text(
                                isUpdatingSlots.value
                                    ? 'Menyimpan...'
                                    : 'Simpan Slot',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: _openWhatsApp,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                  color: Color(0xFF25D366),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: const Color(
                                  0xFF25D366,
                                ).withValues(alpha: 0.05),
                              ),
                              icon: const Icon(
                                Icons.message_rounded,
                                color: Color(0xFF25D366),
                                size: 20,
                              ),
                              label: const Text(
                                'Hubungi WhatsApp',
                                style: TextStyle(
                                  color: Color(0xFF0F172A),
                                  fontSize: 15,
                                  fontFamily: 'Lexend',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  }),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final String label;

  const _AmenityChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF0F172A),
          fontSize: 12,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _ParticipantCard extends StatelessWidget {
  final String name;
  final String level;

  const _ParticipantCard({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('assets/PP Pemain.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            level,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 10,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _OpenSlotCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF94A3B8), size: 24),
          ),
          const SizedBox(height: 8),
          const Text(
            'Open Slot',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 10,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
