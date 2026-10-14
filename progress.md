# 进度报告3（第5周·Dart语言基础二：面向对象与集合）

> 使用方式：在模板上作答，作答完成后将全文复制到雨课堂答题区（图片无法粘贴时在雨课堂编辑器中手工重新上传），并将同一内容存入自己仓库 `lecture3/progress.md`。

## 一、任务理解

本次作业要完成的内容：

1. **案例复现**：按实践指南复现课堂案例 `dart_oo`——用类建模「课程成绩册」：`Student`（私有字段、命名构造 fromJson、校验 setter）与 `GradeBook`（内部 List）；统计功能（平均分、最高分、及格人数、按档分 Map）全部用集合链式方法实现（禁止手写 for 循环）；抽日志能力为 mixin `Logger` 混入 GradeBook；在 `test/` 写至少 2 个单元测试；每步一次 Git 提交。
2. **自主实践基本要求**（5 项）：
   - 类设计合理性：字段封装、命名构造、校验 setter 齐全（`ScoreCard` 示例）；
   - mixin 改造：用混入替代代码中的一层继承并说明理由；
   - 集合统计链：至少 5 个链式方法组合完成一组统计（实际用了 8 个）；
   - test 包单元测试：至少 2 个用例覆盖正常与异常路径；
   - AI 使用标注。
3. **独立研究任务（选做）**：mixin 线性化实验、集合不可变实践、`==` 与 `hashCode` 重写，已全部完成并运行验证。

**验收标准**：`dart run` 统计输出正确；`dart test` 全部通过；代码按步骤 Git 提交（≥3 次）；进度报告十节填写完整；仓库 lecture3 含 README；AI 使用记录真实可追溯。

## 二、环境与工具

| 项目 | 内容 |
|------|------|
| 操作系统 | Windows 11（版本 10.0.26200.9550） |
| Dart SDK | 3.13.5（stable） |
| Flutter | 3.47.6（stable，本次仅用 `flutter doctor` 做环境检查，未运行界面） |
| Git | 2.55.0.windows.5 |
| 运行目标 | 纯 Dart 命令行程序 + 单元测试（`dart run` / `dart test`），不涉及 Web/模拟器/真机 |
| AI 工具 | TraeCode（AI 编码助手）：代码生成、代码审查、错误定位，均经运行验证 |

`flutter doctor` 摘要：Flutter/Android toolchain/Chrome/连接设备均正常；Visual Studio 未安装（本课不需要）。

## 三、过程记录（时间线）

1. `dart create dart_oo` 创建工程；编写 `lib/student.dart`（Student：私有 `_score`、命名构造 fromJson、校验 setter、passed 计算属性）与 `lib/gradebook.dart`（GradeBook：内部 List、构造接收列表、`students` 返回只读视图）；`git commit -m "feat: Student & GradeBook models"`。
2. 为 GradeBook 实现 `average`（fold）、`maxBy`（reduce）、`countPassed`（where+length）、`groupByGrade`（四个 where 筛选）——全部链式方法；改造 `bin/dart_oo.dart` 输出统计；`dart run` 输出正确；`git commit -m "feat: gradebook stats via collection chains"`。
3. 抽出 `mixin Logger` 混入 GradeBook（日志输出 `[GradeBook] 统计开始`）；编写 `test/gradebook_test.dart` 2 个用例（正常统计 + 越界分数抛异常）；`dart test` 全绿；`git commit -m "feat: Logger mixin & unit tests"`。
4. 自主实践：`practice/class_design.dart`（ScoreCard 类设计）、`practice/mixin_refactor.dart`（继承→mixin 改造）、`practice/collection_stats.dart`（8 个链式方法统计）；配套 `test/practice_test.dart` 2 个用例；首次运行发现 import 路径错误，修正后 `dart test` 全绿；`git commit -m "feat: practice tasks (...)"`。
5. 独立研究：`research/mixin_linearization.dart`、`research/immutable_collections.dart`、`research/equality_hashcode.dart`，三个程序均运行验证输出与结论一致。
6. 编写 README、progress.md；`flutter doctor` 环境检查；`git commit -m "docs: research experiments + progress report"`。

## 四、关键代码

### 4.1 集合统计链（本课重点：链式处理 + 禁止手写 for 循环）

```dart
double get average =>
    _students.isEmpty
        ? 0
        : _students.fold<double>(0, (sum, s) => sum + s.score) /
              _students.length;
int get countPassed => _students.where((s) => s.passed).length;
Map<String, List<Student>> groupByGrade() => {
      '优': _students.where((s) => s.score >= 90).toList(),
      '良': _students.where((s) => s.score >= 80 && s.score < 90).toList(),
      '中': _students.where((s) => s.score >= 60 && s.score < 80).toList(),
      '不及格': _students.where((s) => s.score < 60).toList(),
    };
```

