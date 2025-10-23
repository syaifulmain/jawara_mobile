import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DataCard extends StatelessWidget {
  final String itemName;
  final List<Map<String, String>> itemData;
  final String? detailRoute;

  const DataCard({
    super.key,
    required this.itemName,
    required this.itemData,
    this.detailRoute,
  });

  Widget detailBlankDefaulter(BuildContext context) {
    if (detailRoute == null) {
      return new Row();
    }
    return Center(
      child: TextButton(
        onPressed: detailRoute != null
            ? () => context.pushNamed(detailRoute!)
            : null,
        child: const Text(
          "Detail",
          style: TextStyle(color: Colors.blue),
        ),
      ),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(itemName, style: Theme
                .of(context)
                .textTheme
                .titleMedium),
            const SizedBox(height: 2),
            Divider(thickness: 2),
            const SizedBox(height: 2),
            ...itemData.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.entries.map((entry) {
                    return Padding(
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
            const SizedBox(height: 1),
            Divider(thickness: 1),
            detailBlankDefaulter(context),
            const SizedBox(height: 1),

          ],
        ),
      ),
    );
  }
}
