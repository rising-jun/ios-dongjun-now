//
//  HomeVioew.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/15.
//

import Foundation
import UIKit
import SnapKit
import Then

class HomeView: BaseView{

    var menuCV: UICollectionView!
    
    override func setup() {
        super.setup()
        backgroundColor = CustomColor.oilBlue()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        menuCV = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubViews(menuCV)
        
        menuCV.backgroundColor = CustomColor.oilBlue()
        menuCV.showsHorizontalScrollIndicator = false
        menuCV.snp.makeConstraints { make in
            make.bottom.equalTo(self.snp.bottom).offset(-120)
            make.height.equalTo(150)
            make.leading.equalTo(self).offset(30)
            make.trailing.equalTo(self).offset(-30)
        }
        
    }
    
    
    
}
