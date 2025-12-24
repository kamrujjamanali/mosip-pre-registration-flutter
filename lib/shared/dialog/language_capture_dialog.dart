import 'package:flutter/material.dart';
import 'package:mosip_pre_registration_mobile/models/language_capture_dialog_data.dart';

class LanguageCaptureDialog extends StatefulWidget {
  final LanguageCaptureDialogData data;

  const LanguageCaptureDialog({super.key, required this.data});

  @override
  State<LanguageCaptureDialog> createState() =>
      _LanguageCaptureDialogState();
}

class _LanguageCaptureDialogState extends State<LanguageCaptureDialog> {
  late List<String> selectedLanguages;
  bool disableSubmit = true;

  @override
  void initState() {
    super.initState();

    selectedLanguages = [...widget.data.mandatoryLanguages];

    if (!selectedLanguages.contains(widget.data.userPrefLanguage)) {
      selectedLanguages.add(widget.data.userPrefLanguage);
    }

    _validate();
  }

  void _onSelectLanguage(String code, bool checked) {
    setState(() {
      if (checked) {
        selectedLanguages.add(code);
      } else {
        selectedLanguages.remove(code);
      }
      _validate();
    });
  }

  void _validate() {
    disableSubmit = !(selectedLanguages.length >= widget.data.minLanguage &&
        selectedLanguages.length <= widget.data.maxLanguage);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.data.dir,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: SizedBox(
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TITLE
                Text(
                  widget.data.title.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFFFD518C),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Divider(color: Color(0xFFFD518C)),

                /// MESSAGE
                Text(widget.data.message),
                const SizedBox(height: 12),

                /// ERROR
                if (selectedLanguages.length > widget.data.maxLanguage)
                  Text(
                    widget.data.errorText,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),

                const SizedBox(height: 8),

                /// LANGUAGE CHECKBOXES
                ...widget.data.languages.map((lang) {
                  final isMandatory =
                      widget.data.mandatoryLanguages.contains(lang.code);
                  final isChecked =
                      selectedLanguages.contains(lang.code);

                  return CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(lang.value),
                    value: isChecked,
                    onChanged: isMandatory
                        ? null
                        : (val) => _onSelectLanguage(lang.code, val!),
                  );
                }),

                const SizedBox(height: 20),

                /// ACTIONS
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFFD518C)),
                      ),
                      child: Text(
                        widget.data.cancelButtonText,
                        style:
                            const TextStyle(color: Color(0xFFFD518C)),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: disableSubmit
                          ? null
                          : () =>
                              Navigator.pop(context, selectedLanguages),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFD518C),
                      ),
                      child: Text(widget.data.submitButtonText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
