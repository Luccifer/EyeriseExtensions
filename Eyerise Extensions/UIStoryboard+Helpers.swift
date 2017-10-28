//
//  UIStoryboard+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 28/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

#if os(iOS) || os(tvOS)
    
    import UIKit
    
    public extension UIStoryboard {
        
        /// Get the application's main storyboard
        /// Usage: let storyboard = UIStoryboard.mainStoryboard
        public static var mainStoryboard: UIStoryboard? {
            let bundle = Bundle.main
            guard let name = bundle.object(forInfoDictionaryKey: "Main") as? String else {
                return nil
            }
            return UIStoryboard(name: name, bundle: bundle)
        }
        
        /// Get view controller from storyboard by its class type
        /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
        /// Warning: identifier should match storyboard ID in storyboard of identifier class
        public func instantiateVC<T>(_ identifier: T.Type) -> T? {
            let storyboardID = String(describing: identifier)
            if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
                return vc
            } else {
                return nil
            }
        }
    }
    
#endif
