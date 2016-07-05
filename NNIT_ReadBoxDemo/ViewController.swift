//
//  ViewController.swift
//  NNIT_ReadBoxDemo
//
//  Created by Andrew on 16/7/5.
//  Copyright © 2016年 Andrew. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rect = CGRectMake(100, 100, 100, 40)
        let btn = UIButton(frame: rect)
        btn.setTitle("读取数据", forState: .Normal)
        btn.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn.addTarget(self, action: #selector(readAction(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(btn)
    }
    
    func readAction(btn:UIButton) -> Void {
        let readBox = ReadBoxDataController()
        self.navigationController?.pushViewController(readBox, animated: true)
    }

  


}

