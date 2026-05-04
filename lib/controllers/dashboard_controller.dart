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

  /// 🔹 CONTROLLERS
  final hissasController = TextEditingController();
  final animalCountController = TextEditingController();
  final perDayCapacityController = TextEditingController();
  final amountController = TextEditingController();
  final receiptController = TextEditingController();
  final reasonController = TextEditingController();
  final receivedController = TextEditingController();

  final box = GetStorage();

  @override
  void onInit() {
    fetchBookings();
    fetchCentres();
    fetchRates();
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
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔥 FETCH CENTRES
  Future<void> fetchCentres() async {
    final token = box.read("token");

    final res = await http.get(
      Uri.parse("http://192.168.1.230:3002/api/qurbani-booking-centres"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      centres.value = jsonDecode(res.body);
    }
  }

  /// 🔥 FETCH RATES (ONLY FOR CAPACITY)
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

  /// 🔥 MAIN CALCULATION (UPDATED AS PER REQUIREMENT)
  void recalculate() {
    int h = int.tryParse(hissasController.text) ?? 0;

    /// 🔹 Animal count
    if (animalType.value == "Big") {
      animalCountController.text = (h / 7).toStringAsFixed(2);
    } else {
      animalCountController.text = h.toString();
    }

    /// 🔹 Capacity from API
    var rate = rates.firstWhereOrNull(
      (r) =>
          r["centreId"].toString() == selectedCentreId.value &&
          r["dayCode"].toString() == selectedDay.value,
    );

    if (rate != null) {
      perDayCapacityController.text = rate["capacity"].toString();
    } else {
      perDayCapacityController.text = "0";
    }

    /// 🔹 Amount fixed
    amountController.text = (h * 5000).toString();
  }

  /// 🔥 CREATE BOOKING
  Future<void> createBooking() async {
    final token = box.read("token");

    if (amountController.text != receivedController.text) {
      Get.snackbar("Error", "Received amount must match total amount");
      return;
    }

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
        "amount": int.parse(amountController.text),
        "reason": reasonController.text,
      }),
    );

    fetchBookings();
    clearForm();
  }

  void clearForm() {
    hissasController.clear();
    animalCountController.clear();
    perDayCapacityController.clear();
    amountController.clear();
    receiptController.clear();
    reasonController.clear();
    receivedController.clear();

    selectedCentreId.value = "";
    selectedDay.value = "";
    bookingType.value = "";
    animalType.value = "";
  }
}
