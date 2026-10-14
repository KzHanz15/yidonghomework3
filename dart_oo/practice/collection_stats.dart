// ============================================================
// 自主实践 3：集合统计链
// 一组统计同时组合 ≥5 个链式方法：where / map / fold / sort /
// take / any / every / firstWhere（全部基于 Iterable 高阶方法）
// ============================================================
import 'package:dart_oo/student.dart';

/// 对成绩列表做一套统计，返回摘要 Map
Map<String, Object> analyze(List<Student> students) {
  final passed = students.where((s) => s.passed).toList(); // ① 筛选
  final names = students.map((s) => s.name).toList(); // ② 映射
  final total = students.fold<double>(0, (sum, s) => sum + s.score); // ③ 聚合
  final sorted = [...students]..sort((a, b) => b.score.compareTo(a.score)); // ④ 排序(副本)
  final top3 = sorted.take(3).map((s) => s.name).toList(); // ⑤ 前3名
  final hasFull = students.any((s) => s.score == 100); // ⑥ 判定：任意
  final allPassed = students.every((s) => s.passed); // ⑦ 判定：全部
  final firstPassed = students.firstWhere( // ⑧ 查找 + orElse 兜底
    (s) => s.passed,
    orElse: () => Student('?', '（无）', 0),
  );
  return {
    '总数': students.length,
    '及格人数': passed.length,
    '及格名单': passed.map((s) => s.name).toList(),
    '姓名列表': names,
    '总分': total,
    '平均分': students.isEmpty ? 0 : total / students.length,
    '前三名': top3,
    '有满分': hasFull,
    '全部及格': allPassed,
    '第一位及格者': firstPassed.name,
  };
}

void main() {
  final students = [
    Student('01', '李华', 92),
    Student('02', '王芳', 55),
    Student('03', '张伟', 78),
    Student('04', '陈静', 66),
  ];
  print('===== 集合统计链（8 个链式方法组合）=====');
  final stats = analyze(students);
  stats.forEach((k, v) => print('$k: $v'));
}
