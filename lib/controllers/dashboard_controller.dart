import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../models/booking_model.dart';

class DashboardController extends GetxController {
  /// QURBANI DASHBOARD
  var dashboardData = {}.obs;
  var dashboardLoading = false.obs;

  /// 🔹 BOOKINGS
  var bookings = <Booking>[].obs;
  var isLoading = false.obs;

  /// 🔹 SUMMARY
  var hissasD1 = 0.obs;
  var hissasD2 = 0.obs;
  var hissasD3 = 0.obs;

  var bookedD1 = 0.0.obs;
  var bookedD2 = 0.0.obs;
  var bookedD3 = 0.0.obs;

  /// 🔹 DROPDOWN DATA
  var centres = [].obs;
  var rates = [].obs;

  /// 🔹 FORM VALUES
  var selectedCentreId = "".obs;
  var selectedDay = "".obs;
  var bookingType = "".obs;
  var animalType = "".obs;

  /// ✅ NEW
  var amountType = "".obs;

  /// volunteer allocated days
  var allowedDays = <String>[].obs;

  /// ADD UPDATE PAGE DATA
  /// UPDATE PAGE CENTRE NAME
  var updateCentreName = "".obs;
  var updateCentres = [].obs;

  /// default empty -> shows label/hint
  var selectedUpdateCentreId = Rx<String?>(null);

  /// default empty -> shows label/hint
  var updateSelectedDay = Rx<String?>(null);

  var updateAllowedDays = <String>[].obs;

  List<String> updateDays = ["day1", "day2", "day3"];

  /// Animal Type Dropdown
  var updateAnimalType = Rx<String?>(null);

  /// 🔹 CONTROLLERS
  final hissasController = TextEditingController();
  final animalCountController = TextEditingController();
  final amountTypeController = TextEditingController();
  final perDayCapacityController = TextEditingController();
  final amountController = TextEditingController();
  final receiptController = TextEditingController();
  final reasonController = TextEditingController();
  final receivedController = TextEditingController();

  final updateDateController = TextEditingController();

  final updateTotalController = TextEditingController();

  final updateSlaughteredController = TextEditingController();

  final updateRemainingController = TextEditingController();

  final supervisorController = TextEditingController();

  final remarksController = TextEditingController();

  final box = GetStorage();

  @override
  void onInit() async {
    super.onInit();

    dashboardLoading.value = true;

    updateDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());

    bookingType.value = "Matloob";
    animalType.value = "Big";
    amountType.value = "Local";

    /// IMPORTANT ORDER

    await fetchCentres();

    await fetchVolunteerDays();

    await fetchUpdateAllowedDays();

    await fetchRates();

    await fetchBookings();

    await fetchDashboardData();

