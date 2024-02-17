import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temparature;
  const HourlyForecast(
      {super.key,
      required this.time,
      required this.temparature,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
        child: Column(
          children: [
            const SizedBox(height: 5),
            Text(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              time,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Icon(
              icon,
              size: 30,
            ),
            const SizedBox(height: 15),
            Text(
              temparature,
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