逐行解释：`fold<double>(0, (sum, s) => sum + s.score)` 是聚合（累加分数），空列表用 `?:` 防止除零；`where((s) => s.passed)` 筛选后取 `length` 得及格人数；`groupByGrade` 用四个 `where` 各筛一档再 `toList()`，边界（90/80/60）归属由比较符保证。验证方式：`dart run` 输出平均分 72.75、及格 3 人、分档名单正确；`dart test` 覆盖含边界（60/80/90）的用例。（AI 生成，本人核对边界语义后运行与测试验证。）

### 4.2 mixin 改造前后对照（用混入替代一层继承）

**改造前（继承）：**

```dart
class BaseReport { final String title; BaseReport(this.title); }
class LoggedReport extends BaseReport {          // 一层继承只为加日志
  LoggedReport(super.title);
  void log(String msg) => print('[LoggedReport] $msg');
}
```

**改造后（mixin）：**

```dart
mixin Loggable { void log(String msg) => print('[$runtimeType] $msg'); }
class LoggedReport2 extends BaseReport2 with Loggable { LoggedReport2(super.title); }
class WeeklyReport2 extends BaseReport2 with Loggable { WeeklyReport2(super.title); }
```

理由：日志是横切能力，与「报告」没有 is-a 关系，用继承是在硬造父子关系；mixin 可被任意类按需混入，多个报告类共享能力而不互相继承，避免一层套一层的脆弱继承链。验证：`dart run practice/mixin_refactor.dart` 中改造前后输出一致且第二类复用无需再继承。（AI 生成，本人验证输出与理由。）

### 4.3 类设计合理性（ScoreCard，自主实践 1）

```dart
class ScoreCard {
  final String id; final String name;
  double _score; // 私有字段
  ScoreCard(this.id, this.name, [this._score = 0]);
  ScoreCard.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String, name = json['name'] as String,
        _score = _validateScore((json['score'] as num).toDouble());
  static double _validateScore(double v) {
    if (v < 0 || v > 100) throw ArgumentError('分数越界: $v');
    return v;
  }
  double get score => _score;
  set score(double v) => _score = _validateScore(v);
  String get level => _score >= 90 ? '优' : _score >= 80 ? '良' : _score >= 60 ? '中' : '不及格';
  bool get passed => _score >= 60;
}
```

解释：`_score` 下划线前缀实现库内私有（封装）；getter/setter 读写分离，写路径统一校验 0~100；命名构造 `fromJson` 作为数据入口也走同一套 `_validateScore`，杜绝脏数据进入对象；`level`/`passed` 为计算属性，不重复存字段避免不一致。验证：`dart run practice/class_design.dart` 中 setter(101) 与 fromJson(-5) 均抛 ArgumentError。（AI 生成，本人复核校验收敛设计。）

## 五、检查点结果

**检查点 1：`dart run` 统计输出正确。** 在 `dart_oo` 目录执行 `dart run`：

```
[GradeBook] 统计开始
===== 课程成绩册统计 =====
平均分：72.75
最高分：Student(01, 李华, 92.0)
及格人数：3
优：[李华]
良：[]
中：[张伟, 陈静]
不及格：[王芳]
```

（(92+55+78+66)/4 = 72.75 ✓；最高分李华 92 ✓；及格 3 人 ✓；分档名单正确 ✓）

**检查点 2：`dart test` 全部通过。**

```
00:00 +2: test\gradebook_test.dart: GradeBook 统计功能 正常数据统计正确（含分档边界）
00:00 +3: test\gradebook_test.dart: GradeBook 统计功能 越界分数抛异常（setter 校验）
00:00 +4: test\practice_test.dart: 集合统计链 analyze 正常数据统计正确
00:00 +5: test\practice_test.dart: 集合统计链 analyze 异常路径：空列表不崩溃、非法分数被拦截
00:00 +5: All tests passed!
```

（+5：含 4 个用例 + 脚手架自带 1 个；覆盖正常统计、分档边界、越界异常、空列表除零保护、非法分数拦截。）

口头解释 with 顺序对同名方法的影响：mixin 线性化中 with 列表「靠后」的混入者胜出（见 6.1 独立研究实验 X with A,B -> B，Y with B,A -> A）。

## 六、问题与调试

**问题 1：`practice_test.dart` 加载失败（测试文件 import 路径错误）。**
- 现象：`dart test` 报 `test\practice_test.dart: loading test\practice_test.dart`，`Some tests failed`，具体为加载期编译错误。
- 定位过程：对比 `gradebook_test.dart`（用 package: 导入，正常）与 `practice_test.dart`（用相对路径导入 `../../practice/collection_stats.dart`）；发现 `test/` 与 `practice/` 同属 `dart_oo` 包根下，从 `test/practice_test.dart` 到 `practice/` 只需上一级，`../../` 却多走了一层（会指向包外目录）。
- 解决方案：把 import 改为 `../practice/collection_stats.dart`。
- 验证：`dart test` 重新运行，`All tests passed!`（+5）。

