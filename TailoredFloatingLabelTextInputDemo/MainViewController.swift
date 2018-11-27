//
// MainViewController.swift
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

class MainViewController: UIViewController {
    
    let identifierEmbedTextFieldViewController = "embedTextFieldViewController"
    let identifierEmbedTextInputLayoutViewController = "embedTextInputLayoutViewController"
    
    var textFieldViewController: TextFieldViewController?
    var textInputLayoutViewController: TextInputLayoutViewController?
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var textFieldContainer: UIView!
    @IBOutlet weak var textInputLayoutContainer: UIView!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var errorStateSwitch: UISwitch!
    @IBOutlet weak var clearErrorOnTextEntrySwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == identifierEmbedTextFieldViewController {
            textFieldViewController = segue.destination as? TextFieldViewController
            textFieldViewController?.bottomViewHeight = bottomViewHeightConstraint.constant
        } else if segue.identifier == identifierEmbedTextInputLayoutViewController {
            textInputLayoutViewController = segue.destination as? TextInputLayoutViewController
            textFieldViewController?.bottomViewHeight = bottomViewHeightConstraint.constant
        }
    }
    
    @IBAction func onSegmentedControlValueChanged(_ sender: Any) {
        dismissKeyboard()
        switch segmentedControl.selectedSegmentIndex {
        case 1:
            textInputLayoutContainer.isHidden = true
            textFieldContainer.isHidden = false
            textFieldViewController?.onErrorStateSwitchValueChanged(isOn: errorStateSwitch.isOn)
            textFieldViewController?.onClearErrorOnTextEntrySwitchValueChanged(isOn: clearErrorOnTextEntrySwitch.isOn)
        default:
            textInputLayoutContainer.isHidden = false
            textFieldContainer.isHidden = true
            textInputLayoutViewController?.onErrorStateSwitchValueChanged(isOn: errorStateSwitch.isOn)
            textInputLayoutViewController?.onClearErrorOnTextEntrySwitchValueChanged(isOn: clearErrorOnTextEntrySwitch.isOn)
        }
    }
    
    @IBAction func onTogglErrorStateTouchUpInside(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: textFieldViewController?.onTogglErrorStateTouchUpInside()
        default: textInputLayoutViewController?.onTogglErrorStateTouchUpInside()
        }
    }
    
    @IBAction func onErrorStateSwitchValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: textFieldViewController?.onErrorStateSwitchValueChanged(isOn: errorStateSwitch.isOn)
        default: textInputLayoutViewController?.onErrorStateSwitchValueChanged(isOn: errorStateSwitch.isOn)
        }
    }
    
    @IBAction func onClearErrorOnTextEntrySwitchValueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 1: textFieldViewController?.onClearErrorOnTextEntrySwitchValueChanged(isOn: clearErrorOnTextEntrySwitch.isOn)
        default: textInputLayoutViewController?.onClearErrorOnTextEntrySwitchValueChanged(isOn: clearErrorOnTextEntrySwitch.isOn)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension MainViewController: UINavigationBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}

