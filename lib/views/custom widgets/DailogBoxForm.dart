import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../themes/app_theme.dart';

class Dailogboxform extends GetView<DashboardController> {
  const Dailogboxform({super.key});

  @override
  Widget build(BuildContext context) {
    final c = controller;

    /// FETCH ALL CENTRES
    c.fetchUpdateCentres();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: Container(
        width: 500,
        padding: const EdgeInsets.all(20),

        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Add Update",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Get.back();
                      controller.clearUpdateForm();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.error,
                      size: 28,
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              /// CENTRE
              Obx(
                () => DropdownButtonFormField<String?>(
                  value: controller.selectedUpdateCentreId.value,

                  decoration: InputDecoration(
                    labelText: "Select Centre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  hint: const Text("Select Centre"),

                  items: controller.updateCentres
                      .map<DropdownMenuItem<String?>>((e) {
                        return DropdownMenuItem<String?>(
                          value: e["id"].toString(),
                          child: Text(e["name"].toString()),
                        );
                      })
                      .toList(),

                  onChanged: (v) {
                    controller.selectedUpdateCentreId.value = v;
                  },
                ),
              ),
              const SizedBox(height: 18),
              Obx(
                () => DropdownButtonFormField<String?>(
                  value: controller.updateSelectedDay.value,

                  decoration: InputDecoration(
                    labelText: "Select Day",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  hint: const Text("Select Day"),

                  items: controller.updateDays.map<DropdownMenuItem<String?>>((
                    day,
                  ) {
                    return DropdownMenuItem<String?>(
                      value: day,
                      child: Text(day),
                    );
                  }).toList(),

                  onChanged: (v) {
                    controller.updateSelectedDay.value = v;
                  },
                ),
              ),
              const SizedBox(height: 18),
              Obx(
                () => DropdownButtonFormField<String?>(
                  value: controller.updateAnimalType.value,

                  decoration: InputDecoration(
                    labelText: "Select Animal Type",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  hint: const Text("Select Animal Type"),

                  items: ["Big", "Small"]
                      .map<DropdownMenuItem<String?>>(
                        (type) => DropdownMenuItem<String?>(
                          value: type,
                          child: Text(type),
                        ),
                      )
                      .toList(),

                  onChanged: (v) {
                    controller.updateAnimalType.value = v;
                  },
                ),
              ),
              const SizedBox(height: 18),

              /// DATE
              TextField(
                decoration: InputDecoration(
                  labelText: "Centre & Date *",
                  border: const OutlineInputBorder(),
                  hintText:
                      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),

              const SizedBox(height: 18),

              /// TOTAL
              TextField(
                decoration: const InputDecoration(
                  labelText: "Total *",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// ANIMALS SLAUGHTERED
              TextField(
                decoration: const InputDecoration(
                  labelText: "Animals Slaughtered",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// REMAINING
              TextField(
                decoration: const InputDecoration(
                  labelText: "Remaining (Auto)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// SUPERVISOR
              TextField(
                decoration: const InputDecoration(
                  labelText: "Supervisor",
                  hintText: "Letters and spaces only",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// REMARKS
              TextField(
                maxLines: 5,
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
                      controller.clearUpdateForm();
                    },
                    child: const Text("Cancel"),
                  ),

                  const SizedBox(width: 15),

                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 15,
                      ),
                    ),

                    onPressed: () {},

                    icon: const Icon(Icons.save, color: Colors.white),

                    label: const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
