import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/models/olympic.dart';

import 'globals.dart';

class DatabaseServices {
  static Future<List<Olympic>> getOlympics() async {
      var url = Uri.parse(baseURL+ '/demo/olympic');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      List<Olympic> olympics = [];
      List<dynamic> responseList = json.decode(utf8.decode(response.bodyBytes));
      for (dynamic element in responseList) {
        element = element as Map<String, dynamic>;
        Olympic olympic = Olympic.fromMap(element);
        olympics.add(olympic);
      }
      return olympics;
  }
  static getAuth() async {
    var url = Uri.parse(baseURL+ '/demo/auth');
    await Future.delayed(Duration(seconds: 1));
    return true;
  }
  
  static Future<List<Gamble>> getGamble(isAuth) async {
    if (isAuth){
      var url = Uri.parse(baseURL+ '/demo/gamble');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      List<Gamble> gambles = [];
      List<dynamic> responseList = json.decode(utf8.decode(response.bodyBytes));
      for (dynamic element in responseList) {
        element = element as Map<String, dynamic>;
        Gamble gamble = Gamble.fromMap(element);
        gambles.add(gamble);
      }
      return gambles;
    } else {
      return [];
    }
  }

  static Future<Customer> getCustomer(isAuth) async {
    if (isAuth){
      var url = Uri.parse(baseURL+ '/demo/customer');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      Map responseMap = json.decode(utf8.decode(response.bodyBytes));
      Customer customer = Customer.fromMap(responseMap);
      return customer;
    } else {
      return Customer(customerName: '', customerEmail: '', customerSolde: 0, customerGender: '') ;
    }
  }

  static postShoppingCart(List<Gamble> gambles,isAuth) async {
    if (isAuth){
      Map<String, dynamic> toMap(Olympic olympic)  {
      return {
          "eventId": olympic.eventId,
          "discipline": olympic.discipline,
          "dateTime": olympic.dateTime,
          "lieu": olympic.lieu,
          "participants": olympic.participants,
          "result": olympic.result,
          "cote": olympic.cote,
        };
      }
      String body = '{';
      for (int i = 0; i < gambles.length; i++) {
        int y = i + 1;
        body += '"$y": ${json.encode({
          "gambleId": gambles[i].gambleId,
          "olympicEvent": toMap(gambles[i].olympicEvent),
          "amount": gambles[i].amount,
          "pay": gambles[i].pay,
        })}';
        if (i != gambles.length - 1) {
          body += ',';
        }
      }
      body += '}';

      
      var url = Uri.parse(baseURL + '/demo/gamble');
      await http.post(
          url,
          headers: headers,
          body: body,
      );
    } else {
      return Customer(customerName: '', customerEmail: '', customerSolde: 0, customerGender: '') ;
    }
  }
}
