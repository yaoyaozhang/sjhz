//
//  ZZVoiceView.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

class ZZVoiceView: UIView,MusicPlayToolsDelegate {
    public var model:ZZChapterModel?
    var menuBtmView : UIView?
    var headView    : UIView?
    var headImageViewBg    : UIView?
    var headImageView      : UIImageView?
    var progressSlider:UISlider?
    var curTimeLab:UILabel?
    var allTimeLab:UILabel?
    var playButton:UIButton?
    
    var downBtn:UIButton?
    
    var simpleView  : UIView?
    var stitleLab:UILabel?
    var stimeLab:UILabel?
    var sheadImageView: UIImageView?
    var sPlayButton:UIButton?
    
    let menuHegith:CGFloat = 50
    
    let menuTitle:Array = ["列表","文本","评论","收藏","分享"]
    let menuIcon:Array = ["icon_play_list","icon_play_menu_text","icon_play_comment","icon_play_collect","icon_play_share"]
    
    let playIcon:Array = ["icon_play_pre_fast","icon_play_pre","icon_play_pause","icon_play_next","icon_play_next_fast"]
    
    var isPause:Bool?
    
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        setupSubViews()
        
        MusicPlayTools.shareMusicPlay().delegate = self;
    }
    
    func getCurTiem(_ curTime: String!, totle totleTime: String!, progress: CGFloat) {
        allTimeLab?.text = totleTime
        curTimeLab?.text = curTime
        progressSlider?.value = Float(progress)
        stimeLab?.text = String(format: "%@ --%@", "徐顺霖",totleTime)
    }
    
    func endOfPlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_open"), for: UIControlState.normal)
        sPlayButton?.setImage(UIImage(named: "icon_btmplay"), for: UIControlState.normal)
        
        
        isPause = false
    }
    func pausePlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_open"), for: UIControlState.normal)
        sPlayButton?.setImage(UIImage(named: "icon_btmplay"), for: UIControlState.normal)
        isPause = true
    }
    func startPlayAction() {
        playButton?.setImage(UIImage(named: "icon_play_pause"), for: UIControlState.normal)
        sPlayButton?.setImage(UIImage(named: "icon_btmpause"), for: UIControlState.normal)
        
        isPause = false
        
    }
    
    public func showSimpleView(_ frame:CGRect){
        menuBtmView?.isHidden = true
        headView?.isHidden = true
        simpleView?.isHidden = false
        self.frame = frame
        
        downBtn?.frame = CGRect(x: kSCREEN_WIDTH - 95, y: (simpleView?.frame.height)!/2 - 20, width: 40, height: 40)
        downBtn?.setImage(UIImage(named: "icon_play_up"), for: UIControlState.normal)
    }
    
    /// 定位视频播放时间
    ///
    /// - parameter style: 类型
    /// - parameter frame: 位置
    public func showViewAllFull(_ frame:CGRect) {
        menuBtmView?.isHidden = false
        headView?.isHidden = false
        simpleView?.isHidden = true
        self.frame = frame
        menuBtmView?.frame = CGRect(x: 0, y: frame.size.height - menuHegith, width: frame.size.width, height: menuHegith)
    
        
        downBtn?.frame = CGRect(x: kSCREEN_WIDTH/2-20, y: 21, width: 40, height: 40)
        downBtn?.setImage(UIImage(named: "icon_play_down"), for: UIControlState.normal)
    }
    
    func dissmisView() {
        MusicPlayTools.shareMusicPlay().musicPause()
        isPause = false
       
        self.isHidden = true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        let frame = self.bounds
        self.backgroundColor = UIColorFromRGB(rgbValue: TextWhiteColor)
        menuBtmView = UIView(frame: frame)
        menuBtmView?.backgroundColor = UIColorFromRGB(rgbValue: BgVCodeColor)
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT-menuHegith))
        
        self.addSubview(menuBtmView!)
        self.addSubview(headView!)
        
        self.createHeaderItem()
        self.createMenuButton()
        
        
        self.createSimpleView()
        self.addSubview(simpleView!)
        
        downBtn = self.createButton(imgName: "icon_play_down")
        downBtn?.frame = CGRect(x: kSCREEN_WIDTH/2 - 10, y: 30, width: 20, height: 10)
        downBtn?.addTarget(self, action: #selector(self.onBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        self.addSubview(downBtn!)
        
        
        isPause = false
    }
    func onBtnClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        
        if (!(simpleView?.isHidden)!) {
            showViewAllFull(CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT))
        }else{
            showSimpleView(CGRect(x: 0, y: kSCREEN_HEIGHT - 100, width: kSCREEN_WIDTH, height: 50))
        }
        
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
           startPlay()
            break
        case 10:
            //暂停、播放
            startPlay()
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
    
    
    func startPlay() {
        //暂停、播放
        if MusicPlayTools.shareMusicPlay().isPlaying() {
            MusicPlayTools.shareMusicPlay().musicPause()
        }else{
            if isPause! {
                MusicPlayTools.shareMusicPlay().musicPlay()
            }else{
                MusicPlayTools.shareMusicPlay().musicPrePlay("http://www.sanjiahuizhen.com/upload/audio/2018-04-02/20180402180612165.mp3")
            }
        }
    }
    
    func progressChange(proSlider:UISlider) {
        
        MusicPlayTools.shareMusicPlay().seekToTime(withValue:CGFloat((progressSlider?.value)!))
    }
    
    
    func createHeaderItem() {
        headImageViewBg = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: (kSCREEN_HEIGHT-menuHegith)/2))
        headImageViewBg?.layer.contents = UIImage(named: "voice_bg")?.cgImage
        
        
        headImageView = UIImageView(frame: CGRect(x: (kSCREEN_WIDTH-175)/2, y: (((kSCREEN_HEIGHT-menuHegith)/2)-175)/2, width: 175, height: 175))
        headImageView?.layer.cornerRadius = 175/2
        headImageView?.layer.masksToBounds = true
        headImageView?.image=UIImage(named: "docheader")
        
        
        headImageViewBg?.addSubview(headImageView!)
        
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
    func createSimpleView()  {
        simpleView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 50.0))
        simpleView?.backgroundColor = UIColor(patternImage: UIImage(named: "voice_bg")!)
        sheadImageView = UIImageView(frame: CGRect(x: (kSCREEN_WIDTH-175)/2, y: (((kSCREEN_HEIGHT-menuHegith)/2)-175)/2, width: 175, height: 175))
        sheadImageView?.layer.cornerRadius = 175/2
        sheadImageView?.layer.masksToBounds = true
        sheadImageView?.image=UIImage(named: "docheader")
        
        stitleLab = self.createLabel(f: CGRect(x: 52, y: 5, width: kSCREEN_WIDTH-52-90, height: 21))
        stitleLab?.textColor = UIColor.white
        stitleLab?.textAlignment=NSTextAlignment.left
        stitleLab?.font = FontWithSize(size: 16)
        stitleLab?.text = "作者"
        stimeLab = self.createLabel(f: CGRect(x: 52, y: 26, width: kSCREEN_WIDTH-52-90, height: 21))
        stimeLab?.textColor=UIColorFromRGB(rgbValue: TextWhiteColor)
        stimeLab?.text = "00:00 -徐顺霖"
        stimeLab?.font = FontWithSize(size: 14)
        stimeLab?.textAlignment=NSTextAlignment.left
        sPlayButton = self.createButton(imgName: "icon_btmplay");
        sPlayButton?.frame = CGRect(x: kSCREEN_WIDTH - 60, y: 10, width: 32, height: 32)
        sPlayButton?.tag = 10
        sPlayButton?.addTarget(self, action:#selector(self.onPlayClick(btn:)), for: UIControlEvents.touchUpInside)
        
        let btn:UIButton = UIButton(frame: CGRect(x: kSCREEN_WIDTH-25, y: -5, width: 25, height: 25))
        btn.setImage(UIImage(named: "icon_btmclose"), for: UIControlState.normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(dissmisView), for: UIControlEvents.touchUpInside)
        
        
        simpleView?.addSubview(sheadImageView!)
        simpleView?.addSubview(stitleLab!)
        simpleView?.addSubview(stimeLab!)
        simpleView?.addSubview(sPlayButton!)
        simpleView?.addSubview(btn)
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
