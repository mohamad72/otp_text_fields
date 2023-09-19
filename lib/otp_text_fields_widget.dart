import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animator/flutter_animator.dart';

enum OtpState { normal, error, success, loading }

enum OtpBoxState { filled, empty, active }

class OtpTextFieldsController {
  final ValueNotifier<String> otpValue = ValueNotifier<String>('');
  final ValueNotifier<OtpState> currentState = ValueNotifier<OtpState>(OtpState.normal);

  OtpTextFieldsController({String otpValue = '', OtpState currentState = OtpState.normal}) {
    this.otpValue.value = otpValue;
    this.currentState.value = currentState;
  }
}

class OtpTextFields extends StatefulWidget {
  final int otpLength;
  final double height;
  final double spacing;
  final OtpTextFieldsController otpTextFieldsController;
  final BoxDecoration? decorationEmptyBox;
  final BoxDecoration? decorationFilledBox;
  final BoxDecoration? decorationActiveBox;
  final BoxDecoration? decorationLoadingBox;
  final BoxDecoration? decorationErrorBox;
  final BoxDecoration? decorationSuccessBox;
  final TextStyle defaultTextStyle;
  final TextStyle? textStyleFilled;
  final TextStyle? textStyleActive;
  final TextStyle? textStyleLoading;
  final TextStyle? textStyleError;
  final TextStyle? textStyleSuccess;

  final void Function(String otpValue, bool isFinished)? onChanged;
  final void Function()? onSubmitKeyboardPressed;

