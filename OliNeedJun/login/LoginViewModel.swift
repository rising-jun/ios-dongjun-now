//
//  LoginViewModel.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType{
    var input: Input?
    var output: Output?
    
    private let state = BehaviorRelay<LoginState>(value: LoginState())
    
    struct Input{
        
        let viewState: Observable<ViewState>?
        let priceValChanged: Observable<Int>?
        
        
    }
    
    struct Output{
        var state: Driver<LoginState>?
    }
    
    private let disposeBag = DisposeBag()
    
    func bind(input: Input) -> Output{
        self.input = input
            
        input.viewState?
            .withLatestFrom(state){ viewState, state -> LoginState in
                var newState = state
                viewState == .viewDidLoad ? (newState.viewLogic = .setUpView) : (newState.viewLogic = .setAnimate)

                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.priceValChanged?
            .distinctUntilChanged()
            .withLatestFrom(state){ price, state -> LoginState in
                var newState = state
                newState.price = price
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
        
    
    
}



struct LoginState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    var price: Int?
    
}
