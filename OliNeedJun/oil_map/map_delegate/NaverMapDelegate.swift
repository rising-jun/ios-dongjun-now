//
//  NaverMapDelegate.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/28.
//

import Foundation
import NMapsMap
import RxSwift

class NaverMapDelegate: NSObject{
    var mapDidTap: PublishSubject<Void>!
    
}

extension NaverMapDelegate: NMFMapViewTouchDelegate{
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        mapDidTap.onNext(())
    }
    
}
