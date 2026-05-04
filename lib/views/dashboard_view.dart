import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_app/themes/app_theme.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton.extended(
          onPressed: () => _showBookingDialog(context),
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add, color: AppColors.white),
          label: const Text(
            "New Counter Slot Booking",
            style: TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search Bookings",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Obx(
              () => Row(
                children: [
                  _card("Hissas", "${c.hissasD1}/${c.hissasD2}/${c.hissasD3}"),
                  _card(
                    "Booked",
                    "${c.bookedD1.value.toStringAsFixed(1)}/"
                        "${c.bookedD2.value.toStringAsFixed(1)}/"
                        "${c.bookedD3.value.toStringAsFixed(1)}",
                  ),
                  _card("Remaining", "0/0/0"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: Obx(() {
                if (c.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: c.bookings.length,
                  itemBuilder: (_, i) {
                    final b = c.bookings[i];

                    return Card(
                      child: ListTile(
                        title: Text(b.code),
                        subtitle: Text("${b.centreName} • ${b.dayCode}"),
                        trailing: Text("₹${b.amount}"),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String t, String v) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(t),
              const SizedBox(height: 5),
              Text(v, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    final c = controller;

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Obx(() {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "New Booking",
                        // ignore: deprecated_member_use
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: AppColors.error,
                          size: 25,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  DropdownButtonFormField(
                    items: c.centres
                        .map<DropdownMenuItem>(
                          (e) => DropdownMenuItem(
                            value: e["id"].toString(),
                            child: Text(e["name"]),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      c.selectedCentreId.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(labelText: "Centre"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: ["day1", "day2", "day3"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.selectedDay.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(labelText: "Day"),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: ["Matloob", "Waqf (Hyderabad)", "Waqf"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => c.bookingType.value = v.toString(),
                    decoration: const InputDecoration(
                      labelText: "Booking Type",
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField(
                    items: ["Big", "Small"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.animalType.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(labelText: "Animal Type"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: c.hissasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Hissas"),
                    onChanged: (_) => c.recalculate(),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: c.animalCountController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Animal Count",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: c.perDayCapacityController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Per Day Capacity",
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: c.amountController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Amount"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: c.receivedController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: "Reason"),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: c.receivedController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Received Amount",
                    ),
                  ),

                  const SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () async {
                      await c.createBooking();
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
