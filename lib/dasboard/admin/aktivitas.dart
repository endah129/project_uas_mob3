import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecentActivityWidget extends StatelessWidget {
  const RecentActivityWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('activities').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading activities'));
            }

            final activities = snapshot.data?.docs ?? [];

            return Column(
              children: activities.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final title = data['title'] ?? 'No Title';
                final subtitle = data['subtitle'] ?? 'No Subtitle';
                final time = data['time'] ?? 'Unknown Time';
                final iconName = data['icon'] ?? 'error_outline'; // Default to 'error_outline'
                final iconColorHex = data['iconColor'] ?? '#0000FF'; // Default to blue color

                // Map icon name to actual icon
                final icon = _getIconFromName(iconName);
                final iconColor = Color(int.parse('0xff' + iconColorHex.substring(1)));

                return _buildActivityTile(
                  icon: icon,
                  iconColor: iconColor,
                  title: title,
                  subtitle: subtitle,
                  time: time,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // Helper function to get Icon from icon name
  Icon _getIconFromName(String iconName) {
    switch (iconName) {
      case 'home':
        return const Icon(Icons.home);
      case 'error_outline':
        return const Icon(Icons.error_outline);
      case 'group':
        return const Icon(Icons.group);
      case 'attach_money':
        return const Icon(Icons.attach_money);
      case 'bar_chart':
        return const Icon(Icons.bar_chart);
      default:
        return const Icon(Icons.error_outline); // Default icon in case of unknown name
    }
  }

  Widget _buildActivityTile({
    required Icon icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withOpacity(0.1),
        child: icon,
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
    );
  }
}
