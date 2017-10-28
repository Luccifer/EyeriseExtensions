//
//  CIFilter+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public extension CIFilter {
    
    /// Returns image with applied filter
    ///
    /// - Returns: UIImage?
    func uiImage(byProcessingUIImage: UIImage?) -> UIImage? {
        
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        //        let context = CIContext(options: nil)
        let ciImage = CIImage(image: byProcessingUIImage!)
        self.setValue(ciImage, forKey: kCIInputImageKey)
        guard let result = self.value(forKey: kCIOutputImageKey) as? CIImage else { return nil }
        guard let final: CGImage = context.createCGImage(result, from: result.extent) else { return nil }
        let image: UIImage = UIImage(cgImage: final)
        return image
    }
    
}
