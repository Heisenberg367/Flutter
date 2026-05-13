import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/mpesa_controller.dart';

class MpesaCheckoutScreen extends StatefulWidget {
  final int amount;
  final String orderId;

  const MpesaCheckoutScreen({
    super.key,
    required this.amount,
    required this.orderId,
  });

  @override
  State<MpesaCheckoutScreen> createState() => _MpesaCheckoutScreenState();
}

class _MpesaCheckoutScreenState extends State<MpesaCheckoutScreen>
    with TickerProviderStateMixin {
  final MpesaController _mpesa = Get.put(MpesaController());
  final TextEditingController _phoneCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  static const Color _green = Color(0xFF00A651);
  static const Color _darkGreen = Color(0xFF007A3D);
  static const Color _bg = Color(0xFFF5F7FA);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textMid = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'M-Pesa Checkout',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    switch (_mpesa.state) {
      case MpesaState.idle:
        return _buildForm();
      case MpesaState.initiating:
        return _buildStatus(
          icon: Icons.send_rounded,
          iconColor: _green,
          title: 'Sending Request',
          subtitle: _mpesa.message,
          showSpinner: true,
        );
      case MpesaState.waitingUser:
        return _buildWaiting();
      case MpesaState.polling:
        return _buildStatus(
          icon: Icons.search_rounded,
          iconColor: Colors.orange,
          title: 'Confirming Payment',
          subtitle: _mpesa.message,
          showSpinner: true,
        );
      case MpesaState.success:
        return _buildSuccess();
      case MpesaState.failed:
        return _buildResult(
          icon: Icons.error_outline_rounded,
          iconColor: Colors.red,
          title: 'Payment Failed',
          subtitle: _mpesa.message,
        );
      case MpesaState.cancelled:
        return _buildResult(
          icon: Icons.cancel_outlined,
          iconColor: Colors.orange,
          title: 'Payment Cancelled',
          subtitle: _mpesa.message,
        );
    }
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _summaryCard(),
            const SizedBox(height: 24),
            _mpesaLogoRow(),
            const SizedBox(height: 24),
            _label('M-Pesa Phone Number'),
            const SizedBox(height: 8),
            _phoneField(),
            const SizedBox(height: 8),
            _hint('Format: 07XX XXX XXX'),
            const SizedBox(height: 32),
            _payButton(),
            const SizedBox(height: 20),
            _securityNote(),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 13,
              color: _textMid,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Order #${widget.orderId}',
            style: const TextStyle(
              fontSize: 15,
              color: _textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total Amount',
                  style: TextStyle(color: _textMid)),
              Text(
                'KES ${widget.amount}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mpesaLogoRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5EF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _green.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Lipa Na M-Pesa',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _darkGreen,
                  fontSize: 15,
                ),
              ),
              Text(
                'Secured by Safaricom',
                style: TextStyle(fontSize: 12, color: _textMid),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.verified_rounded, color: _green, size: 20),
        ],
      ),
    );
  }

  Widget _phoneField() {
    return TextFormField(
      controller: _phoneCtrl,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d+]'))
      ],
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.phone_android_rounded, color: _green),
        hintText: '0712 345 678',
        hintStyle: TextStyle(color: _textMid.withOpacity(0.6)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _green, width: 2),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter your phone number';
        }
        final clean = val.replaceAll(RegExp(r'[\s\-]'), '');
        if (!RegExp(r'^(0[17]\d{8}|2547\d{8}|2541\d{8})$')
            .hasMatch(clean)) {
          return 'Enter a valid Safaricom number (07XX or 01XX)';
        }
        return null;
      },
    );
  }

  Widget _payButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 3,
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            FocusScope.of(context).unfocus();
            _mpesa.pay(
              phone: _phoneCtrl.text.trim(),
              amount: widget.amount,
              orderId: widget.orderId,
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.lock_rounded, size: 18),
            SizedBox(width: 8),
            Text(
              'Pay with M-Pesa',
              style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _securityNote() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, size: 14, color: _textMid),
          const SizedBox(width: 4),
          Text(
            'Secured by Safaricom Daraja',
            style: TextStyle(fontSize: 12, color: _textMid),
          ),
        ],
      ),
    );
  }

  Widget _buildWaiting() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _pulseAnim,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: _green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.phone_android_rounded,
                  size: 52,
                  color: _green,
                ),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Check Your Phone!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _mpesa.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 15, color: _textMid, height: 1.5),
            ),
            const SizedBox(height: 32),
            _stepPill('1', 'A pop-up appeared on your phone'),
            const SizedBox(height: 8),
            _stepPill('2', 'Enter your M-Pesa PIN'),
            const SizedBox(height: 8),
            _stepPill('3', 'Press OK to confirm payment'),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => _mpesa.reset(),
              child: const Text(
                'Cancel Payment',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepPill(String number, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _green.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: _green,
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(fontSize: 13, color: _textDark)),
        ],
      ),
    );
  }

  Widget _buildStatus({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    bool showSpinner = false,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showSpinner) ...[
              CircularProgressIndicator(color: iconColor),
              const SizedBox(height: 24),
            ],
            Icon(icon, size: 56, color: iconColor),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: _textMid, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: _green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 72,
                color: _green,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Order #${widget.orderId} has been paid.\nYou\'ll receive an M-Pesa SMS shortly.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: _textMid, height: 1.6),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => Get.until((r) => r.isFirst),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResult({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: iconColor),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _textDark),
            ),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14, color: _textMid, height: 1.5),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () => _mpesa.reset(),
                child: const Text('Try Again',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Go Back',
                  style: TextStyle(color: _textMid)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: _textDark,
        ),
      );

  Widget _hint(String text) => Text(
        text,
        style: TextStyle(fontSize: 12, color: _textMid),
      );
}