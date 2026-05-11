import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../themes/app_theme.dart';

class Dailogboxform extends GetView<DashboardController> {
  const Dailogboxform({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 850,
        padding: const EdgeInsets.all(20),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Update",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),

                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),

              const Divider(),

              const SizedBox(height: 15),

              /// ROW 1
              Row(
                children: [
                  /// CENTRE
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: c.selectedCentreId.value.isEmpty
                          ? null
                          : c.selectedCentreId.value,

                      decoration: const InputDecoration(
                        labelText: "Centre *",
                        border: OutlineInputBorder(),
                      ),

                      items: c.centres.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                          value: e["id"].toString(),
                          child: Text(e["name"].toString()),
                        );
                      }).toList(),

                      onChanged: null,
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// DAY
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: c.allowedDays.contains(c.selectedDay.value)
                          ? c.selectedDay.value
                          : null,

                      decoration: const InputDecoration(
                        labelText: "Day",
                        border: OutlineInputBorder(),
                      ),

                      items: c.allowedDays
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (v) {
                        if (v != null) {
                          c.selectedDay.value = v;
                        }
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// ANIMAL TYPE
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: c.animalType.value,

                      decoration: const InputDecoration(
                        labelText: "Animal Type",
                        border: OutlineInputBorder(),
                      ),

                      items: ["Big", "Small"]
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            ),
                          )
                          .toList(),

                      onChanged: (v) {
                        c.animalType.value = v!;
                        c.recalculate();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// ROW 2
              Row(
                children: [
                  /// DATE
                  Expanded(
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Centre & Date *",
                        border: const OutlineInputBorder(),
                        hintText:
                            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                        suffixIcon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// TOTAL
                  Expanded(
                    child: TextField(
                      controller: c.hissasController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => c.recalculate(),
                      decoration: const InputDecoration(
                        labelText: "Total *",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// ANIMALS SLAUGHTERED
                  Expanded(
                    child: TextField(
                      controller: c.animalCountController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Animals Slaughtered",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              /// ROW 3
              Row(
                children: [
                  /// REMAINING
                  Expanded(
                    child: TextField(
                      controller: c.perDayCapacityController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Remaining (Auto)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  /// SUPERVISOR
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Supervisor",
                        hintText: "Letters and spaces only",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),

              const SizedBox(height: 15),

              /// REMARKS
              TextField(
                controller: c.reasonController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Remarks",
                  hintText: "Letters and spaces only",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              /// BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),

                  const SizedBox(width: 10),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),

                    onPressed: () async {
                      await c.createBooking();
                    },

                    icon: const Icon(Icons.save, color: Colors.white),

                    label: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
