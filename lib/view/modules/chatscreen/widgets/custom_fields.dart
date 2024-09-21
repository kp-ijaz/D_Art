import 'package:d_art/view/modules/chatscreen/services/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:small_chat/utils/strings.dart';

// import '../utils/colors.dart';

Widget customField({
  required String topLabel,
  required String label,
  IconData? leadingIcon,
  IconData? trailingIcon,
  void Function()? onTrailingTap,
  TextInputType? keyboardType,
  bool? secured,
  TextEditingController? controller,
  bool? whiteMode,
  bool? required,
  List<TextInputFormatter>? inputFormatter,
  Color? backgroundColor,
  int? minLine,
  int? maxLine,
  bool? enabled,
}) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            topLabel,
            style: TextStyle(
              color: whiteMode == true
                  ? Colors.white.withOpacity(.8)
                  : Colors.black.withOpacity(.8),
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: whiteMode == true
                ? Colors.white.withOpacity(.2)
                : Colors.black.withOpacity(.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Center(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: leadingIcon == null ? 15.0 : 0),
                child: TextFormField(
                  minLines: minLine ?? 1,
                  maxLines: maxLine ?? 1,
                  inputFormatters: inputFormatter,
                  validator: required == true
                      ? (val) {
                          if (val!.isEmpty) {
                            return validationErrorMsg;
                          }
                          return null;
                        }
                      : null,
                  style:
                      TextStyle(color: whiteMode == true ? Colors.white : null),
                  controller: controller,
                  obscureText: secured ?? false,
                  enabled: enabled,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: TextStyle(
                      color: whiteMode == true
                          ? Colors.white.withOpacity(.5)
                          : null,
                    ),
                    prefixIcon: leadingIcon == null
                        ? null
                        : Icon(
                            leadingIcon,
                            color: whiteMode == true
                                ? Colors.white.withOpacity(.5)
                                : Colors.black.withOpacity(.5),
                          ),
                    suffixIcon: IconButton(
                      onPressed: onTrailingTap,
                      icon: Icon(
                        trailingIcon,
                        color: whiteMode == true
                            ? Colors.white.withOpacity(.5)
                            : Colors.black.withOpacity(.5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      )
    ],
  );
}
