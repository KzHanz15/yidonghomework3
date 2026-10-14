import 'student.dart';

/// 成绩册：内部持有学生列表，构造时接收列表
class GradeBook {
  final List<Student> _students;

  GradeBook(this._students);

  List<Student> get students => List.unmodifiable(_students);
}
