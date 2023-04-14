import 'package:Maven/dev/dev_options_screen.dart';
import 'package:flutter/material.dart';

import '../theme/m_themes.dart';

class MavenDesignToolIcon extends StatefulWidget {
  const MavenDesignToolIcon({super.key});

  @override
  _FloatingIconState createState() => _FloatingIconState();
}

class _FloatingIconState extends State<MavenDesignToolIcon> {
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayEntry = _createOverlayEntry();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_overlayEntry!);
    });
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).size.height / 2,
          right: 5,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DesignScreen()),);
            },
            backgroundColor: mt(context).color.background,
            mini: true,
            child: const Icon(Icons.more_horiz_rounded),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
