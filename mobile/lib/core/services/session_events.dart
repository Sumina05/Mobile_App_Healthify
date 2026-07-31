import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Decouples the network layer from the auth feature: the refresh
/// interceptor fires [expired], the auth controller listens and reacts.
class SessionEvents extends ChangeNotifier {
  void expired() => notifyListeners();
}

final sessionEventsProvider = Provider<SessionEvents>((ref) {
  final events = SessionEvents();
  ref.onDispose(events.dispose);
  return events;
});
