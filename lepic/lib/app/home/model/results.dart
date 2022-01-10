class Results {
  Results({required this.resultId,
    required this.studentId,
    required this.assessId,
    required this.date,
    required this.totalReadingTime,
    required this.numOfWordsReadPM,
    required this.numOfWordsReadFM,
    required this.numOfCorrectWordsReadPM,
    required this.numOfIncorrectWords});


  final String? resultId;
  final String? studentId;
  final String? assessId;
  final double? totalReadingTime;
  final double? numOfWordsReadPM;
  final int? numOfWordsReadFM;
  final double? numOfCorrectWordsReadPM;
  final int? numOfIncorrectWords;
  final String? date;
}