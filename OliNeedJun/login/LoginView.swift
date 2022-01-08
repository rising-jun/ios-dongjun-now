//
//  LoginView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import UIKit
import Then
import SnapKit

class LoginView: BaseView{
    
    let introLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "한달 기름값\n 얼마나 사용하시나요?"
        $0.numberOfLines = 2
        $0.sizeToFit()
    }
    
    let priceLabel = UILabel().then{
        $0.textAlignment = .center
        $0.textColor = CustomColor.oilBlue()
        $0.font = UIFont.boldSystemFont(ofSize: 28)
        $0.text = "5만원"
        $0.sizeToFit()
    }
    
    let oilPriceSlider = OilSliderView().then{
        $0.backgroundColor = .white
        $0.maximumValue = 50
        $0.minimumValue = 5
        $0.thumbTintColor = CustomColor.oilBlue()
        $0.tintColor = CustomColor.oilBlue()
        
    }
    
    
    override func setup() {
        super.setup()
        backgroundColor = .white
        addSubViews(introLabel, priceLabel, oilPriceSlider)
        
        introLabel.backgroundColor = .white
        introLabel.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(100)
        }
        
        priceLabel.backgroundColor = .yellow
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(introLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        oilPriceSlider.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(20)
            make.trailing.equalTo(self).offset(-50)
            make.left.equalTo(self).offset(50)
            make.height.equalTo(50)
        }
    
        
    }
    
}
//rgb(75, 118, 186)
