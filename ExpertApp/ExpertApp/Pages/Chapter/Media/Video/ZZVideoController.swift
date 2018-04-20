//
//  ZZVideoController.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

class ZZVideoController: BaseController {
    public var model:ZZChapterModel?
    var mhPlayer:MHAVPlayerSDK?
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var collectBtn:UIButton?
    var commentBtn:UIButton?
    var descLab:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = true //1表示支持横竖屏
        
        // Do any additional setup after loading the view.
        mhPlayer = MHAVPlayerSDK(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 300))
        mhPlayer?.mhPlayerURL = "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
        mhPlayer?.mhPlayerTitle = "测试播放地址"
        mhPlayer?.mhAutoOrient = true
        mhPlayer?.MHAVPlayerSDKDelegate = self
        view.addSubview(mhPlayer!)
        
        let spaceX:CGFloat = 15
        var spaceY:CGFloat = 310
        titleLabel = UILabel(frame: CGRect(x: spaceX, y: spaceY, width: kSCREEN_WIDTH - spaceX*2, height: 35))
        titleLabel?.textColor=UIColorFromRGB(rgbValue: TextBlackColor)
        titleLabel?.font = FontWithSize(size: 16)
        
        spaceY = spaceY + 35
        timeLabel = UILabel(frame: CGRect(x: spaceX, y: spaceY, width: kSCREEN_WIDTH - spaceX*2, height: 21))
        timeLabel?.textColor=UIColorFromRGB(rgbValue: TextBlackColor)
        timeLabel?.font = FontWithSize(size: 16)
        
        spaceY = spaceY + 31
        collectBtn = UIButton(frame: CGRect(x: spaceX, y: spaceY, width: 50, height: 30))
        collectBtn?.setImage(UIImage(named: "icon_play_collect"), for: UIControlState.normal)
        collectBtn?.setTitle("收藏", for: UIControlState.normal)
        collectBtn?.tag=1
        collectBtn?.addTarget(self, action: #selector(onItemClick(btn:)), for: UIControlEvents.touchUpInside)
        
        commentBtn = UIButton(frame: CGRect(x: spaceX+60, y: spaceY, width: 50, height: 30))
        commentBtn?.setImage(UIImage(named: "icon_play_comment"), for: UIControlState.normal)
        commentBtn?.setTitle("评论", for: UIControlState.normal)
        commentBtn?.tag=2
        commentBtn?.addTarget(self, action: #selector(onItemClick(btn:)), for: UIControlEvents.touchUpInside)
        
        let scroll:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: spaceY, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - spaceY - 10))
        scroll.backgroundColor = UIColor.clear
        
        var df:CGRect = CGRect(x: spaceX, y: 0, width: kSCREEN_WIDTH-spaceX*2, height: 0)
        descLab = UILabel(frame: df)
        descLab?.numberOfLines = 0
        descLab?.textColor=UIColorFromRGB(rgbValue: TextDarkColor)
        descLab?.font = FontWithSize(size: 14)
        scroll.addSubview(descLab!)
        
        self.view.addSubview(titleLabel!)
        self.view.addSubview(timeLabel!)
        self.view.addSubview(collectBtn!)
        self.view.addSubview(commentBtn!)
        self.view.addSubview(scroll)
        
        
        descLab?.text = "一个叫张三的人，存了三百两银子，想把它藏起来，又怕被人偷去，想来想去，还是把它埋起来好。于是找了个隐蔽地方挖了个坑把银子埋了，但还是不放心，就在埋银子的地方立了块牌子，上面写道“此地无银三百两”。他的邻居李四看到了这个牌子，大笑道：“这不是明明告诉人们，这里有三百两银子吗？”于是就把银子挖走了，但也不放心，怕张三怀疑自己，于是就在那块牌子边上又立了一块牌子，上面写道：“邻居李四不曾偷”。"
        df.size.height = getLabHeigh(label:descLab!, width: df.width)
        descLab?.frame = df
        
        scroll.contentSize = CGSize(width: kSCREEN_WIDTH, height: df.size.height+10)
    }
    
    func onItemClick(btn:UIButton)  {
        if btn.tag == 1{
            //收藏
        }
        if btn.tag == 2{
            //评论
        }
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
