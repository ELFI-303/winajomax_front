import 'package:flutter/material.dart';
import 'package:todospring/Screens/gamble_screen.dart';
import 'package:todospring/Screens/shopping_cart_screen.dart';

import '../models/customer.dart';

class CustomerProfile extends StatelessWidget {
  final Customer customer;

  const CustomerProfile({Key? key, required this.customer})
      : super(key: key);

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
            TextButton(child: Text('Historique des paris'),onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => GambleScreen()),
                                      );
              
            },)
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