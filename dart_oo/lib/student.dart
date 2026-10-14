/// 学生模型：字段、命名构造、封装（getter/setter + 校验）
class Student {
  final String id;
  final String name;
  double _score; // 私有：下划线前缀，库外不可直接访问

  // 普通构造：可省略第三个参数（默认 0 分）
  Student(this.id, this.name, [this._score = 0]);

  // 命名构造 fromJson：从 Map/JSON 造对象的标准入口
  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        _score = (json['score'] as num).toDouble();

  double get score => _score; // getter

  set score(double v) {
    // setter 带校验
    if (v < 0 || v > 100) throw ArgumentError('分数越界: $v');
    _score = v;
  }

  bool get passed => _score >= 60; // 计算属性

  @override
  String toString() => 'Student($id, $name, $score)';
}
