int daysLeft(String purchaseDate, int shelfLife) {
  DateTime purchase = DateTime.parse(purchaseDate);
  DateTime expiry = purchase.add(Duration(days: shelfLife));
  return expiry.difference(DateTime.now()).inDays;
}

String getStatus(int qty, int days) {
  if (qty == 0) return "finished";
  if (days <= 0) return "expired";
  if (days <= 2) return "urgent";
  if (days <= 5) return "useSoon";
  return "fresh";
}