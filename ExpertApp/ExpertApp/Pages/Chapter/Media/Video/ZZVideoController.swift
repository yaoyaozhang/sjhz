//
//  ZZVideoController.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

class ZZVideoController: BaseController {
    var mhPlayer:MHAVPlayerSDK?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = true //1表示支持横竖屏
        
        self.createTitleMenu()

        // Do any additional setup after loading the view.
        mhPlayer = MHAVPlayerSDK(frame: CGRect(x: 0, y: NavBarHeight, width: kSCREEN_WIDTH, height: 300))
        mhPlayer?.mhPlayerURL = "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
        mhPlayer?.mhPlayerTitle = "测试播放地址"
        mhPlayer?.mhAutoOrient = true
        mhPlayer?.MHAVPlayerSDKDelegate = self
        view.addSubview(mhPlayer!)
    }
    
    override func buttonClick(_ sender:Any!) {
        super.buttonClick(sender)
        let sd = sender as! UIButton
        if sd.tag == 1 {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ZZVideoController: MHAVPlayerSDKDelegate {
    
    func mhGoBack() {
        mhPlayer?.mhStopPlayer()
        self.goBack(nil)
    }
    
    func mhNextPlayer() {
        mhPlayer?.mhPlayerURL = "http://baobab.wdjcdn.com/1455782903700jy.mp4"
        mhPlayer?.mhPlayerTitle = "第二部";
    }
    
}
