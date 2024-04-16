import 'package:flutter/material.dart';
import '/models/gamble.dart';

class GambleTile extends StatelessWidget {
  final Gamble gamble;

  const GambleTile({Key? key, required this.gamble})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cote = double.parse(gamble.olympicEvent.cote.toString().substring(1, gamble.olympicEvent.cote.toString().length - 1));
    double amount = double.parse(gamble.amount.toString());
    DateTime currentDate = DateTime.parse("2024-07-25T15:30:00");
    DateTime eventDate = DateTime.parse(gamble.olympicEvent.dateTime);
    String eventDateString = eventDate.toString().substring(0, eventDate.toString().length - 7);
    return Card(
      child: ListTile(
        title: Text(
          gamble.olympicEvent.discipline+' - '+gamble.olympicEvent.lieu+' - '+eventDateString,
        ),
        subtitle: Text(
          'Votre mise: '+amount.toString().replaceAll('-','')+'€\n'
          'Vos potentiels gains: '+cote.toString()+'x'+amount.toString().replaceAll('-','')
          +"="+(cote*amount).toString().replaceAll('-','')+'€',
        ),
        trailing: eventDate.isAfter(currentDate) ? Text('Date:'+eventDateString) : Text('Gains/Pertes:'+(cote*amount).toString()+'€',style: TextStyle(color: cote*amount>0 ? Colors.green : Colors.red),),
      ),
    );
  }
}