**问题 2（设计取舍记录）：fromJson 是否校验分数。**
- 现象：指南里的 `Student.fromJson` 直接给 `_score` 赋值、不校验；若 JSON 含 101 分也会被接受。
- 定位：`_score` 是私有字段，命名构造在初始化列表中直接赋值会绕过 setter 校验。
- 方案：在自主实践的 `ScoreCard.fromJson` 中把入口也接到同一 `_validateScore`（4.3），让所有入口校验收敛；课堂复现保持与指南一致。
- 验证：`ScoreCard.fromJson` 传 -5 抛 ArgumentError（运行输出可见）；`Student` 的 setter 校验由测试覆盖。

## 七、AI 使用记录（TraeCode 清单）

| 用途 | 指令摘要 | AI 输出 | 本人验证方式 |
|------|----------|---------|--------------|
| 建模 Student/GradeBook | 按指南生成 Student（fromJson/校验 setter）与 GradeBook | lib 两个模型文件 | `dart run` 输出正确；`dart test` 通过 |
| 统计功能 | 用集合链式方法实现 average/maxBy/countPassed/groupByGrade，禁止 for | gradebook.dart 统计方法 | 运行输出 72.75 等正确；测试覆盖边界 |
| Logger mixin 与测试 | 抽日志 mixin 混入 GradeBook，写 2 个测试 | mixin + gradebook_test.dart | `dart test` 全绿（+5） |
| 类设计示例 | 生成类设计合理性示例（封装/命名构造/校验 setter） | practice/class_design.dart | 运行输出 setter/fromJson 拦截 ArgumentError |
| mixin 改造 | 用 mixin 替代一层继承并说明理由 | practice/mixin_refactor.dart | 运行输出改造前后一致、第二类复用成功 |
| 统计链扩展 | ≥5 个链式方法组合统计 | practice/collection_stats.dart | 运行输出 + 2 个测试用例 |
| 错误定位 | 分析 practice_test 加载失败原因 | import 路径修正建议 | 修正后 `dart test` All tests passed |

所有 AI 生成代码均经运行/测试验证后才提交。

## 八、证据截图

（本人已将真实运行输出作为文本证据写入本报告；此处截图在提交前补充拍摄，每图配一句话说明。）

1. `dart run` 统计输出截图 —— 平均分 72.75、及格 3 人、分档名单正确。
2. `dart test` 输出截图 —— `All tests passed!`（+5），含边界与异常用例。
3. `flutter doctor` 输出截图 —— Flutter/Android toolchain/Chrome/设备正常。
4. `git log` 提交记录截图 —— 按指南步骤多次提交（文本证据如下）：

```
docs: research experiments + progress report
feat: practice tasks (class design, mixin refactor, stats chain, tests)
feat: Logger mixin & unit tests
feat: gradebook stats via collection chains
feat: Student & GradeBook models
```

## 九、自评（对照作业要求逐项自查）

| 要求 | 完成情况 |
|------|----------|
| 案例复现 dart_oo（代码与指南一致、可运行） | ✅ Student/GradeBook/统计/mixin 齐全，`dart run` 输出正确 |
| 检查点：统计输出正确 | ✅ 平均分/最高分/及格人数/分档全部正确 |
| 检查点：测试全部通过 | ✅ `dart test` All tests passed（+5） |
| Git 规范（按步骤 ≥3 次提交） | ✅ 5 次提交，message 规范 |
| 报告记录（十节模板） | ✅ 本文件 |
| 类设计合理性（字段、构造、封装） | ✅ ScoreCard：私有字段 + fromJson + 校验 setter（4.3） |
| mixin 改造（替代一层继承 + 理由） | ✅ Loggable 替换 LoggedReport 继承（4.2） |
| 集合统计链（≥5 个链式方法） | ✅ 用了 8 个（where/map/fold/sort/take/any/every/firstWhere） |
| test 包单元测试（≥2 用例，正常+异常） | ✅ 4 个用例（正常统计、分档边界、越界异常、空列表/非法分数） |
| AI 使用标注（真实可追溯） | ✅ 第七节 + 各代码注明 |
| 独立研究：mixin 线性化实验 | ✅ X with A,B -> B；Y with B,A -> A；super 沿链向上 |
| 独立研究：集合不可变实践 | ✅ const/unmodifiable 修改均抛 UnsupportedError，总结使用时机 |
| 独立研究：== 与 hashCode 重写 | ✅ contains/Set 去重/Map 取值行为变化验证 |
| 仓库：lecture3 独立仓库含 README | ✅ |

## 十、一句话收获与下一步计划

**一句话收获**：Dart 的类（封装/命名构造/mixin）与集合链式方法（where/map/fold）配合，能让数据建模和处理既安全又简洁；mixin 的 with 顺序决定同名方法线性化结果，`==` 与 `hashCode` 必须配套重写。

**下一步计划**：第 4 课将进入 Flutter 基础（Widget 与界面），需要提前预习 Widget 树、StatelessWidget/StatefulWidget 概念，并复习本课类与集合知识（Widget 是类、界面数据是集合）；遗留问题：mixin 线性化在多层 with 叠加时的完整顺序，以及 `const` 构造在 Widget 复用中的作用，将在后续课程验证。
