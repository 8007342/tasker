import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../model.dart';

class MapPin {
  const MapPin(this.place, this.count);
  final Place place;
  final int count;
}

/// The illustrated farm, drawn by hand so it needs no map tiles and no connection.
class FarmMapGame extends FlameGame with TapCallbacks {
  FarmMapGame({required this.onPinTap});

  final void Function(String placeId) onPinTap;
  List<MapPin> pins = const [];
  String? selected;

  double _time = 0;
  ui.Picture? _ground;
  Size _groundSize = Size.zero;

  @override
  Color backgroundColor() => const Color(0xFF8DB767);

  @override
  void update(double dt) {
    super.update(dt);
    _time += dt;
  }

  @override
  void render(Canvas canvas) {
    final area = Size(size.x, size.y);
    if (_ground == null || _groundSize != area) {
      final recorder = ui.PictureRecorder();
      _paintGround(Canvas(recorder), area);
      _ground = recorder.endRecording();
      _groundSize = area;
    }
    canvas.drawPicture(_ground!);
    _paintClouds(canvas, area);
    for (final pin in pins) {
      _paintPin(canvas, area, pin);
    }
    super.render(canvas);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final at = event.canvasPosition;
    MapPin? nearest;
    var best = 44.0;
    for (final pin in pins) {
      final d = math.sqrt(math.pow(pin.place.mapX * size.x - at.x, 2) +
          math.pow(pin.place.mapY * size.y - 16 - at.y, 2));
      if (d < best) {
        best = d;
        nearest = pin;
      }
    }
    if (nearest != null) onPinTap(nearest.place.id);
  }

  void _paintClouds(Canvas c, Size s) {
    final shadow = Paint()
      ..color = const Color(0x1A1D3A20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 14);
    for (var i = 0; i < 3; i++) {
      final x = ((_time * (5 + i * 3) + i * 170) % (s.width + 240)) - 120;
      c.drawOval(
        Rect.fromCenter(center: Offset(x, s.height * (0.2 + i * 0.3)), width: 170, height: 60),
        shadow,
      );
    }
  }

  void _paintPin(Canvas c, Size s, MapPin pin) {
    final isOn = selected == pin.place.id;
    final bounce = math.sin(_time * 3 + pin.place.mapX * 9).abs() * 4;
    final tip = Offset(pin.place.mapX * s.width, pin.place.mapY * s.height);
    final head = tip.translate(0, -24 - bounce);
    c.drawOval(
      Rect.fromCenter(center: tip, width: 16, height: 6),
      Paint()..color = const Color(0x55000000),
    );
    final color = isOn ? const Color(0xFFEF6C00) : const Color(0xFFB3261E);
    final path = Path()
      ..moveTo(tip.dx, tip.dy - bounce)
      ..lineTo(head.dx - 10, head.dy + 8)
      ..lineTo(head.dx + 10, head.dy + 8)
      ..close();
    c.drawPath(path, Paint()..color = color);
    c.drawCircle(head, 15, Paint()..color = color);
    c.drawCircle(head, 11, Paint()..color = Colors.white);
    final text = TextPainter(
      text: TextSpan(
        text: '${pin.count}',
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontFamily: 'Atkinson',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    text.paint(c, head - Offset(text.width / 2, text.height / 2));
  }

  void _paintGround(Canvas c, Size s) {
    Offset at(double x, double y) => Offset(x * s.width, y * s.height);
    Rect box(double l, double t, double r, double b) =>
        Rect.fromPoints(at(l, t), at(r, b));

    final rng = math.Random(7);
    c.drawRect(
      Offset.zero & s,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset.zero,
          Offset(s.width, s.height),
          const [Color(0xFF9CC374), Color(0xFF7FAE5B)],
        ),
    );
    final tuft = Paint()..color = const Color(0x22305A1E);
    for (var i = 0; i < 160; i++) {
      c.drawCircle(
        Offset(rng.nextDouble() * s.width, rng.nextDouble() * s.height),
        rng.nextDouble() * 2.4 + 0.6,
        tuft,
      );
    }

    // Tracks between the plots, meeting at the barn.
    final track = Paint()
      ..color = const Color(0xFFD9C08F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(7, s.height * 0.04)
      ..strokeCap = StrokeCap.round;
    c.drawPath(
      Path()
        ..moveTo(0, s.height * 0.52)
        ..cubicTo(s.width * .2, s.height * .46, s.width * .34, s.height * .58, s.width * .52,
            s.height * .6)
        ..cubicTo(s.width * .7, s.height * .62, s.width * .84, s.height * .5, s.width,
            s.height * .54),
      track,
    );
    c.drawLine(at(.52, .6), at(.52, 1), track);

    _field(c, box(.05, .07, .43, .44), const Color(0xFF8A6A3D), const Color(0xFF6E9B3F));
    _orchard(c, box(.58, .06, .95, .42), rng);
    _greenhouse(c, box(.05, .64, .31, .93));
    _pasture(c, box(.63, .66, .96, .95));
    _pond(c, box(.35, .72, .48, .93));
    _barn(c, box(.46, .30, .60, .55));
  }

  void _field(Canvas c, Rect r, Color soil, Color crop) {
    final rounded = RRect.fromRectAndRadius(r, const Radius.circular(6));
    c.drawRRect(rounded, Paint()..color = soil);
    final row = Paint()
      ..color = crop
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    for (var x = r.left + 8; x < r.right - 4; x += 10) {
      c.drawLine(Offset(x, r.top + 6), Offset(x, r.bottom - 6), row);
    }
  }

  void _orchard(Canvas c, Rect r, math.Random rng) {
    c.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(6)),
      Paint()..color = const Color(0xFF86AD5C),
    );
    const cols = 6, rows = 3;
    for (var j = 0; j < rows; j++) {
      for (var i = 0; i < cols; i++) {
        final centre = Offset(
          r.left + r.width * (i + .5) / cols,
          r.top + r.height * (j + .5) / rows,
        );
        c.drawCircle(centre.translate(1.5, 3), 9, Paint()..color = const Color(0x33000000));
        c.drawCircle(centre, 9, Paint()..color = const Color(0xFF3F7D3A));
        c.drawCircle(centre.translate(-2.5, -2.5), 4.5, Paint()..color = const Color(0xFF5FA352));
        if (rng.nextBool()) {
          c.drawCircle(centre.translate(3, 2), 1.8, Paint()..color = const Color(0xFFEF8C2B));
        }
      }
    }
  }

