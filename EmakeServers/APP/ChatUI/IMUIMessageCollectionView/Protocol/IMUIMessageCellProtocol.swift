//
//  IMUIMessageCellProtocol.swift
//  IMUIChat
//
//  Created by oshumini on 2017/4/14.
//  Copyright © 2017年 HXHG. All rights reserved.
//

import Foundation

protocol IMUIMessageCellProtocol {
    func presentCell(with message: IMUIMessageModelProtocol, selectSate: Bool, viewCache: IMUIReuseViewCache, delegate: IMUIMessageMessageCollectionViewDelegate?)
  func didDisAppearCell()

    func showMessageSelect(with isHidden: Bool)
    
    func selctMeaagseOption(with isSelected: Bool)
    
}

extension IMUIMessageCellProtocol {
  func didDisAppearCell() {}
}
