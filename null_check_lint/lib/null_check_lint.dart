import 'dart:math';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:logger/logger.dart';

/// This is the entrypoint of our plugin.
/// All plugins must specify a `createPlugin` function in their `lib/<package_name>.dart` file
PluginBase createPlugin() => _NullCheckableLint();
var logger = Logger();

/// The class listing all the [LintRule]s and [Assist]s defined by our plugin.
class _NullCheckableLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        NullCheckBeforeNonNullAssertion(),
      ];

  @override
  List<Assist> getAssists() => [];
}

class NullCheckBeforeNonNullAssertion extends DartLintRule {
  NullCheckBeforeNonNullAssertion() : super(code: _lintCode);

  static const _lintCode = LintCode(
    name: 'null_check_lint_code',
    problemMessage: 'Use `if(s!=null) s?.length;` instead of `s!.length;`',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    List latestVariable = [];
    // bool expressionExist = true;
    // context.registry.addPrefixExpression((node) {
    //   reporter.reportErrorForNode(code, node);
    // });

    // context.registry.addPropertyAccess((node) {
    //   final target = node.target;
    //
    //   final getter = node.propertyName is SimpleIdentifier && (node.propertyName as SimpleIdentifier).inGetterContext();
    //
    //   if (node is! SimpleIdentifier) {
    //     reporter.reportErrorForNode(code, node);
    //     return;
    //   }
    //   if (getter is! PropertyAccessorElement) {
    //     reporter.reportErrorForNode(code, node);
    //     return;
    //   }
    // });
    context.registry.addIfStatement((node) {
      var condition = node.expression;
      var getter = condition.staticParameterElement;

      // The accessor must be a getter, and it must be synthetic.
      // if (!(getter!.isGetter || getter!.isSynthetic)) {
      //   return;
      // }

      // The variable must be not synthetic, and have to setter yet.
      // var variable = getter.variable;
      // if (variable.isSynthetic || variable.setter != null) {
      //   return;
      // }
      // if (condition is PropertyAccess) {
      //   reporter.reportErrorForNode(code, node);
      // }
      if (condition is BinaryExpression) {
        final leftOperand = condition.leftOperand;
        final rightOperand = condition.rightOperand;

        //mark: checking the tpe of expression, if type is not equall [!=]
        final operand = [
          TokenType.BANG_EQ,
          TokenType.QUESTION,
          TokenType.EQ_EQ,
          TokenType.QUESTION_PERIOD,
          TokenType.QUESTION_QUESTION,
          // TokenType.all
        ].contains(condition.operator.type);
        final additionalParams = rightOperand is Null;

        if (leftOperand is SimpleIdentifier) {
          // if (operand || additionalParams) {
          //   //!reqOperators || additionalParams ||
          //   latestVariable.add(leftOperand.name);
          //   // reporter.reportErrorForNode(code, node);
          // } else {
          //   latestVariable.remove(leftOperand.name);
          // }
        } else if (rightOperand is LibraryIdentifier) {
          reporter.reportErrorForNode(code, node);
        }
      }
      // else if (node is! PropertyAccessorElement) {
      //   if (getter != null) {
      //     reporter.reportErrorForNode(code, node);
      //     latestVariable.remove(getter.name);
      //   }
      // }
      // final target = node.target;
      //
      // final getter = node.propertyName is SimpleIdentifier && (node.propertyName as SimpleIdentifier).inGetterContext();
      //
      // if (node is! SimpleIdentifier) {
      //   reporter.reportErrorForNode(code, node);
      //   return;
      // }
      // if (getter is! PropertyAccessorElement) {
      //   reporter.reportErrorForNode(code, node);
      //   return;
      // }
      // reporter.reportErrorForNode(code, node);
    });
    context.registry.addIfElement((node) {
      final condition = node.expression;
      if (condition is ConditionalExpression) {
        // condition = (node.expression as NullLiteral).;
        reporter.reportErrorForNode(code, node);
      }
    });
    //else we doing check
    context.registry.addPostfixExpression((node) {
      if (node.operator.lexeme == '!' && node.operand is SimpleIdentifier) {
        final operand = node.operand as SimpleIdentifier;
        final element = operand.staticElement;
        if (element is VariableElement) {
          final offset = node.operator.offset;
          final length = node.operator.length;
          if (latestVariable.contains(element.name))
            // final sourceRange = SourceRange(offset, length);
            reporter.reportErrorForOffset(code, offset, length);
        }
      }
    });
  }

  /// [LintRule]s can optionally specify a list of quick-fixes.
  ///
  /// Fixes will show-up in the IDE when the cursor is above the warning. And it
  /// should contain a message explaining how the warning will be fixed.
  @override
  List<Fix> getFixes() => [];
}
