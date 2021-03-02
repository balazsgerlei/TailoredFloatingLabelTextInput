//
// TailoredTextField.swift
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

/** 
 A delegate intended to be used by the TailoredTextInputLayout
 to correctly handle changes in the contained TailoredTextField.
 */
public protocol TailoredTextFieldDelegate {
    
    /**
     Called when the `handleEditingChanged` method is called for the TextField.
     
     - parameter text: The text after the change.
     */
    func onTextChanged(text: String?)
    
    /// Called when the TailoredTextFieldDelegate finished its `layoutSubviews` method.
    func textFieldDidLayoutSubviews()
    
}

/// The key needed to store the `BottomLine` as an associated object.
private var bottomLineStorageKey: UInt8 = 0

/**
 A highly customizable text input field, inherited from `UITextField`.
 */
@IBDesignable open class TailoredTextField: UITextField {
    
    /// The delegate of the `TailoredTextField`
    var tailoredTextFieldDelegate: TailoredTextFieldDelegate?
    
    /**
     Whether the placeholder is in editing mode,
     meaning that it is displayed as a floating label, or simply hidden.
     
     The behaviour of this property depends on the value of
     the `isPlaceholderOnlyChangedOnTextEntered` property:
     * When that is `true`, this will become `true` when text is entered.
     * When that is `false`, this will become `true` as soon as the cursor is
     in this TextField (it becomes the first responder)
     */
    var isPlaceholderInEditingMode: Bool = false {
        didSet {
            onPlaceholderEditingModeChanged()
        }
    }
    
    /** 
     Whether the TextField is embedded inside a `TailoredTextInputLayout`.
     Important because it have to behave differently in this case
     as the `TailoredTextInputLayout` handles some of its aspects.
     */
    var insideTailoredTextInputLayout: Bool = false
    
    // MARK: - Detect text existence
    
    /// Returns whether the text is nil or empty
    var textNotNilOrEmpty: Bool {
        return text != nil && !text!.isEmpty
    }
    
    /**
     Returns whether the error text is nil or empty
     This is used to toggle the error display
     */
    var errorTextNotNilOrEmpty: Bool {
        return errorText != nil && !errorText!.isEmpty
    }
    
    /**
     Returns whether the detail text is nil or empty
     This is used to toggle the detail text display
     */
    var detailTextNotNilOrEmpty: Bool {
        return detailText != nil && !detailText!.isEmpty
    }
    
    // MARK: - Text content customization
    
    /**
     The text contained in the `TextField`
     Needed to be overridden because the state of the TextField
     need to be changed when it is set.
     */
    override open var text: String? {
        didSet {
            onTextChanged(text: text)
        }
    }
    
    /// The inset before and after the text.
    @IBInspectable
    open var textInsetX: CGFloat = 0
    
    /// The inset above and below the text.
    @IBInspectable
    open var textInsetY: CGFloat = 0
    
    // MARK: - Background customization
    
