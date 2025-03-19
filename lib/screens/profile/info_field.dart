import 'package:flutter/material.dart';
import 'package:future_capsule/core/constants/colors.dart';

class InfoField extends StatefulWidget {
  const InfoField(
      {super.key,
      required this.leadingIcon,
      required this.fieldName,
      required this.fieldValue,
      required this.isEditable,
      this.onFieldValueChanged,
      required this.iconColor});

  final IconData leadingIcon;
  final Color iconColor;
  final String fieldName;
  final String fieldValue;
  final bool isEditable;
  final Function(String)? onFieldValueChanged;

  @override
  State<InfoField> createState() => _InfoFieldState();
}

class _InfoFieldState extends State<InfoField> {
  final TextEditingController _controller = TextEditingController();

  _editField() {
    return showDialog(
        context: context,
        builder: (context) {
          _controller.text = widget.fieldValue;
          return Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              height: 180,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Enter your name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.kWarmCoralColor, width: 2.0),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: AppColors.kWarmCoralColor, width: 1.5),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              color: AppColors.kWarmCoralColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                        height: 40,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (widget.onFieldValueChanged != null) {
                            widget.onFieldValueChanged!(_controller.text);
                          }
                          Navigator.pop(context); // Close dialog
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                              color: AppColors.kWarmCoralColor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          // margin: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                widget.leadingIcon,
                size: 28,
                color: widget.iconColor,
              ),
              const SizedBox(
                width: 28,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.fieldName,
                    style: const TextStyle(
                        color: Color.fromRGBO(0, 204, 255, 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width - 130,
                    child: Text(widget.fieldValue,
                        style: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.dActiveColorSecondary,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              const Spacer(),
              if (widget.isEditable)
                GestureDetector(
                  onTap: _editField,
                  child: const Icon(Icons.edit,
                      size: 22, color: Color.fromRGBO(211, 47, 47, 1)),
                ),
            ],
          ),
        ),
        const Divider(
          color: Color.fromARGB(155, 203, 193, 193),
          thickness: 0.3,
          indent: 64,
          endIndent: 18,
        ),
      ],
    );
  }
}
