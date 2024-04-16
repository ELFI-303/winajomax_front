class Customer {
  final int customerId;
  final String customerName;
  final String customerEmail;
  final double customerSolde;
  final String customerGender;

  Customer({
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerSolde,
    required this.customerGender,
  });

  factory Customer.fromMap(Map gambleMap) {
    return Customer(
      customerId: gambleMap['customerId'],
      customerName: gambleMap['customerName'],
      customerEmail: gambleMap['customerEmail'],
      customerSolde: gambleMap['customerSolde'],
      customerGender: gambleMap['customerGender'],
    );
  }
}
