// ============================================================
// 独立研究 3：重写 == 与 hashCode 后，验证 List.contains 与 Set 去重
// ============================================================

class Point {
  final int x;
  final int y;
  Point(this.x, this.y);

  // 值相等：同为 Point 且 x、y 相等
  @override
  bool operator ==(Object other) =>
      other is Point && other.x == x && other.y == y;

  // 与 == 配套：相等的对象必须 hashCode 相同，否则 Set/Map 会出 bug
  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Point($x, $y)';
}

// 对照组：没有重写 == 的类（默认按对象身份比较）
class NoEqPoint {
  final int x;
  final int y;
  NoEqPoint(this.x, this.y);
}

void main() {
  print('===== equality 与 hashCode 重写实验 =====');
  final p1 = Point(1, 2);
  final p2 = Point(1, 2);
  final n1 = NoEqPoint(1, 2);
  final n2 = NoEqPoint(1, 2);

  print('-- 默认行为（NoEqPoint，未重写 ==）--');
  print('n1 == n2                      => ${n1 == n2}'); // false（身份比较）
  print('[n1].contains(n2)             => ${[n1].contains(n2)}'); // false
  print('<NoEqPoint>{n1, n2}.length    => ${<NoEqPoint>{n1, n2}.length}'); // 2（不去重）

  print('');
  print('-- 重写 == 与 hashCode 后（Point）--');
  print('p1 == p2                      => ${p1 == p2}'); // true
  print('[p1].contains(p2)             => ${[p1].contains(p2)}'); // true
  print('<Point>{p1, p2}.length        => ${<Point>{p1, p2}.length}'); // 1（去重）
  print('p1.hashCode == p2.hashCode    => ${p1.hashCode == p2.hashCode}'); // true（必须一致）
  print('{p1: "A"}[p2]                 => ${<Point, String>{p1: 'A'}[p2]}'); // A（Map 用 hashCode 定位）

  print('');
  print('-- 结论 --');
  print('1) 不重写 ==：List.contains / Set 去重 / Map 取值都按对象身份（引用）比较，');
  print('   两个内容相同的对象被视为不同。');
  print('2) 重写 == 后 List.contains 变为值比较；再重写 hashCode 后 Set 才能正确去重。');
  print('3) == 与 hashCode 必须配套：相等的对象 hashCode 必须相同，否则 Set/Map 失效。');
  print('4) hashCode 用 Object.hash(x, y) 组合，简单且不踩坑。');
}
