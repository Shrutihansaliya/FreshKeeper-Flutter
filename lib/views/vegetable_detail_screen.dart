// import 'package:flutter/material.dart';
// import '../utils/freshness.dart';
//
// class VegetableDetailScreen extends StatelessWidget {
//   final Map veg;
//
//   VegetableDetailScreen({required this.veg});
//
//   String formatQty(int g) {
//     return g >= 1000 ? "${(g / 1000)} kg" : "$g g";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int days = daysLeft(veg['purchaseDate'], veg['shelfLifeDays']);
//     String status = veg['status'] ?? "fresh";
//
//     return Scaffold(
//       appBar: AppBar(title: Text(veg['name'] ?? "")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // IMAGE
//             Container(
//               height: 200,
//               width: double.infinity,
//               color: Colors.grey.shade200,
//               child: Center(
//                 child: Image.asset(
//                   "assets/images/${veg['imageName']}.png",
//                   height: 200,
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             Text(veg['name'] ?? "",
//                 style: TextStyle(
//                     fontSize: 24, fontWeight: FontWeight.bold)),
//
//             SizedBox(height: 10),
//
//             Text("Status: $status"),
//             Text("Days Left: $days"),
//             Text("Quantity: ${formatQty(veg['quantity'] ?? 0)}"),
//
//             if ((veg['notes'] ?? "").isNotEmpty)
//               Padding(
//                 padding: EdgeInsets.only(top: 10),
//                 child: Text("Notes: ${veg['notes']}"),
//               ),
//
//             SizedBox(height: 20),
//
//             ElevatedButton(
//               child: Text("Back"),
//               onPressed: () => Navigator.pop(context),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../utils/freshness.dart';
import 'edit_vegetable_screen.dart';
import '../database/db_helper.dart';
class VegetableDetailScreen extends StatelessWidget {
  final Map veg;

  VegetableDetailScreen({required this.veg});

  String formatQty(int g) {
    return g >= 1000 ? "${(g / 1000).toStringAsFixed(2)} kg" : "$g g";
  }

  Color statusColor(String status) {
    switch (status) {
      case "expired":
        return Colors.red;
      case "urgent":
        return Colors.orange;
      case "useSoon":
        return Colors.amber;
      case "finished":
        return Colors.grey;
      default:
        return Colors.green;
    }
  }

  void confirmDelete(BuildContext context) {
    DBHelper db = DBHelper();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text("Delete Vegetable"),
          ],
        ),
        content: Text(
          "Are you sure you want to delete this vegetable?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await db.deleteVegetable(veg['id']);

              Navigator.pop(context, true); // go back + refresh

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Vegetable deleted")),
              );
            },
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    int days = daysLeft(veg['purchaseDate'], veg['shelfLifeDays']);
    String status = getStatus(veg['quantity'] ?? 0, days);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(veg['name'] ?? ""),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () => confirmDelete(context),
          )
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            //  IMAGE CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/${veg['imageName']}.png",
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        Icon(Icons.image, size: 80),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            //  MAIN CARD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // NAME
                    Center(
                      child: Text(
                        veg['name'] ?? "",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // STATUS BADGE
                    Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor(status).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: statusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Divider(height: 30),

                    // DETAILS
                    detailRow(Icons.scale, "Quantity",
                        formatQty(veg['quantity'] ?? 0)),

                    detailRow(Icons.calendar_today, "Days Left", "$days"),

                    if (veg['categoryName'] != null)
                      detailRow(Icons.label, "Category",
                          veg['categoryName']),

                    detailRow(Icons.eco, "Freshness",
                        "$status (${days} days left)",
                        color: statusColor(status)),

                    SizedBox(height: 10),

                    // NOTES
                    if ((veg['notes'] ?? "").isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Notes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey)),
                          SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(veg['notes']),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            //  EDIT BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton.icon(
                icon: Icon(Icons.edit),
                label: Text("Edit Vegetable"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditVegetableScreen(veg: veg),
                    ),
                  );

                  if (result == true) {
                    Navigator.pop(context, true); // refresh parent
                  }
                },
              ),
            ),

            SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  Widget detailRow(IconData icon, String title, String value,
      {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          SizedBox(width: 8),
          Text(title,
              style: TextStyle(color: Colors.grey, fontSize: 14)),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color ?? Colors.black,
            ),
          )
        ],
      ),
    );
  }
}