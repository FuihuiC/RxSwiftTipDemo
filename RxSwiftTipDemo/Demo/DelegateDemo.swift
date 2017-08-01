//
//  DelegateDemo.swift
//  RxSwiftTipDemo
//
//  Created by ENUUI on 2017/8/1.
//  Copyright © 2017年 FUHUI. All rights reserved.
//

import UIKit

@objc protocol DemoDelegate: NSObjectProtocol {
    @objc optional func demo(d: Demo, didSetName name: String)
}

class Demo: NSObject {
    weak public var delegate: DemoDelegate?
    
    public var name: String? {
        didSet {
            if let n = name {
                self.delegate?.demo?(d: self, didSetName: n)
            }
        }
    }
}
