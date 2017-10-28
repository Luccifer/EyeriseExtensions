//
//  UIView+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    ///Make sure you use  "[weak self] (gesture) in" if you are using the keyword self inside the closure or there might be a memory leak
    open class BlockTap: UITapGestureRecognizer {
        private var tapAction: ((UITapGestureRecognizer) -> Void)?
        
        public override init(target: Any?, action: Selector?) {
            super.init(target: target, action: action)
        }
        
        public convenience init (
            tapCount: Int = 1,
            fingerCount: Int = 1,
            action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            
            #if os(iOS)
                
                self.numberOfTouchesRequired = fingerCount
                
            #endif
            
            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
        }
        
        @objc open func didTap (_ tap: UITapGestureRecognizer) {
            tapAction? (tap)
        }
    }
    
#endif

public extension UIView {
    
    func hideBlurEffectWithAnimation() {
        for subview in self.subviews {
            if (subview.tag == 100) {
                UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
                    subview.alpha = 0
                }, completion: { _ in
                    subview.isHidden = true
                })
            }
        }
    }
    
    func addBlurEffect() {
        for subview in self.subviews {
            if (subview.tag == 100) {
                subview.isHidden = false
                subview.alpha = 1
            } else {
                let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.tag = 100
                blurEffectView.frame = self.bounds
                blurEffectView.layer.cornerRadius = self.layer.cornerRadius
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
                self.addSubview(blurEffectView)
            }
        }
    }
    
    class var nibName: String {
        let name = "\(self)".components(separatedBy: ".").first ?? ""
        return name
    }
    
    class var nib: UINib? {
        if let _ = Bundle.main.path(forResource: nibName, ofType: "nib") {
            return UINib(nibName: nibName, bundle: nil)
        } else {
            return nil
        }
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T? {
        
        var view: T?
        let name: String
        if let nibName = nibNameOrNil {
            name = nibName
        } else {
            // Most nibs are demangled by practice, if not, just declare string explicitly
            name = nibName
        }
        
        guard let nibViews = Bundle.main.loadNibNamed(name, owner: nil, options: nil) else {
            return nil
        }
        
        for v in nibViews {
            if let tog = v as? T {
                view = tog
            }
        }
        
        return view
    }
    
    class func fromNib<T : UIView>(nibNameOrNil: String? = nil, type: T.Type) -> T {
        let v: T? = fromNib(nibNameOrNil: nibNameOrNil, type: T.self)
        return v!
    }
    
    class func fromNib(_ nibNameOrNil: String? = nil) -> Self {
        return fromNib(nibNameOrNil: nibNameOrNil, type: self)
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> Void)?) {
        let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    public func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100
        
        self.layer.add(anim, forKey: nil)
    }
    
}

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    // MARK: Custom UIView Initilizers
    extension UIView {
        
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        }
        
        /// puts padding around the view
        public convenience init(superView: UIView, padding: CGFloat) {
            self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.w - padding*2, height: superView.h - padding*2))
        }
        
        /// Copies size of superview
        public convenience init(superView: UIView) {
            self.init(frame: CGRect(origin: CGPoint.zero, size: superView.vsize))
        }
    }
    
    // MARK: Frame Extensions
    extension UIView {
        
        /// add multiple subviews
        public func addSubviews(_ views: [UIView]) {
            views.forEach { [weak self] eachView in
                self?.addSubview(eachView)
            }
        }
        
        
        /// resizes this view so it fits the largest subview
        public func resizeToFitSubviews() {
            var width: CGFloat = 0
            var height: CGFloat = 0
            for someView in self.subviews {
                let aView = someView
                let newWidth = aView.x + aView.w
                let newHeight = aView.y + aView.h
                width = max(width, newWidth)
                height = max(height, newHeight)
            }
            frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        /// resizes this view so it fits the largest subview
        public func resizeToFitSubviews(_ tagsToIgnore: [Int]) {
            var width: CGFloat = 0
            var height: CGFloat = 0
            for someView in self.subviews {
                let aView = someView
                if !tagsToIgnore.contains(someView.tag) {
                    let newWidth = aView.x + aView.w
                    let newHeight = aView.y + aView.h
                    width = max(width, newWidth)
                    height = max(height, newHeight)
                }
            }
            frame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        
        public func resizeToFitWidth() {
            let currentHeight = self.h
            self.sizeToFit()
            self.h = currentHeight
        }
        
        
        public func resizeToFitHeight() {
            let currentWidth = self.w
            self.sizeToFit()
            self.w = currentWidth
        }
        
        
        public var x: CGFloat {
            get {
                return self.frame.origin.x
            } set(value) {
                self.frame = CGRect(x: value, y: self.y, width: self.w, height: self.h)
            }
        }
        
        
        public var y: CGFloat {
            get {
                return self.frame.origin.y
            } set(value) {
                self.frame = CGRect(x: self.x, y: value, width: self.w, height: self.h)
            }
        }
        
        
        public var w: CGFloat {
            get {
                return self.frame.size.width
            } set(value) {
                self.frame = CGRect(x: self.x, y: self.y, width: value, height: self.h)
            }
        }
        
        
        public var h: CGFloat {
            get {
                return self.frame.size.height
            } set(value) {
                self.frame = CGRect(x: self.x, y: self.y, width: self.w, height: value)
            }
        }
        
        
        public var left: CGFloat {
            get {
                return self.x
            } set(value) {
                self.x = value
            }
        }
        
        
        public var right: CGFloat {
            get {
                return self.x + self.w
            } set(value) {
                self.x = value - self.w
            }
        }
        
        
        public var top: CGFloat {
            get {
                return self.y
            } set(value) {
                self.y = value
            }
        }
        
        
        public var bottom: CGFloat {
            get {
                return self.y + self.h
            } set(value) {
                self.y = value - self.h
            }
        }
        
        
        public var origin: CGPoint {
            get {
                return self.frame.origin
            } set(value) {
                self.frame = CGRect(origin: value, size: self.frame.size)
            }
        }
        
        
        public var centerX: CGFloat {
            get {
                return self.center.x
            } set(value) {
                self.center.x = value
            }
        }
        
        
        public var centerY: CGFloat {
            get {
                return self.center.y
            } set(value) {
                self.center.y = value
            }
        }
        
        
        public var vsize: CGSize {
            get {
                return self.frame.size
            } set(value) {
                self.frame = CGRect(origin: self.frame.origin, size: value)
            }
        }
        
        
        public func leftOffset(_ offset: CGFloat) -> CGFloat {
            return self.left - offset
        }
        
        
        public func rightOffset(_ offset: CGFloat) -> CGFloat {
            return self.right + offset
        }
        
        
        public func topOffset(_ offset: CGFloat) -> CGFloat {
            return self.top - offset
        }
        
        
        public func bottomOffset(_ offset: CGFloat) -> CGFloat {
            return self.bottom + offset
        }
        
        
        public func alignRight(_ offset: CGFloat) -> CGFloat {
            return self.w - offset
        }
        
        public func reorderSubViews(_ reorder: Bool = false, tagsToIgnore: [Int] = []) -> CGFloat {
            var currentHeight: CGFloat = 0
            for someView in subviews {
                if !tagsToIgnore.contains(someView.tag) && !(someView ).isHidden {
                    if reorder {
                        let aView = someView
                        aView.frame = CGRect(x: aView.frame.origin.x, y: currentHeight, width: aView.frame.width, height: aView.frame.height)
                    }
                    currentHeight += someView.frame.height
                }
            }
            return currentHeight
        }
        
        public func removeSubviews() {
            for subview in subviews {
                subview.removeFromSuperview()
            }
        }
        
        /// Centers view in superview horizontally
        public func centerXInSuperView() {
            guard let parentView = superview else {
                assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
                return
            }
            
            self.x = parentView.w/2 - self.w/2
        }
        
        /// Centers view in superview vertically
        public func centerYInSuperView() {
            guard let parentView = superview else {
                assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
                return
            }
            
            self.y = parentView.h/2 - self.h/2
        }
        
        /// Centers view in superview horizontally & vertically
        public func centerInSuperView() {
            self.centerXInSuperView()
            self.centerYInSuperView()
        }
    }
    
    // MARK: Transform Extensions
    extension UIView {
        
        public func setRotationX(_ x: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
            self.layer.transform = transform
        }
        
        
        public func setRotationY(_ y: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
            self.layer.transform = transform
        }
        
        
        public func setRotationZ(_ z: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
            self.layer.transform = transform
        }
        
        
        public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DRotate(transform, x.degreesToRadians(), 1.0, 0.0, 0.0)
            transform = CATransform3DRotate(transform, y.degreesToRadians(), 0.0, 1.0, 0.0)
            transform = CATransform3DRotate(transform, z.degreesToRadians(), 0.0, 0.0, 1.0)
            self.layer.transform = transform
        }
        
        
        public func setScale(x: CGFloat, y: CGFloat) {
            var transform = CATransform3DIdentity
            transform.m34 = 1.0 / -1000.0
            transform = CATransform3DScale(transform, x, y, 1)
            self.layer.transform = transform
        }
    }
    
    // MARK: Layer Extensions
    public extension UIView {
        
        public func setCornerRadius(radius: CGFloat) {
            self.layer.cornerRadius = radius
            self.layer.masksToBounds = true
        }
        
        
        public func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
            self.layer.shadowOffset = offset
            self.layer.shadowRadius = radius
            self.layer.shadowOpacity = opacity
            self.layer.shadowColor = color.cgColor
            if let r = cornerRadius {
                self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
            }
        }
        
        
        public func addBorder(width: CGFloat, color: UIColor) {
            layer.borderWidth = width
            layer.borderColor = color.cgColor
            layer.masksToBounds = true
        }
        
        
        public func addBorderTop(size: CGFloat, color: UIColor) {
            addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
        }
        
        
        
        public func addBorderTopWithPadding(size: CGFloat, color: UIColor, padding: CGFloat) {
            addBorderUtility(x: padding, y: 0, width: frame.width - padding*2, height: size, color: color)
        }
        
        
        public func addBorderBottom(size: CGFloat, color: UIColor) {
            addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
        }
        
        
        public func addBorderLeft(size: CGFloat, color: UIColor) {
            addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
        }
        
        
        public func addBorderRight(size: CGFloat, color: UIColor) {
            addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
        }
        
        
        fileprivate func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
            let border = CALayer()
            border.backgroundColor = color.cgColor
            border.frame = CGRect(x: x, y: y, width: width, height: height)
            layer.addSublayer(border)
        }
        
        
        public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = fillColor.cgColor
            shapeLayer.strokeColor = strokeColor.cgColor
            shapeLayer.lineWidth = strokeWidth
            self.layer.addSublayer(shapeLayer)
        }
        
        
        public func drawStroke(width: CGFloat, color: UIColor) {
            let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.w, height: self.w), cornerRadius: self.w/2)
            let shapeLayer = CAShapeLayer ()
            shapeLayer.path = path.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = color.cgColor
            shapeLayer.lineWidth = width
            self.layer.addSublayer(shapeLayer)
        }
    }
    
    private let UIViewAnimationDuration: TimeInterval = 1
    private let UIViewAnimationSpringDamping: CGFloat = 0.5
    private let UIViewAnimationSpringVelocity: CGFloat = 0.5
    
    
    // MARK: Animation Extensions
    extension UIView {
        
        public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
            spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
        }
        
        
        public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
            UIView.animate(
                withDuration: UIViewAnimationDuration,
                delay: 0,
                usingSpringWithDamping: UIViewAnimationSpringDamping,
                initialSpringVelocity: UIViewAnimationSpringVelocity,
                options: UIViewAnimationOptions.allowAnimatedContent,
                animations: animations,
                completion: completion
            )
        }
        
        
        public func animate(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
            UIView.animate(withDuration: duration, animations: animations, completion: completion)
        }
        
        
        public func animate(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
            animate(duration: UIViewAnimationDuration, animations: animations, completion: completion)
        }
        
        
        public func pop() {
            setScale(x: 1.1, y: 1.1)
            spring(duration: 0.2, animations: { [unowned self] () -> Void in
                self.setScale(x: 1, y: 1)
            })
        }
        
        
        public func popBig() {
            setScale(x: 1.25, y: 1.25)
            spring(duration: 0.2, animations: { [unowned self] () -> Void in
                self.setScale(x: 1, y: 1)
            })
        }
        
    }
    
    
    // MARK: Render Extensions
    extension UIView {
        
        public func toImage () -> UIImage {
            UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
            drawHierarchy(in: bounds, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img!
        }
    }
    
    // MARK: Gesture Extensions
    extension UIView {
        
        public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
            let tap = UITapGestureRecognizer(target: target, action: action)
            tap.numberOfTapsRequired = tapNumber
            addGestureRecognizer(tap)
            isUserInteractionEnabled = true
        }
        
        public func addSwipeGesture(direction: UISwipeGestureRecognizerDirection, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
            let swipe = UISwipeGestureRecognizer(target: target, action: action)
            swipe.direction = direction
            
            #if os(iOS)
                
                swipe.numberOfTouchesRequired = numberOfTouches
                
            #endif
            
            addGestureRecognizer(swipe)
            isUserInteractionEnabled = true
        }
        
        public func addPanGesture(target: AnyObject, action: Selector) {
            let pan = UIPanGestureRecognizer(target: target, action: action)
            addGestureRecognizer(pan)
            isUserInteractionEnabled = true
        }
        
        #if os(iOS)
        
        
        public func addPinchGesture(target: AnyObject, action: Selector) {
            let pinch = UIPinchGestureRecognizer(target: target, action: action)
            addGestureRecognizer(pinch)
            isUserInteractionEnabled = true
        }
        
        #endif
        
        
        public func addLongPressGesture(target: AnyObject, action: Selector) {
            let longPress = UILongPressGestureRecognizer(target: target, action: action)
            addGestureRecognizer(longPress)
            isUserInteractionEnabled = true
        }
    }
    
    
    public extension UIView {
       
        
        /// Mask square/rectangle UIView with a circular/capsule cover, with a border of desired color and width around it
        public func roundView(withBorderColor color: UIColor? = nil, withBorderWidth width: CGFloat? = nil) {
            self.setCornerRadius(radius: min(self.frame.size.height, self.frame.size.width) / 2)
            self.layer.borderWidth = width ?? 0
            self.layer.borderColor = color?.cgColor ?? UIColor.clear.cgColor
        }
        
        /// Remove all masking around UIView
        public func nakedView() {
            self.layer.mask = nil
            self.layer.borderWidth = 0
        }
    }
    
    public extension UIView {
        /// Loops until it finds the top root view.
        func rootView() -> UIView {
            guard let parentView = superview else {
                return self
            }
            return parentView.rootView()
        }
    }
    
    // MARK: Fade Extensions
    public let UIViewDefaultFadeDuration: TimeInterval = 0.4
    
    extension UIView {
        /// Fade in with duration, delay and completion block.
        public func fadeIn(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
            fadeTo(1.0, duration: duration, delay: delay, completion: completion)
        }
        
        
        public func fadeOut(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
            fadeTo(0.0, duration: duration, delay: delay, completion: completion)
        }
        
        /// Fade to specific value with duration, delay and completion block.
        public func fadeTo(_ value: CGFloat, duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
            UIView.animate(withDuration: duration ?? UIViewDefaultFadeDuration, delay: delay ?? UIViewDefaultFadeDuration, options: .curveEaseInOut, animations: {
                self.alpha = value
            }, completion: completion)
        }
    }
    
#endif
