//
// TextFieldViewController.swift
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

class TextFieldViewController: UIViewController {
    
    var bottomViewHeight: CGFloat = 120.0
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textInput1: TailoredTextField! {
        didSet {
            textInput1.clipsToBounds = false
        }
    }
    @IBOutlet weak var textInput2: TailoredTextField! {
        didSet {
            textInput2.clipsToBounds = false
        }
    }
    @IBOutlet weak var textInput3: TailoredTextField! {
        didSet {
            textInput3.clipsToBounds = false
            textInput3.contentVerticalAlignment = .bottom
            textInput3.textInsetY = 10
        }
    }
    @IBOutlet weak var textInput4: TailoredTextField! {
        didSet {
            textInput4.clipsToBounds = false
        }
    }
    @IBOutlet weak var textInput5: TailoredTextField! {
        didSet {
            textInput5.clipsToBounds = false
        }
    }
    @IBOutlet weak var textInput6: TailoredTextField! {
        didSet {
            textInput6.clipsToBounds = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardNotification(_ notification: Foundation.Notification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions().rawValue
            let animationCurve: UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            
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

extension TextFieldViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(textInput1) {
            textInput2.becomeFirstResponder()
        } else if textField.isEqual(textInput2) {
            textInput3.becomeFirstResponder()
        } else if textField.isEqual(textInput3) {
            textInput4.becomeFirstResponder()
        } else if textField.isEqual(textInput4) {
            textInput5.becomeFirstResponder()
        } else if textField.isEqual(textInput5) {
            textInput6.becomeFirstResponder()
        } else if textField.isEqual(textInput6) {
            dismissKeyboard()
        }
        return true
    }
    
}

