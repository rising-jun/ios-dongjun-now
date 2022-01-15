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
        let userSliding: Observable<Void>?
        let userSlideEnd: Observable<Void>?
        let loginAction: Observable<Void>?
        
    }
    
    struct Output{
        var state: Driver<LoginState>?
    }
    
    private let disposeBag = DisposeBag()
    private var changePrice: Int = 0
    
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
            .withLatestFrom(state){ [weak self] price, state -> LoginState in
                var newState = state
                newState.price = price
                self?.calcChangePrice(price: price)
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.userSliding?
            .withLatestFrom(state){ price, state -> LoginState in
                var newState = state
                newState.animateStop = true
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.userSlideEnd?
            .withLatestFrom(state){ [weak self] price, state -> LoginState in
                var newState = state
                newState.sliderTouchable = false
                newState.changePrice = self!.changePrice
                return newState
            }.bind(to: self.state)
            .disposed(by: disposeBag)
        
        input.loginAction?
            .withLatestFrom(state)
            .map{ state -> LoginState in
            var newState = state
            newState.presentVC = .home
            return newState
        }.bind(to: self.state)
        .disposed(by: disposeBag)
        
        output = Output(state: state.asDriver())
        return output!
    }
    
        
    
    
}

extension LoginViewModel{
    func calcChangePrice(price: Int){
        self.changePrice = Int(Double(price) * 0.9)
    }
    
}

struct LoginState{
    var presentVC: PresentVC?
    var timeOver: Bool?
    var viewLogic: ViewLogic?
    var price: Int?
    var sliderTouchable: Bool? = true
    var animateStop: Bool? = false
    var changePrice: Int = 0
}
