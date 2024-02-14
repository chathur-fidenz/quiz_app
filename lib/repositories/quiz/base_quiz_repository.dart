import 'package:quiz_app/enums/difficulty.dart';
import 'package:quiz_app/models/question_model.dart';

abstract class BaseQuizRepository {
  Future<List<Question>> getQuestions({
    required int numQuestions,
    required int categoryId,
    required Difficulty difficulty,
  });
}
