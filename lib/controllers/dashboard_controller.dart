import 'package:get/get.dart';

class DashboardController extends GetxController {
  var bookings = [
    {
      "receipt": "CTR-0003",
      "centre": "Kukatpally Masjid",
      "day": "Day 1",
      "type": "Matloob",
      "hissas": "7",
      "animals": "1",
      "amount": "₹31,500",
    },
    {
      "receipt": "CTR-0002",
      "centre": "Kukatpally Masjid",
      "day": "Day 1",
      "type": "Matloob",
      "hissas": "1",
      "animals": "1",
      "amount": "₹4,800",
    },
  ].obs;
}
