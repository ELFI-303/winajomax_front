import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todospring/Screens/home_screen.dart';
import 'package:todospring/models/gamble.dart';
import '/models/olympic.dart';

class OlympicTile extends StatelessWidget {
  OlympicTile({Key? key, required this.olympic,required this.gambleList}) : super(key: key);
  List<Gamble> gambleList;
  List<Gamble> gamblesOlist = [];
  final Olympic olympic;
  final cuntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    DateTime eventDate = DateTime.parse(olympic.dateTime);
    String eventDateString = eventDate.toString().substring(0, eventDate.toString().length - 7);
    bool isEventPassed = eventDate.isAfter(currentDate);
    List<Widget> participantsStringList = [];
    String participantsString = '';
    List<String> paysList = [];
    Map participants = json.decode(olympic.participants);
    Map cote = json.decode(olympic.cote);
    participants.forEach((key, value) {
      participantsString += '* '+ key + ': ' + value + '\n';
      participantsStringList.add(Row( 
        children: [
          Text('${key}: '+'cote: ${cote[key]}'),
          ChangeNotifierProvider(
          create: (_) => CheckboxProvider(),
          child: Consumer<CheckboxProvider>(
            builder: (context, checkboxProvider, _) => Checkbox(
              value: checkboxProvider.isChecked,
              onChanged: (value) {
                checkboxProvider.isChecked = value ?? true;
                if (checkboxProvider.isChecked == true) {
                  paysList.add(key);
                } else {
                  paysList.remove(key);
                }
              },
            ),
          ),
        ),
        ]));
    });
    return Card(
      child: ListTile(
        title: Container(
          width:BorderSide.strokeAlignCenter,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 207, 186, 127),
            borderRadius: BorderRadius.circular(10),
          ),
          child:Center(
            child:Text(
                        olympic.discipline,
                        style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),)
        ),
        subtitle: Column(children: [
          SizedBox(height: 10),
          Row(children: [
            const Text('lieu: ',style: TextStyle(fontWeight: FontWeight.bold)),Text(olympic.lieu),
          ],),
          Row(children: [
            const Text('date: ',style: TextStyle(fontWeight: FontWeight.bold)),Text(eventDateString),
          ],),
          const Row(children: [
            Column(children: [
              Text('participants: ',style: TextStyle(fontWeight: FontWeight.bold)),
            ],)
          ],),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
               Flexible(
               child: new Text(participantsString)),
          ],),
          IconButton(
            icon: const Icon(Icons.add_circle, color: Color.fromARGB(255, 49, 41, 25)),
            onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Ajouter un paris'),
                    content: Column(
                      children: [
                        ListTile(
                            title: Text(
                              olympic.discipline+' - '+olympic.lieu+'\ndate: '+eventDateString
                            ),
                            subtitle: Column(children: [
                        Text('participants: \n${participantsString}'),
                        Column(children: participantsStringList),
                        TextField(
                          decoration: const InputDecoration(
                          labelText: 'Montant (€)',
                          ),
                          controller: cuntroller,
                        ),
                      ],),),
                      ]
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
                                  String input = cuntroller.text;
                                  double amount = double.parse(input);
                                  if (amount > 1 && amount < 10000) {
                                    if (paysList.length == 1) {
                                      String payString = paysList[0];
                                      gamblesOlist.add(Gamble(olympicEvent: olympic, amount: amount, gambleId: 0, pay:payString));
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => HomeScreen(gambleList: gambleList+gamblesOlist,page: 1,isAuthenticated: true)),);
                                    } else {
                                      showDialog(
                                        barrierDismissible: true,//tapping outside dialog will close the dialog if set 'true'
                                        context: context, 
                                        builder: (context){
                                          return const AlertDialog(title: const Text('Veuillez selectionner un seul pay.',style: TextStyle(color: Colors.red)));
                                        }
                                      );
                                    }
                                  } else {
                                      showDialog(
                                        barrierDismissible: true,//tapping outside dialog will close the dialog if set 'true'
                                        context: context, 
                                        builder: (context){
                                          return const AlertDialog(title: const Text('Erreur sur le montant. (montant minimum 1€)',style: TextStyle(color: Colors.red)));
                                        }
                                      );
                                  }
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
class CheckboxProvider with ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  set isChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }
}