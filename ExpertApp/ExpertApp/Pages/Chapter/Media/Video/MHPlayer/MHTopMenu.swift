//
//  MHTopMenu.swift
//  MHPlayer
//
//  Created by kidd on 16/11/25.
//  Copyright © 2016年 CMCC. All rights reserved.
//

import UIKit

class MHTopMenu: UIView {
    
    /// 标题
    var mhAVTitle: String? {
        didSet {
            guard let title = mhAVTitle else { return }
            titleLabel.text = title
        }
    }
    
    /// 隐藏返回按钮,默认为NO
    var mhHiddenBackBtn: Bool?
    /// 返回按钮操作
    var mhTopGoBack: (() ->Void)?
    
    /// 分享按钮
    var mhTopShareListener:(()->Void)?
    
    fileprivate lazy var backButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "nav_back"), for: .normal)
        button.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.white
        return label
    }()
    
    fileprivate lazy var shareButton: UIButton = {
        let button = UIButton(type: UIButtonType.custom)
        button.setImage(UIImage(named: "nav_share"), for: .normal)
        button.addTarget(self, action: #selector(shareListener), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        addAllView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func addAllView() {
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(shareButton)
    }
}


// MARK: - 控制事件
extension MHTopMenu {
    
    @objc fileprivate func goBack() {
        
        if mhTopGoBack != nil {
            mhTopGoBack!()
        }
    }
    
    @objc fileprivate func shareListener() {
        
        if mhTopShareListener != nil {
            mhTopShareListener!()
        }
    }
    

}


// MARK: - 布局
extension MHTopMenu {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if mhHiddenBackBtn == true {
            backButton.removeFromSuperview()
            titleLabel.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
        }else {
            backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            backButton.contentMode = .center
            backButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
            titleLabel.isHidden = true
            
            titleLabel.frame = CGRect(x: 50, y: 5, width: 200, height: 30)
            
            shareButton.frame = CGRect(x: self.frame.width - 50, y: 0, width: 40, height: 40)
            shareButton.contentMode = .center
            shareButton.imageEdgeInsets = UIEdgeInsetsMake(5,5,5,5)
        }
    }
    
}
