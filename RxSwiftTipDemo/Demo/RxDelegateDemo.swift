//
//  RxDelegateDemo.swift
//  RxSwiftTipDemo
//
//  Created by ENUUI on 2017/8/1.
//  Copyright © 2017年 FUHUI. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: Demo {
    // 实现这个，创建的类（本文是Demo）类的对象就可以点出rx了
    var delegate: DelegateProxy {
        return RxDelegateDemoDelegateProxy.proxyForObject(base)
    }
    // 实现这个，创建的类（本文是Demo）类的对象就可以点出rx了
    var didSetName: ControlEvent<String> {
        /**
         DelegateProxy的对象方法 methodInvoked 。
         点到这个方法里，有一大坨的注释解释这个方法。
         大概的意思是说methodInvoked方法只能监听返回值是Void的代理方法。
         有返回值的代理方法要用PublishSubject这个监听，还给了个例子，有兴趣可以点进去看一下。
         */
        let source = delegate.methodInvoked(#selector(DemoDelegate.demo(d:didSetName:))).map({ (a:[Any]) -> String in
            // map函数可以接收到代理方法的参数。可以是单个参数，也可以是多个参数。根据需要取值就可以了，根据参数在代理方法中的位置，下标从0开始。本文实现中，只需要第二个参数，数以取1.
            let i = try castOrThrow(String.self, a[1])
            return i
        })
        // 创建event返回
        return ControlEvent(events: source)
    }
}

class RxDelegateDemoDelegateProxy: RxCocoa.DelegateProxy, DelegateProxyType, DemoDelegate {
    override public class func createProxyForObject(_ object: AnyObject) -> AnyObject {
        let p: Demo = castOrFatalError(object)
        return p.createRxDelegateProxy()
    }
    
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let p: Demo = castOrFatalError(object)
        p.delegate = castOptionalOrFatalError(delegate)
    }
    
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let p: Demo = castOrFatalError(object)
        return p.delegate
    }
}

extension Demo {
    public func createRxDelegateProxy() -> RxDelegateDemoDelegateProxy {
        return RxDelegateDemoDelegateProxy(parentObject: self)
    }
}

// MARK: - 以下四个函数都是rxSwift的错误处理方法, 没有公开, 拷贝了下.
func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    
    return returnValue
}

func castOptionalOrFatalError<T>(_ value: Any?) -> T? {
    if value == nil {
        return nil
    }
    let v: T = castOrFatalError(value)
    return v
}

func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        rxFatalError("Failure converting from &&\(value)&& to \(T.self)")
    }
    return result
}

func rxFatalError(_ lastMessage: String) -> Never  {
    fatalError(lastMessage)
}
