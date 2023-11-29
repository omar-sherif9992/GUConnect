// it will convert the first letter of each word to uppercase
String titleCase(String word) {

  word = word.toLowerCase().trim();
  for (int i = 0; i < word.length; i++) {
    if (i == 0) {
      word = word[i].toUpperCase() + word.substring(1);
    } else if (word[i] == ' ') {
      word = word.substring(0, i + 1) +
          word[i + 1].toUpperCase() +
          word.substring(i + 2);
    }
  }
  return word;

}