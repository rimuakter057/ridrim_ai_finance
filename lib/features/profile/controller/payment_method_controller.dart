import 'package:ridrim/domain/entities/payment_card_item.dart';
import 'package:ridrim/features/profile/presentation/widgets/add_card_sheet.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/utils/extensions.dart';
import '../presentation/utils/card_input_format.dart';

mixin PaymentMethodsControllerMixin<T extends StatefulWidget> on State<T> {
  final List<PaymentCardItem> cards = [
    const PaymentCardItem(
      id: 'card_1',
      brand: 'Visa',
      last4: '4242',
      expiry: '12/28',
      isDefault: true,
    ),
    const PaymentCardItem(
      id: 'card_2',
      brand: 'Mastercard',
      last4: '8812',
      expiry: '09/27',
      isDefault: false,
    ),
  ];

  Future<void> addCard() async {
    final PaymentCardItem? result = await showModalBottomSheet<PaymentCardItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddCardSheet(),
    );

    if (result == null || !mounted) return;

    setState(() => cards.add(result));
    context.showSnackBar('Card ending in ${result.last4} added successfully');
  }

  void setDefault(String id) {
    setState(() {
      for (int i = 0; i < cards.length; i++) {
        cards[i] = cards[i].copyWith(isDefault: cards[i].id == id);
      }
    });
    context.showSnackBar('Default payment method updated');
  }

  void deleteCard(String id) {
    setState(() => cards.removeWhere((c) => c.id == id));
    context.showSnackBar('Payment method removed');
  }
}

mixin AddCardControllerMixin<T extends StatefulWidget> on State<T> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController numberCtrl = TextEditingController();
  final TextEditingController expiryCtrl = TextEditingController();
  final TextEditingController cvvCtrl = TextEditingController();

  bool isLoading = false;
  String detectedBrand = '';

  @override
  void dispose() {
    nameCtrl.dispose();
    numberCtrl.dispose();
    expiryCtrl.dispose();
    cvvCtrl.dispose();
    super.dispose();
  }

  void onNumberChanged(String value) {
    setState(() => detectedBrand = detectCardBrand(value));
  }

  String? validateCardNumber(String? value) {
    final String digits = (value ?? '').replaceAll(' ', '');
    if (digits.length < 13) return AppStrings.fieldRequiredMessage;
    return null;
  }

  String? validateName(String? value) =>
      (value == null || value.trim().isEmpty)
          ? AppStrings.fieldRequiredMessage
          : null;

  String? validateExpiry(String? value) {
    if (value == null || value.length < 5) return AppStrings.fieldRequiredMessage;
    return null;
  }

  String? validateCvv(String? value) {
    if (value == null || value.length < 3) return AppStrings.fieldRequiredMessage;
    return null;
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final String rawNumber = numberCtrl.text.replaceAll(' ', '');
    final String last4 = rawNumber.length >= 4
        ? rawNumber.substring(rawNumber.length - 4)
        : rawNumber;

    final PaymentCardItem newCard = PaymentCardItem(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      brand: detectedBrand.isEmpty ? 'Card' : detectedBrand,
      last4: last4,
      expiry: expiryCtrl.text.trim(),
      isDefault: false,
    );

    Navigator.of(context).pop(newCard);
  }
}