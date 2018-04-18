//
//  ZZOCToSwift.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import Foundation

public class ZZOCToSwift: NSObject {
    class func openVoiceVC() {
        let vc:ZZVoiceController = ZZVoiceController()
        ZZOCToSwift.getCurrentViewVC().navigationController?.pushViewController(vc, animated: true)
    }
    
    // 找到当前显示的window
    class func getCurrentWindow() -> UIWindow? {
        
        // 找到当前显示的UIWindow
        var window: UIWindow? = UIApplication.shared.keyWindow
        /**
         window有一个属性：windowLevel
         当 windowLevel == UIWindowLevelNormal 的时候，表示这个window是当前屏幕正在显示的window
         */
        if window?.windowLevel != UIWindowLevelNormal {
            
            for tempWindow in UIApplication.shared.windows {
                
                if tempWindow.windowLevel == UIWindowLevelNormal {
                    
                    window = tempWindow
                    break
                }
            }
        }
        
        return window
    }
    
    class func getCurrentViewVC() -> UIViewController {
        // 1.声明UIViewController类型的指针
        var viewController: UIViewController?
        
        // 2.找到当前显示的UIWindow
        let window: UIWindow? = getCurrentWindow()
        
        // 3.获得当前显示的UIWindow展示在最上面的view
        let frontView = window?.subviews.first
        
        // 4.找到这个view的nextResponder
        let nextResponder = frontView?.next
        
        if nextResponder?.isKind(of: UIViewController.classForCoder()) == true {
            
            viewController = nextResponder as? UIViewController
        }
        else {
            
            viewController = window?.rootViewController
        }
        
        return viewController!
    }
}
