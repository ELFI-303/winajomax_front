import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/models/olympic.dart';
import 'package:todospring/models/shopping_cart.dart';

import 'globals.dart';

class DatabaseServices {

  static Future<List<Olympic>> getOlympics() async {
    var url = Uri.parse(baseURL+ '/olympic');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    Map<String, dynamic> responseList = json.decode(utf8.decode(response.bodyBytes));
    List<Olympic> olympics = [];
    responseList.forEach((key, value) {
      Olympic olympic = Olympic.fromMap(json.decode(value));
      olympics.add(olympic);
    });
    return olympics;
  }
  
  static Future<List<Gamble>> getGamble() async {
    /*var url = Uri.parse(baseURL+ '/gamble/$id');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    Map<String,dynamic> responseList = json.decode(utf8.decode(response.bodyBytes));*/
    List<Gamble> gambleById = [];
    final dynamic participant1;
    final dynamic participant2;
    final dynamic participant11;
    final dynamic participant21;


    dynamic participantsMap = {
      participant1 = "toto",
    }; 
    dynamic cotesMap = {
      participant11 = "1.2",
    }; 
    gambleById.add(Gamble(gambleId: 1, userId: 1, olympicEvent: Olympic(eventId: 1,discipline: "tir à l'arc",dateTime: "2024-07-20T15:30:00",lieu: "stade de france",participants:participantsMap,result:"France",cote:cotesMap), amount: 120));
    gambleById.add(Gamble(gambleId: 1, userId: 1, olympicEvent: Olympic(eventId: 1,discipline: "100m",dateTime: "2024-07-22T15:30:00",lieu: "stade de france",participants:participantsMap,result:"Gabon",cote:cotesMap), amount: (-60)));
    gambleById.add(Gamble(gambleId: 1, userId: 1, olympicEvent: Olympic(eventId: 1,discipline: "Saut en longueur",dateTime: "2024-07-23T15:30:00",lieu: "arena",participants:participantsMap,result:"Suisse",cote:cotesMap), amount: 80));
    gambleById.add(Gamble(gambleId: 1, userId: 1, olympicEvent: Olympic(eventId: 1,discipline: "Saut en hauteur",dateTime: "2024-07-30T15:30:00",lieu: "arena",participants:participantsMap,result:"Espagne",cote:cotesMap), amount: 75));
    gambleById.add(Gamble(gambleId: 1, userId: 1, olympicEvent: Olympic(eventId: 1,discipline: "200m nage",dateTime: "2024-08-05T15:30:00",lieu: "piscine de paris",participants:participantsMap,result:"France",cote:cotesMap), amount: 95));
    return gambleById;
  }

  static Future<Customer> getCustomer() async {
    var url = Uri.parse(baseURL+ '/customer/1');
    http.Response response = await http.get(
      url,
      headers: headers,
    );
    Map responseMap = json.decode(utf8.decode(response.bodyBytes));
    Customer customer = Customer.fromMap(responseMap);
    return customer;
  }

  static Future<bool> postShoppingCart(ShoppingCart shoppingCart) async {
    Map data = {
      "gambleEvent": shoppingCart.gambles,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/gamble');

    http.Response response = await http.post(
      url,
      headers: headers,
      body: body,
    );
    Future<bool> result = Future.value(response.body == "true");
    return result;
  }

  static void putCustomerSolde(Customer customer,double solde) async {
    Map data = {
      "solde": solde,
    };
    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/customer/${customer.customerId}');

    http.Response response = await http.put(
      url,
      headers: headers,
      body: body,
    );
    print(response.body);
  }
}
