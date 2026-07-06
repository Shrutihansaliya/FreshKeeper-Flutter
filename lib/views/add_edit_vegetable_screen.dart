import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/image_names.dart';
import '../utils/freshness.dart';

class AddEditVegetableScreen extends StatefulWidget {
  final Map? vegetable;
  final String type;

  AddEditVegetableScreen({this.vegetable, required this.type});

  @override
  _AddEditVegetableScreenState createState() =>
      _AddEditVegetableScreenState();
}

class _AddEditVegetableScreenState
    extends State<AddEditVegetableScreen> {
  DBHelper db = DBHelper();

  TextEditingController name = TextEditingController();
  TextEditingController qty = TextEditingController();
  TextEditingController notes = TextEditingController();

  int shelfLife = 5;
  String unit = "g";

  // ✅ FIX: dynamic default image
  late String imageName;

  int? categoryId;
  String error = "";

  List categories = [];

  @override
  void initState() {
    super.initState();

    final imageOptions =
        widget.type == "fruit" ? fruitImages : vegetableImages;
    imageName = imageOptions.first;

    loadCategories();

    if (widget.vegetable != null) {
      final v = widget.vegetable!;
      name.text = v['name'] ?? "";
      qty.text = v['quantity'].toString();
      notes.text = v['notes'] ?? "";
      shelfLife = v['shelfLifeDays'] ?? 5;
      imageName = imageOptions.contains(v['imageName'])
          ? v['imageName']
          : imageOptions.first;
      categoryId = v['categoryId'];
    }
  }

  loadCategories() async {
    categories = await db.getCategoriesByType(widget.type);
    setState(() {});
  }

  bool validate() {
    if (name.text.trim().isEmpty) {
      error = "Name required";
      return false;
    }
    if (qty.text.trim().isEmpty ||
        double.tryParse(qty.text) == null) {
      error = "Enter valid quantity";
      return false;
    }

    double? value = double.tryParse(qty.text);
    if (value == null || value < 1) {
      error = "Quantity must be at least 1";
      return false;
    }

    if (categoryId == null) {
      error = "Select category";
      return false;
    }

    error = "";
    return true;
  }

  save() async {
    if (!validate()) {
      setState(() {});
      return;
    }

    double value = double.parse(qty.text);
    int grams =
    unit == "kg" ? (value * 1000).toInt() : value.toInt();

    int days = daysLeft(DateTime.now().toString(), shelfLife);
    String status = getStatus(grams, days);

    await db.insertVegetable({
      "name": name.text,
      "quantity": grams,
      "imageName": imageName,
      "notes": notes.text,
      "purchaseDate": DateTime.now().toString(),
      "shelfLifeDays": shelfLife,
      "status": status,
      "categoryId": categoryId
    }, widget.type);

    Navigator.pop(context);
  }

  Widget inputField(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey)),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: child,
        ),
        SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageOptions =
        (widget.type == "fruit" ? fruitImages : vegetableImages)
            .toSet()
            .toList();
    final selectedImage =
        imageOptions.contains(imageName) ? imageName : imageOptions.first;

    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: Text(widget.vegetable == null
            ? "Add Vegetable"
            : "Edit Vegetable"),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 15),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                children: [
                  // 🖼 IMAGE PICKER (FIXED)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: selectedImage,
                      isExpanded: true,
                      underline: SizedBox(),

                      items: imageOptions.map((img) {
                        return DropdownMenuItem(
                          value: img,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/$img.png",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,

                                // ✅ FIX: no crash if image missing
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                    color: Colors.grey,
                                  );
                                },
                              ),
                              SizedBox(width: 10),
                              Text(img),
                            ],
                          ),
                        );
                      }).toList(),

                      onChanged: (v) =>
                          setState(() => imageName = v!),
                    ),
                  ),

                  SizedBox(height: 10),

                  inputField("Name", TextField(controller: name)),

                  inputField(
                    "Quantity",
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: qty,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton(
                          value: unit,
                          underline: SizedBox(),
                          items: ["g", "kg"]
                              .map((e) => DropdownMenuItem(
                              value: e, child: Text(e)))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => unit = v!),
                        )
                      ],
                    ),
                  ),

                  inputField("Notes", TextField(controller: notes)),

                  inputField(
                    "Purchase Date",
                    Text(DateTime.now()
                        .toString()
                        .substring(0, 10)),
                  ),

                  inputField(
                    "Shelf Life (days)",
                    Row(
                      children: [
                        Text("$shelfLife"),
                        Expanded(
                          child: Slider(
                            value: shelfLife.toDouble(),
                            min: 0,
                            max: 60,
                            divisions: 59,
                            onChanged: (v) =>
                                setState(() => shelfLife = v.toInt()),
                          ),
                        )
                      ],
                    ),
                  ),

                  inputField(
                    "Category",
                    DropdownButton<int>(
                      value: categoryId,
                      isExpanded: true,
                      underline: SizedBox(),
                      hint: Text("Select Category"),
                      items:
                      categories.map<DropdownMenuItem<int>>((c) {
                        return DropdownMenuItem<int>(
                          value: c['id'] as int,
                          child: Text(c['name']),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => categoryId = v),
                    ),
                  ),
                ],
              ),
            ),

            if (error.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(10),
                child:
                Text(error, style: TextStyle(color: Colors.red)),
              ),

            SizedBox(height: 10),

            // ✅ FIX: button color by type
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.type == "fruit"
                      ? Colors.orange
                      : Colors.green,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: save,
                child: Text("Save"),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}