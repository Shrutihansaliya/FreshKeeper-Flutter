// import 'package:flutter/material.dart';
// import 'category_list_screen.dart';
// import 'vegetable_list_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: Padding(
//         padding: EdgeInsets.only(top: 60),
//         child: Column(
//           children: [
//             Text(
//               "FreshKeeper",
//               style: TextStyle(
//                 fontSize: 32,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//
//             SizedBox(height: 20),
//
//             // 📂 Categories
//             buildTitle("Categories"),
//
//             buildCard("Vegetable Categories", Colors.green, Icons.eco, () {
//               Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (_) => CategoryListScreen(type: "veg")));
//             }),
//
//             buildCard("Fruit Categories", Colors.orange, Icons.apple, () {
//               Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (_) => CategoryListScreen(type: "fruit")));
//             }),
//
//             SizedBox(height: 20),
//
//             // 🥬 Vegetables
//             buildTitle("Vegetables"),
//
//             buildCard("Vegetables", Colors.green, Icons.eco, () {
//               Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (_) => VegetableListScreen(type: "veg")));
//             }),
//
//             SizedBox(height: 20),
//
//             // 🍎 Fruits
//             buildTitle("Fruits"),
//
//             buildCard("Fruits", Colors.orange, Icons.apple, () {
//               Navigator.push(context,
//                   MaterialPageRoute(
//                       builder: (_) => VegetableListScreen(type: "fruit")));
//             }),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Text(title,
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//       ),
//     );
//   }
//
//   Widget buildCard(String title, Color color, IconData icon, Function onTap) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//         padding: EdgeInsets.all(18),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.2),
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 30),
//             SizedBox(width: 10),
//             Text(title,
//                 style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: color)),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'report_screen.dart';
import '../database/db_helper.dart';
import 'category_list_screen.dart';
import 'vegetable_list_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: Padding(
        padding: EdgeInsets.only(top: 60),
        child: Column(
          children: [
            // 🌿 TITLE
            Text(
              "FreshKeeper",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),

            SizedBox(height: 30),

            // 🥬 VEGETABLES
            buildCard(
              "Vegetables",
              Colors.green.shade100,
              Colors.green,
              Icons.eco,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => VegetableListScreen(type: "veg")));
              },
            ),

            SizedBox(height: 15),

            // 🍎 FRUITS
            buildCard(
              "Fruits",
              Colors.orange.shade100,
              Colors.orange,
              Icons.apple,
                  () {
                Navigator.push(context,
                    MaterialPageRoute(
                        builder: (_) => VegetableListScreen(type: "fruit")));
              },
            ),

            SizedBox(height: 25),

            // 📂 CATEGORY ROW
            Row(
              children: [
                Expanded(
                  child: buildSmallCard(
                    "Veg Categories",
                    Colors.pink.shade100,
                    Colors.pink,
                    Icons.eco,
                        () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CategoryListScreen(type: "veg")));
                    },
                  ),
                ),
                Expanded(
                  child: buildSmallCard(
                    "Fruit Categories",
                    Colors.purple.shade100,
                    Colors.purple,
                    Icons.apple,
                        () {
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  CategoryListScreen(type: "fruit")));
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      ),

      bottomNavigationBar: buildBottomBar(context, 0),
    );
  }

  // 🔹 BIG CARD (CLEAN STYLE)
  Widget buildCard(String title, Color bgColor, Color color,
      IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: color),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 🔹 SMALL CARD
  Widget buildSmallCard(String title, Color bgColor, Color color,
      IconData icon, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 26, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w600, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(
      IconData icon, String label, bool selected, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: selected ? Colors.green : Colors.grey),
          Text(label,
              style: TextStyle(
                  color: selected ? Colors.green : Colors.grey)),
        ],
      ),
    );
  }

  Widget buildBottomBar(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          buildNavItem(Icons.home, "Home", index == 0, () {}),

          buildNavItem(Icons.bar_chart, "Reports", index == 1, () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ReportScreen()));
          }),
        ],
      ),
    );
  }
}