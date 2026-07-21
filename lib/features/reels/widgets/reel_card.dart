import 'package:flutter/material.dart';
import 'reel_right_actions.dart';
import 'reel_user_info.dart';
import 'reel_quote_content.dart';

class ReelCard extends StatefulWidget {
  final dynamic reel;
  final bool isActive;
  const ReelCard({super.key, required this.reel, this.isActive = false});
  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> with SingleTickerProviderStateMixin {
  bool _showUI = true;
  late AnimationController _heartAnimationController;
  late Animation<double> _heartScaleAnimation;

  @override
  void initState() {
    super.initState();
    _heartAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _heartScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _heartAnimationController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() { _heartAnimationController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _showUI = !_showUI),
      onDoubleTap: () { _heartAnimationController.forward().then((_) => _heartAnimationController.reverse()); },
      child: Container(
        width: double.infinity, height: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFF1A1A2E), Color(0xFF0D0D0D), Color(0xFF16213E)])),
        child: Stack(fit: StackFit.expand, children: [
          Center(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: ReelQuoteContent(quote: widget.reel.quote ?? '', author: widget.reel.author ?? ''))),
          Positioned(bottom: 0, left: 0, right: 0, height: 200, child: IgnorePointer(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xCC000000), Colors.transparent]))))),
          Positioned(top: 0, left: 0, right: 0, height: 120, child: IgnorePointer(child: Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x66000000), Colors.transparent]))))),
          if (_showUI) ...[
            Positioned(bottom: 100, left: 16, right: 80, child: ReelUserInfo(username: widget.reel.username ?? '', isVerified: widget.reel.isVerified ?? false, description: widget.reel.description ?? '', question: widget.reel.question ?? '', musicInfo: widget.reel.musicInfo ?? '')),
            Positioned(right: 12, bottom: 120, child: ReelRightActions(likes: widget.reel.likes ?? 0, comments: widget.reel.comments ?? 0, shares: widget.reel.shares ?? 0)),
          ],
          Center(child: AnimatedBuilder(animation: _heartScaleAnimation, builder: (context, child) => Transform.scale(scale: _heartScaleAnimation.value, child: const Icon(Icons.favorite, color: Color(0xFFC96A2B), size: 80)))),
        ]),
      ),
    );
  }
}
