import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: const Color.fromARGB(255, 14, 151, 214),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 40, 189, 235),
          onPressed: () {
            // Add your action here
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _card("Remaining", "0/0/0"),
                _card("Booked", "2/0/0"),
                _card("Hissas", "8/0/0"),
              ],
            ),

            const SizedBox(height: 15),

            /// 🔹 Search Field
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
}
