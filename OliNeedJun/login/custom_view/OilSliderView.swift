//
//  OilSliderVioew.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import UIKit
import RxSwift

class OilSliderView: UISlider{
    private let trackHeight: CGFloat = 5
    var spaceThumbAnimation: PublishSubject<Float>!
    
    var defaultThumbSpace: Float = 20
    lazy var startingOffset: Float = 0 - defaultThumbSpace
    lazy var endingOffset: Float = 2 * defaultThumbSpace
    
    
    func subscribeSpaceValue(){
        spaceThumbAnimation.distinctUntilChanged().bind { val in
            print(val)
            self.defaultThumbSpace = val
        }
    }
    
    
    
        override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
            print("defaultThumbSpace \(defaultThumbSpace)")
            var xTranslation: Float = 0.0
            xTranslation =  self.startingOffset + (self.minimumValue + self.endingOffset) / self.maximumValue * value
            return super.thumbRect(forBounds: bounds,
                                   trackRect: rect.applying(CGAffineTransform(translationX: CGFloat(xTranslation),
                                                                              y: 0)),
                                   value: value)
        }
    
    
    

}


