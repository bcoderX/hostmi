class FaqModel {
  final String answer;
  final String question;
  final String description;

  const FaqModel(
      {required this.question, this.description = "", required this.answer});
}
