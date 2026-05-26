import 'dart:async';

import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/event_model.dart';

class EventController extends GetxController {
  final ApiClient _apiClient;
  final RxBool isLoading = false.obs;
  final RxMap<String, bool> eventLoadingStates = <String, bool>{}.obs;
  final RxList<EventModel> events = <EventModel>[].obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;
  final RxnString currentCity = RxnString();
  final RxnString currentDistrict = RxnString();
  final RxnString currentSport = RxnString();
  Timer? _filterDebounce;

  EventController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents({
    String? city,
    String? district,
    String? sport,
    int page = 1,
  }) async {
    isLoading.value = true;
    try {
      if (page <= 1) {
        currentCity.value = city;
        currentDistrict.value = district;
        currentSport.value = sport;
      }

      final query = <String, dynamic>{'page': page};
      if (city != null && city.isNotEmpty) {
        query['city'] = city;
      }
      if (district != null && district.isNotEmpty) {
        query['district'] = district;
      }
      if (sport != null && sport.isNotEmpty) {
        query['sport'] = sport;
      }

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/events',
        queryParameters: query,
      );

      final data = response.data ?? const <String, dynamic>{};
      final items = data['events'];
      final total = data['total'];

      final List<EventModel> parsed = items is List
          ? items
                .whereType<Map<String, dynamic>>()
                .map(EventModel.fromJson)
                .toList()
          : <EventModel>[];

      if (page <= 1) {
        events.assignAll(parsed);
      } else {
        events.addAll(parsed);
      }

      currentPage.value = page;
      if (total is int) {
        hasMore.value = events.length < total;
      } else {
        hasMore.value = parsed.isNotEmpty;
      }
    } on ApiException catch (error) {
      Get.snackbar('Events', error.message);
    } catch (_) {
      Get.snackbar('Events', 'Failed to load events');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadNextPage() async {
    if (isLoading.value || !hasMore.value) {
      return;
    }

    await fetchEvents(
      city: currentCity.value,
      district: currentDistrict.value,
      sport: currentSport.value,
      page: currentPage.value + 1,
    );
  }

  Future<void> resetFilters() async {
    currentCity.value = null;
    currentDistrict.value = null;
    currentSport.value = null;
    await fetchEvents(page: 1);
  }

  Future<void> resetPagination() async {
    if (isLoading.value) {
      return;
    }
    currentPage.value = 1;
    events.clear();
    await fetchEvents(
      city: currentCity.value,
      district: currentDistrict.value,
      sport: currentSport.value,
      page: 1,
    );
  }

  bool _matchesCurrentFilters(EventModel event) {
    final city = currentCity.value;
    if (city != null && city.isNotEmpty) {
      final match = event.city.toLowerCase().contains(city.toLowerCase());
      if (!match) {
        return false;
      }
    }

    final district = currentDistrict.value;
    if (district != null && district.isNotEmpty) {
      final eventDistrict = event.district ?? '';
      final match = eventDistrict.toLowerCase().contains(
        district.toLowerCase(),
      );
      if (!match) {
        return false;
      }
    }

    final sport = currentSport.value;
    if (sport != null && sport.isNotEmpty) {
      if (event.sport.toLowerCase() != sport.toLowerCase()) {
        return false;
      }
    }

    return true;
  }

  Future<EventModel?> createEvent({
    required String name,
    required String sport,
    required String level,
    required DateTime startTime,
    required DateTime endTime,
    required String location,
    required String city,
    required String adminPhone,
    String description = '',
    String? district,
    int? maxSlots,
    int? totalSlots,
    String? imageUrl,
  }) async {
    try {
      final payload = <String, dynamic>{
        'name': name,
        'description': description,
        'sport': sport,
        'level': level,
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'location': location,
        'city': city,
        'district': district ?? '',
        'maxSlots': maxSlots,
        'totalSlots': totalSlots ?? maxSlots,
        'adminPhone': adminPhone,
        'imageUrl': imageUrl ?? '',
      };

      final response = await _apiClient.post<Map<String, dynamic>>(
        '/events',
        data: payload,
      );

      final eventJson = response.data?['event'];
      if (eventJson is! Map<String, dynamic>) {
        Get.snackbar('Events', 'Failed to create event');
        return null;
      }

      final created = EventModel.fromJson(eventJson);

      if (_matchesCurrentFilters(created)) {
        events.insert(0, created);
      }

      await fetchEvents(
        city: currentCity.value,
        district: currentDistrict.value,
        sport: currentSport.value,
        page: 1,
      );

      Get.snackbar('Events', 'Aktivitas berhasil ditambahkan');
      return created;
    } on ApiException catch (error) {
      Get.snackbar('Events', error.message);
      return null;
    } catch (_) {
      Get.snackbar('Events', 'Gagal menambahkan aktivitas');
      return null;
    }
  }

  void fetchEventsDebounced({
    String? city,
    String? district,
    String? sport,
    int page = 1,
  }) {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchEvents(city: city, district: district, sport: sport, page: page);
    });
  }

  @override
  void onClose() {
    _filterDebounce?.cancel();
    super.onClose();
  }

  Future<void> joinEvent(String eventId) async {
    if (_isEventLoading(eventId)) {
      return;
    }
    _setEventLoading(eventId, true);
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/events/$eventId/join',
      );
      _replaceEventFromResponse(response.data);
      Get.snackbar('Events', 'Successfully joined the event!');
    } on ApiException catch (error) {
      Get.snackbar('Events', error.message);
    } catch (_) {
      Get.snackbar('Events', 'Failed to join event');
    } finally {
      _setEventLoading(eventId, false);
    }
  }

  Future<void> leaveEvent(String eventId) async {
    if (_isEventLoading(eventId)) {
      return;
    }
    _setEventLoading(eventId, true);
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/events/$eventId/leave',
      );
      _replaceEventFromResponse(response.data);
      Get.snackbar('Events', 'You left the event');
    } on ApiException catch (error) {
      Get.snackbar('Events', error.message);
    } catch (_) {
      Get.snackbar('Events', 'Failed to leave event');
    } finally {
      _setEventLoading(eventId, false);
    }
  }

  void _replaceEventFromResponse(Map<String, dynamic>? data) {
    final eventJson = data?['event'];
    if (eventJson is! Map<String, dynamic>) {
      return;
    }

    final updated = EventModel.fromJson(eventJson);
    final index = events.indexWhere((event) => event.id == updated.id);
    if (index == -1) {
      return;
    }

    events[index] = updated;
  }

  bool _isEventLoading(String eventId) {
    return eventLoadingStates[eventId] == true;
  }

  bool isEventLoading(String eventId) {
    return _isEventLoading(eventId);
  }

  void _setEventLoading(String eventId, bool isLoading) {
    if (isLoading) {
      eventLoadingStates[eventId] = true;
    } else {
      eventLoadingStates.remove(eventId);
    }
  }
}
