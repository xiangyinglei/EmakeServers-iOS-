//
//  IMUIGalleryCell.swift
//  IMUIChat
//
//  Created by wuxingchen on 2017/3/14.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import UIKit
import Photos

//相册视图
class IMUIGalleryCell: UICollectionViewCell, IMUIFeatureCellProtocol {
  //蒙层
  @IBOutlet weak var grayView: UIView!
    //  图片
  @IBOutlet weak var galleryImageView: UIImageView!
    //选择图片
  @IBOutlet weak var selectImageView: UIImageView!
    //视频
  @IBOutlet weak var mediaView: UIView!
  //视图播放层
  var playerLayer : AVPlayerLayer!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    playerLayer = AVPlayerLayer()
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    self.mediaView.layer.addSublayer(playerLayer)
    self.galleryImageView.layer.masksToBounds = true
    self.galleryImageView.layer.mask = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = self.mediaView.layer.bounds
  }
  
    //资源加载
  var asset : PHAsset?{
    didSet{
      switch asset!.mediaType {
      case .image:
        PHImageManager.default().requestImage(for: asset!, targetSize: self.frame.size, contentMode: PHImageContentMode.default, options: nil, resultHandler: { [weak self] (image, _) in
          self?.galleryImageView.image = image
          self?.galleryImageView.isHidden = false
          self?.mediaView.isHidden = true
          self?.playerLayer.player = nil
        })
        break
      case .audio, .video:
        galleryImageView.image = nil
        galleryImageView.isHidden = true
        mediaView.isHidden = false
        PHImageManager.default().requestPlayerItem(forVideo: self.asset!, options: nil, resultHandler: { [weak self] (avPlayerItem, _) in
          self?.contentView.sendSubview(toBack: (self?.mediaView)!)
          self?.playerLayer.player?.pause()
          let player = AVPlayer(playerItem: avPlayerItem)
          self?.playerLayer.player = player
          player.play()
        })
        
        break
      default:
        break
      }
      //去做动画
      animate(duration: 0)
      
    }
  }
  
  private var didSelect : Bool{
    get{
      return IMUIGalleryDataManager.selectedAssets.contains(asset!)
    }
  }
  
  func clicked(){
    if asset!.mediaType != .image {
      print("now only support send image type")
      return
    }
    
    if didSelect {
      IMUIGalleryDataManager.selectedAssets = IMUIGalleryDataManager.selectedAssets.filter({$0 != asset!})
    }else{
      IMUIGalleryDataManager.insertSelectedAssets(with: asset!)
    }
    animate(duration: 0.2)
  }
  //视图选择动画
  private func animate(duration:TimeInterval){
    var scale : CGFloat = 1
    //缩放比例
    if didSelect {
      scale = 0.9
    } else {
      scale = 1/0.9
    }
    
    UIView.animate(withDuration: duration, animations: { [weak self] in
      let transform = CGAffineTransform(scaleX: scale, y: scale)
        //先做动画
      self?.galleryImageView.transform = transform
      self?.grayView.transform = transform
      self?.mediaView.transform = transform
    }) {  [weak self] ( completion ) in
        //视图隐藏显示
      self?.selectImageView.isHidden = !(self?.didSelect)!
      self?.grayView.isHidden = !(self?.didSelect)!
      self?.contentView.bringSubview(toFront: (self?.grayView)!)
      self?.contentView.bringSubview(toFront: (self?.selectImageView)!)
    }
  }
  
}
