class Customer {
  final String customerName;
  final String customerEmail;
  final double customerSolde;
  final String customerGender;

  Customer({
    required this.customerName,
    required this.customerEmail,
    required this.customerSolde,
    required this.customerGender,
  });

  factory Customer.fromMap(Map gambleMap) {
    return Customer(
      customerName: gambleMap['customerName'],
      customerEmail: gambleMap['customerEmail'],
      customerSolde: gambleMap['customerSolde'],
      customerGender: gambleMap['customerGender'],
    );
  }
}
