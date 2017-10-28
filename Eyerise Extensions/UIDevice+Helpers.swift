//
//  UIDevice+Helpers.swift
//  Eyerise Extensions
//
//  Created by Gleb Karpushkin on 14/10/2017.
//  Copyright © 2017 Gleb Karpushkin. All rights reserved.
//

public enum SystemArchitecture {
    case x64, x86_32, simulator, unknown
}

public extension UIDevice {
    
    /// returns modelName of device
    ///
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    /// Returns system architecture of device
    ///
    var systemArch: SystemArchitecture {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1",
             "iPod7,1",
             "iPhone3,1",
             "iPhone3,2",
             "iPhone3,3",
             "iPhone4,1",
             "iPhone5,1",
             "iPhone5,2",
             "iPhone5,3",
             "iPhone5,4":
            return .x86_32
        case "iPhone5,3",
             "iPhone5,4",
             "iPhone6,1",
             "iPhone6,2",
             "iPhone7,2",
             "iPhone7,2",
             "iPhone7,1",
             "iPhone8,1",
             "iPhone8,2",
             "iPhone9,1",
             "iPhone9,3",
             "iPhone9,2",
             "iPhone9,4",
             "iPhone8,4":
            return .x64
        case "i386", "x86_64":
            return .simulator
        default:
            return .unknown
        }
    }
    
    var gatheredInfo: String {
        get {
            let systemVersion = UIDevice.current.systemVersion
            let systemName = UIDevice.current.systemName
            let systemArch = UIDevice.current.systemArch
            let model = UIDevice.current.model
            let modelName = UIDevice.current.modelName
            let idiom: String
            switch UIDevice.current.userInterfaceIdiom {
            case .tv:
                idiom = "tv"
            case.phone:
                idiom = "phone"
            case .pad:
                idiom = "pad"
            case .carPlay:
                idiom = "carPlay"
            case .unspecified:
                idiom = "wtf"
            }
            
            var technicalInfo: String = ""
            technicalInfo += "System Version: \(systemVersion)\n"
            technicalInfo += "System Name: \(systemName)\n"
            technicalInfo += "System Arch: \(systemArch)\n"
            technicalInfo += "Model: \(model)\n"
            technicalInfo += "Model Name: \(modelName)\n"
            technicalInfo += "Idiom: \(idiom)\n"
            return technicalInfo
        }
    }
    
}
