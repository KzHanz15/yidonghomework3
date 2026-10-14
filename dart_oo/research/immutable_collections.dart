// ============================================================
// 独立研究 2：集合不可变实践
// 尝试修改 const 列表 / List.unmodifiable / const Set，记录错误。
// ============================================================

void main() {
  print('===== 集合不可变实践 =====');
  const xs = [1, 2, 3]; // 编译期常量列表
  print('const xs = $xs');
  try {
    xs.add(4);
  } catch (e) {
    print('const 列表 .add(4)    => ${e.runtimeType}: $e');
  }
  try {
    xs[0] = 99;
  } catch (e) {
    print('const 列表 .[0]=99    => ${e.runtimeType}: $e');
  }

  final ys = List.unmodifiable([1, 2, 3]); // 只读视图（元素值可相同，但不可增删改）
  print('List.unmodifiable = $ys');
  try {
    ys.add(4);
  } catch (e) {
    print('unmodifiable .add(4) => ${e.runtimeType}: $e');
  }
  try {
    ys.removeLast();
  } catch (e) {
    print('unmodifiable .removeLast() => ${e.runtimeType}: $e');
  }

  const zs = <String>{'a', 'b'}; // const Set
  print('const Set = $zs');
  try {
    zs.add('c');
  } catch (e) {
    print('const Set .add(c)    => ${e.runtimeType}: $e');
  }

  print('');
  print('-- 总结：不可变的使用时机 --');
  print('1) const 列表/集合：值在编译期固定，适合常量配置（如静态选项表）。');
  print('2) List.unmodifiable：运行期把可变集合「冻结」为只读视图，');
  print('   适合对外暴露内部数据而不想让调用方篡改（本课 GradeBook.students 即此用途）。');
  print('3) 修改不可变集合统一抛 UnsupportedError: Cannot modify an unmodifiable list。');
  print('4) 选择原则：数据不会变就不可变——少一类 bug（意外修改），利于多线程/并发。');
}
