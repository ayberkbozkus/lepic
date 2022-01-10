
class Classes {
  Classes(
      {required this.Id,
        required this.classLevel,
        required this.className,
        required this.creatorName,
        required this.studentList,
        required this.assesList});
  final String Id;
  final String className;
  final String classLevel;
  final String creatorName;
  final List<dynamic>? studentList;
  final List<dynamic>? assesList;

  factory Classes.fromMap(Map<String, dynamic> data, String documentId) {
    final String className = data['className'];
    final String classLevel = data['classLevel'];
    final String creatorName = data['creatorName'];
    final List<dynamic>? studentList = data['studentList'];
    final List<dynamic>? assesList = data['assesList'];
    return Classes(
        Id: documentId,
        className: className,
        classLevel: classLevel,
        creatorName: creatorName,
        studentList: studentList,
        assesList: assesList);
  }

  Map<String, dynamic> toMap() {
    return {
      'classLevel': classLevel,
      'className': className,
      'creatorName': creatorName,
      'studentList': studentList,
      'assessList' : assesList
    };
  }
}