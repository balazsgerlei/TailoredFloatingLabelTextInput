//
// TextInputLayoutViewController.swift
//
// Copyright (c) 2018 Balázs Gerlei
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import UIKit
import TailoredFloatingLabelTextInput

class TextInputLayoutViewController: UIViewController {
    
    var bottomViewHeight: CGFloat = 120.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textInput1: TailoredTextInputLayout! {
        didSet {
            textInput1.textField.delegate = self
        }
    }
    @IBOutlet weak var textInput2: TailoredTextInputLayout! {
        didSet {
            textInput2.textField.delegate = self
        }
    }
    @IBOutlet weak var textInput3: TailoredTextInputLayout! {
        didSet {
            textInput3.textField.delegate = self
            textInput3.textField.contentVerticalAlignment = .bottom
            textInput3.textField.textInsetY = 10
        }
    }
    @IBOutlet weak var textInput4: TailoredTextInputLayout! {
        didSet {
            textInput4.textField.delegate = self
        }
    }
    @IBOutlet weak var textInput5: TailoredTextInputLayout! {
        didSet {
            textInput5.textField.delegate = self
        }
    }
    @IBOutlet weak var textInput6: TailoredTextInputLayout! {
        didSet {
            textInput6.textField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardNotification(_ notification: Foundation.Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions().rawValue
            let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            
            if (endFrame != nil && endFrame!.origin.y >= UIScreen.main.bounds.size.height)
                || endFrame?.size.height == nil {
                scrollView.contentInset.bottom = 0.0
            } else {
                scrollView.contentInset.bottom = endFrame!.size.height - bottomViewHeight
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func onTogglErrorStateTouchUpInside() {
        textInput1.errorText = textInput1.errorText == nil || textInput1.errorText == "" ? "Error" : ""
        textInput2.errorText = textInput2.errorText == nil || textInput2.errorText == "" ? "Error" : ""
        textInput3.errorText = textInput3.errorText == nil || textInput3.errorText == "" ? "Error" : ""
        textInput4.errorText = textInput4.errorText == nil || textInput4.errorText == "" ? "Error" : ""
        textInput5.errorText = textInput5.errorText == nil || textInput5.errorText == "" ? "Error" : ""
        textInput6.errorText = textInput6.errorText == nil || textInput5.errorText == "" ? "Error" : ""
    }
    
    func onErrorStateSwitchValueChanged(isOn: Bool) {
        if isOn {
            textInput1.errorText = "Error"
            textInput2.errorText = "Error"
            textInput3.errorText = "Error"
            textInput4.errorText = "Error"
            textInput5.errorText = "Error"
            textInput6.errorText = "Error"
        } else {
            textInput1.errorText = nil
            textInput2.errorText = nil
            textInput3.errorText = nil
            textInput4.errorText = nil
            textInput5.errorText = nil
            textInput6.errorText = nil
        }
    }
    
    func onClearErrorOnTextEntrySwitchValueChanged(isOn: Bool) {
        if isOn {
            textInput1.clearErrorOnInput = true
            textInput2.clearErrorOnInput = true
            textInput3.clearErrorOnInput = true
            textInput4.clearErrorOnInput = true
            textInput5.clearErrorOnInput = true
            textInput6.clearErrorOnInput = true
        } else {
            textInput1.clearErrorOnInput = false
            textInput2.clearErrorOnInput = false
            textInput3.clearErrorOnInput = false
            textInput4.clearErrorOnInput = false
            textInput5.clearErrorOnInput = false
            textInput6.clearErrorOnInput = false
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension TextInputLayoutViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(textInput1.textField) {
            textInput2.textField.becomeFirstResponder()
        } else if textField.isEqual(textInput2.textField) {
            textInput3.textField.becomeFirstResponder()
        } else if textField.isEqual(textInput3.textField) {
            textInput4.textField.becomeFirstResponder()
        } else if textField.isEqual(textInput4.textField) {
            textInput5.textField.becomeFirstResponder()
        } else if textField.isEqual(textInput5.textField) {
            textInput6.textField.becomeFirstResponder()
        } else if textField.isEqual(textInput6.textField) {
            dismissKeyboard()
        }
        return true
    }
    
}

