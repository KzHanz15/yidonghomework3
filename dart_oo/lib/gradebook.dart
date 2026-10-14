import 'student.dart';

/// 成绩册：内部持有学生列表，构造时接收列表
class GradeBook {
  final List<Student> _students;

  GradeBook(this._students);

  List<Student> get students => List.unmodifiable(_students);

  // 平均分：fold 聚合（禁止手写 for 循环）
  double get average => _students.isEmpty
      ? 0
      : _students.fold<double>(0, (sum, s) => sum + s.score) / _students.length;

  // 最高分学生：reduce 归约
  Student? get maxBy {
    if (_students.isEmpty) return null;
    return _students.reduce((a, b) => a.score >= b.score ? a : b);
  }

  // 及格人数：where 筛选 + length
  int get countPassed => _students.where((s) => s.passed).length;

  // 按优良中分档返回 Map：四个 where 筛选
  Map<String, List<Student>> groupByGrade() => {
    '优': _students.where((s) => s.score >= 90).toList(),
    '良': _students.where((s) => s.score >= 80 && s.score < 90).toList(),
    '中': _students.where((s) => s.score >= 60 && s.score < 80).toList(),
    '不及格': _students.where((s) => s.score < 60).toList(),
  };
}
