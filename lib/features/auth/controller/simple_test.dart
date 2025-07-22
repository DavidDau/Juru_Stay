import 'package:flutter_riverpod/flutter_riverpod.dart';

// Simple test provider
final testAuthProvider = StateProvider<String?>((ref) => null);

class SimpleTest {
  static void test() {
    print('Simple test works');
  }
}
