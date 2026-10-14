import 'package:dart_oo/gradebook.dart';
import 'package:dart_oo/student.dart';

void main(List<String> arguments) {
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张伟', 78),
    Student('04', '陈静', 66),
  ];
  final book = GradeBook(students);

  print('===== 课程成绩册统计 =====');
  print('平均分：${book.average}');
  print('最高分：${book.maxBy}');
  print('及格人数：${book.countPassed}');
  final byGrade = book.groupByGrade();
  for (final entry in byGrade.entries) {
    final names = entry.value.map((s) => s.name).toList();
    print('${entry.key}：$names');
  }
}
