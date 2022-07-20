import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spell_check_on_client/spell_check_on_client.dart';

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({Key? key}) : super(key: key);

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  final Map<String, String> languages = {
    'English': 'en',
  };

  String language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Spell Checker',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SpellCheckExample(
          language: languages[language]!,
          key: UniqueKey(),
        ));
  }
}

class SpellCheckExample extends StatefulWidget {
  final String language;
  const SpellCheckExample({required this.language, Key? key}) : super(key: key);

  @override
  State<SpellCheckExample> createState() => _SpellCheckExampleState();
}

class _SpellCheckExampleState extends State<SpellCheckExample> {
  String didYouMean = '';
  SpellCheck spellCheck = SpellCheck.fromWordsList(['cat', 'bat', 'hat']);
  TextEditingController controller = TextEditingController();
  TextEditingController logController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSpellCheck();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextFormField(
              maxLines: 4,
              controller: controller,
              decoration: InputDecoration(
                  focusColor: Theme.of(context).textTheme.bodyText1!.color,
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color:
                              Theme.of(context).textTheme.bodyText1!.color!))),
            ),
            const SizedBox(height: 10),
            MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 10,
                color: Colors.green,
                child: Text(
                  'Check Spelling'.toUpperCase(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                onPressed: () => spellCheckValidate()),
            const SizedBox(height: 50),
            didYouMean == ''
                ? const SizedBox()
                : Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'Did you mean ',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: '$didYouMean?',
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 20)),
                          ],
                        ),
                      ),
                    ],
                  ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              enabled: false,
              minLines: 10,
              maxLines: 10,
              controller: logController,
            ),
          ],
        ),
      ),
    );
  }

  void initSpellCheck() async {
    String content =
        await rootBundle.loadString('assets/${widget.language}_words.txt');

    spellCheck = SpellCheck.fromWordsContent(content,
        letters: LanguageLetters.getLanguageForLanguage(widget.language));
  }

  void spellCheckValidate() {
    String text = controller.text;
    didYouMean = spellCheck.didYouMean(text);

    setState(() {});
  }
}
