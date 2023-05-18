
# Explain
This is a linter rule which should help to force and manipulation with null variables.
Sucha as dart and flutter doesen't have a check if statement for null variables, we decided to create this plugin to help community with resolve this problem.

When developers writing:
``
int? s;
s!.hashCode;
``
The linter rule should show that they should check if this varibale isn't null. You probably do not need this to use ofter,only partly when you have null check operators problems or crashes on null variable check.

# Info
The lint rule `null_check_before_non_null_assertion` does not exist in the default Dart linter rules. It seems that there is no built-in lint rule specifically designed to enforce checking nullability before using the non-null assertion operator (!) in Dart.

To achieve the desired behavior, you can consider using a static analysis tool like the Dart static analysis tool (dartanalyzer) with custom static analysis rules. You can write custom rules to analyze your code and enforce the desired behavior.

The problem being addressed in this thread is the development of a custom lint rule using the custom_lint package in Flutter. The goal is to create a lint rule named "null_check_before_non_null_assertion" that detects when developers use the null operator without checking for null values, and report an error in the code. The desired behavior is to prompt developers to add a null check before using the null operator to prevent potential null pointer exceptions. The code snippets and explanations provided in this thread aim to guide the implementation of this custom lint rule.

# Example 

https://github.com/followthemoney1/null_check_before_non_null_assertion/assets/8526612/828e2366-3387-479e-ac59-0a5af3ffc466

