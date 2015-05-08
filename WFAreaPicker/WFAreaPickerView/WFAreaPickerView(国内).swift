//
//  WFAreaPickerView.swift
//  WFAreaPicker
//
//  Created by happi on 15/4/12.
//  Copyright (c) 2015年 happi. All rights reserved.
//

import UIKit

protocol WFAreaPickerDelegate {
    func pickerDidChaneStatus(scView:WFAreaPickerView)
}

class WFAreaPickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var pickerView:UIPickerView!
    
    var state:String = "" //省份
    var city:String = ""  //城市
    var district:String = "" //地区
    
    var delegate:WFAreaPickerDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.provinces = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area.plist", ofType: nil)!)
        self.cities = self.provinces[0]["cities"] as! NSArray
        self.areas = self.cities[0]["areas"] as! NSArray
        
        
        pickerView = UIPickerView(frame: self.bounds)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.whiteColor()
        pickerView.showsSelectionIndicator = true;
        self.addSubview(pickerView)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    var provinces:NSArray!
    var cities:NSArray!
    var areas:NSArray!
    
    /*
    *pragma mark - PickerView lifecycle
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return self.provinces.count
        case 1:
            return self.cities.count
        case 2:
            return self.areas.count
        default:
            return 0
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        switch component {
        case 0:
            return self.provinces[row]["state"] as! String
        case 1:
            return self.cities[row]["city"] as! String
        case 2:
            return self.areas[row] as! String
        default:
            return "无数据"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            self.cities = self.provinces[row]["cities"] as! NSArray
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(1)
            
            
            self.areas = self.cities[0]["areas"] as! NSArray
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
            
            var state:String = self.provinces[row]["state"]as! String
            
            var city:String = self.cities[0]["city"] as! String
            
            var district:String = ""
            if self.areas.count > 0 {
                district = self.areas[0] as! String
            }
            
            self.state = state
            self.city = city
            self.district = district
            
        case 1:
            
            self.areas = self.cities[row]["areas"] as! NSArray
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
            
            var city:String = self.cities[row]["city"] as! String
            
            var district:String = ""
            if self.areas.count > 0 {
                district = self.areas[0] as! String
            }
            
            self.city = city
            self.district = district
            
            
        case 2:
            var district:String = ""
            if self.areas.count > 0 {
                district = self.areas[row] as! String
            }
            self.district = district
            
        default:
            break
        }
        
        if self.delegate != nil {
            self.delegate.pickerDidChaneStatus(self)
        }
        
    }
    

    /*
    * pragma mark - animation
    */
    
    func showInView(view:UIView) {
        self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height)
        //////view.bringSubviewToFront(self)
        view.addSubview(self)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height)
        })
    }

    func cancelPicker() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            
            self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height)
            
            }) { (finished:Bool) -> Void in
            self.removeFromSuperview()
        }
    }

}
