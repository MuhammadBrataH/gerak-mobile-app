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
  final RxSet<String> currentSports = <String>{}.obs;
  final Rxn<DateTime> currentDate = Rxn<DateTime>();
  final RxnString currentActivityType = RxnString('match');
  Timer? _filterDebounce;

  EventController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  @override
  void onInit() {
    super.onInit();
    fetchEvents(activityType: 'match');
  }

  Future<({List<EventModel> events, int total})> _fetchEventsPage({
    String? city,
    String? district,
    String? sport,
    String? createdBy,
    String? activityType,
    int page = 1,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (city != null && city.isNotEmpty) {
      query['city'] = city;
    }
    if (district != null && district.isNotEmpty) {
      query['district'] = district;
    }
    if (sport != null && sport.isNotEmpty) {
      query['sport'] = sport;
    }
    if (createdBy != null && createdBy.isNotEmpty) {
      query['createdBy'] = createdBy;
    }
    if (activityType != null && activityType.isNotEmpty) {
      query['activityType'] = activityType;
    }

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/events',
      queryParameters: query,
    );

    final data = response.data ?? const <String, dynamic>{};
    final items = data['events'];
    final total = data['total'];

    final parsed = items is List
        ? items
              .whereType<Map<String, dynamic>>()
              .map(EventModel.fromJson)
              .where(
                (event) =>
                    event.activityType != 'post' || activityType == 'post',
              )
              .toList()
        : <EventModel>[];

    return (events: parsed, total: total is int ? total : parsed.length);
  }

  Future<void> fetchEvents({
    String? city,
    String? district,
    Set<String>? sports,
    DateTime? date,
    String? activityType,
    int page = 1,
  }) async {
    isLoading.value = true;
    try {
      final effectiveActivityType =
          activityType ?? currentActivityType.value ?? 'match';
      final effectiveSports = sports ?? currentSports.toSet();
      final effectiveDate = date ?? currentDate.value;
      final apiSport = effectiveSports.length == 1
          ? effectiveSports.first
          : null;

      if (page <= 1) {
        currentCity.value = city;
        currentDistrict.value = district;
        currentSports
          ..clear()
          ..addAll(effectiveSports);
        currentDate.value = effectiveDate;
        currentActivityType.value = effectiveActivityType;
      }

      final result = await _fetchEventsPage(
        city: city,
        district: district,
        sport: apiSport,
        activityType: effectiveActivityType,
        page: page,
      );

      final filtered = _applyLocalFilters(
        result.events,
        sports: effectiveSports,
        date: effectiveDate,
      );

      if (page <= 1) {
        events.assignAll(filtered);
      } else {
        events.addAll(filtered);
      }

      currentPage.value = page;
      hasMore.value = events.length < result.total;
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
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
      page: currentPage.value + 1,
    );
  }

  Future<void> resetFilters() async {
    currentCity.value = null;
    currentDistrict.value = null;
    currentSports.clear();
    currentDate.value = null;
    currentActivityType.value = 'match';
    await fetchEvents(page: 1, activityType: 'match');
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
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
      page: 1,
    );
  }

  Future<List<EventModel>> fetchEventsAsList({
    String? city,
    String? district,
    Set<String>? sports,
    DateTime? date,
    String? createdBy,
    String? activityType,
    int page = 1,
    int limit = 50,
  }) async {
    final result = await _fetchEventsPage(
      city: city,
      district: district,
      sport: sports != null && sports.length == 1 ? sports.first : null,
      createdBy: createdBy,
      activityType: activityType,
      page: page,
      limit: limit,
    );
    return _applyLocalFilters(result.events, sports: sports, date: date);
  }

  List<EventModel> _applyLocalFilters(
    List<EventModel> source, {
    Set<String>? sports,
    DateTime? date,
  }) {
    final normalizedSports = sports
        ?.map((sport) => sport.toLowerCase())
        .toSet();

    return source.where((event) {
      if (normalizedSports != null && normalizedSports.isNotEmpty) {
        if (!normalizedSports.contains(event.sport.toLowerCase())) {
          return false;
        }
      }

      if (date != null) {
        final start = event.startTime;
        if (start == null) {
          return false;
        }
        if (start.year != date.year ||
            start.month != date.month ||
            start.day != date.day) {
          return false;
        }
      }

      return true;
    }).toList();
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

    if (currentSports.isNotEmpty) {
      final normalized = currentSports
          .map((sport) => sport.toLowerCase())
          .toSet();
      if (!normalized.contains(event.sport.toLowerCase())) {
        return false;
      }
    }

    final date = currentDate.value;
    if (date != null) {
      final start = event.startTime;
      if (start == null) {
        return false;
      }
      if (start.year != date.year ||
          start.month != date.month ||
          start.day != date.day) {
        return false;
      }
    }

    return true;
  }

  void setSelectedSports(Set<String> sports) {
    currentSports
      ..clear()
      ..addAll(sports);
    fetchEventsDebounced(
      city: currentCity.value,
      district: currentDistrict.value,
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
    );
  }

  void toggleSportSelection(String sportKey) {
    if (currentSports.contains(sportKey)) {
      currentSports.remove(sportKey);
    } else {
      currentSports.add(sportKey);
    }
    fetchEventsDebounced(
      city: currentCity.value,
      district: currentDistrict.value,
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
    );
  }

  void setSelectedDate(DateTime? date) {
    currentDate.value = date;
    fetchEventsDebounced(
      city: currentCity.value,
      district: currentDistrict.value,
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
    );
  }

  void applyFilters({String? city, String? district}) {
    fetchEventsDebounced(
      city: city ?? currentCity.value,
      district: district ?? currentDistrict.value,
      sports: currentSports.toSet(),
      date: currentDate.value,
      activityType: currentActivityType.value,
    );
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
    String activityType = 'match',
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
        'activityType': activityType,
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
        sports: currentSports.toSet(),
        date: currentDate.value,
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
    Set<String>? sports,
    DateTime? date,
    String? activityType,
    int page = 1,
  }) {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(const Duration(milliseconds: 500), () {
      fetchEvents(
        city: city,
        district: district,
        sports: sports,
        date: date,
        activityType: activityType,
        page: page,
      );
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
