import 'package:web/web.dart' as web;

bool isMobileWebBrowser() {
  final userAgent = web.window.navigator.userAgent.toLowerCase();
  const mobileKeywords = ['iphone', 'ipad', 'ipod', 'android', 'mobile'];
  return mobileKeywords.any((keyword) => userAgent.contains(keyword));
}
