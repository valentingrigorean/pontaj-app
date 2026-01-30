import 'dart:ffi' as ffi;
import 'dart:io';

typedef _BeepNative = ffi.Int32 Function(ffi.Uint32, ffi.Uint32);
typedef _BeepDart = int Function(int, int);

class _ChimePlayer {
  _ChimePlayer._();
  static final _ChimePlayer instance = _ChimePlayer._();

  _BeepDart? _beep;

  void _ensureLoaded() {
    if (_beep != null || !Platform.isWindows) return;
    try {
      final lib = ffi.DynamicLibrary.open('kernel32.dll');
      _beep = lib.lookupFunction<_BeepNative, _BeepDart>('Beep');
    } catch (_) {
      _beep = null;
    }
  }

  Future<void> play() async {
    _ensureLoaded();
    final beep = _beep;
    if (beep == null) return;
    const tones = <(int, int)>[
      (523, 160),
      (659, 160),
      (784, 200),
      (1046, 280),
      (880, 220),
    ];
    for (final tone in tones) {
      beep(tone.$1, tone.$2);
    }
  }
}

Future<void> playSplashChime() => _ChimePlayer.instance.play();
