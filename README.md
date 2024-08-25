# UnderlineText Package

The `basic_underline` package provides a customizable Flutter widget that allows you to add animated underlines to text. You can choose between straight and squiggly underline animations, customize colors, and optionally add URL links to your text.

## Features

- **Straight Underline Animation:** A smooth, expanding line that animates from left to right.
- **Squiggly Underline Animation:** An animated squiggly line that moves under the text.
- **Customization:** Easily control text color, underline color, hover text color, animation duration, and underline thickness.
- **Link Support:** Make text clickable with optional URL launching.

## Installation

Add `underline_text` to your `pubspec.yaml` file:

```yaml
dependencies:
  underline_text: ^1.0.0
```
and then run this to update the packages
```
flutter pub get
```

## Usage

Here's how to use the UnderlineText widget in your Flutter application:
```dart
import 'package:flutter/material.dart';
import 'package:underline_text/underline_text.dart'; // Import the package

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('UnderlineText Example')),
        body: Center(
          child: UnderlineText(
            text: 'Click Me',
            textColor: Colors.black,
            underlineColor: Colors.blue,
            hoverTextColor: Colors.blueAccent,
            animationType: UnderlineAnimationType.squiggly,
            animationDuration: Duration(milliseconds: 500),
            underlineThickness: 3.0,
            url: 'www.himalthapa1.com.np', // Optional URL
          ),
        ),
      ),
    );
  }
}
```

## Widget Parameters
- **text (required)** : The Desired text to display to the user.
- **textColor (optional)** : The desired color of the text or default color will be used if not provided by the developer.
- **hoverColor (optional)** : The desired hover color of the text that will be shown to the user on mouse hover event or default color will be used if not provided by the developer.
- **underlineColor (optional)** : The desired color of the underline that will be shown to the user on mouse hover event or default color will be used if not provided by the developer.
- **animationType (optional)** : The type of underline animation. Options are **UnderlineAnimationType.straight** and **UnderlineAnimationType.squiggly**. Defaults to UnderlineAnimationType.straight.
- **url(optional)** : The URL to open when the text is clicked. If null, the text will not be clickable.
- **animationDuration(optional)** : The duration upon which the animation of the underline will be drawn under the text.
- **underlineThickness(optional)** : The thickness of the underline. (tip : donot use too much thick underline especially on squiggly underline).

## License
This package is licensed under the MIT License. See the LICENSE file for more details.

## Contributing
Contributions are very much not only welcome but encouraged! Please open an issue or submit a pull request if you have suggestions or improvements. I would be happy to help you or collaborate with you on the issue or improvements to the code.

## Contact
For any questions or feedback, feel free to open an issue on the [GitHub repository](https://github.com/HimalThapaMagar/Most-Basic-Underline.git).Thank you!