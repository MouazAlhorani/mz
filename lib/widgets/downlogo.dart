import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DownlogoMz extends StatefulWidget {
  const DownlogoMz({super.key});

  @override
  State<DownlogoMz> createState() => _DownlogoMzState();
}

class _DownlogoMzState extends State<DownlogoMz> {
  bool hover = false;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: MouseRegion(
        onHover: ((e) => setState(() {
              hover = true;
            })),
        onExit: ((e) => setState(() {
              hover = false;
            })),
        child: Container(
          height: 25,
          width: 300,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.deepPurpleAccent,
              Colors.grey.shade200,
              !hover ? Colors.white : Colors.deepOrange
            ]),
            borderRadius:
                BorderRadius.only(topRight: Radius.elliptical(100, 100)),
          ),
          child: Center(
              child: Hero(
            tag: "logotag",
            child: TextButton(
              child: Text("by: Mouaz Al-Horani"),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return Hero(
                        tag: "logotag",
                        child: AlertDialog(
                          scrollable: true,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SelectableText(
                                  "Full Stack Developer\nBackEnd Python  -- rest ful api\nFront Flutter\n\n======== Mouaz Al-Horani =======\n\n0992738933")
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          )),
        ),
      ),
    );
  }
}
