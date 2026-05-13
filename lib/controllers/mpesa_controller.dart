import 'dart:async';
import 'package:get/get.dart';
import '../services/mpesa_service.dart';

enum MpesaState {
  idle,
  initiating,
  waitingUser,
  polling,
  success,
  failed,
  cancelled,
}

class MpesaController extends GetxController {
  final _state = MpesaState.idle.obs;
  final _message = ''.obs;
  final _checkoutRequestId = ''.obs;

  MpesaState get state => _state.value;
  String get message => _message.value;

  bool get isLoading =>
      _state.value == MpesaState.initiating ||
      _state.value == MpesaState.waitingUser ||
      _state.value == MpesaState.polling;

  Timer? _pollTimer;
  int _pollCount = 0;
  static const int _maxPolls = 12;

  Future<void> pay({
    required String phone,
    required int amount,
    required String orderId,
  }) async {
    try {
      _reset();
      _state.value = MpesaState.initiating;
      _message.value = 'Sending payment request…';

      final response = await MpesaService.initiateStkPush(
        phone: phone,
        amount: amount,
        orderId: orderId,
      );

      _checkoutRequestId.value = response.checkoutRequestId;
      _state.value = MpesaState.waitingUser;
      _message.value =
          'Check your phone ($phone) and enter your M-Pesa PIN to complete payment.';

      await Future.delayed(const Duration(seconds: 5));
      _startPolling();
    } on MpesaException catch (e) {
      _state.value = MpesaState.failed;
      _message.value = e.message;
    } catch (e) {
      _state.value = MpesaState.failed;
      _message.value = 'Unexpected error. Please try again.';
    }
  }

  void _startPolling() {
    _pollCount = 0;
    _state.value = MpesaState.polling;
    _message.value = 'Confirming payment…';

    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      _pollCount++;

      try {
        final result = await MpesaService.queryTransaction(
          checkoutRequestId: _checkoutRequestId.value,
        );

        if (result.isSuccess) {
          _pollTimer?.cancel();
          _state.value = MpesaState.success;
          _message.value = 'Payment successful! 🎉';
          return;
        }

        if (result.resultCode == '1032') {
          _pollTimer?.cancel();
          _state.value = MpesaState.cancelled;
          _message.value = 'Payment was cancelled.';
          return;
        }

        if (_pollCount >= _maxPolls) {
          _pollTimer?.cancel();
          _state.value = MpesaState.failed;
          _message.value =
              'Payment timed out. If money was deducted, contact support.';
        }
      } catch (_) {}
    });
  }

  void _reset() {
    _pollTimer?.cancel();
    _pollCount = 0;
    _checkoutRequestId.value = '';
    _message.value = '';
    _state.value = MpesaState.idle;
  }

  void reset() => _reset();

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}