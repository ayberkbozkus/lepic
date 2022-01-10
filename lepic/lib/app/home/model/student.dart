class Students{
  Students({
    // TODO add class id
    required this.studentFirstName,
    required this.studentLastName,
    required this.studentClass,
    required this.studentId,
    required this.classId,
  });
  final String studentFirstName;
  final String studentLastName;
  final String studentClass;
  final String studentId;
  final String classId;



  factory Students.fromMap(Map<String, dynamic> data, String classId) {
    final String studentFirstName = data['studentFirstName'];
    final String studentLastName = data['studentLastName'];
    final String studentClass = data['studentClass'];
    return Students(
      studentId: '',
      classId: classId,
      studentFirstName: studentFirstName,
      studentLastName: studentLastName,
        studentClass: studentClass,
    );
  }
  Map<String, dynamic> toMap(){
    return{
      'classId': classId,
      'studentFirstName': studentFirstName,
      'studentLastname': studentLastName,
      'studentClass': studentClass,

    };
  }
}