// Simple test file to check auth controller import
import '../controller/auth_controller.dart';

void main() {
  print('Testing auth controller import');
  // If this works, the provider should be accessible
  print(authControllerProvider.runtimeType);
}
