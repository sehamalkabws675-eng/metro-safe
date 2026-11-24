import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(const MetroSafeApp());

// ============================ ADJUSTABLE VALUES ============================
class MetroSafeStyle {
  // Colors (sampled from the reference image)
  static const Color background = Color(0xFFFFFFFF);
  static const Color navy = Color(0xFF01133A);
  static const Color blue = Color(0xFF0653C8);
  static const Color cream = Color(0xFFFDF4E3);
  static const Color white = Color(0xFFFFFFFF);

  // Drop shadow
  static const Color shadowColor = Color(0xFF0A1A40); // navy
  static const double shadowOpacity = 0.30;
  static const Offset shadowOffset = Offset(1, 5);
  static const double shadowBlur = 5; // sigma

  // White halo around every element
  static const double haloWidth = 4;

  // Text
  static const String fontFamily = 'Poppins';
  static const double metroSize = 102;
  static const double safeSize = 54;
  static const double taglineSize = 41;
  static const String tagline = 'Your Safety Is Our Priority';

  // Splash duration
  static const Duration splashDuration = Duration(seconds: 3);
}
// ==========================================================================

class MetroSafeApp extends StatelessWidget {
  const MetroSafeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Metro Safe',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(MetroSafeStyle.splashDuration, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MetroSafeStyle.background,
      body: SizedBox.expand(
        // The design is drawn on the reference's 751 x 1654 canvas and scaled
        // to fit any screen, so proportions and positions stay identical.
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: MetroSafePainter.canvasWidth,
            height: MetroSafePainter.canvasHeight,
            child: CustomPaint(painter: MetroSafePainter()),
          ),
        ),
      ),
    );
  }
}

/// Placeholder for the screen that opens after the splash.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Metro Safe')),
      body: const Center(child: Text('Home')),
    );
  }
}

class MetroSafePainter extends CustomPainter {
  static const double canvasWidth = 751;
  static const double canvasHeight = 1654;

  // Icon block origin on the canvas
  static const Offset iconOrigin = Offset(290, 603);

  // ---------------------------------------------------------------- shapes
  Path get _mainShield => Path()
    ..moveTo(78, 9)
    ..quadraticBezierTo(85, 5, 92, 9)
    ..lineTo(156, 37)
    ..quadraticBezierTo(167, 42, 167, 54)
    ..lineTo(167, 99)
    ..quadraticBezierTo(167, 141, 85, 169)
    ..quadraticBezierTo(3, 141, 3, 99)
    ..lineTo(3, 54)
    ..quadraticBezierTo(3, 42, 14, 37)
    ..close();

  Path get _chevron => Path()
    ..moveTo(40, 149)
    ..lineTo(85, 168)
    ..lineTo(130, 149)
    ..lineTo(130, 157)
    ..lineTo(85, 175)
    ..lineTo(40, 157)
    ..close();

  Path get _smallShield => Path()
    ..moveTo(173, 94)
    ..quadraticBezierTo(188, 103, 207, 104)
    ..lineTo(207, 130)
    ..quadraticBezierTo(207, 160, 173, 176)
    ..quadraticBezierTo(139, 160, 139, 130)
    ..lineTo(139, 104)
    ..quadraticBezierTo(158, 103, 173, 94)
    ..close();

  Path get _check => Path()
    ..moveTo(159, 136)
    ..lineTo(170, 147)
    ..lineTo(188, 124);

