//
//  HomeViewModel.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/15.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<HomeState>(value: HomeState())
    private let disposeBag = DisposeBag()
    
    struct Input{
        let viewState: Observable<ViewState>?
        let touchedPushScreen: Observable<PresentVC>?
    }
    
    struct Output{
        var state: Driver<HomeState>?
    }

    func bind(input: Input) -> Output{
        
        input.viewState?
            .filter{$0 == .viewDidLoad}
            .withLatestFrom(state){ viewState, state -> HomeState in
                var newState = state
                newState.viewLogic = .setUpView
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.touchedPushScreen?
            .distinctUntilChanged()
            .withLatestFrom(state){ presentVC, state -> HomeState in
                var newState = state
                newState.presentVC = presentVC
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        
        output = Output(state: state.asDriver())
        return output!
    }
    
}


struct HomeState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    var price: Int?
    var sliderTouchable: Bool? = true
    var animateStop: Bool? = false
    var changePrice: Int = 0
}
