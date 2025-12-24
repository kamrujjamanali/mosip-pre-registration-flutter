import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/models/consent_dialog_data.dart';

class ConsentDialog extends StatefulWidget {
  final ConsentDialogData data;

  const ConsentDialog({super.key, required this.data});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox(
        width: 900,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TITLE
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                widget.data.title.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFFD518C),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Divider(color: Color(0xFFFD518C)),

            /// CONTENT
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  ExpansionPanelList.radio(
                    initialOpenPanelValue: 0,
                    children: widget.data.data.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return ExpansionPanelRadio(
                        value: index,
                        headerBuilder: (_, __) {
                          return Directionality(
                            textDirection:
                                widget.data.textDirectionArr[index],
                            child: ListTile(
                              title: Text(
                                item.labels.title,
                                style: const TextStyle(
                                  color: Color(0xFFFD518C),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        },
                        body: Directionality(
                          textDirection:
                              widget.data.textDirectionArr[index],
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.labels.subtitle,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ...item.fileText
                                    .map((line) => Text(line)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  /// CHECKBOX
                  Row(
                    children: [
                      Checkbox(
                        value: !isChecked,
                        onChanged: (val) {
                          setState(() => isChecked = !val!);
                        },
                      ),
                      Expanded(
                        child: Wrap(
                          children: widget.data.data
                              .map((e) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(e.labels.checkCondition),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// ACTIONS
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFD518C)),
                    ),
                    child: Text(
                      widget.data.cancelBtn,
                      style: const TextStyle(color: Color(0xFFFD518C)),
                    ),
                  ),
                  const Spacer(),
                  ...widget.data.data.map((item) {
                    if (item.langCode ==
                        widget.data.userPreferredLangCode) {
                      return ElevatedButton(
                        onPressed: isChecked
                            ? null
                            : () => Navigator.pop(
                                  context,
                                  item.labels.acceptButton,
                                ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFD518C),
                        ),
                        child: Text(item.labels.acceptButton),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