  void _greenhouse(Canvas c, Rect r) {
    c.drawRRect(
      RRect.fromRectAndRadius(r, const Radius.circular(10)),
      Paint()..color = const Color(0xFFD7EEE9),
    );
    final bar = Paint()
      ..color = const Color(0xFF8FB9B1)
      ..strokeWidth = 2;
    for (var x = r.left + r.width / 5; x < r.right - 2; x += r.width / 5) {
      c.drawLine(Offset(x, r.top), Offset(x, r.bottom), bar);
    }
    c.drawLine(r.centerLeft, r.centerRight, bar);
  }

  void _pasture(Canvas c, Rect r) {
    c.drawRect(r, Paint()..color = const Color(0xFFAFD07F));
    final fence = Paint()
      ..color = const Color(0xFF7A5230)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    c.drawRect(r, fence);
    for (final o in [const Offset(.3, .35), const Offset(.68, .3), const Offset(.5, .72)]) {
      final p = Offset(r.left + r.width * o.dx, r.top + r.height * o.dy);
      c.drawOval(Rect.fromCenter(center: p, width: 15, height: 9), Paint()..color = Colors.white);
      c.drawCircle(p.translate(8, -2), 3.2, Paint()..color = const Color(0xFF3A2A1C));
    }
  }

  void _pond(Canvas c, Rect r) {
    c.drawOval(r.inflate(2), Paint()..color = const Color(0xFFD9C08F));
    c.drawOval(r, Paint()..color = const Color(0xFF5BA6D6));
    c.drawOval(
      Rect.fromCenter(center: r.center.translate(-3, -4), width: r.width * .45, height: r.height * .2),
      Paint()..color = const Color(0x66FFFFFF),
    );
  }

  void _barn(Canvas c, Rect r) {
    c.drawRect(r.shift(const Offset(3, 4)), Paint()..color = const Color(0x33000000));
    c.drawRect(r, Paint()..color = const Color(0xFFA23B2A));
    final roof = Path()
      ..moveTo(r.left - 5, r.top + r.height * .35)
      ..lineTo(r.center.dx, r.top - 2)
      ..lineTo(r.right + 5, r.top + r.height * .35)
      ..close();
    c.drawPath(roof, Paint()..color = const Color(0xFF5B5148));
    c.drawRect(
      Rect.fromCenter(
        center: Offset(r.center.dx, r.bottom - r.height * .2),
        width: r.width * .4,
        height: r.height * .4,
      ),
      Paint()..color = const Color(0xFFF2E6CF),
    );
  }
}

/// Shows the map; tapping a pin reports its place.
class FarmMap extends StatefulWidget {
  const FarmMap({super.key, required this.pins, this.selected, required this.onPinTap});

  final List<MapPin> pins;
  final String? selected;
  final void Function(String placeId) onPinTap;

  @override
  State<FarmMap> createState() => _FarmMapState();
}

class _FarmMapState extends State<FarmMap> {
  late final FarmMapGame _game = FarmMapGame(onPinTap: (id) => widget.onPinTap(id));

  @override
  Widget build(BuildContext context) {
    _game
      ..pins = widget.pins
      ..selected = widget.selected;
    return SizedBox(height: 210, child: GameWidget(game: _game));
  }
}

List<MapPin> pinsFor(Iterable<Place> places, Map<String, int> openByPlace) => [
      for (final place in places)
        if ((openByPlace[place.id] ?? 0) > 0) MapPin(place, openByPlace[place.id]!),
    ];
