import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../models/booking_model.dart';

class DashboardController extends GetxController {
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

  /// 🔹 CONTROLLERS
  final hissasController = TextEditingController();
  final animalCountController = TextEditingController();
  final amountTypeController = TextEditingController();
  final perDayCapacityController = TextEditingController();
  final amountController = TextEditingController();
  final receiptController = TextEditingController();
  final reasonController = TextEditingController();
  final receivedController = TextEditingController();

  final box = GetStorage();

  @override
  @override
  void onInit() {
    fetchBookings();
    fetchCentres();
    fetchRates();

    /// default values automatically
    selectedDay.value = "day1";
    bookingType.value = "Matloob";
    animalType.value = "Big";
    amountType.value = "Local";

    super.onInit();
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
        headers: {"Authorization": "Bearer $token"},
      );

      print("CENTRE STATUS: ${res.statusCode}");
      print("CENTRE BODY: ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        /// dropdown expects list
        centres.value = [data];

        /// auto selected
        selectedCentreId.value = data["id"].toString();

        recalculate();
      }
    } catch (e) {
      print("Centre fetch error: $e");
    }
  }
  // /// 🔥 FETCH CENTRES
  // Future<void> fetchCentres() async {
  //   final token = box.read("token");

  //   final res = await http.get(
  //     Uri.parse("http://192.168.1.230:3002/api/qurbani-booking-centres"),
  //     headers: {"Authorization": "Bearer $token"},
  //   );

  //   if (res.statusCode == 200) {
  //     centres.value = jsonDecode(res.body);
  //   }
  // }

  /// 🔥 FETCH RATES
  Future<void> fetchRates() async {
    final token = box.read("token");

    final res = await http.get(
      Uri.parse("http://192.168.1.230:3002/api/qurbani-hissa-rates"),
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

  /// 🔥 CREATE BOOKING
  Future<void> createBooking() async {
    final token = box.read("token");

    await http.post(
      Uri.parse("http://192.168.1.230:3002/api/qurbani-counter-slot-bookings"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "centreId": selectedCentreId.value,
        "dayCode": selectedDay.value,
        "animalType": animalType.value,
        "hissas": int.parse(hissasController.text),
        "bookingType": bookingType.value,

        /// ✅ NEW
        "amountType": amountType.value,

        "amount": int.parse(amountController.text),

        "receiptNo": receiptController.text,

        "reason": reasonController.text,
      }),
    );

    fetchBookings();
    clearForm();
  }

  void clearForm() {
    hissasController.clear();
    amountTypeController.clear();
    perDayCapacityController.clear();
    amountController.clear();
    receiptController.clear();
    reasonController.clear();
    receivedController.clear();

    /// keep defaults
    selectedDay.value = "day1";
    bookingType.value = "Matloob";
    animalType.value = "Big";
    amountType.value = "Local";

    /// refresh counts
    recalculate();
  }
}
