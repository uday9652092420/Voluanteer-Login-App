import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login_app/themes/app_theme.dart';

import '../controllers/dashboard_controller.dart';
import 'custom widgets/DailogBoxForm.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      backgroundColor: const Color(0xffeef2f5),

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Qurbani Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton.extended(
              heroTag: "booking",
              onPressed: () => _showBookingDialog(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "New Counter Slot Booking",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            FloatingActionButton.extended(
              heroTag: "update",
              onPressed: () => _showDailogBoxForm(context),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "Add Day Wise Qurbani Update",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Obx(() {
        if (c.dashboardLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final dashboard = c.dashboardData.value;

        final stats = dashboard["data"]?["stats"] ?? {};

        final List dayWise = dashboard["data"]?["dayWiseBreakdown"] ?? [];

        final List centres = dashboard["data"]?["centreBreakdown"] ?? [];

        return RefreshIndicator(
          onRefresh: () async {
            await c.fetchDashboardData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Eid-ul-Adha (Qurbani) Dashboard",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 4),

                const Text(
                  "Madrasa Qurbani Operations & Finance Control Panel",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),

                const SizedBox(height: 18),

                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.15,
                  children: [
                    _dashboardCard(
                      title: "Total Booking Centres",
                      value: "${stats['totalCentres'] ?? 0}",
                      icon: Icons.location_on,
                    ),

                    _dashboardCard(
                      title: "Total Animals",
                      value: "${stats['totalAnimals'] ?? 0}",
                      icon: Icons.pets,
                    ),

                    _dashboardCard(
                      title: "Total Bookings",
                      value: "${stats['totalBookings'] ?? 0}",
                      icon: Icons.book_online,
                    ),

                    _dashboardCard(
                      title: "Total Slaughtered",
                      value: "${stats['totalSlaughtered'] ?? 0}",
                      icon: Icons.analytics,
                    ),

                    _dashboardCard(
                      title: "Amount Collected",
                      value: "₹${stats['amountCollected'] ?? 0}",
                      icon: Icons.currency_rupee,
                    ),

                    _dashboardCard(
                      title: "Balance Cash",
                      value: "₹${stats['balanceCash'] ?? 0}",
                      icon: Icons.account_balance_wallet,
                    ),

                    _dashboardCard(
                      title: "Total Expenses",
                      value: "₹${stats['totalExpenses'] ?? 0}",
                      icon: Icons.money_off,
                    ),

                    _dashboardCard(
                      title: "Remaining Animals",
                      value: "${stats['remainingAnimals'] ?? 0}",
                      icon: Icons.pets,
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                _sectionCard(
                  title: "Day-wise Slaughter",
                  child: Column(
                    children: dayWise.map((item) {
                      return _progressRow(
                        item["day"]?.toString() ?? "",
                        (item["slaughtered"] ?? 0).toDouble(),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                _sectionCard(
                  title: "Centre-wise Bookings",
                  child: Column(
                    children: centres.map((item) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Bookings: ${item['bookings'] ?? 0}"),

                                Text(
                                  "Slaughtered: ${item['slaughtered'] ?? 0}",
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Pending: ${item['pending'] ?? 0}"),

                                Text(
                                  "${item['status'] ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 18),

                /// =============================
                /// VENDOR PURCHASES
                /// =============================
                _sectionCard(
                  title: "Vendor Purchases",
                  child: Column(
                    children: [
                      _vendorRow(
                        vendor: "Khaleel",
                        quantity: "90000",
                        amount: "₹66,60,000",
                      ),

                      _vendorRow(
                        vendor: "Jahangeer",
                        quantity: "140",
                        amount: "₹40,60,000",
                      ),

                      _vendorRow(
                        vendor: "FAWWAZ",
                        quantity: "28",
                        amount: "₹92,400",
                      ),

                      _vendorRow(
                        vendor: "Robin",
                        quantity: "15",
                        amount: "₹25,000",
                      ),

                      _vendorRow(
                        vendor: "Fahaad",
                        quantity: "4",
                        amount: "₹18,000",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// =============================
                /// CENTRE SUMMARY
                /// =============================
                _sectionCard(
                  title: "Centre Summary",
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        Colors.grey.shade200,
                      ),
                      columns: const [
                        DataColumn(label: Text("Centre")),
                        DataColumn(label: Text("Bookings")),
                        DataColumn(label: Text("Slaughtered")),
                        DataColumn(label: Text("Pending")),
                        DataColumn(label: Text("Status")),
                      ],
                      rows: centres.map<DataRow>((item) {
                        final bookings = item['bookings'] ?? 0;
                        final slaughtered = item['slaughtered'] ?? 0;

                        return DataRow(
                          cells: [
                            DataCell(Text(item['name']?.toString() ?? '')),

                            DataCell(Text(bookings.toString())),

                            DataCell(Text(slaughtered.toString())),

                            DataCell(
                              Text(
                                ((bookings as int) - (slaughtered as int))
                                    .toString(),
                              ),
                            ),

                            const DataCell(
                              Text(
                                "active",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _dashboardCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 30),

          const SizedBox(height: 10),

          Text(
            title,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 15),

          child,
        ],
      ),
    );
  }

  Widget _progressRow(String day, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              day,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 14,
                value: value / 500,
                backgroundColor: Colors.grey.shade300,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Text(
            value.toInt().toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _vendorRow({
    required String vendor,
    required String quantity,
    required String amount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vendor,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "$quantity — $amount",
                style: const TextStyle(color: Colors.black54),
              ),
            ],
          ),

          Row(
            children: [
              OutlinedButton(onPressed: () {}, child: const Text("Track")),

              const SizedBox(width: 8),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text("View"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDailogBoxForm(BuildContext context) {
    final controller = Get.find<DashboardController>();

    controller.fetchUpdateCentres();

    Get.dialog(const Dailogboxform());
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
                  //center
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

                      decoration: const InputDecoration(labelText: "Center"),
                    ),
                  ),
                  const SizedBox(height: 10),

                  DropdownButtonFormField(
                    initialValue: c.amountType.value.isEmpty
                        ? null
                        : c.amountType.value,
                    items: ["Local", "Out-of-State"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.amountType.value = v.toString();
                      c.recalculate();
                    },
                    decoration: const InputDecoration(labelText: "Region"),
                  ),
                  const SizedBox(height: 10),
                  // DAY DROPDOWN
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: c.allowedDays.contains(c.selectedDay.value)
                          ? c.selectedDay.value
                          : null,

                      items: c.allowedDays
                          .toSet() // ✅ remove duplicates
                          .map<DropdownMenuItem<String>>(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (v) {
                        if (v != null) {
                          c.selectedDay.value = v;
                          c.recalculate();
                        }
                      },

                      decoration: const InputDecoration(labelText: "Day"),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // BOOKING TYPE DROPDOWN
                  DropdownButtonFormField(
                    initialValue: c.bookingType.value.isEmpty
                        ? null
                        : c.bookingType.value,
                    items: ["Matloob", "Waqf (Hyderabad)", "Waqf"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) {
                      c.bookingType.value = v.toString();
                    },

                    decoration: const InputDecoration(
                      labelText: "Booking Type",
                    ),
                  ),
                  const SizedBox(height: 10),
                  // ANIMAL TYPE DROPDOWN
                  DropdownButtonFormField(
                    initialValue: c.animalType.value.isEmpty
                        ? null
                        : c.animalType.value,
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

                  // //animalcount
                  // const SizedBox(height: 15),
                  // TextField(
                  //   controller: c.animalCountController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: "Animal Count",
                  //   ),
                  // ),

                  //amounttype
                  const SizedBox(height: 15),

                  // //perday capacity
                  // TextField(
                  //   controller: c.perDayCapacityController,
                  //   readOnly: true,
                  //   decoration: const InputDecoration(
                  //     labelText: "Per Day Capacity",
                  //   ),
                  // ),
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
