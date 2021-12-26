//
//  ViewModelProtocol.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation

protocol ViewModelType: class{
    associatedtype Input
    associatedtype Output
    
    var input: Input? { get }
    var output: Output? { get }
}

