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