    /// The corner radius of the `TextField` background.
    @IBInspectable
    open var backgroundCornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            layoutSubviews()
        }
    }
    
    // MARK: - Border customization
    
    /// Whether the border is displayed or not for the TextField.
    @IBInspectable
    open var borderEnabled: Bool = false
    
    /**
     The color of the border for the normal state (when there is no error).
     
     - Note:
     It is only taken into account if the `borderEnabled` is set to `true`.
     */
    @IBInspectable
    open var normalBorderColor: UIColor?
    
    // MARK: - Drop shadow customization
    
    /**
     The color of the drop shadow. If it is set, the drop shadow will be displayed.
     The opacity of the drop shadow can be set with the `dropShadowOpacity` property.
     
     - Note: Setting the drop shadow means it will be displayed for all components
     of the `TailoredTextField`, including the floating label and the error and detail labels.
     If you are not satisfied with this behaviour, please use the `TailoredTextInputLayout` instead,
     which only display the drop shadow below the TextField itself.
     */
    @IBInspectable
    open var dropShadowColor: UIColor? {
        get {
            if let shadowColor = layer.shadowColor {
                return UIColor(cgColor: shadowColor)
            }
            return nil
        }
        set {
            if let shadowColor = newValue {
                layer.shadowColor = shadowColor.cgColor
                layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                layer.shadowRadius = 2.0
                clipsToBounds = false
            } else {
                clipsToBounds = true
            }
            layoutSubviews()
        }
    }
    
    /**
     The opacity of the drop shadow.
     
     - Note:
     It is only taken into account if the `dropShadowColor` is not `nil`.
     */
    @IBInspectable
    open var dropShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            layoutSubviews()
        }
    }
    
    // MARK: - Bottom line customization
    
    /// Whether the bottom line is displayed for the TextField.
    @IBInspectable
    open var bottomLineEnabled: Bool = false
    
    /**
     The color of the bottom line when it is in the normal state (not active or error).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineNormalColor: UIColor?
    
    /**
     The color of the bottom line when it is in the active state (when the TextField is the first responder).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineActiveColor: UIColor?
    
    /**
     The color of the bottom line when it is in the error state (when the `errorText` is set).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineErrorColor: UIColor?
    
    // MARK: - Floating label customization
    
    /// Whether the placeholder text is displayed as a floating label when the TextField is active.
    @IBInspectable
    open var floatingLabelEnabled: Bool = true
    
    /// The value which the floating label needs to be tranlated upwards when displayed.
    @IBInspectable
    open var floatingLabelTranslateY: CGFloat = 36.0
    
    /// The text color of the floating label.
    @IBInspectable
    open var floatingLabelTextColor: UIColor?
    
    /// The text color of the floating label when the TextField is in the error state.
    @IBInspectable
    open var floatingLabelErrorTextColor: UIColor?
    
    /// The inset before the floating label.
    @IBInspectable
    open var floatingLabelInsetX: CGFloat = 0
    
    // MARK: - Placeholder text customization
    
    /**
     Whether the placeholder display is changed as soon as the TextField becomes a first responder
     or only when text is entered. The placholder display can be changed in two ways:
     * As a floating label
     * Or completely disappear (as the default TextField behaves)
     */
    @IBInspectable
    open var isPlaceholderOnlyChangedOnTextEntered: Bool = false
    
    /// The inset before and after the placeholder label.
    @IBInspectable
    open var placeholderInsetX: CGFloat = 0 {
        didSet {
            placeholderLabelLeftConstraint?.constant = placeholderInsetX
            placeholderLabelRightConstraint?.constant = -(placeholderInsetX + (rightView?.layer.frame.size.width ?? 0))
        }
    }
    
    /// The inset above and below the placeholder label.
    @IBInspectable
    open var placeholderInsetY: CGFloat = 0 {
        didSet {
            placeholderLabelTopConstraint?.constant = placeholderInsetY
            placeholderLabelBottomConstraint?.constant = placeholderInsetY
        }
    }
    
    /// The label that displays the placeholder and is also transformed
    /// to be a floating label if that functionality is enabled.
    @IBInspectable
    public let placeholderLabel = UILabel()
    
    /// The text to be displayed as placeholder and also
    /// as a floating label if that functionality is enabled.
    @IBInspectable
    open var placeholderText: String? {
        get {
            return placeholderLabel.text
        }
        set {
            placeholderLabel.text = newValue
            if newValue != nil && !newValue!.isEmpty {
                placeholderLabel.isHidden = false
            } else {
                placeholderLabel.isHidden = true
            }
            layoutSubviews()
        }
    }
    
    /// The text color of the placeholder.
    @IBInspectable
    open var placeholderTextColor: UIColor? {
        didSet {
            if !isPlaceholderInEditingMode {
                placeholderLabel.textColor = placeholderTextColor
            }
        }
    }
    
    // MARK: - Detail text customization
    
    /// The inset before and after the detail label.
    @IBInspectable
    open var detailInsetX: CGFloat = 0 {
        didSet {
            detailLabelLeftConstraint?.constant = detailInsetX
            detailLabelRightConstraint?.constant = -detailInsetX
        }
    }
    
    /// The label used to display the detail text.
    @IBInspectable
    public let detailLabel = UILabel()
    
    /// The text displayed in the detail label.
    @IBInspectable
    open var detailText: String? {
        didSet {
            detailLabel.text = detailText
            if detailTextNotNilOrEmpty {
                detailLabel.isHidden = false
            } else {
                detailLabel.isHidden = true
            }
            layoutSubviews()
        }
    }
    
    /// The text color of the detail text.
    @IBInspectable
    open var detailTextColor: UIColor?
    
    /**
     The alignment of the detail text. This property is used to store and set the alignment from code.
     
     - Note:
     Another property called `detailTextAlignmentName` is used the set this value in the Interface Builder.
     */
    open var detailTextAlignment = TailoredTextAlignment.left
    
    /**
     The property used to set the alignment of the detail text from the Interface Builder.
     
     - Important:
     This property is reserved for Interface Builder. Use `detailTextAlignment` property to 
     set the detail text alignment from code instead.
     */
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'detailTextAlignment' instead.")
    @IBInspectable
    open var detailTextAlignmentName: String? {
        willSet {
            if let newDetailTextAlignment = TailoredTextAlignment(rawValue: newValue?.lowercased() ?? "") {
                detailTextAlignment = newDetailTextAlignment
            } else {
                detailTextAlignment = .left
            }
            layoutSubviews()
        }
    }
    
    // MARK: - Error display customization
    
    /// The inset to be applied before and after the error text.
    @IBInspectable
    open var errorInsetX: CGFloat = 0
    
    /**
     The text to be displayed as an error.
     
     - Note:
     If this is set anything different than `nil`, the error will be shown.
     */
    @IBInspectable
    open var errorText: String? {
        didSet {
            if errorTextNotNilOrEmpty {
                detailLabel.text = errorText
            } else {
                detailLabel.text = detailText
            }
            layoutSubviews()
        }
    }
    
    /// Whether the error state should be cleared as soon as text is entered.
    @IBInspectable
    open var clearErrorOnInput: Bool = false
    
    /// Whether a border should be displayed in error state.
    @IBInspectable
    open var displayBorderOnError: Bool = false
    
    /**
     The color of the border for the error state (when `errorText` is not `nil`).
     
     - Note:
     It is only taken into account if the `displayBorderOnError` is set to `true`.
     */
    @IBInspectable
    open var errorBorderColor: UIColor?
    
    /// The text color of the error text.
    @IBInspectable
    open var errorTextColor: UIColor?
    
    /// The background color of the error text.
    @IBInspectable
    open var errorBackgroundColor: UIColor?
    
    /// The bottom corner radius of the error text label's background.
    @IBInspectable
    open var errorBackgroundBottomCornerRadius: CGFloat = 0.0
    
    /**
     The alignment of the error text. This property is used to store and set the alignment from code.
     
     - Note:
     Another property called `errorTextAlignmentName` is used the set this value in the Interface Builder.
     */
    open var errorTextAlignment = TailoredTextAlignment.left
    
    /**
     The property used to set the alignment of the error text from the Interface Builder.
     
     - Important:
     This property is reserved for Interface Builder. Use `errorTextAlignment` property to
     set the detail text alignment from code instead.
     */
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'errorTextAlignment' instead.")
    @IBInspectable var errorTextAlignmentName: String? {
        willSet {
            if let newErrorTextAlignment = TailoredTextAlignment(rawValue: newValue?.lowercased() ?? "") {
                errorTextAlignment = newErrorTextAlignment
            } else {
                errorTextAlignment = .left
            }
            layoutSubviews()
        }
    }
    
    // MARK: - Bottom line associated object and helper methods
    
    /**
     The bottom line that is displayed at the bottom of the TextInputField. It is stored as
     an associated object with the key `bottomLineStorageKey`.
     
     - Note:
     The bottom line is only visible if the `bottomLineEnabled` property is set to `true`.
     */
    public private(set) var bottomLine: BottomLine {
        get {
            var result: BottomLine? = objc_getAssociatedObject(self, &bottomLineStorageKey) as? BottomLine
            if result == nil {
                result = BottomLine(view: self)
                objc_setAssociatedObject(self, &bottomLineStorageKey, result, .OBJC_ASSOCIATION_RETAIN)
            }
            return result!
        }
        set {
            objc_setAssociatedObject(self, &bottomLineStorageKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// A computed property to check whether the bottom line is currently hidden.
    open var isBottomLineHidden: Bool {
        get {
            return bottomLine.isHidden
        }
        set {
            bottomLine.isHidden = newValue
        }
    }
    
    /// The current color of the bottom line.
    open var bottomLineColor: UIColor? {
        get {
            return bottomLine.color
        }
        set {
            bottomLine.color = newValue
        }
    }
    
    /// The current thickness of the bottom line.
    open var bottomLineThickness: CGFloat {
        get {
            return bottomLine.lineThickness
        }
        set {
            bottomLine.lineThickness = newValue
        }
    }
    
    // MARK: - Set up text rectangles
    
    /**
     Returns the drawing rectangle for the text field’s text.
     Overridden to set the drawing rectangle based on insets.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uitextfield/1619636-textrect)
     */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonVisible = clearButtonMode == .always || clearButtonMode == .whileEditing
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let extractFromWidth = clearButtonVisible ? textInsetX + clearButtonWidth : 2 * textInsetX
        
        let editingRectX = bounds.origin.x + textInsetX
        let editingRectY = bounds.origin.y + textInsetY
        let editingRectWidth = bounds.width - extractFromWidth
        let editingRectHeight = bounds.height - 2 * textInsetY
        return CGRect(x: editingRectX, y: editingRectY, width: editingRectWidth, height: editingRectHeight)
    }
    
    /**
     Returns the rectangle in which editable text can be displayed.
     Overridden to set the drawing rectangle based on insets.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uitextfield/1619589-editingrect)
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        let clearButtonVisible = clearButtonMode == .always || clearButtonMode == .whileEditing
        let clearButtonWidth = clearButtonRect(forBounds: bounds).width
        let extractFromWidth = clearButtonVisible ? textInsetX + clearButtonWidth : 2 * textInsetX
        
        let editingRectX = bounds.origin.x + textInsetX
        let editingRectY = bounds.origin.y + textInsetY
        let editingRectWidth = bounds.width - extractFromWidth
        let editingRectHeight = bounds.height - 2 * textInsetY
        return CGRect(x: editingRectX, y: editingRectY, width: editingRectWidth, height: editingRectHeight)
    }
    
    // MARK: - Initializers
    
    /**
     Initializes and returns a newly allocated view object with the specified frame rectangle.
     Overridden to call the `setupSubviews` method.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uiview/1622488-init)
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    /**
     Returns an object initialized from data in a given unarchiver.
     
     Overridden to call the `setupSubviews` method.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/foundation/nscoding/1416145-init)
     */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }
    
    // MARK: - Constraints
    
    /// The constraint for the vertical space above the placeholder label.
    var placeholderLabelTopConstraint: NSLayoutConstraint?
    
    /// The constraint for the vertical space below the placeholder label.
    var placeholderLabelBottomConstraint: NSLayoutConstraint?
    
    /// The constraint for the horizontal space to the left of the placeholder label.
    var placeholderLabelLeftConstraint: NSLayoutConstraint?
    
    /// The constraint for the horizontal space to the right of the placeholder label.
    var placeholderLabelRightConstraint: NSLayoutConstraint?
    
    /// The constraint for the height of the detail label.
    var detailLabelHeightConstraint: NSLayoutConstraint?
    
    /// The constraint for the vertical space above the detail label.
    var detailLabelTopConstraint: NSLayoutConstraint?
    
    /// The constraint for the horizontal space to the left of the detail label.
    var detailLabelLeftConstraint: NSLayoutConstraint?
    
    /// The constraint for the horizontal space to the right of the detail label.
    var detailLabelRightConstraint: NSLayoutConstraint?
    
    // MARK: - Other setup methods
    
    /**
     The function that needs to be called to set up the subviews, such as
     the placeholder and detail labels and their constraints.
     */
    fileprivate func setupSubviews() {
        borderStyle = .none
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        
        detailLabel.font = UIFont.systemFont(ofSize: 14.0)
        detailLabel.clipsToBounds = true
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(detailLabel)
        
        setupConstraints()
        
    }
    
    /**
     The function that needs to be called to create and activate the
     constraints for the subviews, such as the placeholder and detail labels.
     */
    fileprivate func setupConstraints() {
        placeholderLabelTopConstraint = NSLayoutConstraint(item: placeholderLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: placeholderInsetY)
        placeholderLabelBottomConstraint = NSLayoutConstraint(item: placeholderLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: placeholderInsetY)
        placeholderLabelLeftConstraint = NSLayoutConstraint(item: placeholderLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: placeholderInsetX)
        placeholderLabelRightConstraint = NSLayoutConstraint(item: placeholderLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -(placeholderInsetX + (rightView?.layer.frame.size.width ?? 0)))
        NSLayoutConstraint.activate([placeholderLabelTopConstraint!, placeholderLabelBottomConstraint!, placeholderLabelLeftConstraint!, placeholderLabelRightConstraint!])
        
        detailLabelTopConstraint = NSLayoutConstraint(item: detailLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        detailLabelLeftConstraint = NSLayoutConstraint(item: detailLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: detailInsetX)
        detailLabelRightConstraint = NSLayoutConstraint(item: detailLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -detailInsetX)
        detailLabelHeightConstraint = NSLayoutConstraint(item: detailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 22.0)
        NSLayoutConstraint.activate([detailLabelTopConstraint!, detailLabelLeftConstraint!, detailLabelRightConstraint!, detailLabelHeightConstraint!])
    }
    
    /**
     Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
     Overridden to set up the appearance of the view based on its properties, and add event handlers.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/objectivec/nsobject/1402907-awakefromnib)
     */
    override open func awakeFromNib() {
        super.awakeFromNib()
        borderStyle = .none
        placeholderLabel.font = UIFont.systemFont(ofSize: self.font?.pointSize ?? 18.0, weight: UIFont.Weight.light)
        detailLabel.font = UIFont.systemFont(ofSize: 12.0)
        
        addTargetHandlers()
    }
    
    /**
     Lays out subviews.
     Overridden to change the appearance of the view based on its properties.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uiview/1622482-layoutsubviews)
     */
    override open func layoutSubviews() {
        super.layoutSubviews()
        let detailLabelPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 4.0, height: 4.0))
        let detailLabelMask = CAShapeLayer()
        detailLabelMask.path = detailLabelPath.cgPath
        detailLabel.layer.mask = detailLabelMask
        setTextAlignment(detailTextAlignment, for: detailLabel)
        
        if !insideTailoredTextInputLayout {
            if errorTextNotNilOrEmpty {
                detailLabelLeftConstraint?.constant = errorInsetX
                detailLabelRightConstraint?.constant = -errorInsetX
                
                detailLabel.clipsToBounds = true
                let detailLabelPath = UIBezierPath(roundedRect: detailLabel.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: errorBackgroundBottomCornerRadius, height: errorBackgroundBottomCornerRadius))
                let detailLabelMask = CAShapeLayer()
                detailLabelMask.path = detailLabelPath.cgPath
                detailLabel.layer.mask = detailLabelMask
            } else {
                detailLabelLeftConstraint?.constant = detailInsetX
                detailLabelRightConstraint?.constant = -detailInsetX
                
                detailLabel.clipsToBounds = false
                let detailLabelPath = UIBezierPath(roundedRect: detailLabel.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 0.0, height: 0.0))
                let detailLabelMask = CAShapeLayer()
                detailLabelMask.path = detailLabelPath.cgPath
                detailLabel.layer.mask = detailLabelMask
            }
            
            if borderEnabled {
                if displayBorderOnError && errorTextNotNilOrEmpty && errorBorderColor?.cgColor != nil {
                    self.layer.borderColor = errorBorderColor!.cgColor
                    self.layer.borderWidth = 1
                } else {
                    self.layer.borderColor = normalBorderColor?.cgColor
                    self.layer.borderWidth = 1
                }
            } else {
                self.layer.borderColor = errorBorderColor?.cgColor ?? UIColor.clear.cgColor
                self.layer.borderWidth = displayBorderOnError && errorTextNotNilOrEmpty ? 1 : 0
            }
            
            if bottomLineEnabled {
                if errorTextNotNilOrEmpty {
                    bottomLineColor = bottomLineErrorColor
                    bottomLineThickness = 2
                } else {
                    bottomLineColor = isEditing ? bottomLineActiveColor : bottomLineNormalColor
                    bottomLineThickness = isEditing ? 2 : 1
                }
            }
            
            if errorTextNotNilOrEmpty {
                detailLabel.backgroundColor = errorBackgroundColor ?? .clear
                detailLabel.textColor = errorTextColor ?? .red
                setTextAlignment(errorTextAlignment, for: detailLabel)
                if floatingLabelErrorTextColor != nil && floatingLabelEnabled {
                    placeholderLabel.textColor = isPlaceholderInEditingMode ? floatingLabelErrorTextColor : placeholderTextColor
                }
            } else {
                detailLabel.backgroundColor = .clear
                detailLabel.textColor = detailTextColor
                setTextAlignment(detailTextAlignment, for: detailLabel)
                if floatingLabelEnabled {
                    placeholderLabel.textColor = isPlaceholderInEditingMode ? floatingLabelTextColor : placeholderTextColor
                }
            }
        }
        tailoredTextFieldDelegate?.textFieldDidLayoutSubviews()
    }
    
    // MARK: - Handle changes
    
    /**
     Notifies this object that it has been asked to relinquish its status as first responder in its window.
     Overridden to call the `setNeedsLayout` and `layoutIfNeeded` methods, so a weird animation won't play
     when a user ViewController change the ScrollView content insets when the keyboard appears or disappears.
     This method always returns the result of the method call to super.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uiresponder/1621097-resignfirstresponder)
     */
    override open func resignFirstResponder() -> Bool {
        let result = super.resignFirstResponder()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        return result
    }
    
    /**
     The function that needs to be called to add the following `UIControlEvents`:
     * `editingDidBegin`
     * `editingChanged`
     * `editingDidEnd`
     
     They are need to be handled to change placeholder and error label display.
     */
    fileprivate func addTargetHandlers() {
        addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
    }
    
    /**
     The function that is called when the `editingDidBegin` `UIControlEvents` happen.
     It is used to change the display of the placeholder label (display as a floating
     label or hide) when the cursor is in the TextField.
     
     - Note:
     This functionality can be turned on or off by setting the 
     `isPlaceholderOnlyChangedOnTextEntered` property's value.
     */
    @objc fileprivate func handleEditingDidBegin() {
        if !isPlaceholderOnlyChangedOnTextEntered && !isPlaceholderInEditingMode {
            isPlaceholderInEditingMode = true
        }
    }
    
    /**
     The function that is called when the `editingChanged` `UIControlEvents` happen.
     It is used to change the display of the placeholder label (display as a floating
     label or hide) and hide the error label when text is entered to the TextField.
     
     - Note:
     The placeholder label behaviour can be turned on or off by setting the
     `isPlaceholderOnlyChangedOnTextEntered` property's value.
     The error label hiding can be turned on or off by setting the
     `clearErrorOnInput` property's value.
     
     - parameter textField: The TextField which created the event. It should be
     always this TextField, the parameter is only required to enable adding
     this as the target handler for the `editingChanged` `UIControlEvents`.
     */
    @objc fileprivate func handleEditingChanged(textField: UITextField) {
        if isPlaceholderOnlyChangedOnTextEntered {
            onTextChanged(text: textField.text)
        }else if textNotNilOrEmpty && clearErrorOnInput {
            errorText = nil
        }
    }
    
    /**
     The function that is called when the `editingDidEnd` `UIControlEvents` happen.
     It is used to change the display of the placeholder label (turn back to simple placeholder
     from floating label or set to visible) when the cursor leaves the TextField.
     
     - Note:
     This functionality can be turned on or off by setting the
     `isPlaceholderOnlyChangedOnTextEntered` property's value.
     */
    @objc fileprivate func handleEditingDidEnd() {
        if !isPlaceholderOnlyChangedOnTextEntered && isPlaceholderInEditingMode && !textNotNilOrEmpty {
            isPlaceholderInEditingMode = false
        }
    }
    
    /**
     The function is called from the `handleEditingChanged` method, to handle the event
     of the text being changed (some text is entered or deleted) in the TextField.
     It is used to change the display of the placeholder label (display as a floating
     label or hide) and hide the error label when text is entered to the TextField.
     
     The method also calls the similarly named method of the `TailoredTextFieldDelegate`.
     
     - Note:
     The placeholder label behaviour can be turned on or off by setting the
     `isPlaceholderOnlyChangedOnTextEntered` property's value.
     The error label hiding can be turned on or off by setting the
     `TailoredTextFieldDelegate` to also enable handling this event by that.
     
     - parameter text: The text after the change.
     */
    public func onTextChanged(text: String?) {
        if isPlaceholderInEditingMode != textNotNilOrEmpty {
            isPlaceholderInEditingMode = textNotNilOrEmpty
        }
        
        if textNotNilOrEmpty && clearErrorOnInput {
            errorText = nil
        }
        
        tailoredTextFieldDelegate?.onTextChanged(text: text)
    }
    
    /**
     The function that handles changes in the placeholder label's editing mode.
     It is called from the `isPlaceholderInEditingMode` property's property observer (`didSet`).
     This method initiates the floating label animation or hiding/displaying the placeholder label,
     depending on the value of the `floatingLabelEnabled` property.
     
     - Note:
     To correctly translate the placeholder label to the floating label position (along the leading axis),
     the auto layout constraints need to be disabled by setting the `translatesAutoresizingMaskIntoConstraints`
     to `true` for the placeholder label. This breaks the constraints of it.
     */
    fileprivate func onPlaceholderEditingModeChanged() {
        if floatingLabelEnabled {
            if isPlaceholderInEditingMode {
                if floatingLabelErrorTextColor != nil && errorTextNotNilOrEmpty {
                    placeholderLabel.textColor = floatingLabelErrorTextColor ?? placeholderTextColor
                } else {
                    placeholderLabel.textColor = floatingLabelTextColor ?? placeholderTextColor
                }
                placeholderLabel.translatesAutoresizingMaskIntoConstraints = true
                setAnchorPoint(CGPoint(x: 0.0, y: 0.5), for: placeholderLabel)
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    [weak self]
                    in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75).translatedBy(x: 0, y: strongSelf.placeholderInsetY - strongSelf.floatingLabelTranslateY)
                    strongSelf.layoutIfNeeded()
                    }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.15, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                    [weak self]
                    in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.placeholderLabel.transform = .identity
                    strongSelf.layoutIfNeeded()
                }) {
                    [weak self]
                    finished in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.placeholderLabel.textColor = strongSelf.placeholderTextColor
                }
            }
        } else {
            placeholderLabel.isHidden = isPlaceholderInEditingMode
        }
    }
    
    // MARK: - Helper methods
    
    /**
     The function is called from the `onPlaceholderEditingModeChanged` function to
     set the anchor point of the placeholder label and transalte it to the floating label
     position along the leading axis. Without calling this helper funcion, the
     placeholder label would be translated along the center axis which is not the
     correct behaviour.
     
     - Note:
     For setting the anchor point and correctly display the animation translateing the placeholder label 
     to the floating label position along the leading axis, the auto layout constraints need to be disabled 
     by setting the `translatesAutoresizingMaskIntoConstraints` to `true` for the placeholder label. 
     This breaks the constraints of it.
     
     - Parameters:
         - anchorPoint: The anchor point to be set.
         - view: The view which the anchor point needs to be set.
     */
    fileprivate func setAnchorPoint(_ anchorPoint: CGPoint, for view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(view.transform)
        oldPoint = oldPoint.applying(view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
    
    /**
     The function that is called to set the text alingment for a label based on one
     of the `TailoredTextAlignment` `enum` cases.
     
     - Parameters:
         - textAlignment: The text alingment to be set.
         - label: The label which the text alignment needs to be set.
     */
    fileprivate func setTextAlignment(_ textAlignment: TailoredTextAlignment, for label: UILabel) {
        switch textAlignment {
        case .left:
            label.textAlignment = .left
        case .center:
            label.textAlignment = .center
        case .right:
            label.textAlignment = .right
        }
    }
    
}
