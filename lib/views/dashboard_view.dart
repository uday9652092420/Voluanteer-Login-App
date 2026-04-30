import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_app/themes/app_theme.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            "DashBoard",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.primary, // Change this to your desired color
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 40, 189, 235),
          onPressed: () {
            _showBookingDialog(context);
          },
          label: const Text(
            "New Counter Booking",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Column(
          children: [
            /// 🔹 Summary Cards
            ///  /// 🔹 Search Field
            TextField(
              decoration: InputDecoration(
                hintText: "Search Bookings",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _card("Remaining", "0/0/0"),
                _card("Booked", "2/0/0"),
                _card("Hissas", "8/0/0"),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔹 List
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.bookings.length,
                  itemBuilder: (context, index) {
                    final item = controller.bookings[index];

                    return Card(
                      child: ListTile(
                        title: Text(item["receipt"]!),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["centre"]!),
                            Text("${item["day"]} • ${item["type"]}"),
                          ],
                        ),
                        trailing: Text(item["amount"]!),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Card Widget
  Widget _card(String title, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 12)),
              SizedBox(height: 5),
              Text(
                value,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// 🔹 Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "New Booking",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// 🔹 Form Fields
                _inputField("Centre"),
                _inputField("Day"),
                _inputField("Booking Type"),

                Row(
                  children: [
                    Expanded(child: _inputField("Animal Type")),
                    const SizedBox(width: 10),
                    Expanded(child: _inputField("Hissas")),
                  ],
                ),

                Row(
                  children: [
                    Expanded(child: _inputField("Per Day Capacity")),
                    const SizedBox(width: 10),
                    Expanded(child: _inputField("Animal Count (Auto)")),
                  ],
                ),

                Row(
                  children: [
                    Expanded(child: _inputField("Amount Type")),
                    const SizedBox(width: 10),
                    Expanded(child: _inputField("Amount")),
                  ],
                ),

                _inputField("Receipt No"),
                _inputField("Reason"),
                _inputField("Received Amount"),

                const SizedBox(height: 15),

                /// 🔹 Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: () {
                        // TODO: Save logic
                        Get.back();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputField(String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