    dashboardLoading.value = false;
  }

  /// FETCH QURBANI DASHBOARD
  Future<void> fetchDashboardData() async {
    try {
      dashboardLoading.value = true;

      final token = box.read("token");

      final response = await http.get(
        Uri.parse("http://192.168.1.230:3002/api/qurbani/dashboard"),
        // Uri.parse("http://109.199.106.107:3000/api/qurbani/dashboard"),
        headers: {"Authorization": "Bearer $token"},
      );

      print("DASHBOARD STATUS: ${response.statusCode}");
      print("DASHBOARD BODY: ${response.body}");

      if (response.statusCode == 200) {
        dashboardData.value = jsonDecode(response.body);
      }
    } catch (e) {
      print("DASHBOARD ERROR: $e");
    } finally {
      dashboardLoading.value = false;
    }
  }

  /// 🔥 FETCH BOOKINGS
  Future<void> fetchBookings() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      final res = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-counter-slot-bookings",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-counter-slot-bookings",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        bookings.value = data.map((e) => Booking.fromJson(e)).toList();
        calculateSummary();
        recalculate();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 FETCH ONLY ALLOCATED CENTRE
  Future<void> fetchCentres() async {
    try {
      final token = box.read("token");

      /// volunteer object saved during login
      final volunteer = box.read("volunteer");

      if (volunteer == null) {
        print("Volunteer data not found");
        return;
      }

      /// allocated centre id
      final centreId = volunteer["assignedCentreId"];

      print("ALLOCATED CENTRE ID: $centreId");

      if (centreId == null || centreId.toString().isEmpty) {
        print("No centre allocated");
        return;
      }

      /// get centre details
      final res = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-booking-centres/$centreId",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-booking-centres/$centreId",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      print("CENTRE STATUS: ${res.statusCode}");
      print("CENTRE BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        centres.assignAll([data]);

        selectedCentreId.value = data["id"].toString();

        print("SELECTED CENTRE ID: ${selectedCentreId.value}");
        print("CENTRES: $centres");

        recalculate();
      }
    } catch (e) {
      print("Centre fetch error: $e");
    }
  }

  Future<void> fetchVolunteerDays() async {
    try {
      final token = box.read("token");

      final volunteer = box.read("volunteer");

      if (volunteer == null) {
        print("Volunteer not found");
        return;
      }

      final username = volunteer["username"];

      print("USERNAME: $username");

      final res = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-volunteers/volunteer-days/$username",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-volunteers/volunteer-days/$username",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      print("DAYS STATUS: ${res.statusCode}");
      print("DAYS BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        /// API RESPONSE:
        /// { "days": ["day1"] }

        if (data["days"] != null) {
          allowedDays.value = List<String>.from(data["days"]);
        }

        /// auto select first allowed day
        if (allowedDays.isNotEmpty) {
          selectedDay.value = allowedDays.first;
        }

        recalculate();
      }
    } catch (e) {
      print("Volunteer days error: $e");
    }
  }

  /// 🔥 FETCH RATES
  Future<void> fetchRates() async {
    final token = box.read("token");

    final res = await http.get(
      Uri.parse("http://192.168.1.230:3002/api/qurbani-hissa-rates"),
      // Uri.parse("http://109.199.106.107:3000/api/qurbani-hissa-rates"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      rates.value = jsonDecode(res.body);
    }
  }

  /// 🔥 SUMMARY
  void calculateSummary() {
    hissasD1.value = 0;
    hissasD2.value = 0;
    hissasD3.value = 0;

    bookedD1.value = 0;
    bookedD2.value = 0;
    bookedD3.value = 0;

    for (var b in bookings) {
      int h = b.hissas;

      if (b.dayCode == "day1") hissasD1.value += h;
      if (b.dayCode == "day2") hissasD2.value += h;
      if (b.dayCode == "day3") hissasD3.value += h;

      double animals = b.animalType.toLowerCase() == "big"
          ? h / 7
          : h.toDouble();

      if (b.dayCode == "day1") bookedD1.value += animals;
      if (b.dayCode == "day2") bookedD2.value += animals;
      if (b.dayCode == "day3") bookedD3.value += animals;
    }
  }

  /// 🔥 MAIN CALCULATION
  void recalculate() {
    int h = int.tryParse(hissasController.text) ?? 0;

    /// ===================================================
    /// ✅ EXISTING + CURRENT ANIMAL COUNT
    /// ===================================================

    /// ===================================================
    /// ✅ EXISTING + CURRENT ANIMAL COUNT
    /// ===================================================

    double existingAnimalCount = 0;

    /// calculate existing animal count from DB
    for (var b in bookings) {
      if (b.animalType.toLowerCase() == animalType.value.toLowerCase()) {
        /// BIG => 7 hissas = 1 animal
        if (b.animalType.toLowerCase() == "big") {
          existingAnimalCount += (b.hissas / 7);
        }
        /// SMALL => 1 hissa = 1 animal
        else {
          existingAnimalCount += b.hissas.toDouble();
        }
      }
    }

    /// current entered hissas animal count
    double currentAnimalCount = 0;

    if (h > 0) {
      /// BIG => 7 hissas = 1 animal
      if (animalType.value == "Big") {
        currentAnimalCount = h / 7;
      }
      /// SMALL => 1 hissa = 1 animal
      else {
        currentAnimalCount = h.toDouble();
      }
    }

    /// final animal count
    double finalAnimalCount = existingAnimalCount + currentAnimalCount;

    /// display in field
    animalCountController.text = finalAnimalCount.toStringAsFixed(2);

    /// ✅ Amount Type
    amountTypeController.text = amountType.value;

    /// ✅ Per Hissa Amount
    int perHissaAmount = 0;

    if (amountType.value == "Local") {
      perHissaAmount = 5000;
    } else if (amountType.value == "Out-of-State") {
      perHissaAmount = 6000;
    }

    /// ✅ Total Amount
    amountController.text = (h * perHissaAmount).toString();

    /// ===================================================
    /// ✅ DYNAMIC PER DAY CAPACITY FROM API
    /// ===================================================

    try {
      /// total centers
      int totalCenters = centres.length;

      if (totalCenters == 0) {
        perDayCapacityController.text = "0";
        return;
      }

      /// find matching animal type from API
      var animalRate = rates.firstWhereOrNull(
        (r) =>
            r["animalType"].toString().toLowerCase() ==
            animalType.value.toLowerCase(),
      );

      if (animalRate == null) {
        perDayCapacityController.text = "0";
        return;
      }

      /// total capacity from API
      double totalCapacity =
          double.tryParse(animalRate["totalCapacity"].toString()) ?? 0;

      /// per center
      double perCenterCapacity = totalCapacity / totalCenters;

      /// per day (3 days)
      double perDayCapacity = perCenterCapacity / 3;

      perDayCapacityController.text = perDayCapacity.toStringAsFixed(0);
    } catch (e) {
      perDayCapacityController.text = "0";
    }
  }

  /// 🔥 FETCH NEXT RECEIPT No
  Future<void> fetchNextReceiptNumber() async {
    try {
      final token = box.read("token");

      final res = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-counter-slot-bookings/next-receipt-preview",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-counter-slot-bookings/next-receipt-preview",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        /// API response example:
        /// { "receiptNo": "CTR-0005" }

        receiptController.text = data["receiptNo"]?.toString() ?? "";
      }
    } catch (e) {
      print("Receipt fetch error: $e");
    }
  }

  //create newslot booking
  Future<void> createBooking() async {
    final token = box.read("token");

    if (hissasController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter hissas");
      return;
    }

    if (reasonController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter reason");
      return;
    }

    if (receivedController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please enter received amount");
      return;
    }

    try {
      final bodyData = {
        "centreId": selectedCentreId.value,
        "dayCode": selectedDay.value,
        "animalType": animalType.value,
        "hissas": int.tryParse(hissasController.text.trim()) ?? 0,
        "bookingType": bookingType.value,
        "amountType": amountType.value,
        "amount": int.tryParse(amountController.text.trim()) ?? 0,
        "receiptNo": receiptController.text.trim(),
        "reason": reasonController.text.trim(),

        // IMPORTANT
        "recalculatedAmount": int.tryParse(receivedController.text.trim()) ?? 0,
      };

      print("POST BODY => ${jsonEncode(bodyData)}");

      final response = await http.post(
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-counter-slot-bookings/next-receipt-preview",
        // ),
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-counter-slot-bookings",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(bodyData),
      );

      print("STATUS CODE => ${response.statusCode}");
      print("RESPONSE BODY => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchBookings();

        clearForm();

        Get.back();

        Get.snackbar("Success", "Booking Created");
      } else {
        Get.snackbar("Error", "Booking failed");
      }
    } catch (e) {
      print("CREATE BOOKING ERROR: $e");

      Get.snackbar("Error", "Booking failed");
    }
  }

  Future<void> fetchUpdateCentres() async {
    try {
      final token = box.read("token");

      final volunteer = box.read("volunteer");

      if (volunteer == null) return;

      final centreId = volunteer["assignedCentreId"];

      final response = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-booking-centres/$centreId",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-booking-centres/$centreId",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      print("UPDATE STATUS: ${response.statusCode}");
      print("UPDATE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// save centre id
        selectedUpdateCentreId.value = data["id"].toString();

        /// save centre name
        updateCentreName.value = data["name"].toString();
      }
    } catch (e) {
      print("Update centre error: $e");
    }
  }

  Future<void> fetchUpdateAllowedDays() async {
    try {
      final token = box.read("token");

      final volunteer = box.read("volunteer");

      if (volunteer == null) {
        print("Volunteer not found");
        return;
      }

      final username = volunteer["username"];

      final res = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-volunteers/volunteer-days/$username",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-volunteers/volunteer-days/$username",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      print("UPDATE DAYS STATUS: ${res.statusCode}");
      print("UPDATE DAYS BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        if (data["days"] != null) {
          updateAllowedDays.value = List<String>.from(data["days"]);
        }

        /// auto select first allowed day
        if (updateAllowedDays.isNotEmpty) {
          updateSelectedDay.value = updateAllowedDays.first;
        }
      }
    } catch (e) {
      print("Update allowed days error: $e");
    }
  }

  void calculateRemaining() {
    int total = int.tryParse(updateTotalController.text.trim()) ?? 0;

    int slaughtered =
        int.tryParse(updateSlaughteredController.text.trim()) ?? 0;

    int remaining = total - slaughtered;

    if (remaining < 0) {
      remaining = 0;
    }

    updateRemainingController.text = remaining.toString();
  }

  /// AUTO SET TOTAL BASED ON ANIMAL TYPE
  void setTotalByAnimalType() {
    try {
      if (rates.isEmpty) return;

      /// find selected animal type from API
      var selectedRate = rates.firstWhereOrNull(
        (r) =>
            r["animalType"].toString().toLowerCase() ==
            updateAnimalType.value.toString().toLowerCase(),
      );

      if (selectedRate == null) {
        updateTotalController.text = "0";
        return;
      }

      /// get total capacity from API
      int totalCapacity =
          int.tryParse(selectedRate["totalCapacity"].toString()) ?? 0;

      /// display in total field
      updateTotalController.text = totalCapacity.toString();

      /// auto calculate remaining also
      calculateRemaining();
    } catch (e) {
      print("SET TOTAL ERROR: $e");
    }
  }

  Future<void> fetchDayAnimalData() async {
    try {
      final token = box.read("token");

      if (updateAnimalType.value == null) {
        return;
      }

      String animal = updateAnimalType.value!;

      /// ============================================
      /// GET TOTAL ANIMALS FROM HISSA RATES API
      /// ============================================

      print("RATES DATA: $rates");

      var selectedRate = rates.firstWhereOrNull(
        (r) => r["animalType"].toString().toLowerCase() == animal.toLowerCase(),
      );

      print("SELECTED RATE: $selectedRate");

      if (selectedRate != null) {
        /// USING totalAnimalsLocal FROM API
        updateTotalController.text = selectedRate["totalAnimalsLocal"]
            .toString();
      } else {
        updateTotalController.text = "0";
      }

      /// ============================================
      /// FETCH DAY-WISE SLAUGHTER DATA
      /// ============================================

      final response = await http.get(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-day-wise-updates/overall-data/by-day-animal?animalType=$animal",
        ),
        //  Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-day-wise-updates/overall-data/by-day-animal?animalType=$animal",
        // ),
        headers: {"Authorization": "Bearer $token"},
      );

      print("FETCH STATUS: ${response.statusCode}");
      print("FETCH BODY: ${response.body}");

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        /// IF NO DATA FOUND
        if (data.isEmpty) {
          updateSlaughteredController.text = "0";

          supervisorController.clear();

          remarksController.clear();

          calculateRemaining();

          return;
        }

        /// FIRST RECORD
        final item = data.first;

        updateSlaughteredController.text =
            item["animals_slaughtered"]?.toString() ?? "0";

        supervisorController.text = item["supervisor"]?.toString() ?? "";

        remarksController.text = item["remarks"]?.toString() ?? "";

        /// AUTO CALCULATE REMAINING
        calculateRemaining();
      }
    } catch (e) {
      print("FETCH ERROR: $e");
    }
  }

  /// CREATE DAY WISE UPDATE
  Future<bool> createDayWiseUpdate() async {
    try {
      final token = box.read("token");

      // VALIDATIONS

      // if (selectedUpdateCentreId.value == null) {
      //   Get.snackbar("Error", "Please select centre");
      //   return false;
      // }

      if (updateSelectedDay.value == null) {
        Get.snackbar("Error", "Please select day");
        return false;
      }

      if (updateAnimalType.value == null) {
        Get.snackbar("Error", "Please select animal type");
        return false;
      }

      if (updateDateController.text.trim().isEmpty) {
        Get.snackbar("Error", "Please select date");
        return false;
      }

      if (updateTotalController.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter total");
        return false;
      }

      if (updateSlaughteredController.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter slaughtered");
        return false;
      }

      if (supervisorController.text.trim().isEmpty) {
        Get.snackbar("Error", "Please enter supervisor");
        return false;
      }

      final response = await http.post(
        Uri.parse(
          "http://192.168.1.230:3002/api/qurbani-day-wise-updates/overall-data",
        ),
        // Uri.parse(
        //   "http://109.199.106.107:3000/api/qurbani-day-wise-updates/overall-data",
        // ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "centreId": selectedUpdateCentreId.value,

          /// REQUIRED
          "date": updateDateController.text,

          /// REQUIRED
          "day": updateSelectedDay.value,

          "animalType": updateAnimalType.value,

          "totalAnimals": int.tryParse(updateTotalController.text) ?? 0,

          /// API EXPECTS THIS KEY
          "animalsSlaughtered":
              int.tryParse(updateSlaughteredController.text) ?? 0,

          "remaining": int.tryParse(updateRemainingController.text) ?? 0,

          "supervisor": supervisorController.text,
          "notes": null,
          "remarks": remarksController.text,
        }),
        // body: jsonEncode({
        //   "centreId": selectedUpdateCentreId.value,
        //   "day": updateSelectedDay.value,
        //   "animalType": updateAnimalType.value,
        //   "totalAnimals": int.tryParse(updateTotalController.text) ?? 0,
        //   "totalBookings": int.tryParse(updateTotalController.text) ?? 0,
        //   "availableSlots": int.tryParse(updateRemainingController.text) ?? 0,
        //   "slaughtered": int.tryParse(updateSlaughteredController.text) ?? 0,
        //   "remaining": int.tryParse(updateRemainingController.text) ?? 0,
        //   "supervisor": supervisorController.text,
        //   "notes": null,
        //   "remarks": remarksController.text,
        // }),
      );
      print("STATUS CODE: ${response.statusCode}");
      print("BODY: ${response.body}");

      print(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Update Created");

        clearUpdateForm();
        //Get.back();

        return true;
      } else {
        Get.snackbar("Error", "Failed to create update");
        return false;
      }
    } catch (e) {
      print("CREATE UPDATE ERROR: $e");

      Get.snackbar("Error", "Something went wrong");

      return false;
    }
  }

  void clearForm() {
    hissasController.clear();
    amountTypeController.clear();
    perDayCapacityController.clear();
    amountController.clear();
    receiptController.clear();
    reasonController.clear();
    receivedController.clear();

    bookingType.value = "Matloob";
    animalType.value = "Big";
    amountType.value = "Local";

    /// refresh counts
    recalculate();
  }

  /// CLEAR ADD UPDATE FORM
  void clearUpdateForm() {
    /// clear dropdowns
    // selectedUpdateCentreId.value = null;
    // updateSelectedDay.value = null;
    updateAnimalType.value = null;

    updateTotalController.clear();

    updateSlaughteredController.clear();

    updateRemainingController.clear();
    supervisorController.clear();

    remarksController.clear();
  }
}
