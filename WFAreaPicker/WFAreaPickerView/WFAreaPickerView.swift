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
    
    var state:String = "" //国家
    var province:String = ""  //省
    var city:String = "" //市
    var code:String = ""//地区代码
    
    var delegate:WFAreaPickerDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.provinces = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area.plist", ofType: nil)!)
        //self.cities = self.provinces[0]["cities"] as! NSArray
        //self.areas = self.cities[0]["areas"] as! NSArray
        
        //self.provinces = self.getAreaJSONDate()
        self.states = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area-data.plist", ofType: nil)!)
        self.provinces = self.states[0]["province"] as! NSArray
        if self.provinces.count > 0 {
            self.citys = self.provinces[0]["city"] as! NSArray
        }
        
        
        pickerView = UIPickerView(frame: self.bounds)
        pickerView.delegate = self
        pickerView.dataSource = self
        self.addSubview(pickerView)
    }
    
    
    //将 area-data.json 文件的JSON格式数据转换成 接口需要的 数据格式 保存为 area-data.plist
    func getAreaJSONDate() -> NSArray {
        var data:NSData = NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("area-data.json", ofType: nil)!)!
        var provinc:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
        
        
        //国
        var array:NSMutableArray = NSMutableArray()
        for (key,value) in provinc {
            
            var dic:NSMutableDictionary = NSMutableDictionary()
            dic["state_code"] = key
            
            var stateDic:NSDictionary = value as! NSDictionary
            for (key,value) in stateDic {
                if key as! String == "name" {
                    dic["state_name"] = value
                } else {
                    
                    //省
                    var provinceDic:NSDictionary? = stateDic["node"] as? NSDictionary
                    var provinceArray:NSMutableArray = NSMutableArray()
                    if provinceDic != nil {
                        for (key,value1) in provinceDic! {
                            var dic1:NSMutableDictionary = NSMutableDictionary()
                            dic1["province_code"] = key
                            
                            var provinceDic:NSDictionary = value1 as! NSDictionary
                            for (key,value) in provinceDic {
                                if key as! String == "name" {
                                    dic1["province_name"] = value
                                } else {
                                    
                                    
                                    //市
                                    var cityDic:NSDictionary? = provinceDic["node"] as? NSDictionary
                                    var cityArray:NSMutableArray = NSMutableArray()
                                    if cityDic != nil {
                                        for (key,value2) in cityDic! {
                                            var dic2:NSMutableDictionary = NSMutableDictionary()
                                            dic2["city_code"] = key
                                            
                                            var cityDic:NSDictionary = value2 as! NSDictionary
                                            for (key,value) in cityDic {
                                                if key as! String == "name" {
                                                    dic2["city_name"] = value
                                                } else {
                                                    //------------
                                                }
                                            }
                                            
                                            
                                            cityArray.addObject(dic2)
                                        }
                                    }
                                    dic1["city"] = cityArray
                                }
                            }
                            provinceArray.addObject(dic1)
                        }
                    }
                    dic["province"] = provinceArray
                }
            }
            array.addObject(dic)
        }
        
        
        array.writeToFile("/Users/happi/Desktop/area-data.plist", atomically: true)
        
        
        return array
       // println(array)
        
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    var states:NSArray! = NSArray()
    var provinces:NSArray! = NSArray()
    var citys:NSArray! = NSArray()
    
    /*
    *pragma mark - PickerView lifecycle
    */
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.states.count
        case 1:
            return self.provinces.count
        case 2:
            return self.citys.count
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return self.states[row]["state_name"] as! String
        case 1:
            return self.provinces[row]["province_name"] as! String
        case 2:
            return self.citys[row]["city_name"] as! String
        default:
            return "无数据"
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.provinces = self.states[row]["province"] as! NSArray
            pickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView.reloadComponent(1)
            
            if self.provinces.count > 0 {
                self.citys = self.provinces[0]["city"] as! NSArray
            }
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
            
            var code:String = ""
            var state:String = self.states[row]["state_name"] as! String
            code = self.states[row]["state_code"] as! String
            
            var province:String = ""
            if self.provinces.count > 0 {
                province = self.provinces[0]["province_name"] as! String
                code = self.provinces[0]["province_code"] as! String
            }
            
            var city:String = ""
            if self.citys.count > 0 {
                city = self.citys[0]["city_name"] as! String
                code = self.citys[0]["city_code"] as! String
            }
            
            self.state = state
            self.province = province
            self.city = city
            self.code = code
            
        case 1:
            
            if self.provinces.count > row {
                self.citys = self.provinces[row]["city"] as! NSArray
            }
            pickerView.selectRow(0, inComponent: 2, animated: true)
            pickerView.reloadComponent(2)
            
            var province:String = ""
            
            if self.provinces.count > row {
                province = self.provinces[row]["province_name"] as! String
                self.code = self.provinces[row]["province_code"] as! String
            }
            
            var city:String = ""
            if self.citys.count > 0 {
                city = self.citys[0]["city_name"] as! String
                self.code = self.citys[0]["city_code"] as! String
            }
            
            self.province = province
            self.city = city
            
        case 2:
            var city:String = ""
            if self.citys.count > row {
                city = self.citys[row]["city_name"] as! String
                self.code = self.citys[row]["city_code"] as! String
            }
            self.city = city
            
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
