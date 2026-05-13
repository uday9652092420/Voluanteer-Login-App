import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';
import '../../themes/app_theme.dart';

class Dailogboxform extends GetView<DashboardController> {
  const Dailogboxform({super.key});

  @override
  Widget build(BuildContext context) {
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
                    "Add Qurbani Update",
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
                () => TextFormField(
                  readOnly: true,

                  controller: TextEditingController(
                    text: controller.updateCentreName.value,
                  ),

                  decoration: InputDecoration(
                    labelText: "Centre",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.updateSelectedDay.value,

                  decoration: InputDecoration(
                    labelText: "Select Day",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  items: controller.updateAllowedDays.map((day) {
                    return DropdownMenuItem<String>(
                      value: day,
                      child: Text(day.toUpperCase()),
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
                  initialValue: controller.updateAnimalType.value,

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

              TextFormField(
                controller: controller.updateDateController,
                readOnly: true,

                decoration: InputDecoration(
                  labelText: "Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// TOTAL
              TextField(
                controller: controller.updateTotalController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Total *",
                  border: OutlineInputBorder(),
                ),

                onChanged: (v) {
                  controller.calculateRemaining();
                },
              ),
              const SizedBox(height: 18),

              /// ANIMALS SLAUGHTERED
              TextField(
                controller: controller.updateSlaughteredController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  labelText: "Animals Slaughtered",
                  border: OutlineInputBorder(),
                ),

                onChanged: (v) {
                  controller.calculateRemaining();
                },
              ),
              const SizedBox(height: 18),

              /// REMAINING
              TextField(
                controller: controller.updateRemainingController,
                readOnly: true,

                decoration: const InputDecoration(
                  labelText: "Remaining (Auto)",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// SUPERVISOR
              TextField(
                controller: controller.supervisorController,
                keyboardType: TextInputType.text,

                decoration: const InputDecoration(
                  labelText: "Supervisor",
                  hintText: "Letters and spaces only",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 18),

              /// REMARKS
              TextField(
                controller: controller.remarksController,
                keyboardType: TextInputType.text,
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
                    onPressed: () async {
                      bool success = await controller.createDayWiseUpdate();

                      print("SUCCESS VALUE: $success");

                      if (success) {
                        Get.back();
                      }
                    },
                    // onPressed: () async {
                    //   bool success = await controller.createDayWiseUpdate();

                    //   print("SUCCESS VALUE: $success");

                    //   if(success) {
                    //     Get.back();
                    //   }
                    // },
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
