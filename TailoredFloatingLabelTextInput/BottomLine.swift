//
// BottomLine.swift
//
// Copyright (c) 2017 AutSoft Kft.
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

/// The struct used for displaying a line at the bottom of 
/// TailoredTextInputLayout and TailoredTextField.
public struct BottomLine {
    
    fileprivate let lineZPosition: CGFloat = 5000.0
    
    internal weak var view: UIView?
    internal var lineView: UIView?
    
    internal init(view: UIView?, lineThickness: CGFloat = 1) {
        self.view = view
        self.lineThickness = lineThickness
    }
    
    internal var isHidden = false {
        didSet {
            lineView?.isHidden = isHidden
        }
    }
    
    internal var lineThickness: CGFloat {
        didSet {
            layoutView()
        }
    }
    
    internal var color: UIColor? {
        get {
            return lineView?.backgroundColor
        }
        set {
            guard let newValue = newValue else {
                lineView?.removeFromSuperview()
                lineView = nil
                return
            }
            if lineView == nil {
                lineView = UIView()
                lineView?.layer.zPosition = lineZPosition
                view?.addSubview(lineView!)
                layoutView()
            }
            lineView?.backgroundColor = newValue
        }
    }
    
    fileprivate func layoutView() {
        guard let lineView = lineView, let view = view else {
            return
        }
        lineView.frame = CGRect(x: 0, y: view.layer.frame.height - lineThickness, width: view.layer.frame.width, height: lineThickness)
    }
    
}
