import 'package:flutter/material.dart';
import '/models/olympic.dart';

class OlympicTile extends StatelessWidget {
  final Olympic olympic;

  const OlympicTile({Key? key, required this.olympic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime eventDate = DateTime.parse(olympic.dateTime);
    String eventDateString = eventDate.toString().substring(0, eventDate.toString().length - 7);
    bool isEventPassed = eventDate.isAfter(currentDate);
    List<String> keys = olympic.participants.keys.toList();
    List<dynamic> participants = olympic.participants.values.toList();
    List<dynamic> cotes = olympic.cote.values.toList();
    String participantsString = '';
    List<Widget> participantsStringList = [];
    for (int i = 0; i < keys.length; i++) {
      participantsString+='Athletes de ${keys[i]}\: \n${participants[i]}\n';
      participantsStringList.add(Row( children: [Text('${keys[i]}: '+'cote: ${cotes[i]}'),Checkbox(value:false,onChanged:(value) {
      },)]));
    }
    return Card(
      child: ListTile(
        title: Text(
          olympic.discipline
        ),
        subtitle: Column(children: [
          Text(
            'lieu: '+olympic.lieu+'\ndate: '+eventDateString+'\nparticipants: \n'+ participantsString
          ),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.red),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Ajouter un paris'),
                    content: Column(
                      children: [
                        ListTile(
                            title: Text(
                              olympic.discipline+' - '+olympic.lieu+' - '+eventDateString
                            ),
                            subtitle: Column(children: [
                              Text(
                                'participants: \n'+ participantsString
                        ),
                        Column(children: participantsStringList),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Montant (€)',
                          ),
                        ),
                      ],),),]
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Annuler'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Ajouter au panier'),
                      ),
                    ],
                  );
                },
              );
            
            },
          ),
        ],),

        trailing: isEventPassed == true ? null : Text('result: '+olympic.result.toString()),
      ),
    );
  }
}