//
// TailoredTextInputLayout.swift
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
 A container layout, inherited from `UIView`, containing a `TailoredTextField`
 which highly customizable text input field, inherited from `UITextField`.
 
 Although it is less convinient to set up than the `TailoredTextField` itself,
 this view provide more customization options, for example the drop shadow
 can be applied to only the TextField, rather than only for all of the components
 like the floating label, error and detail labels.
 */
@IBDesignable open class TailoredTextInputLayout: UIView {
    
    /**
     Whether the placeholder is in editing mode,
     meaning that it is displayed as a floating label, or simply hidden.
     
     The behaviour of this property depends on the value of
     the `isPlaceholderOnlyChangedOnTextEntered` property:
     * When that is `true`, this will become `true` when text is entered.
     * When that is `false`, this will become `true` as soon as the cursor is
     in this TextField (it becomes the first responder)
     */
    fileprivate var isPlaceholderInEditingMode: Bool = false {
        didSet {
            onPlaceholderEditingModeChanged()
        }
    }
    
    // MARK: - Detect text existence
    
    /// Returns whether the text is nil or empty
    var textNotNilOrEmpty: Bool {
        return textField.text != nil && !textField.text!.isEmpty
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
     The text contained in the TextField.
     
     - Note:
     This is only a property for conviniently accessing the text
     of the contained `TextField`, but it can be also done by
     setting the `text` property of the `TextField`, accessible
     via the `textField` property.
     */
    open var text: String? {
        get {
            return textField.text
        } set {
            textField.text = newValue
        }
    }
    
    /// The inset before and after the text.
    @IBInspectable
    open var textInsetX: CGFloat = 0 {
        didSet {
            self.textField?.textInsetX = textInsetX
        }
    }
    
    /// The inset above and below the text.
    @IBInspectable
    open var textInsetY: CGFloat = 0 {
        didSet {
            self.textField?.textInsetY = textInsetY
        }
    }
    
    /**
     The height of the contained `TailoredTextField`.
     
     - Note:
     This property sets the consant value of the constraint that
     sets the height of the `TailoredTextField`.
     */
    @IBInspectable
    open var textFieldHeight: CGFloat {
        get {
            return textFieldContainerHeightConstraint.constant
        }
        set {
            textFieldContainerHeightConstraint.constant = newValue
            layoutSubviews()
        }
    }
    
    // MARK: - Background customization
    
    /// The background color of the conatined `TailoredTextField`.
    @IBInspectable
    open var backroundFillColor: UIColor? {
        didSet {
            self.textField?.backgroundColor = backroundFillColor
        }
    }
    
    /// The corner radius of the conatined `TailoredTextField`'s background.
    @IBInspectable
    open var textFieldCornerRadius: CGFloat = 0.0 {
        didSet {
            self.textField?.backgroundCornerRadius = textFieldCornerRadius
        }
    }
    
    // MARK: - Border customization
    
    /// Whether the border is displayed or not for the conatined `TailoredTextField`.
    @IBInspectable
    open var borderEnabled: Bool {
        get {
            return textField.borderEnabled
        }
        set {
            textField.borderEnabled = newValue
        }
    }
    
    /**
     The color of the border for the normal state (when there is no error).
     
     - Note:
     It is only taken into account if the `borderEnabled` is set to `true`.
     */
    @IBInspectable
    open var normalBorderColor: UIColor? {
        didSet {
            self.textField?.normalBorderColor = normalBorderColor
        }
    }
    
    // MARK: - Drop shadow customization
    
    /**
     The color of the drop shadow. If it is set, the drop shadow will be displayed.
     The opacity of the drop shadow can be set with the `dropShadowOpacity` property.
     
     - Note: Contrary to the `TailoredTextField`, the drop shadow is only displayed
     below the TextField itself, and not the other components (like the floating labe
     or the detail label).
     */
    @IBInspectable
    open var dropShadowColor: UIColor? {
        get {
            if let shadowColor = textField.dropShadowColor {
                return shadowColor
            }
            return nil
        }
        set {
            if let shadowColor = newValue {
                textFieldContainer.backgroundColor = .clear
                textFieldContainer.layer.shadowColor = shadowColor.cgColor
                textFieldContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                textFieldContainer.layer.shadowRadius = 2.0
                textFieldContainer.clipsToBounds = false
            } else {
                textFieldContainer.clipsToBounds = true
            }
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
            return textFieldContainer.layer.shadowOpacity
        }
        set {
            textFieldContainer.layer.shadowOpacity = newValue
        }
    }
    
    // MARK: - Bottom line customization
    
    /// Whether the bottom line is displayed for the TextField.
    @IBInspectable
    open var bottomLineEnabled: Bool {
        get {
            return textField.bottomLineEnabled
        }
        set {
            textField.bottomLineEnabled = newValue
        }
    }
    
    /**
     The color of the bottom line when it is in the normal state (not active or error).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineNormalColor: UIColor? {
        get {
            return textField.bottomLineNormalColor
        }
        set {
            textField.bottomLineNormalColor = newValue
        }
    }
    
    /**
     The color of the bottom line when it is in the active state (when the TextField is the first responder).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineActiveColor: UIColor? {
        get {
            return textField.bottomLineActiveColor
        }
        set {
            textField.bottomLineActiveColor = newValue
        }
    }
    
    /**
     The color of the bottom line when it is in the error state (when the `errorText` is set).
     
     - Note:
     It is only taken into account if the `bottomLineEnabled` is set to `true`.
     */
    @IBInspectable
    open var bottomLineErrorColor: UIColor? {
        get {
            return textField.bottomLineErrorColor
        }
        set {
            textField.bottomLineErrorColor = newValue
        }
    }
    
    // MARK: - Floating label customization
    
    /// Whether the placeholder text is displayed as a floating label when the TextField is active.
    @IBInspectable
    open var floatingLabelEnabled: Bool = true {
        didSet {
            layoutSubviews()
        }
    }
    
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
            self.textField?.placeholderInsetX = placeholderInsetX
            placeholderLabelLeftConstraint.constant = placeholderInsetX
            placeholderLabelRightConstraint.constant = placeholderInsetX
        }
    }
    
    /// The inset above and below the placeholder label.
    @IBInspectable
    open var placeholderInsetY: CGFloat = 0 {
        didSet {
            self.textField?.placeholderInsetY = placeholderInsetY
        }
    }
    
    /// The text to be displayed as placeholder and also
    /// as a floating label if that functionality is enabled.
    @IBInspectable
    open var placeholderText: String? {
        didSet {
            if placeholderText != nil && !placeholderText!.isEmpty {
                placeholderLabel?.text = placeholderText
                placeholderLabel?.isHidden = false
            } else {
                placeholderLabel?.isHidden = true
            }
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
            detailLabelLeftConstraint.constant = detailInsetX
        }
    }
    
    /// The text displayed in the detail label.
    @IBInspectable
    open var detailText: String? {
        didSet {
            if detailTextNotNilOrEmpty {
                detailLabel?.text = detailText
                detailLabel?.isHidden = false
            } else {
                detailLabel?.isHidden = true
            }
        }
    }
    
    /// The text color of the detail text.
    @IBInspectable
    open var detailTextColor: UIColor? {
        get {
            return detailLabel.textColor
        }
        set {
            detailLabel.textColor = newValue
        }
    }
    
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
    open var errorInsetX: CGFloat = 0 {
        didSet {
            errorLabelLeftConstraint.constant = errorInsetX
            errorLabelRightConstraint.constant = errorInsetX
        }
    }
    
    /**
     The text to be displayed as an error.
     
     - Note:
     If this is set anything different than `nil`, the error will be shown.
     */
    @IBInspectable
    open var errorText: String? {
        didSet {
            if errorTextNotNilOrEmpty {
                errorLabel?.text = errorText
                detailLabel?.isHidden = true
                errorLabel?.isHidden = false
                if floatingLabelErrorTextColor != nil && floatingLabelEnabled {
                    placeholderLabel.textColor = isPlaceholderInEditingMode ? floatingLabelErrorTextColor : placeholderTextColor
                }
            } else {
                detailLabel?.isHidden = !detailTextNotNilOrEmpty
                errorLabel?.isHidden = true
                if floatingLabelEnabled {
                    placeholderLabel.textColor = isPlaceholderInEditingMode ? floatingLabelTextColor : placeholderTextColor
                }
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
    open var errorTextColor: UIColor? {
        get {
            return errorLabel.textColor
        }
        set {
            errorLabel.textColor = newValue
        }
    }
    
    /// The background color of the error text.
    @IBInspectable
    open var errorBackgroundColor: UIColor? {
        get {
            return errorLabel.backgroundColor
        }
        set {
            errorLabel.backgroundColor = newValue
        }
    }
    
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
    
    // MARK: - Constraints and other IBOutlets
    
    /// The constraint for the vertical space above the placeholder label.
    @IBOutlet weak var placeholderLabelTopConstraint: NSLayoutConstraint!
    
    /// The constraint for the vertical space below the placeholder label.
    @IBOutlet weak var placeholderLabelBottomConstraint: NSLayoutConstraint!
    
    /// The constraint for the horizontal space to the left of the placeholder label.
    @IBOutlet weak var placeholderLabelLeftConstraint: NSLayoutConstraint!
    
    /// The constraint for the horizontal space to the right of the placeholder label.
    @IBOutlet weak var placeholderLabelRightConstraint: NSLayoutConstraint!
    
    /// The label that displays the placeholder and is also transformed
    /// to be a floating label if that functionality is enabled.
    @IBOutlet weak var placeholderLabel: UILabel!
    
    /// The `UIView` containing the `TailoredTextField`.
    @IBOutlet weak var textFieldContainer: UIView!
    
    /// The constraint for the height of the `UIView` containing the `TailoredTextField`.
    @IBOutlet weak var textFieldContainerHeightConstraint: NSLayoutConstraint!
    
    /// The contained `TailoredTextField`.
    @IBOutlet public weak var textField: TailoredTextField!
    
    /// The constraint for the vertical space above the contained `TailoredTextField`.
    @IBOutlet weak var textFieldTopConstraint: NSLayoutConstraint!
    
    /// The constraint for the horizontal space to the left of the detail label.
    @IBOutlet weak var detailLabelLeftConstraint: NSLayoutConstraint!
    
    /// The `UILabel` used to display the detail text.
    @IBOutlet weak var detailLabel: UILabel!
    
    /// The constraint for the horizontal space to the left of the error label.
    @IBOutlet weak var errorLabelLeftConstraint: NSLayoutConstraint!
    
    /// The constraint for the horizontal space to the right of the error label.
    @IBOutlet weak var errorLabelRightConstraint: NSLayoutConstraint!
    
    /// The `UILabel` used to display the error text.
    @IBOutlet weak var errorLabel: UILabel!
    
    // Reference for self as a UIView.
    var view: UIView!
    
    // MARK: - Initializers
    
    /**
     Initializes and returns a newly allocated view object with the specified frame rectangle.
     Overridden to call the `setupSubviews` method.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uiview/1622488-init)
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        addTargetHandlers()
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
        xibSetup()
        addTargetHandlers()
        setupSubviews()
    }
    
    // MARK: - Other setup methods
    
    /**
     The function that needs to be called to set up some properties and
     the subviews.
     */
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        addSubview(view)
    }
    
    /**
     This function can be used to load this view as a `UIView` from `UINib`.
     
     - returns: This view, loaded from a `UINib`.
     */
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: self.classForCoder)
        let nib = UINib(nibName: "TailoredTextInputLayout", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    /**
     The function that needs to be called to set up the subviews, such as
     the placeholder and detail labels and their constraints.
     */
    fileprivate func setupSubviews() {
        placeholderLabel?.isHidden = true
        detailLabel?.isHidden = true
        errorLabel?.isHidden = true
        errorLabel.backgroundColor = .clear
        textField.insideTailoredTextInputLayout = true
        textField.tailoredTextFieldDelegate = self
    }
    
    /**
     Lays out subviews.
     Overridden to change the appearance of the view based on its properties.
     
     - SeeAlso:
     [Apple Documentation](https://developer.apple.com/documentation/uikit/uiview/1622482-layoutsubviews)
     */
    override open func layoutSubviews() {
        setTextAlignment(detailTextAlignment, for: detailLabel)
        
        errorLabel.clipsToBounds = true
        let errorLabelPath = UIBezierPath(roundedRect: errorLabel.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: errorBackgroundBottomCornerRadius, height: errorBackgroundBottomCornerRadius))
        let errorLabelMask = CAShapeLayer()
        errorLabelMask.path = errorLabelPath.cgPath
        errorLabel.layer.mask = errorLabelMask
        setTextAlignment(errorTextAlignment, for: errorLabel)
        
        textField.clipsToBounds = false
        let textFieldPath = UIBezierPath(roundedRect: textField.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: textFieldCornerRadius, height: textFieldCornerRadius))
        let textFieldMask = CAShapeLayer()
        textFieldMask.path = textFieldPath.cgPath
        textField.layer.mask = textFieldMask
        
        if borderEnabled {
            if displayBorderOnError && errorTextNotNilOrEmpty && errorBorderColor?.cgColor != nil {
                textField.layer.borderColor = errorBorderColor!.cgColor
                textField.layer.borderWidth = 1
            } else {
                textField.layer.borderColor = normalBorderColor?.cgColor
                textField.layer.borderWidth = 1
            }
        } else {
            textField.layer.borderColor = errorBorderColor?.cgColor ?? UIColor.clear.cgColor
            textField.layer.borderWidth = displayBorderOnError && errorTextNotNilOrEmpty ? 1 : 0
        }
        
        if bottomLineEnabled {
            if errorTextNotNilOrEmpty {
                textField.bottomLineColor = bottomLineErrorColor
                textField.bottomLineThickness = 2
            } else {
                textField.bottomLineColor = textField.isEditing ? bottomLineActiveColor : bottomLineNormalColor
                textField.bottomLineThickness = textField.isEditing ? 2 : 1
            }
        }
        
        textFieldTopConstraint.constant = floatingLabelEnabled ? 29.0 : 0.0
    }
    
    // MARK: - Handle changes
    
    /**
     The function that needs to be called to add the following `UIControlEvents`:
     * `editingDidBegin`
     * `editingChanged`
     * `editingDidEnd`
     
     They are need to be handled to change placeholder and error label display.
     */
    fileprivate func addTargetHandlers() {
        textField.addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
        textField.addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
        textField.addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
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
        } else if textNotNilOrEmpty && clearErrorOnInput {
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
                UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    [weak self]
                    in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75).translatedBy(x: 0, y: strongSelf.placeholderInsetY - strongSelf.floatingLabelTranslateY)
                    strongSelf.view.layoutIfNeeded()
                    }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.15, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    [weak self]
                    in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.placeholderLabel.transform = .identity
                    strongSelf.view.layoutIfNeeded()
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
        layoutSubviews()
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

