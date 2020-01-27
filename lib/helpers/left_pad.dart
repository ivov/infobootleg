/// Pads `userInput` with zeros up to 5 digits, for querying Firebase.
String leftPad(userInput) {
  while (userInput.length < 5) {
    userInput = "0" + userInput;
  }
  return userInput;
}
