//
//  LoginViewController.swift
//  OliNeedJun
//
//  Created by 김동준 on 2022/01/08.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxViewController

class LoginViewController: BaseViewController{
    
    lazy var v = LoginView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let viewModel = LoginViewModel()
    private lazy var input = LoginViewModel.Input(viewState: Observable.merge(self.rx.viewDidLoad.map{ViewState.viewDidLoad}.asObservable(),
                                                                              self.rx.viewDidAppear.map{_ in ViewState.viewDidAppear}.asObservable()),
                                                  priceValChanged: v.oilPriceSlider.rx.value.map{(Int($0) / 10) * 5}.distinctUntilChanged().asObservable(),
                                                  userSliding: v.oilPriceSlider.rx.controlEvent(.touchDown).map{Void()}.asObservable(),
                                                  userSlideEnd: v.oilPriceSlider.rx.controlEvent(.touchUpInside).map{Void()}.asObservable())
    private lazy var output = viewModel.bind(input: input)
    
    private let spaceThumb = PublishSubject<Float>()
    let arr: [Int] = []
    private var timer: Disposable!
    
    override func bindViewModel() {
        super.bindViewModel()
    
        output.state?.map{$0.viewLogic}
        .distinctUntilChanged()
        .drive(onNext: { [weak self] logic in
            guard let self = self else { return }
            if logic == .setUpView{
                self.setUpView()
            }else if logic == .setAnimate{
                self.setUpAnimation()
            }
        }).disposed(by: disposeBag)
        
        output.state?.map{$0.price ?? 5}
        .distinctUntilChanged()
        .map{$0 == 0 ? 5 : $0}
        .map{$0 == 50 ? "\($0)만원 이상" : "\($0)만원"}
        .drive(v.priceLabel.rx.text)
        .disposed(by: disposeBag)
        
        output.state?.map{$0.sliderTouchable ?? true}
        .distinctUntilChanged()
        .filter{$0 == false}
        .drive(onNext: { [weak self]  _ in
            guard let self = self else { return }
            self.v.oilPriceSlider.isUserInteractionEnabled = false
            UIView.animate(withDuration: 1.5) {
                self.v.showMakePrice()
            }
        }).disposed(by: disposeBag)
    
        output.state?.map{$0.animateStop ?? false}
        .distinctUntilChanged()
        .filter{$0 == true}
        .drive(onNext: { [weak self]  _ in
            guard let self = self else { return }
            self.timer.dispose()
           
        }).disposed(by: disposeBag)
        
        
        
    }
    
}

extension LoginViewController{
    func setUpView(){
        view = v
        print("setview")
    }
    
    func setUpAnimation(){
        print("setAnimation function")
        
        self.timer = PublishSubject<Int>
            .timer(.milliseconds(0), period: .milliseconds(300), scheduler: MainScheduler.instance)
            .take(5)
            .subscribe { sec in
                self.animateExcute(reapeat: sec)
            } onDisposed: {
                print("disposed timer")
            }
        
    
    }
    
    func animateExcute(reapeat: Int){
        let value = [15, 5, 0, 5, 0]
        UIView.animate(withDuration: 0.6, delay: 0.00, options: .allowUserInteraction) {
            self.v.oilPriceSlider.setValue(Float(value[reapeat]), animated: true)
        }
    }
    
}
