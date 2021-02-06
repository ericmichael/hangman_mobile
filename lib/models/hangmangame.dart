import 'package:http/http.dart' as http;

class HangmanGame {
  String word;
  String correctGuesses;
  String wrongGuesses;

  //Constructor starts off with blank strings that we will concatenate during the course of play
  HangmanGame(this.word) {
    correctGuesses = "";
    wrongGuesses = "";
  }

  bool guess(String letter) {
    //This tests if the letter passed as a guess by the user is a valid alphanumeric character through the use of regular expressions
    RegExp test = new RegExp(r'[a-zA-Z]');

    if (letter == null || letter == "" || !test.hasMatch(letter)) {
      throw ArgumentError();
    }

    //We want for our guesses to be case insensitive
    letter = letter.toLowerCase();

    if (word.contains(letter)) {
      if (correctGuesses.contains(letter)) {
        return false;
      }
      correctGuesses += letter;
      return true;
    } else {
      if (wrongGuesses.contains(letter)) {
        return false;
      }
      wrongGuesses += letter;
      return true;
    }
  }

  String gameBlanksWithCorrectGuesses() {
    String tmp = "";
    for (int a = 0; a < word.length; a++) {
      if (correctGuesses.contains(word[a])) {
        tmp += word[a];
      } else {
        tmp += "-";
      }
    }
    return tmp;
  }

  String get status {
    return gameStatus();
  }

  String get blanksWithCorrectGuesses {
    return gameBlanksWithCorrectGuesses();
  }

  String gameStatus() {
    String status = gameBlanksWithCorrectGuesses();
    if (wrongGuesses.length >= 7) {
      return "lose";
    } else if (status == word) {
      return "win";
    } else {
      return "play";
    }
  }

  //when running integration tests always return "banana"
  static Future<String> getStartingWord(bool areWeInIntegrationTest) async {
    String word;

    if (areWeInIntegrationTest) {
      word = "banana";
    } else {
      try {
        var response = await http
            .post("http://randomword.saasbook.info/RandomWord");
        word = response.body;
      } catch (e) {
        word = "error";
      }
    }

    return word;
  }
}