  RRect _rr(double x, double y, double w, double h, double r) =>
      RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r));

  Paint get _layerOpacity => Paint()
    ..color = Color.fromRGBO(0, 0, 0, MetroSafeStyle.shadowOpacity);

  Paint _fill(Color c) => Paint()
    ..color = c
    ..style = PaintingStyle.fill
    ..isAntiAlias = true;

  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..isAntiAlias = true;

  /// Draws the whole icon. When [override] is given (shadow / halo passes),
  /// every shape is drawn in that single color, widened by [extra] px.
  void _drawIcon(Canvas canvas, {Color? override, double extra = 0, MaskFilter? blur}) {
    Paint fill(Color c) {
      final p = _fill(override ?? c);
      if (blur != null) p.maskFilter = blur;
      return p;
    }

    Paint stroke(Color c, double w) {
      final p = _stroke(override ?? c, w + extra);
      if (blur != null) p.maskFilter = blur;
      return p;
    }

    final silhouette = override != null;

    // main shield
    canvas.drawPath(_mainShield, fill(MetroSafeStyle.cream));
    canvas.drawPath(_mainShield, stroke(MetroSafeStyle.navy, 9));

    // blue chevron
    canvas.drawPath(_chevron, fill(MetroSafeStyle.blue));
    if (silhouette) canvas.drawPath(_chevron, stroke(MetroSafeStyle.blue, 0.1));

    // train body
    canvas.drawRRect(_rr(67, 36, 36, 6, 2), fill(MetroSafeStyle.navy));
    canvas.drawRRect(_rr(78, 31, 14, 6, 2), fill(MetroSafeStyle.navy));
    canvas.drawRRect(_rr(49, 43, 72, 88, 14), fill(MetroSafeStyle.navy));
    if (!silhouette) {
      canvas.drawRRect(_rr(58, 58, 54, 34, 7), fill(MetroSafeStyle.cream)); // window
      canvas.drawRRect(_rr(61, 98, 48, 5, 2), fill(MetroSafeStyle.cream)); // bar
      canvas.drawCircle(const Offset(64, 116), 6, fill(MetroSafeStyle.cream)); // lights
      canvas.drawCircle(const Offset(106, 116), 6, fill(MetroSafeStyle.cream));
    }

    // rails
    canvas.drawLine(const Offset(64, 133), const Offset(41, 169), stroke(MetroSafeStyle.navy, 7));
    canvas.drawLine(const Offset(106, 133), const Offset(129, 169), stroke(MetroSafeStyle.navy, 7));
    final sleeper = stroke(MetroSafeStyle.navy, 5)..strokeCap = StrokeCap.butt;
    canvas.drawLine(const Offset(57, 145), const Offset(113, 145), sleeper);

    // small blue shield + check
    canvas.drawPath(_smallShield, fill(MetroSafeStyle.blue));
    canvas.drawPath(_smallShield, stroke(MetroSafeStyle.navy, 4));
    if (!silhouette) {
      canvas.drawPath(_check, stroke(MetroSafeStyle.white, 7));
    }
  }

  // ------------------------------------------------------------------ text
  TextPainter _text(String s, double size, FontWeight weight, {Paint? foreground, Color? color, double spacing = 0}) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: TextStyle(
          fontFamily: MetroSafeStyle.fontFamily,
          fontSize: size,
          fontWeight: weight,
          letterSpacing: spacing,
          height: 1.0,
          color: foreground == null ? color : null,
          foreground: foreground,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return tp;
  }

  /// Paints text centered on [cx] with its alphabetic baseline on [baseline],
  /// including the shadow and white halo passes.
  void _drawText(Canvas canvas, String s, double size, FontWeight weight, Color color,
      double cx, double baseline, {double spacing = 0}) {
    final shadowPaint = Paint()
      ..color = MetroSafeStyle.shadowColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = MetroSafeStyle.haloWidth * 2
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, MetroSafeStyle.shadowBlur);
    final haloPaint = Paint()
      ..color = MetroSafeStyle.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = MetroSafeStyle.haloWidth
      ..strokeJoin = StrokeJoin.round;

    final main = _text(s, size, weight, color: color, spacing: spacing);
    final asc = main.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    final pos = Offset(cx - main.width / 2, baseline - asc);

    final shadowFill = Paint()
      ..color = MetroSafeStyle.shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, MetroSafeStyle.shadowBlur);
    canvas.saveLayer(null, _layerOpacity);
    _text(s, size, weight, foreground: shadowFill, spacing: spacing)
        .paint(canvas, pos + MetroSafeStyle.shadowOffset);
    _text(s, size, weight, foreground: shadowPaint, spacing: spacing)
        .paint(canvas, pos + MetroSafeStyle.shadowOffset);
    canvas.restore();
    _text(s, size, weight, foreground: haloPaint, spacing: spacing).paint(canvas, pos);
    main.paint(canvas, pos);
  }

  void _drawDash(Canvas canvas, Rect r) {
    final rr = RRect.fromRectAndRadius(r, const Radius.circular(3));
    canvas.drawRRect(
      rr.shift(MetroSafeStyle.shadowOffset).inflate(MetroSafeStyle.haloWidth),
      Paint()
        ..color = MetroSafeStyle.shadowColor.withOpacity(MetroSafeStyle.shadowOpacity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, MetroSafeStyle.shadowBlur),
    );
    canvas.drawRRect(rr.inflate(MetroSafeStyle.haloWidth / 2), _fill(MetroSafeStyle.white));
    canvas.drawRRect(rr, _fill(MetroSafeStyle.blue));
  }

  // ----------------------------------------------------------------- paint
  @override
  void paint(Canvas canvas, Size size) {
    // background
    canvas.drawRect(Offset.zero & size, _fill(MetroSafeStyle.background));

    // icon: shadow pass -> halo pass -> artwork
    canvas.save();
    canvas.translate(iconOrigin.dx, iconOrigin.dy);

    canvas.saveLayer(null, _layerOpacity);
    canvas.translate(MetroSafeStyle.shadowOffset.dx, MetroSafeStyle.shadowOffset.dy);
    _drawIcon(canvas,
        override: MetroSafeStyle.shadowColor,
        extra: MetroSafeStyle.haloWidth * 2,
        blur: const MaskFilter.blur(BlurStyle.normal, MetroSafeStyle.shadowBlur));
    canvas.restore();

    _drawIcon(canvas, override: MetroSafeStyle.white, extra: MetroSafeStyle.haloWidth);
    _drawIcon(canvas);
    canvas.restore();

    // wordmark
    _drawText(canvas, 'metro', MetroSafeStyle.metroSize, FontWeight.w700,
        MetroSafeStyle.navy, 384, 855, spacing: -2);
    _drawDash(canvas, const Rect.fromLTWH(255, 884, 58, 6));
    _drawDash(canvas, const Rect.fromLTWH(458, 884, 60, 6));
    _drawText(canvas, 'safe', MetroSafeStyle.safeSize, FontWeight.w700,
        MetroSafeStyle.blue, 383, 905);

    // tagline
    _drawText(canvas, MetroSafeStyle.tagline, MetroSafeStyle.taglineSize, FontWeight.w500,
        MetroSafeStyle.navy, 376, 960);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
