import 'package:todospring/models/gamble.dart';

class ShoppingCart {
  final int customerId;
  final List<Gamble> gambles;

  ShoppingCart({
    required this.customerId,
    required this.gambles,
  });
  factory ShoppingCart.fromArgs(customerId, gambles) {
    return ShoppingCart(
      customerId: customerId,
      gambles: gambles,
    );
  }
}
