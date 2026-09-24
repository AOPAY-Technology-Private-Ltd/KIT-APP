class FaqEntity {
  final String id;
  final String question;
  final String answer;

  const FaqEntity({required this.id, required this.question, required this.answer});
}

class SupportInfoEntity {
  final String phone;
  final String whatsapp;
  final String email;

  const SupportInfoEntity({required this.phone, required this.whatsapp, required this.email});
}