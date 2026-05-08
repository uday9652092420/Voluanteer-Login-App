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
        title: const Text(
          "DASHBOARD",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
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
                        "${c.bookedD3.value.toStringAsFixed(1)}/",
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
    c.fetchNextReceiptNumber();

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
                          controller.clearForm();
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
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value: c.selectedCentreId.value.isEmpty
                          ? null
                          : c.selectedCentreId.value,

                      items: c.centres.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          value: e["id"].toString(),
                          child: Text(e["name"].toString()),
                        );
                      }).toList(),

                      onChanged: null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // DAY DROPDOWN
                  DropdownButtonFormField(
                    value: c.selectedDay.value.isEmpty
                        ? null
                        : c.selectedDay.value,
                    items: ["day1", "day2", "day3"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.selectedDay.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 10),

                  // BOOKING TYPE DROPDOWN
                  DropdownButtonFormField(
                    value: c.bookingType.value.isEmpty
                        ? null
                        : c.bookingType.value,
                    items: ["Matloob", "Waqf (Hyderabad)", "Waqf"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.bookingType.value = v.toString();
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 10),
                  // ANIMAL TYPE DROPDOWN
                  DropdownButtonFormField(
                    value: c.animalType.value.isEmpty
                        ? null
                        : c.animalType.value,
                    items: ["Big", "Small"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.animalType.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: c.hissasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Hissas"),
                    onChanged: (_) => c.recalculate(),
                  ),

                  //animalcount
                  const SizedBox(height: 15),
                  TextField(
                    controller: c.animalCountController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Animal Count",
                    ),
                  ),

                  //amounttype
                  const SizedBox(height: 15),
                  //amount type
                  DropdownButtonFormField(
                    value: c.amountType.value.isEmpty
                        ? null
                        : c.amountType.value,
                    items: ["Local", "Out-of-State"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.amountType.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(),
                  ),
                  const SizedBox(height: 15),

                  //perday capacity
                  TextField(
                    controller: c.perDayCapacityController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: "Per Day Capacity",
                    ),
                  ),

                  const SizedBox(height: 10),
                  TextField(
                    controller: c.amountController,
                    readOnly: true,
                    decoration: const InputDecoration(labelText: "Amount"),
                  ),
                  const SizedBox(height: 10),

                  //ReceiptNo
                  TextField(
                    controller: c.receiptController,
                    readOnly: true,

                    decoration: const InputDecoration(labelText: "Receipt No"),
                  ),
                  const SizedBox(height: 10),

                  //Reason
                  TextField(
                    controller: c.reasonController,
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
                    child: const Text("Book"),
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
