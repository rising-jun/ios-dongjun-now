//
//  MenuViewCell.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/15.
//

import Foundation
import UIKit
import SnapKit
import Then

class MenuViewCell: UICollectionViewCell{
    
    let infoView = UIView().then{
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 15
    }
    
    let infoLabel = UILabel().then{
        $0.text = "메뉴"
        $0.font = UIFont.boldSystemFont(ofSize: 22)
        $0.textColor = CustomColor.oilBlue()
        $0.textAlignment = .center
    }
    
    let subLabel = UILabel().then{
        $0.text = "설명설명"
        $0.font = UIFont.boldSystemFont(ofSize: 14)
        $0.adjustsFontSizeToFitWidth = true
        $0.textColor = CustomColor.oilBlue()
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubViews(infoView, infoLabel, subLabel)
        infoView.backgroundColor = .white
        infoView.snp.makeConstraints { make in
            make.width.height.equalTo(140)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.top.equalTo(infoView.snp.top).offset(20)
            make.centerX.equalTo(infoView)
            make.height.equalTo(50)
        }
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.leading.equalTo(infoView.snp.leading).offset(15)
            make.trailing.equalTo(infoView.snp_trailingMargin).offset(-15)
        }
        
    }
    
    
    
}
