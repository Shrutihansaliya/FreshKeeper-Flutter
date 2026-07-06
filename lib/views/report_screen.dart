import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  DBHelper db = DBHelper();

  int vegWeek = 0;
  int fruitWeek = 0;
  int vegMonth = 0;
  int fruitMonth = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    vegWeek = await db.getExpiredCount("veg", 7);
    fruitWeek = await db.getExpiredCount("fruit", 7);
    vegMonth = await db.getExpiredCount("veg", 30);
    fruitMonth = await db.getExpiredCount("fruit", 30);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text("Reports"),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: Colors.grey.shade800, // dark gray
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildDescriptionCard(),

            SizedBox(height: 16),
            buildSection("This Week", vegWeek, fruitWeek),

            SizedBox(height: 20),

            buildSection("This Month", vegMonth, fruitMonth),
          ],
        ),
      ),
    );
  }

  // 🔥 SECTION (Week / Month)
  Widget buildSection(String title, int veg, int fruit) {
    return Container(
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),

          SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: buildCountCard(
                  "Vegetables",
                  veg,
                  Colors.green,
                  Icons.eco,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: buildCountCard(
                  "Fruits",
                  fruit,
                  Colors.orange,
                  Icons.apple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🌈 COUNT CARD (PREMIUM)
  Widget buildCountCard(
      String title, int count, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),

          SizedBox(height: 8),

          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),

          SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }


  Widget buildDescriptionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: Colors.blue),

          SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Expiry Report",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue.shade800,
                  ),
                ),

                SizedBox(height: 6),

                Text(
                  "This report shows the number of vegetables and fruits that expired in the last 7 days (weekly) and last 30 days (monthly).",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}