extension TailoredTextInputLayout: TailoredTextFieldDelegate {
    
    // MARK: - TailoredTextFieldDelegate implementation
    
    /**
     Implemented to change the display of the placeholder label (display as a floating
     label or hide) and hide the error label when text is entered to the TextField.
     
     - parameter text: The text after the change.
     */
    public func onTextChanged(text: String?) {
        if isPlaceholderInEditingMode != textNotNilOrEmpty {
            isPlaceholderInEditingMode = textNotNilOrEmpty
        }
        
        if textNotNilOrEmpty && clearErrorOnInput {
            errorText = nil
        }
    }
    
    /**
     Called when the TailoredTextFieldDelegate finished its `layoutSubviews` method.
     Implemented to change the appearance of the bottom line based on the state
     of the `TailoredTextField`, like when error needs to be displayed.
     */
    public func textFieldDidLayoutSubviews() {
        if bottomLineEnabled {
            if errorTextNotNilOrEmpty {
                textField.bottomLineColor = bottomLineErrorColor
                textField.bottomLineThickness = 2
            } else {
                textField.bottomLineColor = textField.isEditing ? bottomLineActiveColor : bottomLineNormalColor
                textField.bottomLineThickness = textField.isEditing ? 2 : 1
            }
        }
    }
    
}
