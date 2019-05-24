//
//  ZZVoiceView.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

@objc protocol ZZVideoViewDelegate: NSObjectProtocol {
    /// 返回按钮
    @objc optional func mmVoiceViewDissmis(_ ispause:Bool)
    
}

class ZZVoiceView: UIView,MusicPlayToolsDelegate {
    /// 代理
    @objc weak var voiceDelegate: ZZVideoViewDelegate?
    
    @objc public var model:ZZChapterModel?
    @objc public var curIndex:String?
    @objc public var listArray:[ZZChapterModel]=[]
    @objc public var viewController:UIViewController?
    
    var simpleFrame:CGRect?
    var allFrame:CGRect?
    
    var menuBtmView : UIView?
    var headView    : UIView?
    var headImageViewBg    : UIView?
    var headImageView      : UIImageView?
    var progressSlider:UISlider?
    var curTimeLab:UILabel?
    var allTimeLab:UILabel?
    var playButton:UIButton?
    var titleLab2:UILabel?
    var titleLab:UILabel?
    var totalDuration:Int?
    
    
    var downBtn:UIButton?
    
    var simpleView  : UIView?
    var stitleLab:UILabel?
    var stimeLab:UILabel?
    var sheadImageView: UIImageView?
    var sPlayButton:UIButton?
    
    let menuHegith:CGFloat = 50
    
//    let menuTitle:Array = ["列表","文本","评论","收藏","分享"]
    let menuTitle:Array = ["文本","评论","收藏","分享"]
//    let menuIcon:Array = ["icon_play_list","icon_play_menu_text","icon_play_comment","icon_play_collect","icon_play_share"]
        let menuIcon:Array = ["icon_play_menu_text","icon_play_comment","icon_play_collect","icon_play_share"]
    
    let playIcon:Array = ["icon_play_pre_fast","icon_play_pre","icon_play_pause","icon_play_next","icon_play_next_fast"]
    
    /// 是否暂停
    var isPause:Bool?
    
    /// 播放/暂停
    var mmVoiceViewDissmis: ((_ flag: Bool) -> Void)?
    
    
    override init(frame:CGRect){
        super.init(frame: frame)
        
        MusicPlayTools.shareMusicPlay().delegate = self;
    }
    func getCurTiem(_ curTime: String!, totle totleTime: String!, progress: CGFloat, totleValue total: Int) {
        allTimeLab?.text = totleTime
        curTimeLab?.text = curTime
        progressSlider?.value = Float(progress)
        stimeLab?.text = String(format: "%@--%@", curTime,totleTime)
        
        totalDuration = total

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
        
        self.isHidden = false
        
    }
    
    @objc func setFullScreenFrame(_ frame:CGRect){
        allFrame = frame
        setupSubViews()
    }
    @objc func setSimpleFrame(_ frame:CGRect) {
        simpleFrame = frame
    }
    
    @objc public func showSimpleView(){
        menuBtmView?.isHidden = true
        headView?.isHidden = true
        simpleView?.isHidden = false
        self.frame = simpleFrame!
        
        downBtn?.frame = CGRect(x: kSCREEN_WIDTH - 95, y: (simpleView?.frame.height)!/2 - 20, width: 40, height: 40)
        downBtn?.setImage(UIImage(named: "icon_play_up"), for: UIControlState.normal)
    }
    
    /// 定位视频播放时间
    ///
    /// - parameter style: 类型
    /// - parameter frame: 位置
    @objc public func showViewAllFull() {
        menuBtmView?.isHidden = false
        headView?.isHidden = false
        simpleView?.isHidden = true
        self.frame = allFrame!
        menuBtmView?.frame = CGRect(x: 0, y: self.frame.size.height - menuHegith, width: self.frame.size.width, height: menuHegith)
    
        if Int((allFrame?.origin.y)!) > 20 {
            downBtn?.frame = CGRect(x: kSCREEN_WIDTH/2-20, y: 0, width: 40, height: 40)
        }else{
            downBtn?.frame = CGRect(x: kSCREEN_WIDTH/2-20, y: ZC_iPhoneX ? (34+21) : 21, width: 40, height: 40)
        }
        
        downBtn?.setImage(UIImage(named: "icon_play_down"), for: UIControlState.normal)
    }
    
    @objc func dissmisView() {
        MusicPlayTools.shareMusicPlay().musicPause()
        isPause = false
       
        self.isHidden = true
        
        if (self.voiceDelegate?.responds(to: NSSelectorFromString("mmVoiceViewDissmis:")))! {
            self.voiceDelegate?.mmVoiceViewDissmis!(isPause!)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        let frame = self.bounds
        self.backgroundColor = UIColorFromRGB(rgbValue: TextWhiteColor)
        menuBtmView = UIView(frame: frame)
        menuBtmView?.backgroundColor = UIColorFromRGB(rgbValue: BgSystemColor)
        
        headView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: (allFrame?.size.height)!-menuHegith))
        
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
        
