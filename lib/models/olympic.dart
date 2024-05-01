class Olympic {
  final int eventId;
  final String discipline;
  final String dateTime;
  final String lieu;
  final dynamic participants;
  final String result;
  final dynamic cote;

  Olympic({
    required this.eventId,
    required this.discipline,
    required this.dateTime,
    required this.lieu,
    required this.participants,
    required this.result,
    required this.cote,
  });

  factory Olympic.fromMap(Map olympicMap) {
    dynamic participantsJSON = olympicMap['participants'] as dynamic;
    dynamic coteJSON = olympicMap['cote'] as dynamic;
    String resultJSON = olympicMap['result'] as String;
    String lieuJSON = olympicMap['lieu'] as String;
    String datetimeJSON = olympicMap['dateTime'] as String;
    String disciplineJSON = olympicMap['discipline'] as String;
    int eventIdJSON = olympicMap['eventId'] as int;
    return Olympic(
      eventId: eventIdJSON,
      discipline: disciplineJSON,
      dateTime: datetimeJSON,
      lieu: lieuJSON,
      participants: participantsJSON,
      result: resultJSON,
      cote: coteJSON,
    );
  }
}
