import 'package:flutter/material.dart';

class MainItemCard extends StatefulWidget {
  const MainItemCard(
      {super.key, required this.label, required this.icon, this.gotopage});
  final String? gotopage;
  final IconData icon;
  final String label;

  @override
  State<MainItemCard> createState() => _MainItemCardState();
}

class _MainItemCardState extends State<MainItemCard> {
  double raduis = 20;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, widget.gotopage!);
      },
      child: MouseRegion(
        onHover: (x) => setState(() {
          raduis = 100;
        }),
        onExit: (x) => setState(() {
          raduis = 20;
        }),
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.all(8),
          child: Stack(
            children: [
              CircleAvatar(
                radius: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      widget.icon,
                      size: raduis == 20 ? 25 : 50,
                    ),
                    Text(widget.label),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: CircleAvatar(
                  radius: raduis,
                  backgroundColor: Colors.amber.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
