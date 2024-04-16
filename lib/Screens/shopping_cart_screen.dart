import 'package:flutter/material.dart';
import 'package:todospring/Screens/gamble_screen.dart';
import 'package:todospring/Screens/home_screen.dart';
import 'package:todospring/Services/database_services.dart';
import 'package:todospring/viewModels/customer_profile.dart';
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/models/olympic.dart';
import 'package:todospring/models/shopping_cart.dart';
import 'package:todospring/viewModels/olympic_tile.dart';


class ShoppingCartPage extends StatefulWidget {
  @override
  _ShoppingCartPageState createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  Customer? customer;

  List<String> _items = [
    'discipline: 100m'+'\n'+'date: 2024-08-05 15:30:00'+'\n'+'lieu: stade de france'+'\n'+'montant: 25€',
    'discipline: 200m'+'\n'+'date: 2024-06-05 10:30:00'+'\n'+'lieu: stade olympique'+'\n'+'montant: 15€',
    'discipline: 200m nage'+'\n'+'date: 2024-04-05 9:30:00'+'\n'+'lieu: seine'+'\n'+'montant: 150€',
  ];
  List<int> _prix = [25, 15, 150];
  
  getCustomer() async {
    customer = await DatabaseServices.getCustomer();
    setState(() {});
  }
  
  postCart(cart) async {
    bool resp = await DatabaseServices.postShoppingCart(cart);
    return resp;
  }
  @override
  void initState() {
    super.initState();
    getCustomer();
  }
  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return customer == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
     appBar: AppBar(title: const Text('WINAMAX OLYMPICS',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,color:Color.fromARGB(255, 223, 209, 165),fontSize: 25,shadows: [Shadow( color: Color.fromARGB(134, 0, 0, 0),blurRadius: 2,offset: Offset(2.5, 2.5))])),
                    centerTitle: true,
                    backgroundColor: const Color.fromARGB(255, 49, 41, 25),
                    actions:[
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomerProfile(customer: customer!);
                            },
                          );
                        },
                        icon: const Icon(Icons.person),
                        color:Color.fromARGB(255, 223, 209, 165),
                      ),
                    
                    ],),
      body: Column(
        children: [
          const SizedBox(height: 10),
              Image.asset('jo_paris_2024.png',width: sHeight*0.15,height:sHeight*0.15),
              const SizedBox(height: 10),
              const SizedBox(width: 50),
              SizedBox(width: 800,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const GambleScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.play_for_work)
                                    ),
                                  IconButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                      );
                                      },
                                    icon: const Icon(Icons.home)
                                    ),
                                  IconButton(
                                    onPressed: () {
                                    },
                                    icon: const Icon(Icons.shopping_cart)
                                    ),
                                ],
                              ),
                            ),
          Expanded(
            child:
      ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_items[index]),
            trailing: Wrap(
              children: [
              Text(_prix[index].toString()+'€', style: TextStyle(fontSize: 20)),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Modifier le solde du pari'),
                          actions: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Nouveau solde',
                              ),
                              onChanged: (String value) {
                                _prix[index] = int.parse(value);
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('valider'),
                            ),
                          ],
                        );
                      },
                    );
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.remove_circle),
                onPressed: () {
                  setState(() {
                    _items.removeAt(index);
                  });
                },
              ),
              ])
          );
        },
      ),),
        ],
      ),

      persistentFooterButtons: [
        Center(
          child: TextButton(
        onPressed: () {
          int total = 0;

          for (int i = 0; i < _items.length; i++) {
            total += _prix[i];
          }
          if (total > customer!.customerSolde) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Solde insuffisant'),
                  content: const Text('Votre solde est insuffisant pour valider ce panier'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            List<Gamble> gambles = [];
            for (int i = 0; i < _items.length; i++) {
              //gambles.add(Gamble.fromMap("""itemMap"""); //Logique pas encore créée
              
            }
            ShoppingCart cart = ShoppingCart.fromArgs(customer!.customerId,gambles);
            bool resp = postCart(cart);
            if (resp == true ){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Panier validé'),
                    content: const Text('Votre panier a été validé avec succès'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Erreur'),
                    content: const Text('Une erreur est survenue lors de la validation du panier'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Text('Valider le panier', style: TextStyle(fontSize: 30,color:const Color.fromARGB(255, 49, 41, 25))),
      ),
          )
      ]
    );
  }
}

