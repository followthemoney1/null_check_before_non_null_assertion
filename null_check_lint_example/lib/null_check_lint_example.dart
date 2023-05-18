import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

/// This is the entrypoint of our plugin.
/// All plugins must specify a `createPlugin` function in their `lib/<package_name>.dart` file
PluginBase createPlugin() => _NullCheckableLint();

/// The class listing all the [LintRule]s and [Assist]s defined by our plugin.
class _NullCheckableLint extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        NullCheckBeforeNonNullAssertion(),
      ];

  // @override
  // List<Assist> getAssists() => [];
}

class NullCheckBeforeNonNullAssertion extends DartLintRule {
  NullCheckBeforeNonNullAssertion() : super(code: _lintCode);

  static const _lintCode = LintCode(
    name: 'null_check_before_non_null_assertion',
    problemMessage: 'Use `if(s!=null) s?.length;` instead of `s!.length;`',
    errorSeverity: ErrorSeverity.ERROR,
  );

  @override
  void run(CustomLintResolver resolver, ErrorReporter reporter, CustomLintContext context) {
    List<dynamic> latestVariable = [];
    context.registry.addIfStatement((node) {
      final condition = node.expression;
      if (condition is BinaryExpression) {
        final leftOperand = condition.leftOperand;
        final rightOperand = condition.rightOperand;
        if (leftOperand is SimpleIdentifier) {
          //mark: checking the tpe of expression, if type is not equall [!=]
          if (condition.operator.type == TokenType.BANG_EQ || rightOperand is Null) {
            //
            // reporter.reportErrorForNode(code, node);
            latestVariable.add(leftOperand.name);
            // latestVariable.add(leftOperand.name);
            // reporter.reportErrorForOffset(code, offset, length)
          } else {
            latestVariable.remove(leftOperand.name);
          }
        }
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
          if (!latestVariable.contains(operand.name))
            // final sourceRange = SourceRange(offset, length);
            reporter.reportErrorForOffset(code, offset, length);
          else
            print('');
        }
      }
    });

    // if (node.operator.lexeme == '!' && node.operand is SimpleIdentifier) {
    //   final operand = node.operand as SimpleIdentifier;
    //   final element = operand.staticElement;
    //
    //   final type = operand.staticType;
    //   if (type != null && type.nullabilitySuffix == NullabilitySuffix.star) {
    //     final offset = node.operator.offset;
    //     final length = node.operator.length;
    //     final sourceRange = SourceRange(offset, length);
    //     reporter.reportErrorForElement(code, element!);
    //   }
    //   // reporter.reportErrorForElement(code, element!);
    // }
  }

  /// [LintRule]s can optionally specify a list of quick-fixes.
  ///
  /// Fixes will show-up in the IDE when the cursor is above the warning. And it
  /// should contain a message explaining how the warning will be fixed.
  @override
  List<Fix> getFixes() => [];
}
//
// class NullCheckBeforeNonNullAssertionVisitor extends RecursiveAstVisitor<void> {
//   final ErrorReporter reporter;
//
//   NullCheckBeforeNonNullAssertionVisitor(this.reporter);
//
//   @override
//   void visitPostfixExpression(PostfixExpression node) {
//     if (node.operator.lexeme == '!' && node.operand is SimpleIdentifier) {
//       final operand = node.operand as SimpleIdentifier;
//       final type = operand.staticType;
//       if (type != null && type.isDartCoreNull) {
//         reporter.reportErrorForElement(code, node.readElement);
//       }
//     }
//     super.visitPostfixExpression(node);
//   }
// }
