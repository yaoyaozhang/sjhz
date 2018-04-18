//
//  ZZVoiceView.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

enum ZZVoiceViewStyle:Int {
    //简单
    case Simple = 0
    // 全屏
    case AllScreen = 1
}


class ZZVoiceView: UIView,MusicPlayToolsDelegate {
    var menuBtmView : UIView?
    var headView    : UIView?
    var headImageViewBg    : UIView?
    var headImageView      : UIImageView?
    var progressSlider:UISlider?
    var curTimeLab:UILabel?
    var allTimeLab:UILabel?
    var playButton:UIButton?
    
    var simpleView  : UIView?
    
    let menuHegith:CGFloat = 50
    
    let menuTitle:Array = ["列表","文本","评论","收藏","分享"]
    let menuIcon:Array = ["icon_play_list","icon_play_menu_text","icon_play_comment","icon_play_collect","icon_play_share"]
    
    let playIcon:Array = ["icon_play_pre_fast","icon_play_pre","icon_play_pause","icon_play_next","icon_play_next_fast"]
    
    
    static let shareVoiceView =   ZZVoiceView.init()
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupSubViews()
        
        MusicPlayTools.shareMusicPlay().delegate = self;
    }
    
    func getCurTiem(_ curTime: String!, totle totleTime: String!, progress: CGFloat) {
        allTimeLab?.text = totleTime
        curTimeLab?.text = curTime
        progressSlider?.value = Float(progress)
    }
    
    func endOfPlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_open"), for: UIControlState.normal)
        
    }
    func pausePlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_open"), for: UIControlState.normal)
    }
    func startPlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_pause"), for: UIControlState.normal)
        
    }
    
    
    func showViewStyple(style:ZZVoiceViewStyle,frame:CGRect) {
        if style == ZZVoiceViewStyle.Simple {
            menuBtmView?.isHidden = true
            
        }
        if style == ZZVoiceViewStyle.AllScreen {
            menuBtmView?.isHidden = false
            self.frame = frame
            menuBtmView?.frame = CGRect(x: 0, y: frame.size.height - menuHegith, width: frame.size.width, height: menuHegith)
        }
    }
    
    func dissmisView() {
        MusicPlayTools.shareMusicPlay().musicPause()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        let frame = self.bounds
        menuBtmView = UIView(frame: frame)
        menuBtmView?.backgroundColor = UIColorFromRGB(rgbValue: BgVCodeColor)
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-menuHegith))
        
        self.addSubview(menuBtmView!)
        self.addSubview(headView!)
        
        self.createHeaderItem()
        self.createMenuButton()
        
    }
    func onBtnClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        
    }
    func onMenuClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        switch btn.tag {
        case 0:
        //列表
            break
        case 1:
        //文本
            break
        case 2:
        //评论
            break
        case 3:
        //收藏
            break
        case 4:
        // 分享
            break
        default: break
            
        }
    }
    func onPlayClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        switch btn.tag {
        case 0:
            //后退15s
            break
        case 1:
            //上一个
            break
        case 2:
            //暂停、播放
            if MusicPlayTools.shareMusicPlay().isPlaying() {
                MusicPlayTools.shareMusicPlay().musicPrePlay("http://www.sanjiahuizhen.com/upload/audio/2018-04-02/20180402180612165.mp3")
            }else{
                MusicPlayTools.shareMusicPlay().musicPrePlay("http://www.sanjiahuizhen.com/upload/audio/2018-04-02/20180402180612165.mp3")
            }
            break
        case 3:
            //下一个
            break
        case 4:
            // 前进15s
            break
        default: break
        }
    }
    
    func progressChange(proSlider:UISlider) {
        
        MusicPlayTools.shareMusicPlay().seekToTime(withValue:CGFloat((progressSlider?.value)!))
    }
    
    
    func createHeaderItem() {
        headImageViewBg = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: (kSCREEN_HEIGHT-menuHegith)/2))
        headImageViewBg?.backgroundColor = UIColor(patternImage: UIImage(named: "voice_bg")!)
        
        let downBtn = self.createButton(imgName: "icon_play_down")
        downBtn.frame = CGRect(x: kSCREEN_WIDTH/2 - 10, y: 30, width: 20, height: 10)
        downBtn.addTarget(self, action: #selector(self.onBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        
        
        headImageView = UIImageView(frame: CGRect(x: (kSCREEN_WIDTH-175)/2, y: (((kSCREEN_HEIGHT-menuHegith)/2)-175)/2, width: 175, height: 175))
        headImageView?.layer.cornerRadius = 175/2
        headImageView?.layer.masksToBounds = true
        headImageView?.image=UIImage(named: "docheader")
        
        
        headImageViewBg?.addSubview(headImageView!)
        headImageViewBg?.addSubview(downBtn)
        
        headView?.addSubview(headImageViewBg!)
        
        let hx = (kSCREEN_HEIGHT - menuHegith)/2;
        var hy = hx;
        let titleLab = self.createLabel(f: CGRect(x: 0, y: hy, width: kSCREEN_WIDTH, height: 30))
        titleLab.text="名称"
        titleLab.font = FontWithSize(size: 18)
        hy = hy + 35
        let titleLab2 = self.createLabel(f: CGRect(x: 0, y: hy, width: kSCREEN_WIDTH, height: 30))
        titleLab2.text="作者"
        
        headView?.addSubview(titleLab)
        headView?.addSubview(titleLab2)
        
        
        hy = kSCREEN_HEIGHT-menuHegith - 180
        curTimeLab = self.createLabel(f: CGRect(x: 40, y: hy, width: 50, height: 30))
        curTimeLab?.text="00:00"
        
        progressSlider = UISlider.init(frame: CGRect(x: 90, y: hy, width: kSCREEN_WIDTH - 180, height: 30))
        progressSlider?.minimumValue = 0.0
        progressSlider?.maximumValue = 1.0
        progressSlider?.minimumTrackTintColor = UIColorFromRGB(rgbValue: BgTitleColor)
        progressSlider?.maximumTrackTintColor = UIColor.lightGray
        progressSlider?.thumbTintColor = UIColorFromRGB(rgbValue: BgTitleColor)
        progressSlider?.addTarget(self, action:#selector(self.progressChange(proSlider:)), for: UIControlEvents.valueChanged)
        
        allTimeLab = self.createLabel(f: CGRect(x: kSCREEN_WIDTH - 90, y: hy, width: 50, height: 30))
        allTimeLab?.text="00:00"
        
        headView?.addSubview(curTimeLab!)
        headView?.addSubview(progressSlider!)
        headView?.addSubview(allTimeLab!)
        
        
        
        
        self.createPlayButton(y: kSCREEN_HEIGHT-menuHegith - 80)
        
        
        
        
        
    }
    
    func createPlayButton(y:CGFloat) {
        let hx:CGFloat = 20.0;
        let wx:CGFloat = (kSCREEN_WIDTH - 40)/5
        for i in 0...4 {
            let btn:UIButton = self.createButton(imgName: playIcon[i]);
            btn.frame = CGRect(x: hx + wx * CGFloat(i), y: y, width: wx, height: wx)
            btn.tag = i
            btn.addTarget(self, action:#selector(self.onPlayClick(btn:)), for: UIControlEvents.touchUpInside)
            headView?.addSubview(btn)
            
            if i==2 {
                playButton  = btn
            }
        }
    }
    
    
    func createMenuButton() {
        let w:CGFloat = kSCREEN_WIDTH / 5
        for (index , item) in menuTitle.enumerated()
        {
            let btn:UIButton = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x:w*CGFloat(index), y: 0.0, width: w, height: menuHegith)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14) //文字大小
            btn.setTitleColor(UIColorFromRGB(rgbValue: TextDarkColor), for: UIControlState.normal)
//            btn.imageView?.frame = CGRect(x: 0, y: 0, width: w, height: menuHegith/2)
//            btn.titleLabel?.frame = CGRect(x: 0, y: menuHegith/2, width: w, height: menuHegith/2)
            btn.clipsToBounds = true
//            btn.setTitle(item, for: UIControlState.normal)
//            btn.setImage(UIImage(named: menuIcon[index]), for: UIControlState.normal)
            btn.tag = index
            btn.set(image: UIImage(named: menuIcon[index]), title: item, titlePosition: UIViewContentMode.bottom, additionalSpacing: 2.0, state: UIControlState.normal)
            btn.addTarget(self, action:#selector(self.onMenuClick(btn:)), for: UIControlEvents.touchUpInside)
            menuBtmView?.addSubview(btn)
            
            
        }
        
    }
    
    func createLabel(f:CGRect) -> UILabel {
        let lab:UILabel = UILabel(frame:f)
        lab.font = FontWithSize(size: 14)
        lab.textColor = UIColorFromRGB(rgbValue: TextListColor)
        lab.textAlignment = NSTextAlignment.center
        return lab
    }
    
    func createButton(imgName:String) -> UIButton {
        let btn:UIButton = UIButton.init(type: UIButtonType.custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14) //文字大小
        btn.setTitleColor(UIColorFromRGB(rgbValue: TextDarkColor), for: UIControlState.normal)
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: imgName), for: UIControlState.normal)
        
        return btn
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
