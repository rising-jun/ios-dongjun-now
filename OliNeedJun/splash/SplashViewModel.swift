//
//  SplashViewModel.swift
//  OliNeedJun
//
//  Created by 김동준 on 2021/12/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SplashViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<SplashState>(value: SplashState())
    
    struct Input{
        let timeOver: Observable<Bool>?
        let viewState: Observable<ViewState>?
    }
    
    struct Output{
        var state: Driver<SplashState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input

        input.timeOver?
            .withLatestFrom(state){ done, state -> SplashState in
                var newState = state
                newState.presentVC = .oilMap
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
            
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> SplashState in
                var newState = state
                newState.viewLogic = .setUpView
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
    
}



struct SplashState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    
}

enum ViewLogic{
    case setUpView
}
