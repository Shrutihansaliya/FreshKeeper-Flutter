// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
//
// class VegetableListScreen extends StatefulWidget {
//   @override
//   _VegetableListScreenState createState() =>
//       _VegetableListScreenState();
// }
//
// class _VegetableListScreenState extends State<VegetableListScreen> {
//   DBHelper db = DBHelper();
//   List data = [];
//
//   @override
//   void initState() {
//     super.initState();
//     load();
//   }
//
//   load() async {
//     data = await db.getVegetables();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Vegetables")),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (_, i) {
//           return ListTile(
//             title: Text(data[i]['name'] ?? ""),
//
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/freshness.dart';
import 'add_edit_vegetable_screen.dart';
import 'vegetable_detail_screen.dart';

class VegetableListScreen extends StatefulWidget {
  final String type;

  VegetableListScreen({required this.type});
  @override
  _VegetableListScreenState createState() =>
      _VegetableListScreenState();
}

class _VegetableListScreenState extends State<VegetableListScreen> {
  DBHelper db = DBHelper();

  List allData = [];
  String search = "";
  String selectedStatus = "All";

  final statusOptions = [
    "All",
    "fresh",
    "useSoon",
    "urgent",
    "expired",
    "finished"
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    allData = await db.getVegetablesByType(widget.type);
    setState(() {});
  }

  // 🧠 FILTER + GROUP
  Map<String, List> get groupedData {
    List filtered = allData;

    // SEARCH
    if (search.isNotEmpty) {
      filtered = filtered
          .where((v) => v['name']
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase()))
          .toList();
    }

    // STATUS FILTER
    if (selectedStatus != "All") {
      filtered = filtered
          .where((v) => v['status'] == selectedStatus)
          .toList();
    }

    // GROUP BY CATEGORY NAME
    Map<String, List> grouped = {};
    for (var v in filtered) {
      String key = (v['categoryName'] ?? "Uncategorized").toString();
      grouped.putIfAbsent(key, () => []).add(v);
    }

    return grouped;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(widget.type == "fruit" ? "My Fruits" : "My Vegetables"),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle, color: Colors.green),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => AddEditVegetableScreen(type: widget.type)));
              load();
            },
          )
        ],
      ),

      body: Column(
        children: [
          // 🔍 SEARCH
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onChanged: (v) => setState(() => search = v),
              decoration: InputDecoration(
                hintText: widget.type == "fruit"
                    ? "Search fruits..."
                    : "Search vegetables...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
              ),
            ),
          ),

          //  STATUS FILTER
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: statusOptions.map((s) {
                bool selected = selectedStatus == s;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedStatus = s),
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.green
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(
                          color:
                          selected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 10),

          //  LIST
          Expanded(
            child: groupedData.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.type == "fruit" ? Icons.apple : Icons.eco,
                    size: 60,
                    color: widget.type == "fruit"
                        ? Colors.orange
                        : Colors.green,
                  ),
                  Text(widget.type == "fruit"
                      ? "No Fruits"
                      : "No Vegetables"),
                  Text(widget.type == "fruit"
                      ? "Add your first fruit"
                      : "Add your first vegetable"),
                ],
              ),
            )
                : ListView(
              children: groupedData.entries.map((entry) {
                return Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        entry.key,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    ...entry.value.map((veg) {
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  VegetableDetailScreen(
                                      veg: veg),
                            ),
                          );

                          if (result == true) {
                            load();
                          }
                        },

                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                              )
                            ],
                          ),

                          child: Row(
                            children: [
                              // IMAGE
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/${veg['imageName']}.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      Icon(Icons.image),
                                ),
                              ),

                              SizedBox(width: 10),

                              // TEXT
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      veg['name'],
                                      style: TextStyle(
                                          fontWeight:
                                          FontWeight.bold),
                                    ),

                                    SizedBox(height: 5),

                                    // STATUS BADGE
                                    Container(
                                      padding:
                                      EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3),
                                      decoration: BoxDecoration(
                                        color: statusColor(
                                            veg['status'])
                                            .withOpacity(0.2),
                                        borderRadius:
                                        BorderRadius.circular(
                                            20),
                                      ),
                                      child: Text(
                                        veg['status'],
                                        style: TextStyle(
                                          color: statusColor(
                                              veg['status']),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 5),

                                    Text(
                                      "Days left: ${daysLeft(veg['purchaseDate'], veg['shelfLifeDays'])}",
                                      style: TextStyle(
                                          color: statusColor(
                                              veg['status'])),
                                    ),
                                  ],
                                ),
                              ),

                              // QUANTITY
                              Column(
                                children: [
                                  Text(
                                    "${veg['quantity']}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  Text("g"),
                                ],
                              ),

                              Icon(Icons.chevron_right,
                                  color: Colors.grey)
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}