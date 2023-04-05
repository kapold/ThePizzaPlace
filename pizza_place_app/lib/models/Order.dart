class Order {
  int orderID;
  int customerID;
  int componentsID;
  // String orderDetails;
  int number;
  DateTime time;
  double finalPrice;

  Order({
    required this.orderID,
    required this.customerID,
    required this.componentsID,
    required this.number,
    required this.time,
    required this.finalPrice
  });
}