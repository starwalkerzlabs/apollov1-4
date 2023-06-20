import 'package:chatgpt_app/main.dart';

class Safety {
  static String? checkSafety(String message) {
    final String lowercaseMessage = message.toLowerCase();

    if (lowercaseMessage.contains('suicidal thoughts') ||
        lowercaseMessage.contains('end of my rope') ||
        lowercaseMessage.contains('homicidal thoughts') ||
        lowercaseMessage.contains('commit suicide') ||
        lowercaseMessage.contains('thoughts of self harm') ||
        lowercaseMessage.contains('want to hurt myself') ||
        lowercaseMessage.contains('want to hurt others') ||
        lowercaseMessage.contains('want to kill someone') ||
        lowercaseMessage.contains("i can't get the voices to stop")) {
      return 'Help is available if you or someone you know is experiencing a crisis. Call or text chat 988 for the 988 Suicide and Crisis Lifeline. As a language model, my ability to help in a crisis is limited. Our team of creators cares about your wellbeing.';
    }

    if (lowercaseMessage.contains('substance abuse') ||
        lowercaseMessage.contains('addiction') ||
        lowercaseMessage.contains("can't stop using drugs") ||
        lowercaseMessage.contains("can't stop using alcohol")) {
      return 'Help is available if you or someone you know needs help for substance abuse or addiction. Call 1-800-662-HELP (4357) for the SAMHSA National Helpline. As a language model, my ability to help in a crisis is limited. Our team of creators cares about your wellbeing.';
    }

    return null;
  }
}
