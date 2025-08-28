class GeneralException implements Exception {
  final String message;

  const GeneralException(this.message);

  @override
  String toString() => message.toString();
}
