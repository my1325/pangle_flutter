//
//  Pangle.swift
//  pangle_flutter
//
//  Created by my on 2020/11/20.
//

import Foundation
import BUAdSDK

public final class Pangle {
    
    public enum Option {
        public enum LogLevel: Int {
            case none
            case error
            case debug
            
            fileprivate var sdkValue: BUAdSDKLogLevel {
                switch self {
                case .none:
                    return .none
                case .error:
                    return .error
                case .debug:
                    return .debug
                }
            }
        }
        case logLevel(LogLevel)
        case coppa(UInt)
        case isPaidApp(Bool)
    }
    
    public static func setup(appId: String, options: [Option] = []) {
        
        BUAdSDKManager.setAppID(appId)
        
        for option in options {
            switch option {
            case let .logLevel(logLevel):
                BUAdSDKManager.setLoglevel(logLevel.sdkValue)
            case let .coppa(coppa):
                BUAdSDKManager.setCoppa(coppa)
            case let .isPaidApp(isPaidApp):
                BUAdSDKManager.setIsPaidApp(isPaidApp)
            }
        }
    }
}
