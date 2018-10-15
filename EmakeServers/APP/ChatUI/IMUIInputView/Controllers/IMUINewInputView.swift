//
//  IMUINewInputView.swift
//  EmakeServers
//
//  Created by 谷伟 on 2018/4/26.
//  Copyright © 2018年 谷伟. All rights reserved.
//

import UIKit
import Photos

enum IMUINewInputStatus {
    case text
    case microphone
    case photo
    case emoji
    case none
}

fileprivate var IMUIFeatureViewHeight:CGFloat = 130
fileprivate var IMUIShowFeatureViewAnimationDuration = 0.25

open class IMUINewInputView: UIView{

    @IBOutlet var view: UIView!
    
    @IBOutlet weak var topInputView: UIView!
    @IBOutlet weak var moreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var emojiButton: UIButton!
    @IBOutlet weak var microButton: UIButton!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var functionView: IMUINewFeatureView!
    var inputViewStatus: IMUINewInputStatus = .none
    open weak var inputViewDelegate: IMUINewInputViewDelegate?
    override public init(frame: CGRect) {
        super.init(frame: frame)
        let bundle = Bundle.imuiNewInputViewBundle()
        view = bundle.loadNibNamed("IMUINewInputView", owner: self, options: nil)?.first as! UIView

        self.addSubview(view)
        view.frame = self.bounds
        self.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.inputTextView.layer.borderWidth = 1;
        self.inputTextView.layer.cornerRadius = 3;
        inputTextView.textContainer.lineBreakMode = .byWordWrapping
        inputTextView.delegate = self
        self.functionView.delegate = self;
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(doNothing))
        self.topInputView.addGestureRecognizer(gesture)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardFrameChanged(_:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bundle = Bundle.imuiNewInputViewBundle()
        view = bundle.loadNibNamed("IMUINewInputView", owner: self, options: nil)?.first as! UIView
        
        self.addSubview(view)
        view.frame = self.bounds
        self.inputTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.inputTextView.layer.borderWidth = 1;
        self.inputTextView.layer.cornerRadius = 3;
        inputTextView.textContainer.lineBreakMode = .byWordWrapping
        inputTextView.delegate = self
        self.functionView.delegate = self;
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(doNothing))
        self.topInputView.addGestureRecognizer(gesture)
    }
    func keyboardFrameChanged(_ notification: Notification) {
        let dic = NSDictionary(dictionary: (notification as NSNotification).userInfo!)
        let keyboardValue = dic.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        var bottomDistance = UIScreen.main.bounds.size.height - keyboardValue.cgRectValue.origin.y
        let duration = Double(dic.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
        if UIScreen.main.bounds.size.height == 812{
            bottomDistance = bottomDistance - 36
        }
        UIView.animate(withDuration: duration) {
            if bottomDistance > 10.0 {
                IMUIFeatureViewHeight = bottomDistance
                self.inputViewDelegate?.keyBoardWillShow?(height: keyboardValue.cgRectValue.size.height, durationTime: duration)
                self.moreViewHeight.constant = IMUIFeatureViewHeight
            }
            self.superview?.layoutIfNeeded()
        }
    }
    
    func fitTextViewSize(_ textView: UITextView) {
        let width = UIScreen.main.bounds.size.width - 121;
        let textViewFitSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        self.inputViewHeight.constant = textViewFitSize.height + 18
    }
    
    open func hideFeatureView() {
        UIView.animate(withDuration: IMUIShowFeatureViewAnimationDuration) {
            self.moreViewHeight.constant = 0
            self.inputTextView.resignFirstResponder()
            self.superview?.layoutIfNeeded()
        }
    }
    open func hideInputView() {
        UIView.animate(withDuration: IMUIShowFeatureViewAnimationDuration) {
            self.moreViewHeight.constant = 0
            self.inputViewHeight.constant = 0
            self.view?.isHidden = true;
            self.inputTextView.resignFirstResponder()
            self.superview?.layoutIfNeeded()
        }
    }
    open func showFeatureView(with type: IMUINewFeatureType) {
        UIView.animate(withDuration: IMUIShowFeatureViewAnimationDuration) {
            if type == .emoji {
                self.moreViewHeight.constant = 200
            }else{
                self.moreViewHeight.constant = 130
            }
            self.superview?.layoutIfNeeded()
        }
    }
    
    func clickSendBtn() {
        
        if inputTextView.text != "" {
            inputViewDelegate?.sendTextMessage?(self.inputTextView.text)
            inputTextView.text = ""
            fitTextViewSize(inputTextView)
        }
    }
    @objc func doNothing(){
        self.hideFeatureView();
    }
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    //语音
    @IBAction func switchToMicroOption(_ sender: Any) {
        self.inputTextView.resignFirstResponder()
        self.functionView.layoutFeature(with: .voice)
        self.showFeatureView(with: .voice)
        self.inputViewDelegate?.showOptionView!()
    }
    //表情
    @IBAction func switchToEmojiOption(_ sender: Any) {
        self.inputTextView.resignFirstResponder()
        self.functionView.layoutFeature(with: .emoji)
        self.showFeatureView(with: .emoji)
        self.inputViewDelegate?.showOptionView!()
    }
    //更多操作
    @IBAction func switchToMoreOption(_ sender: Any) {
        self.inputTextView.resignFirstResponder()
        self.functionView.layoutFeature(with:.option)
        self.showFeatureView(with:.option)
        self.inputViewDelegate?.showOptionView!()
    }
    
}
// MARK: - UITextViewDelegate
extension IMUINewInputView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        self.fitTextViewSize(textView)
    }
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
       inputViewStatus = .text
        return true
    }
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.contains("\n") {
            self.clickSendBtn()
            return false
        }
        return true
    }
    
}
extension IMUINewInputView: IMUINewFeatureViewDelegate {
    public func startRecordVoice() {
        print("startRecordVideo")
        self.inputViewDelegate?.startRecordVoice!()
    }
    
    public func didSelectPhoto() {
        print("didSelectPhoto")
        self.inputViewDelegate?.didSeletedGallery?()
    }
    
    public func didShotPicture() {
        print("didShotPicture")
        self.inputViewDelegate?.didSelectShootPicture?()
    }
    
    public func didSeletedEmoji(with emoji: IMUIEmojiModel) {
        print("didSeletedEmoji")
        self.inputTextView.text.append(emoji.emoji!)
        self.fitTextViewSize(self.inputTextView)
    }
    
    public func didSelectedConvenientReply() {
        print("didSelectedConvenientReply")
        self.inputViewDelegate?.didSelectConnvientReply?()
    }
    
    public func didSelectedProfuct() {
        print("didSelectedProfuct")
        self.inputViewDelegate?.didSelectProduct?()
    }
    public func didRecordVideo(with videoPath: String, durationTime: Double) {
        print("didRecordVideo")
        self.inputViewDelegate?.finishRecordVoice!(videoPath, durationTime: durationTime)
    }
    public func onSelectedFeature(with cell: IMUIFeatureListIconCell) {
        switch cell.featureData!.featureType {
        case .emoji:
            break
        default:
            break
        }
    }
}
