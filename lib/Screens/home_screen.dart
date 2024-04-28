import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:todospring/Services/database_services.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/viewModels/customer_profile.dart';
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/olympic.dart';
import 'package:todospring/viewModels/gamble_tile.dart';
import 'package:todospring/viewModels/olympic_tile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.gambleList, required this.page, required this.isAuthenticated});
  final List<Gamble> gambleList;
  final int page;
  final bool isAuthenticated;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with TickerProviderStateMixin {
  late final TabController _tabController;
  List<Olympic>? olympics;
  Customer? customer;
  List<Gamble>? gamble;
  bool? isAuthenticated;

  final cuntroller = TextEditingController();
  getAuth() {
    isAuthenticated = DatabaseServices.getAuth();
  }
  getGamble(isAuth) async {
    gamble = await DatabaseServices.getGamble(isAuth);
    setState(() {});
  }
  getOlympics() async {
    olympics = await DatabaseServices.getOlympics();
    setState(() {});
  }
  getCustomer(isAuth) async {
    customer = await DatabaseServices.getCustomer(isAuth);
    setState(() {});
  }
  postCart(cart,isAuth) async {
    await DatabaseServices.postShoppingCart(cart,isAuth);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this,initialIndex: widget.page);
    getGamble(widget.isAuthenticated);
    getOlympics();
    getCustomer(widget.isAuthenticated);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double total = 0;
    for (int i = 0; i < widget.gambleList.length; i++) {
      total += widget.gambleList[i].amount;
    }
    return olympics == null ? const Scaffold(body:Center(child:CircularProgressIndicator())) :
        Scaffold(appBar: AppBar( title: const Text('WINAMAX OLYMPICS',style: TextStyle(fontWeight: FontWeight.bold,wordSpacing: 2,color:Color.fromARGB(255, 223, 209, 165),fontSize: 25,shadows: [Shadow( color: Color.fromARGB(134, 0, 0, 0),blurRadius: 2,offset: Offset(2.5, 2.5))])),
                                    backgroundColor: const Color.fromARGB(255, 49, 41, 25),
                                    toolbarHeight: sHeight*0.15,
                                    actions:[ IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) {
                                                      return CustomerProfile(customer: customer!,gambleList: widget.gambleList);
                                                    },
                                                  );
                                                },
                                                icon: const Icon(Icons.person),
                                                color:Color.fromARGB(255, 223, 209, 165),
                                              ),],
                                    bottom: PreferredSize(
                                      preferredSize: const Size.fromHeight(120),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
                                        child: Center(child: Column(children: [
                                          const SizedBox(height: 10),
                                          Center(child: Image.asset('jo_paris_2024.png',width: sHeight*0.15,height:sHeight*0.15)),
                                          const SizedBox(height: 10),
                                          TabBar(
                                              labelColor: const Color.fromARGB(255, 196, 168, 114),
                                              indicatorColor: const Color.fromARGB(255, 196, 168, 114),
                                              automaticIndicatorColorAdjustment: false,
                                              controller: _tabController,
                                              tabs: <Widget>[
                                                const Tab(
                                                  icon: Icon(Icons.play_for_work),
                                                ),
                                                const Tab(
                                                  icon: Icon(Icons.home),
                                                ),
                                                Tab(
                                                  child: Positioned(
                                                    child: Stack(
                                                      children: <Widget>[
                                                        const Icon(Icons.shopping_cart),
                                                        widget.gambleList.length == 0 ? SizedBox() : 
                                                        Positioned(
                                                          top: -2,
                                                          right: -5,
                                                          child: Center(
                                                            child: Container(
                                                              width: 15,
                                                              height: 15,
                                                              decoration: const BoxDecoration(
                                                                shape: BoxShape.circle,
                                                                color: Colors.red),
                                                                child:Text(' '+widget.gambleList.length.toString(),style: const TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500),),),)
                                                          ),])
                                                  ),),
                                              ],
                                            ),
                                        ],),),
                                      ),
                                ),),
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                Center(child: widget.isAuthenticated == false ? Text('unauthenticated') : ListView.builder(
                          itemCount: gamble!.length,
                          itemBuilder: (context, index) {
                            Gamble bet = gamble![index];
                            return GambleTile(gamble: bet);
                            },
                        ),),
                Center(child: ListView.builder(
                          itemCount: olympics!.length,
                          itemBuilder: (context, index) {
                            Olympic olympic = olympics![index];
                            return OlympicTile(olympic: olympic,gambleList: widget.gambleList);
                          },
                        ),),
                Center(
                  child: Column(children: widget.isAuthenticated == false ? [Text('unauthenticated')] : [
                    Expanded(child:ListView.builder(
                            itemCount: widget.gambleList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                tileColor: index.isEven ? Color.fromARGB(255, 223, 209, 165)  : Color.fromARGB(255, 196, 168, 114),
                                title: Column(children:[
                                          Row(children:[Text(widget.gambleList[index].olympicEvent.discipline,style: TextStyle(fontWeight: FontWeight.w600)),]),
                                          Row(children:[Text('lieu: ',style: TextStyle(fontWeight: FontWeight.w600)),Text(widget.gambleList[index].olympicEvent.lieu),]),
                                          Row(children:[Text('date: ',style: TextStyle(fontWeight: FontWeight.w600)),Text(DateTime.parse(widget.gambleList[index].olympicEvent.dateTime).toString().substring(0, DateTime.parse(widget.gambleList[index].olympicEvent.dateTime).toString().length - 7)),])
                                          ]),
                                trailing: Wrap(
                                  children: [
                                  Text(widget.gambleList[index].amount.toString()+'€', style: TextStyle(fontSize: 20)),
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

                                                  controller: cuntroller,
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    String input = cuntroller.text;
                                                    double amount = double.parse(input);
                                                    List<Gamble> list = widget.gambleList;
                                                    list[index] = Gamble(olympicEvent: list[index].olympicEvent,amount:  amount,gambleId:  list[index].gambleId,pay: list[index].pay);
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => HomeScreen(gambleList: list,page:2,isAuthenticated: true)),
                                                    );
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
                                          List<Gamble> list = widget.gambleList;
                                          list.removeAt(index);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => HomeScreen(gambleList: list,page:2,isAuthenticated: true)),
                                          );
                                      });
                                    },
                                  ),
                                  ])
                              );
                            },
                          )),
                          Column(children: [Center(child: Text('Total: '+total.toString()+'€',style: TextStyle(fontSize: 20))),
                          Center(
                            child: TextButton(
                              style:ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 196, 168, 114)),
                                foregroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 196, 168, 114)),
                              ),
                              onPressed: () {
                                if (total > customer!.customerSolde) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Solde insuffisant'),
                                        content: const Text('Votre solde est insuffisant pour valider ce panier'),
                                        actions: [
                                          TextButton(
                                            onPressed: () { Navigator.of(context).pop(); },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  List<Gamble> gambles = widget.gambleList;
                                  for (int i = 0; i < widget.gambleList.length; i++) {
                                    gambles[i] = Gamble(olympicEvent: widget.gambleList[i].olympicEvent,amount:  widget.gambleList[i].amount,gambleId:  widget.gambleList[i].gambleId,pay: widget.gambleList[i].pay);
                                  }
                                  postCart(gambles,widget.isAuthenticated);
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Column(children: [
                                              Row(children:[Text('Panier validé',style: TextStyle(fontSize: 30,color:const Color.fromARGB(255, 49, 41, 25)))]),
                                              SizedBox(height: 30),
                                              Center(child: Image.asset('Party-Icon.webp', width: sHeight*0.15, height: sHeight*0.15)),
                                              SizedBox(height: 30),
                                          ],),
                                          content: const Text('Votre panier a été validé avec succès'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                List<Gamble> list = [];
                                                Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(gambleList: list,page:1,isAuthenticated: true)));
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                  );
                                }
                              },
                              child: Text('Valider le panier', style: TextStyle(fontSize: 30,color:const Color.fromARGB(255, 49, 41, 25))),
                            ),
                            ),
                            SizedBox(height:10)
                          ],)
                      ])
                ),
              ],
            ),
    );
  }
}