  const OtpTextFields({
    required this.otpLength,
    required this.otpTextFieldsController,
    required this.defaultTextStyle,
    this.onSubmitKeyboardPressed,
    this.onChanged,
    this.spacing = 8.0,
    this.height = 55.0,
    this.decorationEmptyBox,
    this.decorationFilledBox,
    this.decorationActiveBox,
    this.decorationLoadingBox,
    this.decorationErrorBox,
    this.decorationSuccessBox,
    this.textStyleFilled,
    this.textStyleActive,
    this.textStyleLoading,
    this.textStyleError,
    this.textStyleSuccess,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpTextFields> createState() => _OtpTextFieldsState();
}

class _OtpTextFieldsState extends State<OtpTextFields> {
  List<FocusNode> myFocusNode = [];
  List<FocusNode> myFocusNodeRaw = [];
  List<int?> numbers = [];
  List<TextEditingController> controllers = [];
  List<GlobalKey<AnimatorWidgetState>> animatePulseKeys = [];

  @override
  void initState() {
    List.generate(widget.otpLength, (index) => myFocusNode.add(FocusNode()));
    List.generate(widget.otpLength, (index) => myFocusNodeRaw.add(FocusNode()));
    List.generate(widget.otpLength, (index) => numbers.add(null));
    List.generate(widget.otpLength, (index) => controllers.add(TextEditingController()));
    List.generate(widget.otpLength, (index) => animatePulseKeys.add(GlobalKey<AnimatorWidgetState>()));

    if (widget.otpTextFieldsController.otpValue.value.isNotEmpty) {
      fillOtp(widget.otpTextFieldsController.otpValue.value);
    }
    super.initState();
  }

  void startPulseIfNeed() async {
    if (widget.otpTextFieldsController.currentState.value != OtpState.loading) return;
    while (widget.otpTextFieldsController.currentState.value == OtpState.loading) {
      for (int i = 0; i < animatePulseKeys.length; i++) {
        await Future.delayed(const Duration(milliseconds: 120));
        animatePulseKeys[i].currentState!.forward();
      }
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  BoxDecoration getBoxDecoration(BuildContext context, OtpBoxState otpBoxState) {
    if (widget.decorationErrorBox != null && widget.otpTextFieldsController.currentState.value == OtpState.error) {
      return widget.decorationErrorBox!;
    }
    if (widget.decorationLoadingBox != null && widget.otpTextFieldsController.currentState.value == OtpState.loading) {
      return widget.decorationLoadingBox!;
    }
    if (widget.decorationSuccessBox != null && widget.otpTextFieldsController.currentState.value == OtpState.success) {
      return widget.decorationSuccessBox!;
    }
    if (widget.decorationActiveBox != null && otpBoxState == OtpBoxState.active) {
      return widget.decorationActiveBox!;
    }
    if (widget.decorationEmptyBox != null && otpBoxState == OtpBoxState.empty) {
      return widget.decorationEmptyBox!;
    }
    if (widget.decorationFilledBox != null && otpBoxState == OtpBoxState.filled) {
      return widget.decorationFilledBox!;
    }
    return BoxDecoration(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: BoxShape.rectangle,
      border: Border.all(
        color: widget.otpTextFieldsController.currentState.value == OtpState.error
            ? Colors.red
            : widget.otpTextFieldsController.currentState.value == OtpState.success
                ? Colors.green
                : widget.otpTextFieldsController.currentState.value == OtpState.loading
                    ? Colors.grey
                    : otpBoxState == OtpBoxState.active
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
        width: otpBoxState == OtpBoxState.active ? 3.0 : 1.5,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
    );
  }

  TextStyle getTextStyle(BuildContext context, OtpBoxState otpBoxState) {
    if (widget.textStyleError != null && widget.otpTextFieldsController.currentState.value == OtpState.error) {
      return widget.textStyleError!;
    }
    if (widget.textStyleLoading != null && widget.otpTextFieldsController.currentState.value == OtpState.loading) {
      return widget.textStyleLoading!;
    }
    if (widget.textStyleSuccess != null && widget.otpTextFieldsController.currentState.value == OtpState.success) {
      return widget.textStyleSuccess!;
    }
    if (widget.textStyleActive != null && otpBoxState == OtpBoxState.active) {
      return widget.textStyleActive!;
    }
    if (widget.textStyleFilled != null && otpBoxState == OtpBoxState.filled) {
      return widget.textStyleFilled!;
    }
    return widget.defaultTextStyle;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder<String>(
          valueListenable: widget.otpTextFieldsController.otpValue,
          builder: (context, otpValue, child) {
            if (otpValue.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) => fillOtp(otpValue));
            }
            return const SizedBox();
          },
        ),
        ValueListenableBuilder<OtpState>(
          valueListenable: widget.otpTextFieldsController.currentState,
          builder: (context, otpState, _) {
            WidgetsBinding.instance.addPostFrameCallback((_) => startPulseIfNeed());
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                  widget.otpLength,
                  (index) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: widget.spacing / 2, right: widget.spacing / 2),
                      child: Pulse(
                        key: animatePulseKeys[index],
                        preferences: const AnimationPreferences(
                          autoPlay: AnimationPlayStates.None,
                          duration: Duration(milliseconds: 160),
                          magnitude: 2.0,
                        ),
                        child: AbsorbPointer(
                          absorbing: otpState == OtpState.loading,
                          child: Container(
                            height: widget.height,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 4, left: 2),
                            decoration: getBoxDecoration(
                              context,
                              myFocusNode[index].hasFocus
                                  ? OtpBoxState.active
                                  : numbers[index] == null
                                      ? OtpBoxState.empty
                                      : OtpBoxState.filled,
                            ),
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                setState(() {});
                              },
                              child: RawKeyboardListener(
                                focusNode: myFocusNodeRaw[index],
                                onKey: (event) {
                                  if (event.data.keyLabel.trim().toLowerCase() == 'backspace' || event.data.keyLabel.trim().isEmpty) {
                                    if (numbers[index] != null) return;
                                    if (index == 0) return;
                                    myFocusNode[index - 1].requestFocus();
                                  }
                                },
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  autofocus: false,
                                  controller: controllers[index],
                                  enableInteractiveSelection: false,
                                  focusNode: myFocusNode[index],
                                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                                  autocorrect: false,
                                  showCursor: false,
                                  onChanged: (value) {
                                    if (value.isEmpty) {
                                      numbers[index] = null;
                                      onChanged();
                                      return;
                                    }
                                    if (value.length == 1) {
                                      numbers[index] = int.parse(value);
                                    } else {
                                      List<int> digits = value.characters.map((e) => int.parse(e)).toList();
                                      numbers[index] = digits.firstWhereOrNull((element) => element != numbers[index]) ?? numbers[index];
                                      controllers[index].text = numbers[index].toString();
                                    }
                                    onChanged();

                                    if (index + 1 == widget.otpLength) return;
                                    myFocusNode[index + 1].requestFocus();
                                  },
                                  onSubmitted: (_) {
                                    if (numbers.every((element) => element != null)) {
                                      if (widget.onSubmitKeyboardPressed != null) widget.onSubmitKeyboardPressed!();
                                    }
                                  },
                                  textAlign: TextAlign.center,
                                  style: getTextStyle(
                                    context,
                                    myFocusNode[index].hasFocus
                                        ? OtpBoxState.active
                                        : numbers[index] == null
                                            ? OtpBoxState.empty
                                            : OtpBoxState.filled,
                                  ),
                                  maxLines: 1,
                                  minLines: 1,
                                  decoration: const InputDecoration(
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(width: 0, color: Colors.transparent)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void fillOtp(String otpValue) async {
    List<int> digits = otpValue.characters.map((e) => int.parse(e)).toList();
    for (int i = 0; i < min(widget.otpLength, digits.length); i++) {
      numbers[i] = digits[i];
      controllers[i].text = digits[i].toString();
      animatePulseKeys[i].currentState!.forward();
      await Future.delayed(const Duration(milliseconds: 140));
    }
    String otp = numbers.map((e) => e ?? '').join('');
    widget.onChanged!(otp, otp.length == widget.otpLength);
    widget.otpTextFieldsController.otpValue.value = otp;
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void onChanged() {
    String otp = numbers.map((e) => e ?? '').join('');
    widget.otpTextFieldsController.otpValue.value = otp;
    if (widget.onChanged != null) widget.onChanged!(otp, otp.length == widget.otpLength);
  }
}
