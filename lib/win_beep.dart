import 'win_beep_stub.dart'
    if (dart.library.io) 'win_beep_io.dart' as impl;

Future<void> playSplashChime() => impl.playSplashChime();
