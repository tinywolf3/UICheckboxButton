//
//  UICheckboxButton.swift
//  Checkbox Button
//
//  Created by tinywolf on 2019-07-05.
//  Copyright © 2019 Baram InfoTech. All rights reserved.
//

import UIKit

@IBDesignable
open class UICheckboxButton: UIButton {
    
    open class RadioGroup {
        fileprivate var btnList = [UICheckboxButton]()
        fileprivate var selBtn: UICheckboxButton?
        var selectedButton: UICheckboxButton? {
            return selBtn
        }

        init(_ buttons: UICheckboxButton...) {
            addButtons(buttons)
        }

        func addButton(_ button: UICheckboxButton) {
            if let prevgrp = button.group {
                prevgrp.removeButton(button)
            }
            button.group = self
            btnList.append(button)
            if button.isSelected {
                self.select(button)
            }
        }
        
        func addButtons(_ buttons: [UICheckboxButton]) {
            for btn in buttons {
                addButton(btn)
            }
        }

        func addButtons(_ buttons: UICheckboxButton...) {
            addButtons(buttons)
        }

        func removeButton(_ button: UICheckboxButton) {
            if !btnList.contains(button) {
                return
            }
            button.group = nil
            btnList.remove(at: btnList.firstIndex(of: button)!)
        }

        func select(_ button: UICheckboxButton) {
            guard let grp = button.group else { return }
            if grp !== self { return }
            if !btnList.contains(button) {
                button.group = nil
                return
            }
            for btn in btnList {
                if btn.isSelected == (btn == button) { continue }
                btn.group = nil
                btn.isSelected = (btn == button)
                btn.group = self
            }
            selBtn = button
        }

        fileprivate func onSelection(_ button: UICheckboxButton) {
            guard let grp = button.group else { return }
            if grp !== self { return }
            if !btnList.contains(button) {
                button.group = nil
                return
            }
            for btn in btnList {
                if btn == button { continue }
                btn.group = nil
                btn.isSelected = (btn == button)
                btn.group = self
            }
            selBtn = button
        }
    }

    fileprivate var group: RadioGroup?
    public var radioGroup: RadioGroup? {
        return group
    }
    
    fileprivate var borderLayer  = CAShapeLayer()
    fileprivate var checkLayer   = CAShapeLayer()
    fileprivate var uncheckLayer = CAShapeLayer()
    fileprivate var pathWidth: [CGFloat] = [ 2, 0, 0 ]
    fileprivate var fillPath: [Bool] = [ false, false, false ]
    
    override open var isSelected: Bool {
        didSet {
            if let grp = group {
                if self.isSelected {
                    grp.onSelection(self)
                } else
                if grp.selBtn === self {
                    self.isSelected = true
                }
            }
            self.changeColor()
        }
    }

    static let defaultBorderColor:  UIColor = UIColor.black
    static let defaultCheckColor:   UIColor = UIColor(displayP3Red:0, green:0.5, blue:0, alpha:1)
    static let defaultUncheckColor: UIColor = UIColor(displayP3Red:0.5, green:0, blue:0, alpha:1)
    
    @IBInspectable var borderColor: UIColor = UICheckboxButton.defaultBorderColor {
        didSet {
            self.changeColor()
        }
    }
    @IBInspectable var isBorderColorSync: Bool = false {
        didSet {
            self.changeColor()
        }
    }
    
    @IBInspectable var checkColor: UIColor = UICheckboxButton.defaultCheckColor {
        didSet {
            self.changeColor()
        }
    }
    
    @IBInspectable var uncheckColor: UIColor = UICheckboxButton.defaultUncheckColor {
        didSet {
            self.changeColor()
        }
    }
    
