// ============================================================
// 自主实践 2：mixin 改造——用混入替代一层继承
// 场景：多个报告类都需要「日志」能力，但彼此不是 is-a 关系。
// ============================================================

// ---- 改造前：用一层继承复用日志能力 ----
class BaseReport {
  final String title;
  BaseReport(this.title);
  void show() => print('报告《$title》');
}

class LoggedReport extends BaseReport {
  LoggedReport(super.title);
  void log(String msg) => print('[LoggedReport] $msg');
}

// 问题：WeeklyReport 也要日志？只能再继承一层，类层次变脆；
//       日志是横切能力，与「报告」没有继承语义。

// ---- 改造后：用 mixin 替代这层继承 ----
mixin Loggable {
  void log(String msg) => print('[$runtimeType] $msg');
}

class BaseReport2 {
  final String title;
  BaseReport2(this.title);
  void show() => print('报告《$title》');
}

class LoggedReport2 extends BaseReport2 with Loggable {
  LoggedReport2(super.title);
}

class WeeklyReport2 extends BaseReport2 with Loggable {
  WeeklyReport2(super.title);
}

void main() {
  print('===== mixin 改造：用混入替代一层继承 =====');
  print('-- 改造前（继承）--');
  LoggedReport('成绩册').log('统计开始');
  print('-- 改造后（mixin）--');
  LoggedReport2('成绩册').log('统计开始');
  WeeklyReport2('周报').log('已发送');

  print('');
  print('-- 理由 --');
  print('1) 日志不是报告的 is-a 关系，用继承是在「硬造父子关系」；');
  print('2) mixin 可被任意类按需混入，多个报告类共享日志能力而互不继承；');
  print('3) 避免一层套一层的脆弱继承链，保持 BaseReport 类层次清晰。');
}
