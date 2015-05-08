//
//  ViewController.swift
//  WFAreaPicker
//
//  Created by happi on 15/4/12.
//  Copyright (c) 2015年 happi. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,WFAreaPickerDelegate {

    
    @IBOutlet weak var textField: UITextField!
    var picker:WFAreaPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        picker = WFAreaPickerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 230))
        picker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    *pragma mark - TextField delegate
    */
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.picker.showInView(self.view)
        return false //返回false 不弹出键盘
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.picker.cancelPicker()
    }
    
    
    
    
    
    
    func pickerDidChaneStatus(scView: WFAreaPickerView) {
        self.textField.text = scView.state + " " + scView.province + " " + scView.city
        
        println("地区编号-->\(scView.code)")
    }
       

}

