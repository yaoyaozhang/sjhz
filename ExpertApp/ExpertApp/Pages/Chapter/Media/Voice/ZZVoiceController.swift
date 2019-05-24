//
//  ZZVoiceController.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

class ZZVoiceController: BaseController{
    var voiceView:ZZVoiceView = ZZVoiceView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.addSubview(voiceView)
        voiceView.allFrame = CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT)
        voiceView.simpleFrame = CGRect(x: 0, y: kSCREEN_HEIGHT - 50, width: kSCREEN_WIDTH, height: 50)
        voiceView.showViewAllFull()
        
        self.createTitleMenu()
        self.titleMenu.backgroundColor=UIColor.clear
    }
    override func buttonClick(_ sender:Any!) {
        super.buttonClick(sender)
        let sd = sender as! UIButton
        if sd.tag == 1 {
            voiceView.dissmisView()
        }
    }
    
    func createBottomMenu(){
        
    }
    
    func createItemButton(){
        let w = kSCREEN_WIDTH / 5
        
        let btn:UIButton = UIButton.init(type: UIButtonType.custom)
        btn.frame = CGRect(x: 0, y: 0, width: w, height: 50)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func barClick(item:UIButton) -> Void{
        NSLog("111111%@",item)
       
        
    }
}
