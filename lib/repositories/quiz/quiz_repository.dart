import 'dart:io';
import 'package:dio/dio.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:quiz_app/enums/difficulty.dart';
import 'package:quiz_app/models/failure_model.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/repositories/quiz/base_quiz_repository.dart';

class QuizRepository extends BaseQuizRepository {
  final Dio dio;

  QuizRepository(this.dio);

  @override
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  }) async {
    try {
      final queryParameters = {
        'type': 'multiple',
        'amount': numQuestions,
        'category': categoryId,
      };

      if (difficulty != Difficulty.any) {
        queryParameters.addAll(
          {
            'difficulty': EnumToString.convertToString(difficulty),
          },
        );
      }

      final response = await dio.get(
        'https://opentdb.com/api.php',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final data = Map<String, dynamic>.from(response.data);
        final results = List<Map<String, dynamic>>.from(data['results'] ?? []);
        if (results.isNotEmpty) {
          return results.map((e) => Question.fromMap(e)).toList();
        }
      }
      return [];
    } on DioException catch (err) {
      throw Failure(message: err.response?.statusMessage);
    } on SocketException {
      throw const Failure(message: 'Please check your connection.');
    }
  }
}
