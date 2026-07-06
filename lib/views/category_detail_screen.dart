// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
//
// class CategoryDetailScreen extends StatefulWidget {
//   final Map category;
//
//   CategoryDetailScreen({required this.category});
//
//   @override
//   _CategoryDetailScreenState createState() =>
//       _CategoryDetailScreenState();
// }
//
// class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
//   DBHelper db = DBHelper();
//   List vegetables = [];
//
//   @override
//   void initState() {
//     super.initState();
//     load();
//   }
//
//   load() async {
//     vegetables =
//     await db.getVegetablesByCategory(widget.category['id']);
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.category['name'] ?? "")),
//       body: ListView.builder(
//         itemCount: vegetables.length,
//         itemBuilder: (_, i) {
//           return ListTile(
//             title: Text(vegetables[i]['name'] ?? ""),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/freshness.dart';
import 'vegetable_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  final Map category;

  CategoryDetailScreen({required this.category});

  @override
  _CategoryDetailScreenState createState() =>
      _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  DBHelper db = DBHelper();
  List vegetables = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    vegetables =
    await db.getVegetablesByCategory(widget.category['id']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌫 BACKGROUND SAME AS iOS
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.category['name'] ?? "",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            // 🌿 CATEGORY TITLE CARD
            Column(
              children: [
                Text(
                  widget.category['name'] ?? "",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Vegetables in this category",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // 🥕 VEGETABLE LIST
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: vegetables.length,
              itemBuilder: (_, i) {
                final veg = vegetables[i];

                int days = daysLeft(
                    veg['purchaseDate'], veg['shelfLifeDays']);
                String status =
                getStatus(veg['quantity'], days);

                Color statusColor;
                switch (status) {
                  case "expired":
                    statusColor = Colors.red;
                    break;
                  case "urgent":
                    statusColor = Colors.orange;
                    break;
                  case "useSoon":
                    statusColor = Colors.yellow.shade700;
                    break;
                  default:
                    statusColor = Colors.green;
                }

                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            VegetableDetailScreen(veg: veg),
                      ),
                    );
                    if (result == true) {
                      load();
                    }
                  },

                  // 🌟 CARD
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),

                    child: Row(
                      children: [
                        // 🖼 IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/${veg['imageName']}.png",
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.image, size: 50),
                          ),
                        ),

                        SizedBox(width: 12),

                        // TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                veg['name'] ?? "Unnamed",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              SizedBox(height: 4),

                              Text(
                                "Days left: $days",
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ➡️ ICON
                        Icon(Icons.chevron_right,
                            color: Colors.grey)
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}