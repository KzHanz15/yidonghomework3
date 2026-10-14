import 'package:dart_oo/student.dart';
import 'package:test/test.dart';

import '../practice/collection_stats.dart';

void main() {
  group('集合统计链 analyze（自主实践 3）', () {
    test('正常数据统计正确', () {
      final stats = analyze([
        Student('01', '李华', 92),
        Student('02', '王芳', 55),
        Student('03', '张伟', 78),
      ]);
      expect(stats['总数'], 3);
      expect(stats['及格人数'], 2);
      expect(stats['总分'], 225.0);
      expect(stats['平均分'], 75.0);
      expect(stats['前三名'], ['李华', '张伟', '王芳']);
      expect(stats['有满分'], isFalse);
      expect(stats['全部及格'], isFalse);
      expect(stats['第一位及格者'], '李华');
    });

    test('异常路径：空列表不崩溃、非法分数被拦截', () {
      final empty = analyze([]);
      expect(empty['总数'], 0);
      expect(empty['及格人数'], 0);
      expect(empty['平均分'], 0); // 空列表有除零保护
      expect(empty['前三名'], isEmpty);
      // 非法分数：setter 校验抛出 ArgumentError
      final s = Student('01', '李华', 92);
      expect(() => s.score = 101, throwsArgumentError);
    });
  });
}
