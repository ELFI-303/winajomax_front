import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todospring/models/customer.dart';
import 'package:todospring/models/gamble.dart';
import 'package:todospring/models/olympic.dart';

class DatabaseServices {
  static Future<List<Olympic>> getOlympics() async {
      var url = Uri.parse('http://localhost:8080/demo/olympic');
      Map<String, String> headers = {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
            "Access-Control-Allow-Methods": "GET",
            "password": "",
            "username": ""};
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
  static Future<List<Gamble>> getGamble(username,password) async {
    if (username == "" && password == ""){
        return [];
      } else {
      Map<String, String> headers = {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
            "Access-Control-Allow-Methods": "GET",
            "password": password,
            "username": username};
      var url = Uri.parse('http://localhost:8080/demo/gamble');
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
      }
  }

  static Future<Customer> getCustomer(username,password) async {
    if (username == "" && password == ""){
        return Customer(customerName: "",customerEmail: "",customerSolde: 0,customerGender: "");
      } else {
      Map<String, String> headers = {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
            "Access-Control-Allow-Methods": "GET",
            "password": password,
            "username": username};
      var url = Uri.parse('http://localhost:8080/demo/customer');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      Map responseMap = json.decode(utf8.decode(response.bodyBytes));
      Customer customer = Customer.fromMap(responseMap);
        return customer;
      }
  }

  static postShoppingCart(List<Gamble> gambles,username,password) async {
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

      
      var url = Uri.parse('http://localhost:8080/demo/gamble');
      Map<String, String> headers = {
            "Access-Control-Allow-Origin": "*",
            "Content-Type": "application/json",
            "Access-Control-Allow-Methods": "POST",
            "password": password,
            "username": username};
      await http.post(
          url,
          headers: headers,
          body: body,
      );
  }
}
