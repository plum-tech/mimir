/// 定义一个对象的规则接口
abstract class Rule<T> {
  /// 该规则是否接受该对象
  bool accept(T object);
}

/// 常量规则(对于任意对象的accept均为恒定的布尔值，默认布尔值为假)
class ConstRule<T> implements Rule<T> {
  final bool constant;
  const ConstRule([this.constant = false]);
  @override
  bool accept(T object) {
    return constant;
  }
}

/// 相等规则，一个规则中仅能匹配和它相等的对象
class EqualRule<T> implements Rule<T> {
  final T value;

  const EqualRule(this.value);
  @override
  bool accept(T object) {
    return object == value;
  }
}

/// 规则交集运算
class RuleCross<T> implements Rule<T> {
  final Iterable<Rule<T>> rules;
  const RuleCross(this.rules);

  @override
  bool accept(T object) {
    for (final rule in rules) {
      /// 规则交集为要求每个规则都能够接受
      /// 即不存在一个规则，使他不能接受
      /// 即如果存在一个不能接受的对象，那么传入值一定不符合规则交集
      if (!rule.accept(object)) {
        return false;
      }
    }
    return true;
  }
}

/// 规则并集运算
class RuleSum<T> implements Rule<T> {
  final Iterable<Rule<T>> rules;
  const RuleSum(this.rules);

  @override
  bool accept(T object) {
    for (final rule in rules) {
      // 只要存在一个能接受，那就整体接受
      if (rule.accept(object)) {
        return true;
      }
    }
    return false;
  }
}

/// 规则补集运算
/// 即原规则-排除规则=source-exclude
class RuleExclude<T> implements Rule<T> {
  /// 源规则是必须规则
  final Rule<T> source;

  /// 若exclude未指定，则该规则恒未假，即与源规则相等
  final Rule<T> exclude;
  const RuleExclude({
    required this.source,
    this.exclude = const ConstRule(),
  });

  /// 若原规则成立，排除规则也成立，那么结果就是不成立
  /// 若原规则成立，排除规则不成立，那么结果就是成立
  /// 若原规则不成立，那么排除后任意规则均不成立(具备短路性质)
  @override
  bool accept(T object) {
    // 若原规则不成立，那么排除后任意规则均不成立(具备短路性质)
    if (!source.accept(object)) {
      return false;
    }

    /// 若原规则成立，排除规则不成立，那么结果就是成立
    if (source.accept(object) && (!exclude.accept(object))) {
      return true;
    }

    /// 最后一种情况，若原规则成立，排除规则也成立，那么结果就是不成立
    return false;
  }
}

/// 正则表达式的匹配规则
class RegExpRule implements Rule<String> {
  final RegExp regExp;
  const RegExpRule(this.regExp);
  @override
  bool accept(String object) {
    return regExp.hasMatch(object);
  }
}

/// 规则的链式运算
/// 规则之间可通过交并补运算转化出其他规则
class ChainRule<T> implements Rule<T> {
  final Rule<T> currentRule;
  const ChainRule(this.currentRule);

  /// 集合交集
  ChainRule<T> cross(Rule<T> otherRule) {
    return ChainRule(
      RuleCross(
        <Rule<T>>[
          currentRule,
          otherRule,
        ],
      ),
    );
  }

  ChainRule<T> sum(Rule<T> otherRule) {
    return ChainRule(
      RuleSum(
        <Rule<T>>[
          currentRule,
          otherRule,
        ],
      ),
    );
  }

  ChainRule<T> exclude(Rule<T> otherRule) {
    return ChainRule(
      RuleExclude(
        source: currentRule,
        exclude: otherRule,
      ),
    );
  }

  @override
  bool accept(T object) {
    return currentRule.accept(object);
  }
}

typedef RuleFunction<T> = bool Function(T object);

/// 函数式规则
class FunctionalRule<T> implements Rule<T> {
  final RuleFunction<T> ruleFunction;
  const FunctionalRule(this.ruleFunction);
  @override
  bool accept(T object) {
    return ruleFunction(object);
  }
}
