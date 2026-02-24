import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/application/token_service.dart';
import '../../features/auth/data/auth_repository.dart'; // for kBackendBaseUrl

// Expose ApiClient via Riverpod
final apiClientProvider = Provider<ApiClient>((ref) {
  final tokenService = ref.watch(tokenServiceProvider);
  final authRepository = ref.watch(authRepositoryProvider);
  return ApiClient(tokenService, authRepository);
});

class ApiClient {
  final TokenService _tokenService;
  final AuthRepository _authRepository;
  final http.Client _client = http.Client();

  ApiClient(this._tokenService, this._authRepository);

  /// Performs a standardized HTTP GET request with authorization.
  Future<http.Response> get(String endpoint) async {
    return _sendRequest('GET', endpoint);
  }

  /// Performs a standardized HTTP POST request with authorization.
  Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest('POST', endpoint, body: body);
  }

  /// Performs a standardized HTTP PUT request with authorization.
  Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    return _sendRequest('PUT', endpoint, body: body);
  }

  /// Performs a standardized HTTP DELETE request with authorization.
  Future<http.Response> delete(String endpoint) async {
    return _sendRequest('DELETE', endpoint);
  }

  /// Internal request handler that adds headers and handles token refresh.
  Future<http.Response> _sendRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    String? accessToken = await _tokenService.getAccessToken();

    final uri = Uri.parse('$kBackendBaseUrl$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      if (accessToken != null) 'Authorization': 'Bearer $accessToken',
    };

    http.Response response = await _executeHttp(method, uri, headers, body);

    // If Unauthorized (Token Expired), try to refresh token and retry
    if (response.statusCode == 401) {
      final refreshToken = await _tokenService.getRefreshToken();
      if (refreshToken != null) {
        try {
          final refreshData = await _authRepository.refreshTokens(refreshToken);
          final newAccessToken = refreshData['accessToken'];
          final newRefreshToken = refreshData['refreshToken'];

          // Save new tokens
          await _tokenService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          // Retry the original request with new access token
          headers['Authorization'] = 'Bearer $newAccessToken';
          response = await _executeHttp(method, uri, headers, body);
        } catch (e) {
          // If refresh fails too, return the original 401 response so UI can handle app logout
          return response;
        }
      }
    }

    return response;
  }

  Future<http.Response> _executeHttp(
    String method,
    Uri uri,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) {
    final bodyJson = body != null ? jsonEncode(body) : null;

    switch (method) {
      case 'GET':
        return _client.get(uri, headers: headers);
      case 'POST':
        return _client.post(uri, headers: headers, body: bodyJson);
      case 'PUT':
        return _client.put(uri, headers: headers, body: bodyJson);
      case 'DELETE':
        return _client.delete(uri, headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
}
