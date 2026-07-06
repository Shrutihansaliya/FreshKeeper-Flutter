// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
// import 'add_category_screen.dart';
// import 'category_detail_screen.dart';
//
// class CategoryListScreen extends StatefulWidget {
//   @override
//   _CategoryListScreenState createState() => _CategoryListScreenState();
// }
//
// class _CategoryListScreenState extends State<CategoryListScreen> {
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
//     data = await db.getCategories();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Categories")),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (_, i) {
//           return ListTile(
//             title: Text(data[i]['name'] ?? ""),
//             onTap: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (_) =>
//                           CategoryDetailScreen(category: data[i])));
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Navigator.push(
//               context, MaterialPageRoute(builder: (_) => AddCategoryScreen()));
//           load();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import 'add_category_screen.dart';
import 'category_detail_screen.dart';

class CategoryListScreen extends StatefulWidget {
  final String type;

  CategoryListScreen({required this.type});

  @override
  _CategoryListScreenState createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  DBHelper db = DBHelper();
  List data = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  load() async {
    data = await db.getCategoriesByType(widget.type);
    setState(() {});
  }

  // 🗑 DELETE
  void confirmDelete(int id) {
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
            Text("Delete Category"),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure you want to delete this category?"),
            SizedBox(height: 10),
            Text(
              "⚠️ All vegetables in this category will also be deleted.",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await db.deleteCategory(id);
              load();

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "Category and all related vegetables deleted"),
                ),
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

  // ✏️ EDIT
  editDialog(Map category) {
    TextEditingController controller =
    TextEditingController(text: category['name']);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Category"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel")),
          TextButton(
              onPressed: () async {
                final dbClient = await db.db;
                await dbClient.update(
                  "category",
                  {"name": controller.text},
                  where: "id=?",
                  whereArgs: [category['id']],
                );
                Navigator.pop(context);
                load();
              },
              child: Text("Update"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 🌈 GRADIENT BACKGROUND
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.type == "fruit"
                ? [Colors.white, Colors.orange.shade100]
                : [Colors.white, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              // 🔝 HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                     IconButton(
                      icon: Icon(
                        Icons.home,
                        color: Colors.blueGrey, // dark gray
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),

                    SizedBox(width: 10),
                    Text(
                      "Categories",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddCategoryScreen(type: widget.type),
                          ),
                        );
                        load();
                      },
                      child: Icon(Icons.add_circle,
                          color: Colors.green, size: 30),
                    )
                  ],
                ),
              ),

              // ✨ SECTION TITLE
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      "Your Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10),

              // 📜 LIST
              Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (_, i) {
                    final cat = data[i];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CategoryDetailScreen(category: cat),
                          ),
                        );
                      },

                      // 🌟 CARD
                      child: Container(
                        margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),

                        child: Row(
                          children: [
                            // 🌿 ICON WITH GLOW
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green.withOpacity(0.15),
                              ),
                              child: Icon(Icons.eco,
                                  color: Colors.green, size: 32),
                            ),

                            SizedBox(width: 15),

                            // TEXT
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cat['name'] ?? "Unknown",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                if (cat['createdAt'] != null)
                                  Text(
                                    cat['createdAt'].toString().substring(0, 10),
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  )
                              ],
                            ),

                            Spacer(),

                            // ACTION BUTTONS
                            PopupMenuButton(
                              itemBuilder: (_) => [
                                PopupMenuItem(
                                  child: Text("Edit"),
                                  value: "edit",
                                ),
                                PopupMenuItem(
                                  child: Text("Delete"),
                                  value: "delete",
                                ),
                              ],
                              onSelected: (value) {
                                if (value == "edit") {
                                  editDialog(cat);
                                } else {
                                  confirmDelete(cat['id']);
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}