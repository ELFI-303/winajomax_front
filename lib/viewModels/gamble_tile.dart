import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import '/models/gamble.dart';

class GambleTile extends StatelessWidget {
  const GambleTile({Key? key, required this.gamble}) : super(key: key);
  final Gamble gamble;

  @override
  Widget build(BuildContext context) {
    double amount = double.parse(gamble.amount.toString());
    dynamic pay = gamble.pay;
    dynamic cotes;
    if (gamble.olympicEvent.cote.runtimeType == String) {
      cotes = json.decode(gamble.olympicEvent.cote);
    } else {
      cotes = gamble.olympicEvent.cote;
    }
    double cote = double.parse(cotes[pay].toString());
    DateTime currentDate = DateTime.parse("2024-07-25T15:30:00");
    DateTime eventDate = DateTime.parse(gamble.olympicEvent.dateTime);
    String eventDateString = eventDate.toString().substring(0, eventDate.toString().length - 7);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        tileColor: Color.fromARGB(Random().nextInt(20)+235, Random().nextInt(20)+220, Random().nextInt(20)+209, 165),
        title: Column(children: [
                Row(children:[Text(gamble.olympicEvent.discipline,style: const TextStyle(fontWeight: FontWeight.bold))]),
                Row(children:[const Text('lieu: ',style: TextStyle(fontWeight: FontWeight.bold)),Text(gamble.olympicEvent.lieu)]),
                Row(children:[const Text('date: ',style: TextStyle(fontWeight: FontWeight.bold)),Text(eventDateString)])

            ]),
        subtitle: Text(
          'Votre mise: '+amount.toString().replaceAll('-','')+'€\n'
          'Vos potentiels gains:\n'+cote.toString()+' x '+amount.toString().replaceAll('-','')
          +" ~= "+(amount*cote).toStringAsFixed(2).replaceAll('-','')+'€',
        ),
        trailing: eventDate.isAfter(currentDate) ? null : gamble.pay == gamble.olympicEvent.result ? Text('Gains: '+(amount*cote).toStringAsFixed(2)+'€',style: const TextStyle(color:  Colors.green ,fontWeight: FontWeight.bold,fontSize: 12)) : Text('Pertes: -'+(amount).toString()+'€',style: const TextStyle(color:Colors.red,fontWeight: FontWeight.bold,fontSize: 12)),
      ),
    );
  }
}