import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../utils/freshness.dart';

class EditVegetableScreen extends StatefulWidget {
  final Map veg;

  EditVegetableScreen({required this.veg});

  @override
  _EditVegetableScreenState createState() =>
      _EditVegetableScreenState();
}

class _EditVegetableScreenState
    extends State<EditVegetableScreen> {
  DBHelper db = DBHelper();

  TextEditingController qty = TextEditingController();
  TextEditingController notes = TextEditingController();

  int shelfLife = 5;
  String unit = "g";
  String status = "fresh";
  String error = "";

  final statusOptions = [
    "fresh",
    "useSoon",
    "urgent",
    "expired",
    "finished"
  ];

  @override
  void initState() {
    super.initState();
    loadInitial();
  }

  void loadInitial() {
    notes.text = widget.veg['notes'] ?? "";
    status = widget.veg['status'] ?? "fresh";
    shelfLife = widget.veg['shelfLifeDays'] ?? 5;

    int grams = widget.veg['quantity'] ?? 0;

    if (grams >= 1000) {
      unit = "kg";
      qty.text = (grams / 1000).toStringAsFixed(2);
    } else {
      unit = "g";
      qty.text = grams.toString();
    }
  }

  bool validate() {
    if (qty.text.isEmpty) {
      error = "Quantity required";
      return false;
    }
    if (double.tryParse(qty.text) == null) {
      error = "Invalid quantity";
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

    final purchaseDate = widget.veg['purchaseDate'] as String;
    int days = daysLeft(purchaseDate, shelfLife);
    String updatedStatus = getStatus(grams, days);

    final dbClient = await db.db;

    await dbClient.update(
      "vegetable",
      {
        "quantity": grams,
        "notes": notes.text,
        "shelfLifeDays": shelfLife,
        "status": updatedStatus,
      },
      where: "id=?",
      whereArgs: [widget.veg['id']],
    );

    Navigator.pop(context, true); // return success
  }

  Widget field(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w600)),
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
    return Scaffold(
      backgroundColor: Colors.grey.shade200,

      appBar: AppBar(
        title: Text("Edit Vegetable"),
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
                  // QUANTITY
                  field(
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

                  // NOTES
                  field(
                    "Notes",
                    TextField(controller: notes),
                  ),

                  // SHELF LIFE
                  field(
                    "Shelf Life",
                    Row(
                      children: [
                        Text("$shelfLife"),
                        Expanded(
                          child: Slider(
                            value: shelfLife.toDouble(),
                            min: 0,
                            max: 30,
                            divisions: 30,
                            onChanged: (v) => setState(
                                    () => shelfLife = v.toInt()),
                          ),
                        )
                      ],
                    ),
                  ),

                  // STATUS
                  field(
                    "Status",
                    DropdownButton<String>(
                      value: status,
                      isExpanded: true,
                      underline: SizedBox(),
                      items: statusOptions.map((s) {
                        return DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        );
                      }).toList(),
                      onChanged: (v) =>
                          setState(() => status = v!),
                    ),
                  ),
                ],
              ),
            ),

            if (error.isNotEmpty)
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(error,
                    style: TextStyle(color: Colors.red)),
              ),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: save,
                child: Text("Save Changes"),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}