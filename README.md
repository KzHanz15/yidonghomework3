# lecture3 — 课堂作业3（第5周 · Dart语言基础二：面向对象与集合）

本仓库为第 5 周课堂作业的独立项目仓库，对应实践指南三：
用类组织程序（封装、继承、mixin），用集合组织数据（泛型、List/Map/Set、链式处理）。

## 目录结构

```
lecture3/
├── dart_oo/               # 课堂案例复现：dart create dart_oo
│   ├── lib/
│   │   ├── student.dart   # Student：私有字段、命名构造 fromJson、校验 setter
│   │   └── gradebook.dart # GradeBook：集合链式统计 + Logger mixin
│   ├── bin/dart_oo.dart   # main：统计输出
│   ├── test/
│   │   ├── gradebook_test.dart # 案例测试：正常统计 + 越界异常
│   │   └── practice_test.dart  # 实践测试：统计链正常 + 空列表/非法分数
│   ├── practice/          # 自主实践基本要求
│   │   ├── class_design.dart       # 任务1：类设计合理性（ScoreCard）
│   │   ├── mixin_refactor.dart     # 任务2：mixin 替代一层继承
│   │   └── collection_stats.dart   # 任务3：8 个链式方法组合统计
│   └── research/          # 独立研究任务（选做，已全部完成）
│       ├── mixin_linearization.dart # 任务1：mixin 线性化实验
│       ├── immutable_collections.dart # 任务2：不可变集合实践
│       └── equality_hashcode.dart   # 任务3：== 与 hashCode 重写
├── progress.md            # 进度报告三（十节完整填写）
└── README.md
```

## 运行方式

```bash
cd dart_oo
dart run                        # 统计输出
dart test                       # 全部单元测试
dart run practice/class_design.dart
dart run practice/mixin_refactor.dart
dart run practice/collection_stats.dart
dart run research/mixin_linearization.dart
dart run research/immutable_collections.dart
dart run research/equality_hashcode.dart
```

## 环境

- Dart SDK 3.13.5（stable）
- Flutter 3.47.6（stable，仅 flutter doctor 环境检查）
- Git 2.55.0

## 提交记录

按实践指南逐步提交：模型 → 统计链 → mixin 与测试 → 自主实践 → 研究报告与进度报告。