    enum BorderStyle {
        case none		//
        case box		// ☐
		case fillBox	// ◼︎
		case circle		// ○
        case fillCircle	// ●
    }
    var borderStyle: BorderStyle = .box {
        didSet {
            self.changeStyle()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'borderStyle' instead.")
    @IBInspectable var borderStyleIB: Int = 1 {
        willSet {
            switch newValue {
            case 0:
                borderStyle = .none
                break
            case 1:
                borderStyle = .box
                break
			case 2:
				borderStyle = .fillBox
				break
			case 3:
				borderStyle = .circle
				break
            case 4:
                borderStyle = .fillCircle
                break
            default:
                borderStyle = .box
                break
            }
        }
    }
    
    enum CheckStyle {
        case none		//
		case box		// ☐
		case fillBox	// ◼︎
		case circle		// ○
		case fillCircle	// ●
        case mark		// ☒☑︎
		case heavyMark	// ☒☑︎
    }
    var checkStyle: CheckStyle = .fillBox {
        didSet {
            self.changeStyle()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'checkStyle' instead.")
    @IBInspectable var checkStyleIB: Int = 2 {
        willSet {
            switch newValue {
			case 0:
				checkStyle = .none
				break
			case 1:
				checkStyle = .box
				break
			case 2:
				checkStyle = .fillBox
				break
			case 3:
				checkStyle = .circle
				break
			case 4:
				checkStyle = .fillCircle
				break
            case 5:
                checkStyle = .mark
                break
			case 6:
				checkStyle = .heavyMark
				break
            default:
                break
            }
        }
    }
    var uncheckStyle: CheckStyle = .none {
        didSet {
            self.changeStyle()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'uncheckStyle' instead.")
    @IBInspectable var uncheckStyleIB: Int = 0 {
        willSet {
            switch newValue {
			case 0:
				uncheckStyle = .none
				break
			case 1:
				uncheckStyle = .box
				break
			case 2:
				uncheckStyle = .fillBox
				break
			case 3:
				uncheckStyle = .circle
				break
			case 4:
				uncheckStyle = .fillCircle
				break
			case 5:
				uncheckStyle = .mark
				break
			case 6:
				uncheckStyle = .heavyMark
				break
            default:
                break
            }
        }
    }
	
	@IBInspectable var strokeWidth: CGFloat = 2 {
		didSet {
			self.changeStyle()
		}
	}
    
    enum Align {
        case left
        case leftTop
        case top
        case rightTop
        case right
        case rightBottom
        case bottom
        case leftBottom
        case center
    }
    var checkAlign: Align = .left {
        didSet {
            self.changeStyle()
        }
    }
    @available(*, unavailable, message: "This property is reserved for Interface Builder. Use 'checkAlign' instead.")
    @IBInspectable var checkAlignIB: Int = 0 {
        willSet {
            switch newValue {
            case 0:
                checkAlign = .left
                break
            case 1:
                checkAlign = .leftTop
                break
            case 2:
                checkAlign = .top
                break
            case 3:
                checkAlign = .rightTop
                break
            case 4:
                checkAlign = .right
                break
            case 5:
                checkAlign = .rightBottom
                break
            case 6:
                checkAlign = .bottom
                break
            case 7:
                checkAlign = .leftBottom
                break
            case 8:
                checkAlign = .center
                break
            default:
                break
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var checkSize: CGFloat = 10.0 {
        didSet {
            self.changeStyle()
        }
    }
    
    fileprivate func checkRect() -> CGRect {
        return CGRect(x: 0, y: 0, width: checkSize, height: checkSize)
    }
    fileprivate func checkRect(insetBy: CGFloat) -> CGRect {
        return CGRect(x: insetBy, y: insetBy, width: checkSize - insetBy * 2, height: checkSize - insetBy * 2)
    }
    fileprivate func checkRect(insetBy: CGPoint) -> CGRect {
        return CGRect(x: insetBy.x, y: insetBy.y, width: checkSize - insetBy.x * 2, height: checkSize - insetBy.y * 2)
    }
    fileprivate func checkRect(growBy: CGFloat) -> CGRect {
        return CGRect(x: checkSize / 2 - growBy, y: checkSize / 2 - growBy, width: growBy * 2, height: growBy * 2)
    }
    fileprivate func checkRect(growBy: CGPoint) -> CGRect {
        return CGRect(x: checkSize / 2 - growBy.x, y: checkSize / 2 - growBy.y, width: growBy.x * 2, height: growBy.y * 2)
    }
    
    fileprivate func checkFrame() -> CGRect {
        var frame = CGRect(x: 0, y: 0, width: checkSize, height: checkSize)
        switch checkAlign {
        case .left:
            frame.origin.x = imageEdgeInsets.left
            frame.origin.y = imageEdgeInsets.top + (bounds.height - checkSize - imageEdgeInsets.top - imageEdgeInsets.bottom) / 2
            break
        case .leftTop:
            frame.origin.x = imageEdgeInsets.left
            frame.origin.y = imageEdgeInsets.top
            break
        case .top:
            frame.origin.x = imageEdgeInsets.left + (bounds.width - checkSize - imageEdgeInsets.left - imageEdgeInsets.right) / 2
            frame.origin.y = imageEdgeInsets.top
            break
        case .rightTop:
            frame.origin.x = bounds.width - checkSize - imageEdgeInsets.right
            frame.origin.y = imageEdgeInsets.top
            break
        case .right:
            frame.origin.x = bounds.width - checkSize - imageEdgeInsets.right
            frame.origin.y = imageEdgeInsets.top + (bounds.height - checkSize - imageEdgeInsets.top - imageEdgeInsets.bottom) / 2
            break
        case .rightBottom:
            frame.origin.x = bounds.width - checkSize - imageEdgeInsets.right
            frame.origin.y = bounds.height - checkSize - imageEdgeInsets.bottom
            break
        case .bottom:
            frame.origin.x = imageEdgeInsets.left + (bounds.width - checkSize - imageEdgeInsets.left - imageEdgeInsets.right) / 2
            frame.origin.y = bounds.height - checkSize - imageEdgeInsets.bottom
            break
        case .leftBottom:
            frame.origin.x = imageEdgeInsets.left
            frame.origin.y = bounds.height - checkSize - imageEdgeInsets.bottom
            break
        case .center:
            frame.origin.x = imageEdgeInsets.left + (bounds.width - checkSize - imageEdgeInsets.left - imageEdgeInsets.right) / 2
            frame.origin.y = imageEdgeInsets.top + (bounds.height - checkSize - imageEdgeInsets.top - imageEdgeInsets.bottom) / 2
            break
        }
        return frame
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    fileprivate func initialize() {
        layer.addSublayer(borderLayer)
        layer.addSublayer(checkLayer)
        layer.addSublayer(uncheckLayer)
        self.changeStyle()
        self.changeColor()
    }
    
    func changeColor() {
        if self.isSelected {
            if self.isBorderColorSync {
                borderLayer.strokeColor = checkColor.cgColor
            } else {
                borderLayer.strokeColor = borderColor.cgColor
            }
            if fillPath[0] {
                if self.isBorderColorSync {
                    borderLayer.fillColor = checkColor.cgColor
                } else {
                    borderLayer.fillColor = borderColor.cgColor
                }
            } else {
                borderLayer.fillColor = UIColor.clear.cgColor
            }
            
            checkLayer.strokeColor = checkColor.cgColor
            if fillPath[1] {
                checkLayer.fillColor = checkColor.cgColor
            } else {
                checkLayer.fillColor = UIColor.clear.cgColor
            }
            
            uncheckLayer.strokeColor = UIColor.clear.cgColor
            uncheckLayer.fillColor = UIColor.clear.cgColor
        }
        else {
            if self.isBorderColorSync {
                borderLayer.strokeColor = uncheckColor.cgColor
            } else {
                borderLayer.strokeColor = borderColor.cgColor
            }
            if fillPath[0] {
                if self.isBorderColorSync {
                    borderLayer.fillColor = checkColor.cgColor
                } else {
                    borderLayer.fillColor = borderColor.cgColor
                }
            } else {
                borderLayer.fillColor = UIColor.clear.cgColor
            }
            
            checkLayer.strokeColor = UIColor.clear.cgColor
            checkLayer.fillColor = UIColor.clear.cgColor
            
            uncheckLayer.strokeColor = uncheckColor.cgColor
            if fillPath[2] {
                uncheckLayer.fillColor = uncheckColor.cgColor
            } else {
                uncheckLayer.fillColor = UIColor.clear.cgColor
            }
        }
    }
    
    func changeStyle() {
        let cf = checkFrame()
        borderLayer.frame = cf
        borderLayer.path = borderPath().cgPath
        borderLayer.lineWidth = pathWidth[0]
        checkLayer.frame = cf
        checkLayer.path = checkPath().cgPath
        checkLayer.lineWidth = pathWidth[1]
        uncheckLayer.frame = cf
        uncheckLayer.path = uncheckPath().cgPath
        uncheckLayer.lineWidth = pathWidth[2]
    }
    
    fileprivate func borderPath() -> UIBezierPath {
        let path = UIBezierPath()
        switch borderStyle {
        case .none:
            break
        case .box:
            pathWidth[0] = strokeWidth
            fillPath[0] = false
            path.append(UIBezierPath(rect: checkRect()))
            break
		case .fillBox:
			pathWidth[0] = strokeWidth
			fillPath[0] = true
			path.append(UIBezierPath(rect: checkRect()))
			break
        case .circle:
            pathWidth[0] = strokeWidth
            fillPath[0] = false
            path.append(UIBezierPath(ovalIn: checkRect()))
            break
		case .fillCircle:
			pathWidth[0] = strokeWidth
			fillPath[0] = true
			path.append(UIBezierPath(ovalIn: checkRect()))
			break
		}
        return path
    }
    
    fileprivate func checkPath() -> UIBezierPath {
        let path = UIBezierPath()
        switch checkStyle {
        case .none:
            break
        case .box:
            pathWidth[1] = strokeWidth
            fillPath[1] = false
            path.append(UIBezierPath(rect: checkRect(insetBy: checkSize / 4)))
            break
		case .fillBox:
			pathWidth[1] = strokeWidth
			fillPath[1] = true
			path.append(UIBezierPath(rect: checkRect(insetBy: checkSize / 4)))
			break
        case .circle:
            pathWidth[1] = strokeWidth
            fillPath[1] = false
			path.append(UIBezierPath(ovalIn: checkRect(insetBy: checkSize / 4)))
            break
		case .fillCircle:
			pathWidth[1] = strokeWidth
			fillPath[1] = true
			path.append(UIBezierPath(ovalIn: checkRect(insetBy: checkSize / 4)))
			break
        case .mark:
            pathWidth[1] = strokeWidth
            fillPath[1] = false
            path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.5))
            path.addLine(to: CGPoint(x: checkSize * 0.5, y: checkSize * 0.8))
            path.addLine(to: CGPoint(x: checkSize * 0.9, y: checkSize * 0.1))
            break
		case .heavyMark:
			pathWidth[1] = strokeWidth * 2
			fillPath[1] = false
			path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.5))
			path.addLine(to: CGPoint(x: checkSize * 0.5, y: checkSize * 0.8))
			path.addLine(to: CGPoint(x: checkSize * 0.9, y: checkSize * 0.1))
			break
		}
        return path
    }
    
    fileprivate func uncheckPath() -> UIBezierPath {
        let path = UIBezierPath()
        switch uncheckStyle {
        case .none:
            break
        case .box:
            pathWidth[2] = strokeWidth
            fillPath[2] = false
            path.append(UIBezierPath(rect: checkRect(insetBy: checkSize / 4)))
            break
		case .fillBox:
			pathWidth[2] = strokeWidth
			fillPath[2] = true
			path.append(UIBezierPath(rect: checkRect(insetBy: checkSize / 4)))
			break
        case .circle:
            pathWidth[2] = strokeWidth
            fillPath[2] = false
            path.append(UIBezierPath(ovalIn: checkRect(insetBy: checkSize / 4)))
            break
		case .fillCircle:
			pathWidth[2] = strokeWidth
			fillPath[2] = true
			path.append(UIBezierPath(ovalIn: checkRect(insetBy: checkSize / 4)))
			break
        case .mark:
            pathWidth[2] = strokeWidth
            fillPath[2] = false
            path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.2))
            path.addLine(to: CGPoint(x: checkSize * 0.8, y: checkSize * 0.8))
            path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.8))
            path.addLine(to: CGPoint(x: checkSize * 0.8, y: checkSize * 0.2))
            break
		case .heavyMark:
			pathWidth[2] = strokeWidth * 2
			fillPath[2] = false
			path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.2))
			path.addLine(to: CGPoint(x: checkSize * 0.8, y: checkSize * 0.8))
			path.move(to: CGPoint(x: checkSize * 0.2, y: checkSize * 0.8))
			path.addLine(to: CGPoint(x: checkSize * 0.8, y: checkSize * 0.2))
			break
		}
        return path
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        changeStyle()
        changeColor()
    }
    
    override open func prepareForInterfaceBuilder() {
        initialize()
    }
}


extension CALayer {
	func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
		for edge in arr_edge {
			let border = CALayer()
			switch edge {
			case UIRectEdge.top:
				border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
				break
			case UIRectEdge.bottom:
				border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
				break
			case UIRectEdge.left:
				border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
				break
			case UIRectEdge.right:
				border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
				break
			default:
				break
			}
			border.backgroundColor = color.cgColor;
			self.addSublayer(border)
		}
	}
}
