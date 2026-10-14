// ============================================================
// 独立研究 1：mixin 线性化实验
// 两个 mixin 定义同名方法 who()，改变 with 顺序，观察调用哪个。
// ============================================================

mixin A {
  void who() => print('A 的方法');
}

mixin B {
  void who() => print('B 的方法');
}

class X with A, B {}
class Y with B, A {}
class Z with A, B {
  @override
  void who() {
    super.who(); // 用 super 访问线性化链上的下一个实现
    print('Z 覆盖后');
  }
}

void main() {
  print('===== mixin 线性化实验 =====');
  print('class X with A, B => X().who() 调用：');
  X().who(); // 预期 B 胜出（with 列表中靠后者胜出）
  print('');
  print('class Y with B, A => Y().who() 调用：');
  Y().who(); // 预期 A 胜出
  print('');
  print('class Z with A, B（Z 自己 override 并调用 super.who()）=>');
  Z().who();

  print('');
  print('-- 结论 --');
  print('1) 多个 mixin 的同名方法，with 顺序中「靠后」的混入者胜出（X->B, Y->A）。');
  print('2) 线性化顺序：类本身 -> 最后一个 mixin -> ... -> 第一个 mixin -> 基类。');
  print('3) 在类里 override 同名方法并用 super.who()，会沿着该线性化链继续往上找。');
  print('4) 实际中避免两个 mixin 定义同名方法，否则行为依赖 with 顺序，易踩坑。');
}
