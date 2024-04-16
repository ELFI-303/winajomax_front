import 'package:todospring/models/olympic.dart';
import 'dart:convert';
class Gamble {
  final int gambleId;
  final int userId;
  final Olympic olympicEvent;
  final double amount;

  Gamble({
    required this.gambleId,
    required this.userId,
    required this.olympicEvent,
    required this.amount,
  });
  /*
  factory Gamble.fromMap(Map gambleMap) {
    int gambleIdJSON = gambleMap['gambleId'] as int;
    int userIdJSON = gambleMap['userId'] as int;
    dynamic olympicEventJSON = json.decode(gambleMap['olympicEvent']);
    double amountJSON = gambleMap['amount'] as double;
    return Gamble(
      gambleId: gambleIdJSON,
      userId: userIdJSON,
      olympicEvent: olympicEventJSON,
      amount: amountJSON,
    );
  }*/
}
