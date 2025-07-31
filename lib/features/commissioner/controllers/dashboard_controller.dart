import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juru_stay/features/auth/services/auth_service.dart';

final commissionerDashboardControllerProvider = StateNotifierProvider.autoDispose<
    CommissionerDashboardController, AsyncValue<void>>(
  (ref) => CommissionerDashboardController(ref),
);

class CommissionerDashboardController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  CommissionerDashboardController(this.ref) : super(const AsyncValue.data(null));

  Future<void> deleteAccount(String uid) async {
    state = const AsyncValue.loading();
    try {
      final authService = ref.read(authServiceProvider);
      await authService.deleteCommissionerProfile(uid);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> deletePlace(String docId) async {
    state = const AsyncValue.loading();
    try {
      await FirebaseFirestore.instance.collection('places').doc(docId).delete();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Stream<QuerySnapshot> getPlacesStream(String commissionerId) {
    return FirebaseFirestore.instance
        .collection('places')
        .where('commissionerId', isEqualTo: commissionerId)
        .snapshots();
  }
}
// features/commissioner/application/dashboard_controller.dart (continued)
final commissionerPlacesStreamProvider = StreamProvider.autoDispose
    .family<QuerySnapshot, String>((ref, commissionerId) {
  return ref
      .watch(commissionerDashboardControllerProvider.notifier)
      .getPlacesStream(commissionerId);
});