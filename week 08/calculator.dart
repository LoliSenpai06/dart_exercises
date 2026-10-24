import 'dart:io';

double calculate(double first, String operator, double second) {
  if (operator == '+') {
    return first + second;
  } else if (operator == '-') {
    return first - second;
  } else if (operator == '*') {
    return first * second;
  } else if (operator == '/') {
    if (second == 0) {
      throw FormatException('Cannot divide by zero.');
    }
    return first / second;
  } else if (operator == '^') {
    if (second < 0 || second != second.roundToDouble()) {
      throw FormatException('For ^, use a non-negative whole number.');
    }

    double answer = 1;
    for (int i = 0; i < second.toInt(); i++) {
      answer *= first;
    }
    return answer;
  } else {
    throw FormatException('That operator is not supported.');
  }
}

void main() {
  for (int i = 1; i <= 3; i++) {
    print('\nCalculation $i of 3');
    stdout.write('First number: ');
    String firstInput = stdin.readLineSync() ?? '';

    stdout.write('Operator (+, -, *, /, ^): ');
    String operator = stdin.readLineSync() ?? '';

    stdout.write('Second number: ');
    String secondInput = stdin.readLineSync() ?? '';

    try {
      double first = double.parse(firstInput);
      double second = double.parse(secondInput);
      double answer = calculate(first, operator, second);

      print('Answer: $answer');

      if (answer > 0) {
        print('The answer is positive.');
      } else if (answer < 0) {
        print('The answer is negative.');
      } else {
        print('The answer is zero.');
      }
    } on FormatException catch (error) {
      print('Could not calculate: ${error.message}');
    }
  }
}