        changeModelMessage()
    }
    @objc func onBtnClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        
        if (!(simpleView?.isHidden)!) {
            showViewAllFull()
        }else{
            showSimpleView()
        }
        
    }
    @objc func onMenuClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        switch btn.tag {
        case 0:
        //列表
            break
        case 1:
        //文本
            let comVC:ZZChapterDetailController = ZZChapterDetailController()
            comVC.model = self.model;
            self.viewController?.navigationController?.pushViewController(comVC, animated: true)
            
            showSimpleView()
            break
        case 2:
        //评论
            let comVC:ZZCommentController = ZZCommentController()
            comVC.nid = (self.model?.nid)!;
            comVC.model = self.model;
            comVC.zzResultBlock = { (status:Int32) in
                self.isHidden = false
            }
            self.viewController?.navigationController?.pushViewController(comVC, animated: true)
            
            ZZVoiceTools.share().hideAllView()
            break
        case 3:
                //收藏
                let params : NSMutableDictionary = NSMutableDictionary()
                params["collectiontType"] = (self.model?.collect)! ? convertIntToString(0) :convertIntToString(1)
                params["nid"] = convertIntToString((self.model?.nid)!)
                params["uid"] = convertIntToString(ZZDataCache.getInstance().getLoginUser().userId)
                ZZRequsetInterface.post(API_CollectChapter, param:params, timeOut: CGFloat(HttpPostTimeOut), start: {
                    
                }, finish: { (_ obj:Any!, data:Data!) in
                    print(String.init(data: data, encoding: .utf8)!)
                }, complete: { (dictValue:Dictionary!) in
                    
                    if (self.model?.collect)! {
                        self.makeToast("取消收藏成功!")
                       btn.setImage(UIImage(named: "icon_play_collect"), for: UIControlState.normal)
                    }else{
                        self.makeToast("收藏成功!")
                        btn.setImage(UIImage(named: "btn_collect"), for: UIControlState.normal)
                    }
                    
                    self.model?.collect = !(self.model?.collect)!
                    
                }, fail: { (_ obj:Any!, msg:String!,err:Error!) in
                    self.makeToast(msg)
                    print(err)
                },progress: { (_p:CGFloat) in
                    
                })
            break
        case 4:
        // 分享
            let sv:ZZShareView = ZZShareView.init(shareType: ZZShareType.chapter, vc: self.window?.rootViewController)
            sv.shareModel = self.model
            sv.show()
            break
        default: break
            
        }
    }
    @objc func onPlayClick(btn:UIButton) {
        NSLog("%d", btn.tag)
        switch btn.tag {
        case 0:
            //后退15s
            MusicPlayTools.shareMusicPlay().seekToTime(withCutValue: -15)
            break
        case 1:
            var index = Int(curIndex!)
            //上一个
            if (listArray.count)>0 && index! > 0  {
                
                repeat {
                    if index == 0 {
                        self.makeToast("已经是第一个了")
                        break
                    }
                    index = index! - 1
                    
                    curIndex = String(index!)
                    
                    let m:ZZChapterModel = listArray[index!]
                    if m.lclassify == 2 {
                        model = m
                        
                        changeModelMessage()
                        
                        MusicPlayTools.shareMusicPlay().musicPrePlay(m.addressUrl)
                        break
                    }
                }while index! >= 0
            }
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
            var index = Int(curIndex!)
            
            if (listArray.count)>0 && index! < listArray.count {
                
                repeat {
                    if index == ((listArray.count)-1) {
                        self.makeToast("已经是最后一个了")
                        break
                    }
                    index = index! + 1
                    
                    curIndex = String(index!)
                    
                    let m:ZZChapterModel = listArray[index!]
                    if m.lclassify == 2 {
                        model = m
                        
                        changeModelMessage()
                        MusicPlayTools.shareMusicPlay().musicPrePlay(m.addressUrl)
                        break
                    }
                    
                    
                }while index! < (listArray.count)
                
            }
            break
        case 4:
            // 前进15s
            MusicPlayTools.shareMusicPlay().seekToTime(withCutValue: 15)
            break
        default: break
        }
    }
    
    
    @objc func startPlay() {
        //暂停、播放
        if MusicPlayTools.shareMusicPlay().isPlaying() {
            MusicPlayTools.shareMusicPlay().musicPause()
        }else{
            if isPause! {
                MusicPlayTools.shareMusicPlay().musicPlay()
            }else{
                MusicPlayTools.shareMusicPlay().musicPrePlay(self.model?.addressUrl)
//                MusicPlayTools.shareMusicPlay().musicPrePlay("http://www.sanjiahuizhen.com/upload/audio/2018-04-02/20180402180612165.mp3")
            }
        }
    }
    
    @objc func progressChange(proSlider:UISlider) {
        let seek:Float = Float(totalDuration!) * proSlider.value
        
        print(seek,(proSlider.value))
        
        MusicPlayTools.shareMusicPlay().seekToTime(withValue:CGFloat(seek))
    }
    
    
    func createHeaderItem() {
        headImageViewBg = UIView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: ( (allFrame?.size.height)!-menuHegith)/2))
        headImageViewBg?.layer.contents = UIImage(named: "voice_bg")?.cgImage
        
        
        headImageView = UIImageView(frame: CGRect(x: (kSCREEN_WIDTH-175)/2, y: ((( (allFrame?.size.height)!-menuHegith)/2)-175)/2, width: 175, height: 175))
        headImageView?.layer.cornerRadius = 175/2
        headImageView?.layer.masksToBounds = true
        
        
        
        headImageViewBg?.addSubview(headImageView!)
        
        headView?.addSubview(headImageViewBg!)
        
        let hx = ( (allFrame?.size.height)! - menuHegith)/2;
        var hy = hx + 10;
        
        titleLab = self.createLabel(f: CGRect(x: 0, y: hy, width: kSCREEN_WIDTH, height: 30))
        
        titleLab?.font = FontWithSize(size: 18)
        hy = hy + 35
        titleLab2 = self.createLabel(f: CGRect(x: 0, y: hy, width: kSCREEN_WIDTH, height: 30))
        
        
        headView?.addSubview(titleLab!)
        headView?.addSubview(titleLab2!)
        
        
        hy =  (allFrame?.size.height)!-menuHegith - 180
        
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
        
        self.createPlayButton(y:  hy + 60)
        
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
        let sw:CGFloat = (simpleFrame?.size.width)!
        simpleView = UIView(frame: CGRect(x: 0, y: 0, width: sw, height: 50.0))
        simpleView?.backgroundColor = UIColor(patternImage: UIImage(named: "voice_bg")!)
        sheadImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        sheadImageView?.layer.cornerRadius = 20
        sheadImageView?.layer.masksToBounds = true
        
        
        stitleLab = self.createLabel(f: CGRect(x: 52, y: 5, width: sw-52-90, height: 21))
        stitleLab?.textColor = UIColor.white
        stitleLab?.textAlignment=NSTextAlignment.left
        stitleLab?.font = FontWithSize(size: 16)
        stitleLab?.text = convertToString(self.model?.title)
        stimeLab = self.createLabel(f: CGRect(x: 52, y: 26, width: sw-52-90, height: 21))
        stimeLab?.textColor=UIColorFromRGB(rgbValue: TextWhiteColor)
        stimeLab?.text = "00:00"
        stimeLab?.font = FontWithSize(size: 14)
        stimeLab?.textAlignment=NSTextAlignment.left
        sPlayButton = self.createButton(imgName: "icon_btmplay");
        sPlayButton?.frame = CGRect(x: sw - 60, y: 10, width: 32, height: 32)
        sPlayButton?.tag = 10
        sPlayButton?.addTarget(self, action:#selector(self.onPlayClick(btn:)), for: UIControlEvents.touchUpInside)
        
        let btn:UIButton = UIButton(frame: CGRect(x: sw-20, y: -5, width: 22, height: 25))
        btn.setImage(UIImage(named: "icon_btmclose"), for: UIControlState.normal)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(dissmisView), for: UIControlEvents.touchUpInside)
        
        
        simpleView?.addSubview(sheadImageView!)
        simpleView?.addSubview(stitleLab!)
        simpleView?.addSubview(stimeLab!)
        simpleView?.addSubview(sPlayButton!)
        simpleView?.addSubview(btn)
    }
    
    func changeModelMessage(){
        sheadImageView?.sd_setImage(with: URL(string:(self.model?.picture)!), placeholderImage: UIImage(named: "docheader"))
        headImageView?.sd_setImage(with: URL(string:(self.model?.picture)!), placeholderImage: UIImage(named: "docheader"))
        titleLab?.text = convertToString(self.model?.title)
        titleLab2?.text=convertToString(self.model?.author)
        
        
        stitleLab?.text = convertToString(self.model?.title)
        stimeLab?.text = "00:00"
    }
    
    func createMenuButton() {
        let w:CGFloat = (allFrame?.size.width)! / CGFloat(menuTitle.count)
        for (index , item) in menuTitle.enumerated()
        {
            let btn:UIButton = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect(x:w*CGFloat(index), y: 0.0, width: w, height: menuHegith)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14) //文字大小
            btn.setTitleColor(UIColorFromRGB(rgbValue: TextLightDarkColor), for: UIControlState.normal)
//            btn.imageView?.frame = CGRect(x: 0, y: 0, width: w, height: menuHegith/2)
//            btn.titleLabel?.frame = CGRect(x: 0, y: menuHegith/2, width: w, height: menuHegith/2)
            btn.clipsToBounds = true
//            btn.setTitle(item, for: UIControlState.normal)
//            btn.setImage(UIImage(named: menuIcon[index]), for: UIControlState.normal)
            btn.tag = index + 1
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
