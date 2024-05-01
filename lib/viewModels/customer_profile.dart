import 'package:flutter/material.dart';
import 'package:todospring/Screens/home_screen.dart';
import 'package:todospring/models/gamble.dart';

import '../models/customer.dart';

class CustomerProfile extends StatelessWidget {
  const CustomerProfile({Key? key, required this.customer, required this.gambleList, required this.username, required this.password})
      : super(key: key);
  final Customer customer;
  final List<Gamble> gambleList;
  final String username;
  final String password;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Profile Details'),
      content: Container(
        width: 200, // Adjust the width as needed
        child: Column(
          mainAxisSize: MainAxisSize.min, // Use min to make it small
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customer.customerGender == 'MALE' ? const Icon(Icons.face) : const Icon(Icons.face_3),
            Text('Name: ${customer.customerName}'),
            Text('Email: ${customer.customerEmail}'),
            Text('Solde: ${customer.customerSolde}€'),
            TextButton(child: Text('Historique des paris',style: TextStyle(color: Color.fromARGB(255, 49, 41, 25))),
                        style: ButtonStyle(backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 226, 191, 114))),
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(gambleList: gambleList,page:0,username: username,password: password,)),);},)
            // Add more profile details here
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }
}