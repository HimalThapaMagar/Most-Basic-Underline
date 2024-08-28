import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum UnderlineAnimationType {
  straight,
  squiggly,
  dotted,
}

class UnderlineText extends StatefulWidget {
  final String text;
  final Color textColor;
  final Color underlineColor;
  final Color hoverTextColor;
  final String? url;
  final UnderlineAnimationType animationType;
  final Duration animationDuration; // Optional duration
  final double underlineThickness;  // Optional underline thickness
  final double dotRadius;           // Optional radius of each dot
  final double dotSpacing;          // Optional spacing between dots

  const UnderlineText({
    super.key,
    required this.text,
    this.textColor = Colors.black,
    this.underlineColor = Colors.blue,
    this.hoverTextColor = Colors.blue,
    this.url,
    this.animationType = UnderlineAnimationType.straight,
    this.animationDuration = const Duration(milliseconds: 300), // Default duration
    this.underlineThickness = 2.0, // Default underline thickness
    this.dotRadius = 2.0,          // Default dot radius
    this.dotSpacing = 4.0,         // Default dot spacing
  });

  @override
  UnderlineTextState createState() => UnderlineTextState();
}

class UnderlineTextState extends State<UnderlineText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _widthAnimation;
  bool isHovered = false;
  double textWidth = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _widthAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateTextWidth();
    });
  }

  void _calculateTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: const TextStyle(fontSize: 20)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    setState(() {
      textWidth = textPainter.size.width;
    });
  }

  Future<void> _launchUrl() async {
    if (widget.url != null && await canLaunchUrl(widget.url! as Uri)) {
      await launchUrl(widget.url! as Uri);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildUnderline() {
    switch (widget.animationType) {
      case UnderlineAnimationType.squiggly:
        return _buildSquigglyUnderline();
      case UnderlineAnimationType.dotted:
        return _buildDottedUnderline();
      case UnderlineAnimationType.straight:
      default:
        return _buildStraightUnderline();
    }
  }

  Widget _buildStraightUnderline() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: _widthAnimation.value * textWidth,
          height: widget.underlineThickness,
          color: widget.underlineColor,
        );
      },
    );
  }

  Widget _buildSquigglyUnderline() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SquigglyUnderlinePainter(
            width: _widthAnimation.value * textWidth,
            color: widget.underlineColor,
            thickness: widget.underlineThickness,
          ),
        );
      },
    );
  }

  Widget _buildDottedUnderline() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: DottedUnderlinePainter(
            width: _widthAnimation.value * textWidth,
            color: widget.underlineColor,
            thickness: widget.underlineThickness,
            dotRadius: widget.dotRadius,
            dotSpacing: widget.dotSpacing,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.url != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        setState(() {
          isHovered = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: widget.url != null ? _launchUrl : null,
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 20,
                color: isHovered ? widget.hoverTextColor : widget.textColor,
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: _buildUnderline(), // Build underline based on type
            ),
          ],
        ),
      ),
    );
  }
}

class SquigglyUnderlinePainter extends CustomPainter {
  final double width;
  final Color color;
  final double thickness;

  SquigglyUnderlinePainter({
    required this.width,
    required this.color,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (width <= 0) return; // Avoid drawing if width is 0

    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    const amplitude = 4.0;
    const wavelength = 10.0;
    double x = 0;

    while (x + wavelength <= width) {
      path.relativeQuadraticBezierTo(wavelength / 2, -amplitude, wavelength, 0);
      path.relativeQuadraticBezierTo(wavelength / 2, amplitude, wavelength, 0);
      x += 2 * wavelength;
    }

    final remainingWidth = width - x;
    if (remainingWidth > 0) {
      path.relativeQuadraticBezierTo(
        remainingWidth / 2, -amplitude, remainingWidth, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DottedUnderlinePainter extends CustomPainter {
  final double width;
  final Color color;
  final double thickness;
  final double dotRadius;
  final double dotSpacing;

  DottedUnderlinePainter({
    required this.width,
    required this.color,
    required this.thickness,
    required this.dotRadius,
    required this.dotSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (width <= 0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double x = 0;

    while (x < width) {
      canvas.drawCircle(Offset(x, 0), dotRadius, paint);
      x += dotRadius * 2 + dotSpacing; // Move to the next position for the next dot
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
