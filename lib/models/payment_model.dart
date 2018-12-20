class PaymentModel {
  String buyerName;
  String byerNumber;
  int totalPrice;
  int cashPay;
  int cardPay;
  List<String> productList;
  DateTime  payDate;

  PaymentModel(
      {this.buyerName,
      this.byerNumber,
      this.totalPrice,
      this.cashPay,
      this.cardPay,
      this.productList,
      this.payDate});
}
