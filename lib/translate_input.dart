import 'package:flutter/material.dart';
import 'translate_api.dart';

class CustomInputTranslate extends StatefulWidget {
  final TranslateApi translateInput;
  final TextEditingController controller; // Kullanıcı girdisini almak için
  final String initialLanguage; // Varsayılan hedef dil
  final List<String> languages; // Desteklenen diller
  final Widget? child; // Kullanıcıdan alınacak özel widget
  final Widget Function(BuildContext context, String translatedText)?
      translatedWidgetBuilder; // Çeviri sonucunu göstermek için
  final bool isHiddenTranslatedText;

  const CustomInputTranslate({
    required this.translateInput,
    required this.controller,
    this.child,
    this.translatedWidgetBuilder,
    this.initialLanguage = 'en',
    this.languages = const ['en', 'tr'],
    Key? key,
    this.isHiddenTranslatedText = false,
  }) : super(key: key);

  @override
  State<CustomInputTranslate> createState() => _CustomInputTranslateState();
}

class _CustomInputTranslateState extends State<CustomInputTranslate> {
  String _translatedText = '';
  String? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.initialLanguage; // Varsayılan dil
  }

  // Dil değiştirme
  void _onLanguageChanged(String? newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  // Çeviri fonksiyonu
  Future<void> _translateText() async {
    final inputText = widget.controller.text;
    if (inputText.isNotEmpty) {
      try {
        final translated = await widget.translateInput.translateText(
          inputText,
          _selectedLanguage ?? 'en',
        );
        setState(() {
          _translatedText = translated;
        });
      } catch (e) {
        setState(() {
          _translatedText = 'Çeviri hatası: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Dil seçici
            DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: _onLanguageChanged,
              items: widget.languages
                  .map(
                    (lang) => DropdownMenuItem<String>(
                      value: lang,
                      child: Text(lang.toUpperCase()),
                    ),
                  )
                  .toList(),
            ),

            // TextField - düzeltildi
            //const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: widget.controller,
                decoration: const InputDecoration(
                  labelText: 'Bir şeyler yazınız',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        // Çeviri butonu
        ElevatedButton(
          onPressed: _translateText,
          child: const Text('Çevir'),
        ),

        // Çeviri sonucu
        widget.controller.text.isNotEmpty
            ? widget.isHiddenTranslatedText
                ? widget.translatedWidgetBuilder != null
                    ? widget.translatedWidgetBuilder!(context, _translatedText)
                    : Text(_translatedText,
                        style: const TextStyle(fontSize: 18))
                : const SizedBox()
            : const SizedBox(),
      ],
    );
  }
}
