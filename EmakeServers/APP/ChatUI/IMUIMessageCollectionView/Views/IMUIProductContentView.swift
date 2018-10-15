//
//  IMUIProductContentView.swift
//  EmakeServers
//
//  Created by 谷伟 on 2018/4/27.
//  Copyright © 2018年 谷伟. All rights reserved.
//
import Foundation
import UIKit

public class IMUIProductContentView: UIView, IMUIMessageContentViewProtocol {
    
    var imageView = UIImageView()
    var productName = UILabel()
    var productPrice = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(productName)
        self.addSubview(productPrice)
        productName.numberOfLines = 2
        productPrice.numberOfLines = 2
        imageView.contentMode = .scaleAspectFit
        
    }
    required public init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    public func layoutContentView(message: IMUIMessageModelProtocol) {
        print("\(message.text())")
        let model = YHGoodsModel.mj_object(withKeyValues: message.text())
        imageView.frame = CGRect(x: 9, y:7, width: 65, height:59)
        productName.font = UIFont.systemFont(ofSize: 14)
        productPrice.font = UIFont.systemFont(ofSize: 18)
        if message.isOutGoing {
            productPrice.textColor = UIColor.white
        }else{
            productPrice.textColor = UIColor.black
        }
        
        productName.frame = CGRect(x: 80, y:7, width: 180, height:25)
        productPrice.frame = CGRect(x: 80, y:32, width: 180, height:25)
        productName.text = model?.goodsSeriesName
        productPrice.text =  model?.goodsPriceValue
        imageView.sd_setImage(with:NSURL.init(string: (model?.goodsImageUrl)!)! as URL , placeholderImage:nil)
    }

}