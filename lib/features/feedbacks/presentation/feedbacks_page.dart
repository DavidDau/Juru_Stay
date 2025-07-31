import 'package:flutter/material.dart';

class FeedbacksPage extends StatelessWidget {
  const FeedbacksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviews = [
      {'name': 'John', 'message': 'Amazing experience, highly recommend!'},
      {'name': 'Hilda', 'message': 'Amazing experience, highly recommend!'},
      {'name': 'Gerald', 'message': 'Amazing experience, highly recommend!'},
      {'name': 'Cherish', 'message': 'Amazing experience, highly recommend!'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tourists Reviews'),
      ),
      backgroundColor: const Color(0xFFB0C4D8),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: const Row(
                children: [
                  Text('Adventure Awaits! 🌍'),
                  Spacer(),
                  Icon(Icons.landscape),
                  SizedBox(width: 4),
                  Icon(Icons.photo),
                  SizedBox(width: 4),
                  Icon(Icons.chat_bubble),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('Tourists Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...reviews.map((review) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(review['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const Spacer(),
                                const Row(
                                  children: [
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                    Icon(Icons.star, size: 16, color: Colors.amber),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(review['message']!),
                            const SizedBox(height: 4),
                            const Icon(Icons.edit, size: 16, color: Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
