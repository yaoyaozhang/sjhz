//
//  ZZVideoController.swift
//  ExpertApp
//
//  Created by zhangxy on 2018/4/17.
//  Copyright © 2018年 sjhz. All rights reserved.
//

import UIKit

class ZZVideoController: BaseController {
   @objc public var model:ZZChapterModel?
    var mhPlayer:MHAVPlayerSDK?
    
    var titleLabel:UILabel?
    var timeLabel:UILabel?
    var collectBtn:UIButton?
    var commentBtn:UIButton?
    var descLab:UILabel?
    var scroll:UIScrollView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.allowRotation = true //1表示支持横竖屏
        
        // Do any additional setup after loading the view.
        mhPlayer = MHAVPlayerSDK(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 300))
        mhPlayer?.mhPlayerURL = self.model?.addressUrl
//        mhPlayer?.mhPlayerURL = "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
        mhPlayer?.mhPlayerTitle = self.model?.title
        mhPlayer?.mhAutoOrient = true
        mhPlayer?.MHAVPlayerSDKDelegate = self
        
        let spaceX:CGFloat = 15
        var spaceY:CGFloat = 310
        titleLabel = UILabel(frame: CGRect(x: spaceX, y: spaceY, width: kSCREEN_WIDTH - spaceX*2, height: 35))
        titleLabel?.textColor=UIColorFromRGB(rgbValue: TextBlackColor)
        titleLabel?.font = FontWithSize(size: 18)
        
        spaceY = spaceY + 35
        timeLabel = UILabel(frame: CGRect(x: spaceX, y: spaceY, width: kSCREEN_WIDTH - spaceX*2, height: 21))
        timeLabel?.textColor=UIColorFromRGB(rgbValue: TextLightDarkColor)
        timeLabel?.font = FontWithSize(size: 14)
        
        spaceY = spaceY + 31
        collectBtn = UIButton(frame: CGRect(x: spaceX, y: spaceY, width: 64, height: 30))
    
        collectBtn?.setImage(UIImage(named: "icon_play_collect"), for: UIControlState.normal)
        collectBtn?.setTitle("收藏", for: UIControlState.normal)
        collectBtn?.titleLabel?.font = FontWithSize(size: 14)
        collectBtn?.setTitleColor(UIColorFromRGB(rgbValue:TextLightDarkColor ), for: UIControlState.normal)
        collectBtn?.tag=1
        collectBtn?.addTarget(self, action: #selector(onItemClick(btn:)), for: UIControlEvents.touchUpInside)
        
        commentBtn = UIButton(frame: CGRect(x: spaceX+74, y: spaceY, width: 64, height: 30))
        commentBtn?.setImage(UIImage(named: "icon_play_comment"), for: UIControlState.normal)
        commentBtn?.setTitle("评论", for: UIControlState.normal)
        commentBtn?.titleLabel?.font = FontWithSize(size: 14)
        commentBtn?.setTitleColor(UIColorFromRGB(rgbValue:TextLightDarkColor ), for: UIControlState.normal)
        commentBtn?.tag=2
        commentBtn?.addTarget(self, action: #selector(onItemClick(btn:)), for: UIControlEvents.touchUpInside)
        
        spaceY = spaceY + 40
        
        scroll = UIScrollView(frame: CGRect(x: 0, y: spaceY, width: kSCREEN_WIDTH, height: kSCREEN_HEIGHT - spaceY - 10))
        scroll?.backgroundColor = UIColor.clear
        
        let df:CGRect = CGRect(x: spaceX, y: 0, width: kSCREEN_WIDTH-spaceX*2, height: 0)
        descLab = UILabel(frame: df)
        descLab?.numberOfLines = 0
        descLab?.textColor=UIColorFromRGB(rgbValue: TextLightDarkColor)
        descLab?.font = FontWithSize(size: 14)
        scroll?.addSubview(descLab!)
        
        self.view.addSubview(titleLabel!)
        self.view.addSubview(timeLabel!)
        self.view.addSubview(collectBtn!)
        self.view.addSubview(commentBtn!)
        self.view.addSubview(scroll!)
        
        self.view.addSubview(mhPlayer!)
        
        
        
        downLoadMessage()
        
        
        countClickNumber()
    }
    
    @objc func onItemClick(btn:UIButton)  {
        if btn.tag == 1{
            //收藏
            let params : NSMutableDictionary = NSMutableDictionary()
            params["collectiontType"] = (self.model?.collect)! ? convertIntToString(0) :convertIntToString(1)
            params["nid"] = convertIntToString((self.model?.nid)!)
            params["uid"] = convertIntToString(ZZDataCache.getInstance().getLoginUser().userId)
            ZZRequsetInterface.post(API_CollectChapter, param:params, timeOut: CGFloat(HttpPostTimeOut), start: {
                
            }, finish: { (_ obj:Any!, data:Data!) in
//                print(String.init(data: data, encoding: .utf8)!)
            }, complete: { (dictValue:Dictionary!) in
                
                if (self.model?.collect)! {
                    self.view.makeToast("取消收藏成功!")
                    self.collectBtn?.setImage(UIImage(named: "icon_play_collect"), for: UIControlState.normal)
                }else{
                    self.view.makeToast("收藏成功!")
                    self.collectBtn?.setImage(UIImage(named: "btn_collect"), for: UIControlState.normal)
                }
                
                self.model?.collect = !(self.model?.collect)!
                
            }, fail: { (_ obj:Any!, msg:String!,err:Error!) in
                self.view.makeToast(msg)
                print(err)
            },progress: { (_p:CGFloat) in
                
            })
        }
        
        if btn.tag == 2{
            //评论
            let comVC:ZZCommentController = ZZCommentController()
            comVC.nid = (self.model?.nid)!;
            comVC.model = self.model;
            self.navigationController?.pushViewController(comVC, animated: true)
        }
    }
    
    
    
    override func buttonClick(_ sender:Any!) {
        super.buttonClick(sender)
        let sd = sender as! UIButton
        if sd.tag == 1 {
            mhPlayer?.mhStopPlayer()
        }
    }
    
    func downLoadMessage() {
        let params : NSMutableDictionary = NSMutableDictionary()
        params["nid"] = convertIntToString((self.model?.nid)!)
        ZZRequsetInterface.post(API_getKnowledgeDetail, param:params, timeOut: CGFloat(HttpPostTimeOut), start: {
            
        }, finish: { (_ obj:Any!, data:Data!) in
            
        }, complete: { (dictValue:Dictionary!) in
            let v:Dictionary<String,Any> = dictValue["retData"]! as! Dictionary
            self.model = ZZChapterModel().createChapterModel(v) as? ZZChapterModel
            
            var df2:CGRect = (self.descLab?.frame)!
            
            self.titleLabel?.text = self.model?.title
            self.timeLabel?.text = self.model?.createTime
            self.descLab?.attributedText = self.getAttrString(text: (self.model?.content)!)
            
            df2.size.height = getLabHeigh(label:self.descLab!, width: df2.width)
            self.descLab?.frame = df2
            
            self.scroll?.contentSize = CGSize(width: kSCREEN_WIDTH, height: df2.size.height+10)
            
            if (self.model?.collect)! {
                self.collectBtn?.setImage(UIImage(named: "icon_play_collect"), for: UIControlState.normal)
            }else{
                self.collectBtn?.setImage(UIImage(named: "btn_collect"), for: UIControlState.normal)
            }
            
            ZZVoiceTools.share().stopPlayer()
            
        }, fail: { (_ obj:Any!, msg:String!,err:Error!) in
            
        },progress: { (_p:CGFloat) in
            
        })
    }
    
    
    // 记录播放数量
    func countClickNumber() {
        let params : NSMutableDictionary = NSMutableDictionary()
        params["idfabulousType"] = convertIntToString(3)
        params["nid"] = convertIntToString((self.model?.nid)!)
        params["uid"] = convertIntToString(ZZDataCache.getInstance().getLoginUser().userId)
        ZZRequsetInterface.post(API_CollectChapterFabulous, param:params, timeOut: CGFloat(HttpPostTimeOut), start: {
            
        }, finish: { (_ obj:Any!, data:Data!) in
            //                print(String.init(data: data, encoding: .utf8)!)
        }, complete: { (dictValue:Dictionary!) in
            
            
//            self.model?.collect = (self.model?.collect)! + 1
            
        }, fail: { (_ obj:Any!, msg:String!,err:Error!) in
//            self.view.makeToast(msg)
//            print(err)
        },progress: { (_p:CGFloat) in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if mhPlayer != nil {
            mhPlayer?.mhPlayPlayer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        if mhPlayer != nil {
            mhPlayer?.mhPausePlayer()
        }
    }
    
    func getAttrString(text:String) -> NSMutableAttributedString {
        var attributeString:NSMutableAttributedString?
        do{
            
            attributeString = try NSMutableAttributedString(data: (text.data(using: String.Encoding.unicode))!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            
            
            //设置字体大小
            attributeString?.addAttribute(NSAttributedStringKey.font,
                                         value: FontWithSize(size: 16),
                                         range: NSMakeRange(0,(attributeString?.length)!))
            attributeString?.addAttribute(NSAttributedStringKey.foregroundColor,
                                          value: UIColorFromRGB(rgbValue: TextLightDarkColor),
                                          range: NSMakeRange(0,(attributeString?.length)!))
            
//            return attributeString!
            
        }catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
        return attributeString!
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
        mhPlayer?.MHAVPlayerSDKDelegate = nil
        mhPlayer = nil
        self.goBack(nil)
    }
    
    
    
    func mhNextPlayer() {
        mhPlayer?.mhPlayerURL = "http://baobab.wdjcdn.com/1455782903700jy.mp4"
        mhPlayer?.mhPlayerTitle = "第二部";
    }
    
    
    func mhShareListener() {
        // 分享
        let sv:ZZShareView = ZZShareView.init(shareType: ZZShareType.chapter, vc: self)
        sv.shareModel = self.model
        sv.show()
    }
    
}
