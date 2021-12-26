//
//  OilMapView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import Then
import NMapsMap
import SnapKit

class OilMapView: BaseView{
    let mapView = NMFMapView()
    
    override func setup() {
        super.setup()
        
        addSubViews(mapView)
        mapView.snp.makeConstraints { make in
            make.height.width.equalTo(self)
        }
    }

}
