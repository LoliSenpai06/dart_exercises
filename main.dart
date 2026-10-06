void main() {
  String calculatorTitle = 'Basic calculator';
  int operandA = 45;
  double operandB = 12.5;
  bool isScientificMode = false;

  double sumResult = operandA + operandB;
  int modulusResult = operandA % 7;
  int integerDivisionResult = operandA ~/ 4;

  bool isSumLarge = sumResult > 50.0;
  bool isRemainderZero = modulusResult == 0;

  print('--- $calculatorTitle ---');
  print('Operand A: $operandA | Operand B: $operandB');
  print('Scientific Mode: $isScientificMode');
  print('Addition ($operandA + $operandB): $sumResult');
  print('Modulus ($operandA % 7): $modulusResult');
  print('Integer Division ($operandA ~/ 4): $integerDivisionResult');
  print('Is the sum greater than 50? $isSumLarge');
  print('Is the remainder zero? $isRemainderZero');
}