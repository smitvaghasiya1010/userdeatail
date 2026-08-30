import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/user.dart';

/// Custom exception class for user service errors.
class UserServiceException implements Exception {
  final String message;
  final int? statusCode;

  UserServiceException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

/// Service class responsible for fetching user data from the REST API.
class UserService {
  static const String _defaultUrl = 'https://jsonplaceholder.typicode.com/users';

  final http.Client _client;
  final String _baseUrl;

  UserService({http.Client? client, String baseUrl = _defaultUrl})
      : _client = client ?? http.Client(),
        _baseUrl = baseUrl;

  /// Fetches the list of users from the JSONPlaceholder API.
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _client
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        if (decodedData is List) {
          return decodedData
              .map((item) => User.fromJson(item as Map<String, dynamic>))
              .toList();
        } else {
          throw UserServiceException('Unexpected data format received from server.');
        }
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        throw UserServiceException(
          'Client error (${response.statusCode}). Please try again later.',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode >= 500) {
        throw UserServiceException(
          'Server error (${response.statusCode}). Please try again later.',
          statusCode: response.statusCode,
        );
      } else {
        throw UserServiceException(
          'Failed to load users (Status code: ${response.statusCode}).',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw UserServiceException('No internet connection. Please check your network.');
    } on http.ClientException {
      throw UserServiceException('Network communication error. Please try again.');
    } on TimeoutException {
      throw UserServiceException('Connection timed out. Please try again.');
    } on FormatException {
      throw UserServiceException('Invalid response format received from server.');
    } on UserServiceException {
      rethrow;
    } catch (e) {
      throw UserServiceException('Something went wrong. Please try again.');
    }
  }
}
