// ============================================================
// 自主实践 1：类设计合理性
// 设计要点：字段封装（私有字段 + getter/setter 校验）、
//          命名构造 fromJson（带校验）、计算属性、toString
// ============================================================

/// 成绩单：比课堂案例更强调「入口处校验」
class ScoreCard {
  final String id;
  final String name;
  double _score; // 私有字段：外部只能通过 getter/setter 访问

  ScoreCard(this.id, this.name, [this._score = 0]);

  // 命名构造：JSON 进来的分数也走同一套校验（_validateScore）
  ScoreCard.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        _score = _validateScore((json['score'] as num).toDouble());

  // 校验逻辑收敛在静态方法，构造、setter、fromJson 共用
  static double _validateScore(double v) {
    if (v < 0 || v > 100) throw ArgumentError('分数越界: $v');
    return v;
  }

  double get score => _score; // getter

  set score(double v) => _score = _validateScore(v); // setter 带校验

  String get level {
    // 计算属性：不额外存字段，由 _score 推导
    if (_score >= 90) return '优';
    if (_score >= 80) return '良';
    if (_score >= 60) return '中';
    return '不及格';
  }

  bool get passed => _score >= 60;

  @override
  String toString() => 'ScoreCard($id, $name, $_score, $level)';
}

void main() {
  print('===== 类设计合理性：ScoreCard =====');
  final a = ScoreCard('01', '李华', 92);
  print('构造+getter   => ${a}');

  a.score = 88; // setter 修改
  print('setter 修改   => ${a}');

  print('-- 校验拦截（try/catch 观察）--');
  try {
    a.score = 101; // 越界
  } catch (e) {
    print('setter(101)   => ${e.runtimeType}: $e');
  }
  try {
    ScoreCard.fromJson({'id': '9', 'name': 'x', 'score': -5}); // 非法 JSON
  } catch (e) {
    print('fromJson(-5)  => ${e.runtimeType}: $e');
  }

  print('');
  print('-- 设计说明 --');
  print('1) _score 私有：库外无法绕过校验直接改分（封装）。');
  print('2) getter/setter：读写分离，写路径统一校验 0~100。');
  print('3) fromJson 命名构造：数据入口也校验，杜绝脏数据进入对象。');
  print('4) level/passed 计算属性：不重复存字段，避免数据不一致。');
  print('5) 校验收敛为静态方法 _validateScore，构造/setter/fromJson 共用，不重复。');
}
