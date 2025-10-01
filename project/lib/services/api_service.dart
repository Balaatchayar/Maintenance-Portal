import 'package:dio/dio.dart';
import '../models/login_model.dart';
import '../models/plant_mapping_model.dart';
import '../models/notification_model.dart';
import '../models/pm_details_model.dart';
import '../models/work_order_model.dart';

class ApiService {
  late final Dio _dio;
  static const String baseUrl = 'http://localhost:3000';

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  Future<LoginResponse> login(String employeeId) async {
    try {
      final response = await _dio.get('/api/maintenance/login/$employeeId');
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PlantMappingResponse> getPlantMapping(String engineerId) async {
    try {
      final response = await _dio.get('/api/maintenance/plant-mapping/$engineerId');
      return PlantMappingResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<NotificationResponse> getNotifications(String plantId) async {
    try {
      final response = await _dio.get('/api/maintenance/notifications/$plantId');
      return NotificationResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<PmDetailsResponse> getPmDetails(String engineerId) async {
    try {
      final response = await _dio.get('/api/maintenance/pm-details/$engineerId');
      return PmDetailsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<WorkOrderResponse> getWorkOrders(String plantId) async {
    try {
      final response = await _dio.get('/api/maintenance/work-orders/$plantId');
      return WorkOrderResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your network connection.';
      case DioExceptionType.connectionError:
        return 'Cannot connect to server. Please check if the server is running.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['error'] ?? 'Unknown error occurred';
        return 'Server error ($statusCode): $message';
      default:
        return 'An unexpected error occurred: ${error.message}';
    }
  }
}