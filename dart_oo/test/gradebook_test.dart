import 'package:dart_oo/gradebook.dart';
import 'package:dart_oo/student.dart';
import 'package:test/test.dart';

void main() {
  group('GradeBook 统计功能', () {
    test('正常数据统计正确（含分档边界）', () {
      final book = GradeBook([
        Student('01', '李华', 92), // 优
        Student('02', '王芳', 55), // 不及格
        Student('03', '张伟', 78), // 中
        Student('04', '陈静', 60), // 中（下边界）
        Student('05', '刘洋', 90), // 优（下边界）
        Student('06', '赵敏', 80), // 良（下边界）
      ]);
      expect(book.average, closeTo(75.83, 0.01));
      expect(book.maxBy!.name, '李华');
      expect(book.countPassed, 5);
      expect(book.groupByGrade()['优']!.length, 2);
      expect(book.groupByGrade()['良']!.length, 1);
      expect(book.groupByGrade()['中']!.length, 2);
      expect(book.groupByGrade()['不及格']!.length, 1);
    });

    test('越界分数抛异常（setter 校验）', () {
      final s = Student('01', '李华', 92);
      expect(() => s.score = 101, throwsArgumentError);
      expect(() => s.score = -1, throwsArgumentError);
      // 合法值仍可正常设置
      s.score = 59.5;
      expect(s.passed, isFalse);
      s.score = 60;
      expect(s.passed, isTrue);
    });
  });
}
