class Assessment {
  Assessment({
    required this.assessmentName,
    required this.text,
    required this.classId,
    required this.assessId,
    required this.className
  });

  final String assessmentName;
  final String text;
  final String classId;
  final String assessId;
  final String className;

  factory Assessment.fromMap(Map<String, dynamic> data) {
    final String assessmentName = data['assessmentName'];
    final String text = data['text'];
    final String classId = data['classId'];
    final String className = data['className'];
    return Assessment(assessmentName: assessmentName, text: text, assessId: '',
    classId: classId, className: className);
  }
}
