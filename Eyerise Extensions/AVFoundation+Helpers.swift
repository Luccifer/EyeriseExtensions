//
//  AVFoundation+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

import AVFoundation

public extension URL {
    
    func thumbnailForVideoAtURL() -> UIImage? {
        
        let asset = AVAsset(url: self)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
            //            return UIImage(cgImage: imageRef, scale: 1.0, orientation: .right)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
