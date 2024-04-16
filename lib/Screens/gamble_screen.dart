import 'package:flutter/material.dart';
import 'package:todospring/Screens/home_screen.dart';
import 'package:todospring/Screens/shopping_cart_screen.dart';
import 'package:todospring/Services/database_services.dart';
import 'package:todospring/viewModels/customer_profile.dart';
import 'package:todospring/viewModels/gamble_tile.dart';
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/models/shopping_cart.dart';


class GambleScreen extends StatefulWidget {
  const GambleScreen({Key? key}) : super(key: key);
  @override
  _GambleScreenState createState() => _GambleScreenState();
}

class _GambleScreenState extends State<GambleScreen> {
  List<Gamble>? gamble;
  Customer? customer;
  getGamble() async {
    gamble = await DatabaseServices.getGamble();
    setState(() {});
  }
  
  getCustomer() async {
    customer = await DatabaseServices.getCustomer();
    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    getGamble();
    getCustomer();
  }


  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return gamble == null
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
                                    onPressed: (){},
                                    icon: const Icon(Icons.play_for_work)
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.home)
                                    ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ShoppingCartPage()),
                                      );
                                    },
                                    icon: const Icon(Icons.shopping_cart)
                                    ),
                                ],
                              ),
                            ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        height: sHeight*0.65,
                        child: ListView.builder(
                          itemCount: gamble!.length,
                          itemBuilder: (context, index) {
                            Gamble bet = gamble![index];
                            return GambleTile(gamble: bet);
                            },
                        ),
                        ),
        ],
      ), 
    );
  }
}
