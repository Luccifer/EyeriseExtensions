//
//  UIImageView+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

private var originalUrlKey: UInt8 = 0

public extension UIImageView {
    
    public class Loader: UIView {
        public enum Size {
            case small
            case large
        }
        
        init(frame: CGRect, size: Size = .large, image: UIImage? = nil, shouldHideWhenStopped: Bool = true) {
            self.size = size
            if let image = image {
                self.image = image
            } else {
                let imageName = self.size == .small ? "loader" : "refresh"
                self.image = UIImage(named: imageName)!
            }
            self.shouldHideWhenStopped = shouldHideWhenStopped
            self.imageView = UIImageView.init(image: self.image)
            self.imageView.contentMode = .center
            
            super.init(frame: frame)
            
            self.addSubview(self.imageView)
            if shouldHideWhenStopped {
                self.isHidden = true
            }
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override public func layoutSubviews() {
            super.layoutSubviews()
            self.frame = self.superview?.bounds ?? self.frame
            self.imageView.center = CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
        }
        
        func animate() {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Double.pi * 100
            rotationAnimation.duration = 100.0
            self.imageView.layer.add(rotationAnimation, forKey: "rotation")
            self.isHidden = false
        }
        
        func stopAnimation() {
            self.imageView.layer.removeAnimation(forKey: "rotation")
            if shouldHideWhenStopped {
                self.isHidden = true
            }
        }
        
        internal var size: Size
        internal var image: UIImage
        internal var imageView: UIImageView
        internal var shouldHideWhenStopped: Bool
        
    }
    
    func bindPlaceholderWhile(feed downloading: () -> Void) {
        let loader = Loader.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), size: .small)
        runThisInMainThread {
            self.addSubview(loader)
            loader.animate()
        }
        downloading()
        runThisInMainThread {
            loader.stopAnimation()
            loader.removeFromSuperview()
        }
    }
    
    func bindPlaceholderWhile(other downloading: () -> Void) {
        let loader = Loader.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), size: .small)
        runThisInMainThread {
            self.addSubview(loader)
            loader.animate()
        }
        downloading()
        runThisInMainThread {
            loader.stopAnimation()
            loader.removeFromSuperview()
        }
    }
    
    func bindRefresh() -> Loader {
        let loader = Loader.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.addSubview(loader)
        loader.animate()
        return loader
    }
    
    func bindPlaceholderWithBlured(_ imageToBlur: URL?, downloading: @escaping (_ done: @escaping () -> ()) -> ()) {
        runThisInMainThread {
            if let imageURL = imageToBlur {
                runThisInBackground { [weak self] in
                    do {
                        let data = try Data(contentsOf: imageURL)
                        let smallImage = UIImage(data: data)
                        runThisInMainThread { [weak self] in
                            self?.image = smallImage
                            downloading {
                                //completion handler
                            }
                        }
                    }catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func imageFrame() -> CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else {return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
    
    var originalUrl: URL {
        get {
            return associatedObject(base: self, key: &originalUrlKey) { return URL(string: "http://google.com")! } // some url
        }
        set { associateObject(base: self, key: &originalUrlKey, value: newValue) }
    }
}

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UIImageView {
        
        /// Convenince init that takes coordinates of bottom left corner, height width and image name.
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, imageName: String) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            image = UIImage(named: imageName)
        }
        
        /// Convenience init that takes coordinates of bottom left corner, image name and scales image frame to width.
        public convenience init(x: CGFloat, y: CGFloat, imageName: String, scaleToWidth: CGFloat) {
            self.init(frame: CGRect(x: x, y: y, width: 0, height: 0))
            image = UIImage(named: imageName)
            if image != nil {
                scaleImageFrameToWidth(width: scaleToWidth)
            } else {
                assertionFailure("EZSwiftExtensions Error: The imageName: '\(imageName)' is invalid!!!")
            }
        }
        
        /// Convenience init that takes coordinates of bottom left corner, width height and an UIImage Object.
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, image: UIImage) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            self.image = image
        }
        
        /// Convenience init that coordinates of bottom left corner, an UIImage object and scales image from to width.
        public convenience init(x: CGFloat, y: CGFloat, image: UIImage, scaleToWidth: CGFloat) {
            self.init(frame: CGRect(x: x, y: y, width: 0, height: 0))
            self.image = image
            scaleImageFrameToWidth(width: scaleToWidth)
        }
        
        /// scales this ImageView size to fit the given width
        public func scaleImageFrameToWidth(width: CGFloat) {
            guard let image = image else {
                print("EZSwiftExtensions Error: The image is not set yet!")
                return
            }
            let widthRatio = image.size.width / width
            let newWidth = image.size.width / widthRatio
            let newHeigth = image.size.height / widthRatio
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newWidth, height: newHeigth)
        }
        
        /// scales this ImageView size to fit the given height
        public func scaleImageFrameToHeight(height: CGFloat) {
            guard let image = image else {
                print("EZSwiftExtensions Error: The image is not set yet!")
                return
            }
            let heightRatio = image.size.height / height
            let newHeight = image.size.height / heightRatio
            let newWidth = image.size.width / heightRatio
            frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: newWidth, height: newHeight)
        }
        
        /// Rounds up an image by clipping the corner radius to one half the frame width.
        public func roundSquareImage() {
            self.clipsToBounds = true
            self.layer.cornerRadius = self.frame.size.width / 2
        }
        
        /// Initializes an UIImage from URL and adds into current ImageView
        public func image(url: String) {
            Eyerise.requestImage(url, success: { (image) -> Void in
                if let img = image {
                    DispatchQueue.main.async {
                        self.image = img
                    }
                }
            })
        }
        
        /// Initializes an UIImage from URL and adds into current ImageView with placeholder
        public func image(url: String, placeholder: UIImage) {
            self.image = placeholder
            image(url: url)
        }
        
        /// Initializes an UIImage from URL and adds into current ImageView with placeholder
        public func image(url: String, placeholderNamed: String) {
            if let image = UIImage(named: placeholderNamed) {
                self.image(url: url, placeholder: image)
            } else {
                image(url: url)
            }
        }
    }

#endif
