//
//  ViewController.swift
//  RxSwiftTipDemo
//
//  Created by ENUUI on 2017/8/1.
//  Copyright © 2017年 FUHUI. All rights reserved.
//

import UIKit
import RxSwift


class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let d = Demo()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        d.rx.didSetName.asObservable().subscribe { (event) in
            switch event {
            case .completed:
                print("completed")
            case .error(let err):
                print(err)
            case .next(let e):
                print(e)
            }
        }.disposed(by: disposeBag)
    }

    @IBAction func clickTry(_ sender: UIButton) {
        
        d.name = "xxxxx"
    }

}

