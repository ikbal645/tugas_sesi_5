class RegistrationTicket {
  final String id;
  final String eventTitle;
  final String name;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime attendanceDate;
  final String kitPackage;
  final double donationAmount;

  RegistrationTicket({
    required this.id,
    required this.eventTitle,
    required this.name,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.kitPackage,
    required this.donationAmount,
  });
}