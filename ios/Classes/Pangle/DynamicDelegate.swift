//
//  DynamicDelegate.swift
//  pangle_flutter
//
//  Created by my on 2020/11/20.
//

import Foundation

public class DynamicDelegate: NSObject {
    
//    let delegate = DynamicDelegateFactory.shared.delegate(for: UITableViewDelegate.self, forTarget: tableView)
//    let block = { (delegate: DynamicDelegate, tableView: UITableView, indexPath: IndexPath) in
//        print("\(indexPath)")
//    }
//    let closure = unsafeBitCast(block as @convention(block) (DynamicDelegate, UITableView, IndexPath) -> Void, to: AnyObject.self)
    public func replaceImplementionForSelector(_ aSelector: Selector, with closure: AnyObject) {
        let imp = imp_implementationWithBlock(closure)
        if !class_addMethod(Self.self, aSelector, imp, nil), let method = class_getInstanceMethod(Self.self, aSelector) {
            method_setImplementation(method, imp)
        }
    }
}
