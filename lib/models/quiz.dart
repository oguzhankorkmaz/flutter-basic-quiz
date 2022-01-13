class Quiz {
  String question;
  String answers;
  String correctAnswer;

  Quiz({this.question = "", this.answers = "", this.correctAnswer = ""});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
        question: json['question'],
        answers: json['answers'],
        correctAnswer: json['correct_answer']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['answers'] = this.answers;
    data['correctAnswer'] = this.correctAnswer;
    return data;
  }
}
