import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:vma_frontend/src/models/visitors.dart';
import 'package:vma_frontend/src/utils/utils.dart';
import 'package:vma_frontend/src/constants/constants.dart';

class VisitorService {
  Future<void> createVisitor({
    required BuildContext context,
    required List<String> names,
    required String? purpose,
    required DateTime startDate,
    required DateTime endDate,
    required bool bringCar,
    required List<String> selectedPlateNumbers,
    required List<Possession> possessions,
    required int numberOfVisitors,
    required bool approved,
    required bool declined,
    required String declineReason,
    required bool isInside,
    required bool hasLeft,
  }) async {
    try {
      Visitor visitor = Visitor(
        numberOfVisitors: numberOfVisitors,
        names: names,
        purpose: purpose,

        startDate: startDate,
        endDate: endDate,
        bringCar: bringCar,
        selectedPlateNumbers: selectedPlateNumbers,
        possessions: possessions,
        approved: approved,
        declined: declined,
        declineReason: declineReason,
        isInside: isInside,
        hasLeft: hasLeft,
      );

      Dio dio = Dio();
      //print("Visitor ${visitor.toJson()}");

      Response response = await dio.post(
        '${Constants.uri}/api/visitors',
        data: visitor.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );
      handleDioResponse(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context, "Visitor Created!");
        },
      );
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e); // Call the handleDioError method
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        print('Unexpected Error: $e');
      }
    }
  }

  Future<void> updateVisitor({
    required BuildContext context,
    required String? visitorId,
    required List<String> names,
    required String? purpose,

    required DateTime startDate,
    required DateTime endDate,
    required bool bringCar,
    required List<String> selectedPlateNumbers,
    required List<Possession> possessions,
    required int numberOfVisitors,
    required bool approved,
    required bool declined,
    required String declineReason,
    required bool isInside,
    required bool hasLeft,
    required 
  }) async {
    try {
      Visitor visitor = Visitor(
        id: visitorId,
        numberOfVisitors: numberOfVisitors,
        names: names,
        purpose: purpose,        
        startDate: startDate,
        endDate: endDate,
        bringCar: bringCar,
        selectedPlateNumbers: selectedPlateNumbers,
        possessions: possessions,
        approved: approved,
        declined: declined,
        declineReason: declineReason,
        isInside: isInside,
        hasLeft: hasLeft,
      );
      Dio dio = Dio();
      Response response = await dio.put(
        '${Constants.uri}/api/visitors/$visitorId',
        data: visitor.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
        ),
      );

      handleDioResponse(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(context, "Visitor Updated!");
        },
      );
    } catch (e) {
      if (e is DioError) {
        handleDioError(context, e);
      } else {
        showSnackBar(context, 'Unexpected Error: $e');
        
      }
    }
  }
Future<void> deleteVisitorById(String visitorId) async {
    final Dio _dio = Dio();

    try {

      final response = await _dio.delete('${Constants.uri}/visitors/$visitorId');

      if (response.statusCode != 200) {
        throw Exception('Failed to delete visitor');
      }
    } catch (error) {
      throw Exception('Failed to delete visitor: $error');
    }
  }
  void handleDioError(BuildContext context, DioError e) {
    String errorMessage;

    switch (e.type) {
      case DioErrorType.cancel:
        errorMessage = "Request to server was cancelled.";
        break;
      case DioErrorType.connectTimeout:
        errorMessage = "Connection timeout with server.";
        break;
      case DioErrorType.sendTimeout:
        errorMessage = "Send timeout in connection with server.";
        break;
      case DioErrorType.receiveTimeout:
        errorMessage = "Receive timeout in connection with server.";
        break;
      case DioErrorType.response:
        if (e.response != null && e.response?.data != null) {
          errorMessage =
              "Error: ${e.response?.statusCode} - ${e.response?.data['message'] ?? e.response?.statusMessage}";
        } else {
          errorMessage =
              "Received invalid status code: ${e.response?.statusCode}";
        }
        break;
      case DioErrorType.other:
        errorMessage =
            "Connection to server failed due to internet connection.";
        break;
      default:
        errorMessage = "Unexpected error occurred.";
        break;
    }

    showSnackBar(context, errorMessage);
    print('Dio Error: $errorMessage');
  }
}
