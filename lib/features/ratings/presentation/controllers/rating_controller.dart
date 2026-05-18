import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/rating_model.dart';

class RatingController extends GetxController {
  final ApiClient _apiClient;
  final RxList<RatingModel> ratings = <RatingModel>[].obs;
  final RxBool isLoading = false.obs;

  RatingController({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<void> createRating(String eventId, int score, String? review) async {
    if (eventId.isEmpty) {
      Get.snackbar('Ratings', 'Event ID is required');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        '/ratings',
        data: {'eventId': eventId, 'score': score, 'review': review},
      );

      final data = response.data ?? const <String, dynamic>{};
      final ratingJson = data['rating'];
      if (ratingJson is Map<String, dynamic>) {
        final created = RatingModel.fromJson(ratingJson);
        ratings.insert(0, created);
      }

      Get.snackbar('Ratings', 'Rating submitted successfully!');
    } on ApiException catch (error) {
      Get.snackbar('Ratings', error.message);
    } catch (_) {
      Get.snackbar('Ratings', 'Failed to create rating');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEventRatings(String eventId) async {
    if (eventId.isEmpty) {
      Get.snackbar('Ratings', 'Event ID is required');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/ratings/event/$eventId',
      );

      final data = response.data ?? const <String, dynamic>{};
      final items = data['ratings'];
      final List<RatingModel> parsed = items is List
          ? items
                .whereType<Map<String, dynamic>>()
                .map(RatingModel.fromJson)
                .toList()
          : <RatingModel>[];
      ratings.assignAll(parsed);
    } on ApiException catch (error) {
      Get.snackbar('Ratings', error.message);
    } catch (_) {
      Get.snackbar('Ratings', 'Failed to load ratings');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserRatings(String userId) async {
    if (userId.isEmpty) {
      Get.snackbar('Ratings', 'User ID is required');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/ratings/user/$userId',
      );

      final data = response.data ?? const <String, dynamic>{};
      final items = data['ratings'];
      final List<RatingModel> parsed = items is List
          ? items
                .whereType<Map<String, dynamic>>()
                .map(RatingModel.fromJson)
                .toList()
          : <RatingModel>[];
      ratings.assignAll(parsed);
    } on ApiException catch (error) {
      Get.snackbar('Ratings', error.message);
    } catch (_) {
      Get.snackbar('Ratings', 'Failed to load ratings');
    } finally {
      isLoading.value = false;
    }
  }
}
