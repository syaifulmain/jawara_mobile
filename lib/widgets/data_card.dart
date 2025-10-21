import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final String itemName;
  final List<Map<String, String>> itemData;
  const DataCard({super.key, required this.itemName, required this.itemData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Divider(thickness: 2),
            const SizedBox(height: 2),
            ...itemData.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.map((entry) {
                    return
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              entry.value,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
