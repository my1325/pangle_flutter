//
//  DynamicDelegateFactory.swift
//  pangle_flutter
//
//  Created by my on 2020/11/20.
//

import Foundation

public final class DynamicDelegateFactory {
    
    public static let shared = DynamicDelegateFactory()
    
    private var cacheDelegate: [String: [String: Any]] = [:]

    public func dynamicDelegateForTarget(_ target: Any, with aProtocol: Protocol) -> DynamicDelegate {
        if let delegate = _delegateCacheForTarget(target, with: aProtocol) as? DynamicDelegate {
            return delegate
        }
        
        let newClass: AnyClass = objc_allocateClassPair(DynamicDelegate.self, _newClassNameForTarget(target), 0)!
        defer {
            objc_registerClassPair(newClass)
        }
        class_addProtocol(newClass, aProtocol)
        
        let delegate = newClass.init() as! DynamicDelegate
        _saveDelegate(delegate, for: target, with: aProtocol)
        
        return delegate
    }
    
    private func _newClassNameForTarget(_ target: Any) -> UnsafePointer<Int8> {
        let nsString = (String(format: "DynamicDelegateFor%p", target as! CVarArg) as NSString)
        return nsString.utf8String!
    }
    
    private func _saveDelegate(_ delegate: Any, for target: Any, with aProtocol: Protocol) {
        var protocolCache = _delegateCacheForProtocol(aProtocol)
        protocolCache[_cacheKeyForTarget(target)] = delegate
        cacheDelegate[NSStringFromProtocol(aProtocol)] = protocolCache
    }

    private func _cacheKeyForTarget(_ target: Any) -> String {
        return String(format: "%p", target as! CVarArg)
    }
    
    private func _delegateCacheForTarget(_ target: Any, with aProtocol: Protocol) -> Any? {
        let key = _cacheKeyForTarget(target)
        let protocolCache = _delegateCacheForProtocol(aProtocol)
        return protocolCache[key]
    }
    
    private func _delegateCacheForProtocol(_ aProtocol: Protocol) -> [String: Any] {
        let key = NSStringFromProtocol(aProtocol)
        if let cache = cacheDelegate[key] {
            return cache
        }
        let newCache: [String: Any] = [:]
        cacheDelegate[key] = newCache
        return newCache
    }
}
