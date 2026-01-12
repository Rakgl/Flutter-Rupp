String? stringMani(String input) {
  final regex = RegExp(r'(\d+mg)');

  final match = regex.firstMatch(input);
  final dosage = match?.group(1);

  return dosage;
}

// to capitalize
String capitalize(String input) {
  if (input.isEmpty) {
    return input;
  }

  final firstChar = input[0].toUpperCase();
  final restOfString = input.substring(1);

  final result = restOfString.replaceAll('_', ' ');

  return '$firstChar$result';
}
