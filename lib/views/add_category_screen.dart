// import 'package:flutter/material.dart';
// import '../database/db_helper.dart';
//
// class AddCategoryScreen extends StatefulWidget {
//   @override
//   _AddCategoryScreenState createState() => _AddCategoryScreenState();
// }
//
// class _AddCategoryScreenState extends State<AddCategoryScreen> {
//   TextEditingController controller = TextEditingController();
//   DBHelper db = DBHelper();
//
//   void save() async {
//     if (controller.text.isEmpty) return;
//     await db.insertCategory(controller.text);
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Add Category")),
//       body: Column(
//         children: [
//           TextField(controller: controller),
//           ElevatedButton(onPressed: save, child: Text("Save"))
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class AddCategoryScreen extends StatefulWidget {
  final String type;

  AddCategoryScreen({required this.type});
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  TextEditingController controller = TextEditingController();
  DBHelper db = DBHelper();

  void save() async {
    if (controller.text.trim().isEmpty) return;

    await db.insertCategory(controller.text.trim(), widget.type);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = controller.text.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),

      // 🌫 BACKGROUND LIKE iOS
      backgroundColor: Colors.grey.shade100,

      body: Padding(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          children: [
            // 🧾 INPUT FIELD
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Category Name",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),

                  // INPUT BOX
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: controller,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: "Enter name...",
                        contentPadding: EdgeInsets.all(14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Spacer(),

            // 🟢 SAVE BUTTON
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: GestureDetector(
                onTap: isValid ? save : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: isValid
                        ? Colors.green
                        : Colors.green.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: isValid
                        ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.4),
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      )
                    ]
                        : [],
                  ),
                  child: Center(
                    child: Text(
                      "Save Category",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}