String leftPad(userInput) {
  while (userInput.length < 5) {
    userInput = "0" + userInput;
  }
  return userInput;
}
