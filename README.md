# Tailored Floating Label Text Input
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms iOS](https://img.shields.io/badge/Platforms-iOS-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
[![Xcode 8.0+](https://img.shields.io/badge/Xcode-8.0+-blue.svg?style=flat)](https://developer.apple.com/swift/)

A highly customizable text input field written in Swift which have a floating label design pattern implementation among many other features. It has no external dependencies and can be used to implement not only Google's Material Design spec but many other designs as well.
___
<br />

Example Gif                |  Empty                    |  Filled                   |  Error
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![Tailored Floating Label Text Input in action](https://github.com/AutSoft/TailoredFloatingLabelTextInput/blob/master/screenshots/example.gif)  |  ![Tailored Floating Label Text Input in action 2](https://github.com/AutSoft/TailoredFloatingLabelTextInput/blob/master/screenshots/scr01.png) | ![Tailored Floating Label Text Input in action](https://github.com/AutSoft/TailoredFloatingLabelTextInput/blob/master/screenshots/scr05.png) | ![Tailored Floating Label Text Input in action 2](https://github.com/AutSoft/TailoredFloatingLabelTextInput/blob/master/screenshots/scr06.png)



## Features
* Animated Floating Label
* Details and error display
* Highly customizable
* Material Design specs can be implemented with ease (see examples)
* Drop shadows
* Colored backgrounds with corner radius
* Configurable in Interface Builder

## Requirements
* Swift 3
* iOS 9.0+
* XCode8

## Installation
### CocoaPods
TailoredFloatingLabelTextInput is available through CocoaPods. To install it, simply add the following line to your Podfile:

```ruby
pod 'TailoredFloatingLabelTextInput', '~>  1.0'
```

Or if you want to use a sepcific version:

```ruby
pod 'TailoredFloatingLabelTextInput', '1.0.0'
```


## Usage
Two UIView are included in this library:

* TailoredTextField
* TailoredTextInputLayout

Most of the features are available with both, but there are some limitations and differences for each, which are detailed below.

### TailoredTextField
To use this in your app, simply add a new *Text Field* to the layout of your `ViewController` and change it's class to `TailoredTextField` in *Identity inspector*.

Inherited from `UITextField`, this View is the more convinient to use, as all properties of the `UITextField` is easily accessible both from the code and Interface Builder, and it can be used everywhere where a simple `UITextField` can be used.

It can be configured from Interface Builder or code, all of the `UITextField`

However, compared to the `TailoredTextInputLayout` it has somewhat limited functionality due to the limitations raised by being a `UITextField` without a custom layout. If you run into these limitations, consider using the `TailoredTextInputLayout` instead, which is a custom view that contains a `TailoredTextField` in a custom layout and provides more features, but cannot be used as `UITextField` (it does not inherit from it).

The following properties can be changed to customize the appearance and behaviour:

| Property                               | Description                                                 | Type     | Default Value |
|:---------------------------------------|:------------------------------------------------------------|:---------|:--------------|
| text                                   | The text content of the TextField.                          | String?  | nil           |
| textInsetX                             | The inset before and after the text.                        | CGFloat  | 0             |
| textInsetY                             | The inset above and below the text.                         | CGFloat  | 0             |
| backgroundCornerRadius                 | The corner radius of the TextField background.              | CGFloat  | 0             |
| borderEnabled                          | Whether the border is displayed or not for the TextField.   | Bool     | false         |
| normalBorderColor                      | The color of the border for the normal state.               | UIColor? | nil           |
| dropShadowColor                        | The color of the drop shadow. If it is set, the drop shadow will be displayed. | UIColor? | nil           |
| dropShadowOpacity                      | The opacity of the drop shadow.                             | Float    | 0.0           |
| bottomLineEnabled                      | Whether the bottom line is displayed for the TextField.     | Bool     | false         |
| bottomLineNormalColor                  | The color of the bottom line when it is in the normal state.| UIColor? | nil           |
| bottomLineActiveColor                  | The color of the bottom line when it is in the active state.| UIColor? | nil           |
| bottomLineErrorColor                   | The color of the bottom line when it is in the error state. | UIColor? | nil           |
| floatingLabelEnabled                   | Whether the placeholder text is displayed as a floating label when the TextField is active.| Bool     | true          |
| floatingLabelTranslateY                | The value which the floating label needs to be tranlated upwards.| CGFloat  | 36.0          |
| floatingLabelTextColor                 | The text color of the floating label.                       | UIColor? | nil           |
| floatingLabelErrorTextColor            |The text color of the floating label when the TextField is in the error state.| UIColor? | nil           |
| floatingLabelInsetX                    | The inset before the floating label.                        | CGFloat  | 0             |
| isPlaceholderOnlyChangedOnTextEntered  | Whether the placeholder display is changed as soon as the TextField becomes a first responder or only when text is entered.| Bool     | false         |
| placeholderInsetX                      | The inset before and after the placeholder label.           | CGFloat  | 0             |
| placeholderInsetY                      | The inset above and below the placeholder label.            | CGFloat  | 0             |
| placeholderText                        | The text to be displayed as placeholder and also as a floating label if that functionality is enabled.| String?  | nil           |
| placeholderTextColor                   | The text color of the placeholder.                          | UIColor? | nil           |
| detailInsetX                           | The inset before and after the detail label.                | CGFloat  | 0             |
| detailText                             | The text displayed in the detail label.                     | String?  | nil           |
| detailTextColor                        | The text color of the detail text.                          | UIColor? | nil           |
| detailTextAlignment                    | The alignment of the detail text.                           | TailoredTextAlignment| .left           |
| errorInsetX                            | The inset to be applied before and after the error text.    | CGFloat  | 0             |
| errorText                              | The text to be displayed as an error.                       | String?  | 0             |
| clearErrorOnInput                      | Whether the error state should be cleared as soon as text is entered.| Bool     | false         |
| displayBorderOnError                   | Whether a border should be displayed in error state.        | Bool     | false         |
| errorBorderColor                       | The color of the border for the error state.                | UIColor? | nil           |
| errorTextColor                         | The text color of the error text.                           | UIColor? | nil           |
| errorBackgroundColor                   | The background color of the error text.                     | UIColor? | nil           |
| errorBackgroundBottomCornerRadius      | The bottom corner radius of the TextField background.       | CGFloat  | 0.0           |
| errorTextAlignment                     | The alignment of the error text.                            | TailoredTextAlignment| .left           |

Limitations / differences compared to the `TailoredTextInputLayout`:

* Drop shadow can only be displayed for the whole View (it can be enabled by setting the `dropShadowColor` and `dropShadowOpacity` properties), including the floating label, error and detail labels.
* The detail and error labels and the floating label (if enabled and the `floatingLabelTranslateY` property is set to a high enough value) are displayed outside of the bounds of the `TailoredTextField` itself. It is not a big problem most of the time, but still something to keep in mind. In case of `TailoredTextInputLayout` only the floating label is displayed outside of the bounds of the view, and only if the `floatingLabelTranslateY` property is set to a high enough value.

### TailoredTextInputLayout
To use this in your app, simply add a new *View* to the layout of your `ViewController` and change it's class to `TailoredTextInputLayout` in *Identity inspector*.

It is a custom view with its layout being defined in a Xib file, containing a `TailoredTextField` and some UILabels (for error, detail and placeholder/floating label). It provides all of the functionality of this library without any limitations of the `TailoredTextField`, but cannot be used where a `UITextField` instance can. It is still configurable in Interface Builder, but some properties of `UITextField` can only be configured from code by accessing them via the `textField` property.

Setting these properties can be done simply with a property observer:

```swift
@IBOutlet weak var textInput: TailoredTextInputLayout! {
    didSet {
        textInput.textField.delegate = self
        textInput.textField.keyboardType = .emailAddress
        textInput.textField.autocorrectionType = .no
    }
}
```

The following properties can be changed to customize the appearance and behaviour:

| Property                               | Description                                                 | Type     | Default Value |
|:---------------------------------------|:------------------------------------------------------------|:---------|:--------------|
| text                                   | The text content of the TextField.                          | String?  | nil           |
| textInsetX                             | The inset before and after the text.                        | CGFloat  | 0.0           |
| textInsetY                             | The inset above and below the text.                         | CGFloat  | 0.0           |
| textFieldHeight                        | The height of the contained TextField.                      | CGFloat  | 0.0           |
| backroundFillColor                     | he background color of the conatined TailoredTextField.     | UIColor? | nil           |
| textFieldCornerRadius                  | The corner radius of the conatined TailoredTextField‘s background.| CGFloat  | 0.0           |
| borderEnabled                          | Whether the border is displayed or not for the TextField.   | Bool     | false         |
| normalBorderColor                      | The color of the border for the normal state.               | UIColor? | nil           |
| dropShadowColor                        | The color of the drop shadow. If it is set, the drop shadow will be displayed. | UIColor? | nil           |
| dropShadowOpacity                      | The opacity of the drop shadow.                             | Float    | 0.0           |
| bottomLineEnabled                      | Whether the bottom line is displayed for the TextField.     | Bool     | false         |
| bottomLineNormalColor                  | The color of the bottom line when it is in the normal state.| UIColor? | nil           |
| bottomLineActiveColor                  | The color of the bottom line when it is in the active state.| UIColor? | nil           |
| bottomLineErrorColor                   | The color of the bottom line when it is in the error state. | UIColor? | nil           |
| floatingLabelEnabled                   | Whether the placeholder text is displayed as a floating label when the TextField is active.| Bool     | true          |
| floatingLabelTranslateY                | The value which the floating label needs to be tranlated upwards.| CGFloat  | 36.0          |
| floatingLabelTextColor                 | The text color of the floating label.                       | UIColor? | nil           |
| floatingLabelErrorTextColor            |The text color of the floating label when the TextField is in the error state.| UIColor? | nil           |
| floatingLabelInsetX                    | The inset before the floating label.                        | CGFloat  | 0             |
| isPlaceholderOnlyChangedOnTextEntered  | Whether the placeholder display is changed as soon as the TextField becomes a first responder or only when text is entered.| Bool     | false         |
| placeholderInsetX                      | The inset before and after the placeholder label.           | CGFloat  | 0             |
| placeholderInsetY                      | The inset above and below the placeholder label.            | CGFloat  | 0             |
| placeholderText                        | The text to be displayed as placeholder and also as a floating label if that functionality is enabled.| String?  | nil           |
| placeholderTextColor                   | The text color of the placeholder.                          | UIColor? | nil           |
| detailInsetX                           | The inset before and after the detail label.                | CGFloat  | 0             |
| detailText                             | The text displayed in the detail label.                     | String?  | nil           |
| detailTextColor                        | The text color of the detail text.                          | UIColor? | nil           |
| detailTextAlignment                    | The alignment of the detail text.                           | TailoredTextAlignment| .left           |
| errorInsetX                            | The inset to be applied before and after the error text.    | CGFloat  | 0             |
| errorText                              | The text to be displayed as an error.                       | String?  | 0             |
| clearErrorOnInput                      | Whether the error state should be cleared as soon as text is entered.| Bool     | false         |
| displayBorderOnError                   | Whether a border should be displayed in error state.        | Bool     | false         |
| errorBorderColor                       | The color of the border for the error state.                | UIColor? | nil           |
| errorTextColor                         | The text color of the error text.                           | UIColor? | nil           |
| errorBackgroundColor                   | The background color of the error text.                     | UIColor? | nil           |
| errorBackgroundBottomCornerRadius      | The bottom corner radius of the TextField background.       | CGFloat  | 0.0           |
| errorTextAlignment                     | The alignment of the error text.                            | TailoredTextAlignment| .left           |

### Also See
* The `TailoredFloatingLabelTextInputDemo` demo project for usage examples
* Full code documentation in the `docs` folder

## Development Goals
- [x] Floating Label with nice, continous animation
- [x] Customizable error and detail display
- [x] Configuration from Interface Builder (`@IBDesignable` with `@IBInspectable` properties)
- [x] Normal and boxed Material Design Text Field implementations
- [x] Full Code Documentation
- [ ] CI integration
- [ ] Unit tests
- [ ] UI Tests with screenshot comparison

## License

This library is released under the MIT license. [See LICENSE](https://github.com/AutSoft/TailoredFloatingLabelTextInput/blob/master/LICENSE) for details.
