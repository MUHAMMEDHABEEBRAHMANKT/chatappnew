// function for conver text to camel case7
String toCamelCase(String text) {
  return text
      .toLowerCase()
      .split(' ')
      .map((str) =>
          str.isNotEmpty ? str[0].toUpperCase() + str.substring(1) : '')
      .join(' ');
}

//function for extract name from email
String extractNameFromEmail(String email) {
  return email.split('@')[0]; // Extract the part before '@'
}
