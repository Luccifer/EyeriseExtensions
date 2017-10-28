//
//  UIImage+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension UIImage {
    
    class func image(from layer: CALayer) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, UIScreen.main.scale)
        
        // Don't proceed unless we have context
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// Fixes UIImage orientation which can be currepted f.e. during the filter apply or etc..
    ///
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        if ( self.imageOrientation == UIImageOrientation.down || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }
        
        if ( self.imageOrientation == UIImageOrientation.left || self.imageOrientation == UIImageOrientation.leftMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2.0))
        }
        
        if ( self.imageOrientation == UIImageOrientation.right || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: 0, y: self.size.height);
            transform = transform.rotated(by: CGFloat(-Double.pi / 2.0));
        }
        
        if ( self.imageOrientation == UIImageOrientation.upMirrored || self.imageOrientation == UIImageOrientation.downMirrored ) {
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.leftMirrored || self.imageOrientation == UIImageOrientation.rightMirrored ) {
            transform = transform.translatedBy(x: self.size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContext = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height),
                                       bitsPerComponent: self.cgImage!.bitsPerComponent, bytesPerRow: 0,
                                       space: self.cgImage!.colorSpace!,
                                       bitmapInfo: self.cgImage!.bitmapInfo.rawValue)!;
        
        ctx.concatenate(transform)
        
        if ( self.imageOrientation == UIImageOrientation.left ||
            self.imageOrientation == UIImageOrientation.leftMirrored ||
            self.imageOrientation == UIImageOrientation.right ||
            self.imageOrientation == UIImageOrientation.rightMirrored ) {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
        } else {
            ctx.draw(self.cgImage!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
        }
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(cgImage: ctx.makeImage()!)
        
    }
    
    /// Slightly dim the image like its shadowed
    ///
    func shadowed() -> UIImage? {
        let image = self
        let rect: CGRect = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        let color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        context.setFillColor(color.cgColor)
        context.setBlendMode(.sourceAtop)
        context.fill(rect)
        if let result: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return result
        } else {
            return nil
        }
    }
    
    
    /// Returns the resized UIImage with given width and future image width
    ///
    /// - Parameter width: the width of future UIImage you want to use
    /// - Returns: resized with new dimentions UIImage with given width
    public func resizeWithWidth(_ width: CGFloat) -> UIImage {
        let aspectSize = CGSize (width: width, height: aspectHeightForWidth(width))
        
        UIGraphicsBeginImageContext(aspectSize)
        self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img!
    }
    
    public func aspectHeightForWidth(_ width: CGFloat) -> CGFloat {
        return (width * self.size.height) / self.size.width
    }
    
    /// Returns rotated UIImage
    ///
    /// - Parameter degrees: ange degrees rotation
    /// - Returns: rotated UIImage
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage? {
        //        let radiansToDegrees: (CGFloat) -> CGFloat = {
        //            return $0 * (180.0 / CGFloat(M_PI))
        //        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees))
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees))
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if flip {
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        
        guard let cg = self.cgImage else {return nil}
        
        bitmap?.draw(cg, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UIImage {
        
        /// Returns base64 string
        public var base64: String {
            return UIImageJPEGRepresentation(self, 1.0)!.base64EncodedString()
        }
        
        /// Returns compressed image to rate from 0 to 1
        public func compressImage(rate: CGFloat) -> Data? {
            return UIImageJPEGRepresentation(self, rate)
        }
        
        /// Returns Image size in Bytes
        public func getSizeAsBytes() -> Int {
            return UIImageJPEGRepresentation(self, 1)?.count ?? 0
        }
        
        /// Returns Image size in Kylobites
        public func getSizeAsKilobytes() -> Int {
            let sizeAsBytes = getSizeAsBytes()
            return sizeAsBytes != 0 ? sizeAsBytes / 1024 : 0
        }
        
        /// scales image
        public class func scaleTo(image: UIImage, w: CGFloat, h: CGFloat) -> UIImage {
            let newSize = CGSize(width: w, height: h)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        
        /// Returns resized image with height. Might return low quality
        public func resizeWith(_ height: CGFloat) -> UIImage {
            let aspectSize = CGSize (width: aspectWidthFor(height), height: height)
            
            UIGraphicsBeginImageContext(aspectSize)
            self.draw(in: CGRect(origin: CGPoint.zero, size: aspectSize))
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return img!
        }
        
        public func aspectWidthFor(_ height: CGFloat) -> CGFloat {
            return (height * self.size.width) / self.size.height
        }
        
        /// Returns cropped image from CGRect
        public func croppedImage(_ bound: CGRect) -> UIImage? {
            guard self.size.width > bound.origin.x else {
                print("Your cropping X coordinate is larger than the image width")
                return nil
            }
            guard self.size.height > bound.origin.y else {
                print("Your cropping Y coordinate is larger than the image height")
                return nil
            }
            let scaledBounds: CGRect = CGRect(x: bound.x * self.scale, y: bound.y * self.scale, width: bound.w * self.scale, height: bound.h * self.scale)
            let imageRef = self.cgImage?.cropping(to: scaledBounds)
            let croppedImage: UIImage = UIImage(cgImage: imageRef!, scale: self.scale, orientation: UIImageOrientation.up)
            return croppedImage
        }
        
        /// Use current image for pattern of color
        public func withColor(_ tintColor: UIColor) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
            
            let context = UIGraphicsGetCurrentContext()
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            context?.setBlendMode(CGBlendMode.normal)
            
            let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
            context?.clip(to: rect, mask: self.cgImage!)
            tintColor.setFill()
            context?.fill(rect)
            
            let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
            UIGraphicsEndImageContext()
            
            return newImage
        }
        
        /// Returns the image associated with the URL
        public convenience init?(urlString: String) {
            guard let url = URL(string: urlString) else {
                self.init(data: Data())
                return
            }
            guard let data = try? Data(contentsOf: url) else {
                print(" No image in URL \(urlString)")
                self.init(data: Data())
                return
            }
            self.init(data: data)
        }
        
        /// Returns an empty image //TODO: Add to readme
        public class func blankImage() -> UIImage {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0.0)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }
    }
    
#endif
