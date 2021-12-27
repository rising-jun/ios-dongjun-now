//
//  OilMapView.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import NMapsMap
import SnapKit
import Then


class OilMapView: BaseView{
    let mapView = NMFNaverMapView().then{
        $0.showLocationButton = false
        $0.showZoomControls = false
    }
    
    lazy var userLocationView = NMFLocationButton()
    
    let infoView = UIView().then{
        $0.backgroundColor = .white
    }
    
    
    override func setup() {
        super.setup()
        
        addSubViews(mapView, userLocationView, infoView)
        
        userLocationView.mapView = mapView.mapView
        
        mapView.snp.makeConstraints { make in
            make.height.width.equalTo(self)
        }
        
        infoView.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.height.equalTo(200)
            make.width.equalTo(self)
        }
        
        userLocationView.snp.makeConstraints { make in
            make.bottom.equalTo(infoView.snp.top).offset(10)
            make.trailing.equalTo(self)
            make.width.height.equalTo(80)
        }
    }

}
