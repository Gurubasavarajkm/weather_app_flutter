import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String value;
  const HourlyForecast(this.time,  this. icon,  this.value,{super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(

        padding: const EdgeInsets.all(10),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
        child:  Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              value,
              style: const TextStyle( fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}