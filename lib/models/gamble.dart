

import 'package:todospring/models/olympic.dart';
import 'dart:convert';
class Gamble {
  final int gambleId;
  final Olympic olympicEvent;
  final double amount;
  final String pay;
  Gamble({
    required this.gambleId,
    required this.olympicEvent,
    required this.amount,
    required this.pay,
  });
  factory Gamble.fromMap(Map gambleMap) {
    int gambleIdJSON = gambleMap['gambleId'] as int;
    String payJSON = gambleMap['pay'] as String;
    Map olympicmap = json.decode(gambleMap['olympicEvent']) as Map;
    List list = [];
    olympicmap.forEach((key, value) {
      if (key == 'participants') {list.add(value as dynamic);}
      else if (key == 'cote') {list.add(value as dynamic);}
      else if (key == 'eventId') {list.add(value);}
      else {list.add(value.toString());}
    });
    Olympic olympicEventJSON = Olympic(
      eventId: list[2],
      discipline: list[4],
      dateTime: list[0],
      lieu: list[5],
      participants: list[6],
      result: list[1],
      cote: list[3]);
    double amountJSON = gambleMap['amount'] as double;
    return Gamble(
      gambleId: gambleIdJSON,
      olympicEvent: olympicEventJSON,
      amount: amountJSON,
      pay: payJSON,
    );
  }
}
