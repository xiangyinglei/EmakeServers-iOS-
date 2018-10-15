//
//  IMUIBaseMessageCell.swift
//  IMUIChat
//
//  Created by oshumini on 2017/3/2.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
typealias SelectBlock = (_ selectState:Bool) -> Void
enum IMUIMessageCellType {
  case incoming
  case outgoing
}

open class IMUIBaseMessageCell: UICollectionViewCell, IMUIMessageCellProtocol {
    
    
  open static var avatarCornerRadius:CGFloat = 0
  
  var bubbleView: IMUIMessageBubbleView
  lazy var avatarImage = UIImageView()
  lazy var timeLabel = UILabel()
  lazy var nameLabel = UILabel()
  lazy var selectMessageButton = UIButton(type:.custom)
  lazy var isShowSelect = true;
    
  weak var statusView: UIView?
  weak var bubbleContentView: IMUIMessageContentViewProtocol?
  var bubbleContentType = ""
  weak var delegate: IMUIMessageMessageCollectionViewDelegate?
  var selectblock : SelectBlock?
  var message: IMUIMessageModelProtocol?
  
  override init(frame: CGRect) {

    bubbleView = IMUIMessageBubbleView(frame: CGRect.zero)
    super.init(frame: frame)
    self.contentView.addSubview(self.bubbleView)
    self.contentView.addSubview(self.avatarImage)
    self.contentView.addSubview(self.timeLabel)
    self.contentView.addSubview(self.nameLabel)
    self.contentView.addSubview(self.selectMessageButton)
    
    let bubbleGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBubbleView))
    let longPressBubbleGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longTapBubbleView))
    bubbleGesture.numberOfTapsRequired = 1
    self.bubbleView.isUserInteractionEnabled = true
    self.bubbleView.addGestureRecognizer(bubbleGesture)
    self.bubbleView.addGestureRecognizer(longPressBubbleGesture)
    
    let avatarGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHeaderImage))
    avatarGesture.numberOfTapsRequired = 1
    avatarImage.isUserInteractionEnabled = true
    avatarImage.addGestureRecognizer(avatarGesture)
    
    nameLabel.font = UIFont.systemFont(ofSize: 12)
    self.setupSubViews()
  }
  
  fileprivate func setupSubViews() {
    timeLabel.textAlignment = .center
    timeLabel.textColor = IMUIMessageCellLayout.timeStringColor
    timeLabel.font = IMUIMessageCellLayout.timeStringFont
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layoutCell(with layout: IMUIMessageCellLayoutProtocol, viewCache: IMUIReuseViewCache, selectSate: Bool) {
    
    self.timeLabel.frame = layout.timeLabelFrame
    self.avatarImage.frame = layout.avatarFrame
    self.bubbleView.frame = layout.bubbleFrame
    self.nameLabel.frame = layout.nameLabelFrame
    self.selectMessageButton.isHidden = true;
    self.selectMessageButton.setImage(UIImage(named: "shopping_cart_select_no2x"), for: .normal)
    self.selectMessageButton.setImage(UIImage(named: "shopping_cart_select_yes"), for: .selected)
    self.selectMessageButton.addTarget(self, action: #selector(selectMessage), for: .touchUpInside)
    self.selectMessageButton.isSelected = selectSate
    
    self.removeStatusView(viewCache: viewCache)
    self.statusView = viewCache.statusViewCache.dequeue(layout: layout ) as? UIView
    self.contentView.addSubview(self.statusView!)
    self.addGestureForStatusView()
    self.nameLabel.textColor = UIColor.hexStringToUIColor(hex: "33333");
    self.statusView!.frame = layout.statusViewFrame
    self.avatarImage.layer.masksToBounds = true
    self.avatarImage.layer.cornerRadius = layout.avatarFrame.width/2
    
    let bubbleContentType = layout.bubbleContentType
    self.removeBubbleContentView(viewCache: viewCache, contentType: bubbleContentType)
    
    self.bubbleContentView = viewCache[bubbleContentType]!.dequeueContentView(layout: layout)
    self.bubbleContentType = bubbleContentType
    self.bubbleView.addSubview(self.bubbleContentView as! UIView)
    (self.bubbleContentView as! UIView).frame = UIEdgeInsetsInsetRect(CGRect(origin: CGPoint.zero, size: layout.bubbleFrame.size), layout.bubbleContentInset)
  }
  
  func addGestureForStatusView() {
    for recognizer in self.statusView?.gestureRecognizers ?? [] {
      self.statusView?.removeGestureRecognizer(recognizer)
    }
    let statusViewGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapSatusView))
    statusViewGesture.numberOfTapsRequired = 1
    self.statusView?.isUserInteractionEnabled = true
    self.statusView?.addGestureRecognizer(statusViewGesture)
  }
  
  func removeStatusView(viewCache: IMUIReuseViewCache) {
    if let view = self.statusView {
      viewCache.statusViewCache.switchViewToNotInUse(reuseView: self.statusView as! IMUIMessageStatusViewProtocol)
      view.removeFromSuperview()
    } else {
      for view in self.contentView.subviews {
        if let _ = view as? IMUIMessageStatusViewProtocol {
          viewCache.statusViewCache.switchViewToNotInUse(reuseView: view as! IMUIMessageStatusViewProtocol)
          view.removeFromSuperview()
        }
      }
    }
  }
    
  func removeBubbleContentView(viewCache: IMUIReuseViewCache, contentType: String) {
    for view in self.bubbleView.subviews {
      if let _ = view as? IMUIMessageContentViewProtocol {
        viewCache[self.bubbleContentType]?.switchViewToNotInUse(reuseView: view as! IMUIMessageContentViewProtocol)
        view.removeFromSuperview()
      }
    }
  }
  

  func setupData(with message: IMUIMessageModelProtocol) {
    if message.isOutGoing {
        let HeadImage = UserDefaults.standard.string(forKey:"HeadImageUrl")
        
        if HeadImage != nil{
            self.avatarImage.sd_setImage(with:NSURL.init(string: HeadImage!) as! URL, placeholderImage: UIImage.init(named:"kefu_logo"), options: .lowPriority,completed:nil)
        }
    }else{
        if message.fromUser.displayName().contains("客服"){
            self.avatarImage.sd_setImage(with:NSURL.init(string: message.fromUser.Avatar()) as! URL , placeholderImage: UIImage.init(named:"kefu_logo"))
        }else{
            self.avatarImage.sd_setImage(with:NSURL.init(string: message.fromUser.Avatar()) as! URL , placeholderImage: UIImage.init(named:"login_logo"))
        }
    }
    self.bubbleView.backgroundColor = UIColor.init(netHex: 0xE7EBEF)
    self.timeLabel.text = message.timeString
    
    
    if message.isOutGoing {
        self.nameLabel.textAlignment = .right
        if UserDefaults.standard.string(forKey:"ServiceID") != nil {
            let customName = UserDefaults.standard.string(forKey:"ServiceID") as! String
            self.nameLabel.text = "客服" + customName
        }else{
            self.nameLabel.text = "客服"
        }
    }else{
        print( message.fromUser.displayName())
        self.nameLabel.text = message.fromUser.displayName()
    }
    if message.isOutGoing {
        self.selectMessageButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.selectMessageButton.center = CGPoint(x:25, y: self.bubbleView.center.y)
    }else{
        self.selectMessageButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.selectMessageButton.center = CGPoint(x:UIScreen.main.bounds.size.width-25, y: self.bubbleView.center.y)
    }
    switch message.layout.bubbleContentType{
    case "Image":
        print("(图片)");
    case "File":
        print("(文件)");
    case "Voice":
        print("(声音)");
    case "Text":
        print("(文字)");
    default:
        self.selectMessageButton.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    self.selectMessageButton.isHidden = self.isShowSelect;
    self.bubbleContentView?.layoutContentView(message: message)
    self.message = message
    
    self.bubbleView.setupBubbleImage(resizeBubbleImage: message.resizableBubbleImage)
    
    let statusView = self.statusView as! IMUIMessageStatusViewProtocol
    switch message.messageStatus {
      case .sending:
        statusView.layoutSendingStatus()
        break
      case .failed:
        statusView.layoutFailedStatus()
        break
      case .success:
        statusView.layoutSuccessStatus()
        break
      case .mediaDownloading:
        statusView.layoutMediaDownloading()
        break
      case .mediaDownloadFail:
        statusView.layoutMediaDownloadFail()
    }
    
    if message.isOutGoing {
      self.nameLabel.textAlignment = .right
    } else {
      self.nameLabel.textAlignment = .left
    }
  }
  
  func presentCell(with message: IMUIMessageModelProtocol, selectSate: Bool, viewCache: IMUIReuseViewCache, delegate: IMUIMessageMessageCollectionViewDelegate?) {

    self.layoutCell(with: message.layout, viewCache: viewCache, selectSate: selectSate)
    self.setupData(with: message)
    self.delegate = delegate
  }
  
  func selectMessage(){
    
        if self.selectMessageButton.isSelected{
            self.delegate?.messageCollectionView?(didDeSelectMessageBubbleInCell: self, model: self.message!)
            if (self.selectblock != nil){
                
                self.selectblock!(!self.selectMessageButton.isSelected)
            }else{
               
            }
        }else{
            self.delegate?.messageCollectionView?(didSelectMessageBubbleInCell: self, model: self.message!)
            if (self.selectblock != nil){
                self.selectblock!(!self.selectMessageButton.isSelected)
            }
        }
        self.selectMessageButton.isSelected = !self.selectMessageButton.isSelected
    }
    
  func tapBubbleView() {
    self.delegate?.messageCollectionView?(didTapMessageBubbleInCell: self, model: self.message!)
  }
  
  func longTapBubbleView(sender: UITapGestureRecognizer) {
    if (sender.state == .began) {
        self.delegate?.messageCollectionView?(beganLongTapMessageBubbleInCell: self, model: self.message!)
    }
  }
  
  func tapHeaderImage() {
    self.delegate?.messageCollectionView?(didTapHeaderImageInCell: self, model: self.message!)
  }
  
  func tapSatusView() {
    self.delegate?.messageCollectionView?(didTapStatusViewInCell: self, model: self.message!)
  }
  
  func didDisAppearCell() {
  }
    func showMessageSelect(with isHidden: Bool) {
        self.isShowSelect = isHidden;
        self.selectMessageButton.isHidden = !isHidden
    }
    func selctMeaagseOption(with isSelected: Bool) {
        self.selectMessageButton.isSelected = isSelected
    }
    func selctOneMeaagseOption(with isSelected: Bool) {
        
    }
}
