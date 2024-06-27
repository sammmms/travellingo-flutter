import 'package:flutter/material.dart';
import 'payment_success_page.dart';

class TransactionCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TransactionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Determine status and button properties based on the status
    String statusText = data['status'] ? "Completed" : "Not Completed";
    Color buttonColor = data['status'] ? Colors.white : const Color(0xFFF5D161);
    Color textColor = data['status'] ? const Color(0xFFF5D161) : Colors.white;
    String buttonText = data['status'] ? "See Details" : "Pay Now";

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ORDER DATE : ${data['date']}",
                  style:
                      const TextStyle(color: Color(0xFFBFBFBF), fontSize: 12),
                ),
                const Icon(Icons.more_vert, color: Color(0xFFBFBFBF)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage(data['image']), // Using a network image
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.local_activity,
                              color: Color(0xFFFF9141), size: 16),
                          Text(" ${data['ticket']} tiket "),
                          const Icon(Icons.calendar_today,
                              color: Color(0xFFFF9141), size: 16),
                          Text(" ${data['date']} "),
                          const Icon(Icons.access_time,
                              color: Color(0xFFFF9141), size: 16),
                          Text(" ${data['time']}"),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: data['status']
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFD68917),
                  ),
                ),
                Text(
                  "USD ${data['price'].toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B1446),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, // Makes the button full width
              child: ElevatedButton(
                onPressed: () {
                  if (!data['status']) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PaymentSuccessPage()),
                    );
                  } else {
                    // If status is true, maybe do something else or nothing
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(buttonColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily:
                        'Inter', // Ensure the font is included in your project
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
