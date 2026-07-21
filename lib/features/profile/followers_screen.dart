import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/public_profile_screen.dart';

class FollowersScreen extends StatelessWidget {
  final String userId;
  final bool isFollowers;
  const FollowersScreen({super.key, required this.userId, this.isFollowers = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(isFollowers ? 'Seguidores' : 'Siguiendo', style: const TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('friend_requests')
            .where(isFollowers ? 'to' : 'from', isEqualTo: userId)
            .where('status', isEqualTo: 'accepted')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(isFollowers ? 'Sin seguidores' : 'No sigues a nadie', style: const TextStyle(color: Colors.grey)));
          }

          final requests = snapshot.data!.docs;
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final data = requests[index].data() as Map<String, dynamic>;
              final otherUserId = isFollowers ? data['from'] : data['to'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) return const SizedBox();
                  final userData = userSnap.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    leading: Container(width: 44, height: 44, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFD7A15D).withValues(alpha: 0.2)), child: Center(child: Text((userData['name'] ?? '?')[0].toUpperCase(), style: const TextStyle(color: Color(0xFFD7A15D), fontWeight: FontWeight.bold)))),
                    title: Text(userData['name'] ?? '', style: const TextStyle(color: Colors.white)),
                    subtitle: Text(userData['username'] ?? '', style: const TextStyle(color: Color(0xFFD7A15D), fontSize: 13)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PublicProfileScreen(username: userData['username'] ?? ''))),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
