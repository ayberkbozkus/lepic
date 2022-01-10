
class ApiPath{
  static String classes(String uid,
  String classId) => 'users/$uid/classes/$classId';
  static String user(String uid) => 'users/$uid';
  static String allClasses(String uid) =>'users/$uid/classes';
  static String students(String studentId) => 'students/$studentId';
}