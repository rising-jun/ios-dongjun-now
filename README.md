# ios-dongjun-now
## 오일나우 벤차마킹
   - 지도 위 주유소 정보 화면
   
## 앱 구조

  RxSwift + MVVM을 사용하였습니다.
  <img width="1071" alt="스크린샷 2021-12-29 오전 1 57 32" src="https://user-images.githubusercontent.com/62687919/147589335-587e86d1-74df-4af3-b208-53ba0bc9385e.png">
  
  - View는 하나의 ViewModel과 Binding되어 있습니다.
  - View에서의 Action들은 input을 통하여 ViewModel로 전달됩니다.
  - ViewModel은 전달받은 Action에 맞는 로직을 한 후 State를 업데이트 합니다.
  - GasStationList등 네트워크가 필요한 작업은 그에 맞는 Model에게 요청합니다. (가짜 데이터를 이용했기에 네트워크 작업은 하지 않았습니다.)
  - ViewController는 ViewModel의 State를 구독하여 변경되는 값이 있다면 Binding을 통하여 View를 업데이트 합니다.
  - RxCocoa의 Drive를 사용하였습니다.
  
## 변경 해본 View
![before](https://user-images.githubusercontent.com/62687919/147589519-ed9f2682-e66b-47b6-bfba-57fe5cd9c65c.gif)
![changed](https://user-images.githubusercontent.com/62687919/147589530-d8e6c510-8ba5-462b-8d66-ca7a014d7789.gif)
     
  - GasStationInfoView가 바로 사라지는 대신 애니메이션을 삽입하여 자연스러워 보이도록 변경하였습니다.
   
## 사용 라이브러리
     
     'RxSwift', 'RxViewController', 'NMapsMap', 'RxCocoa', 'SnapKit', 
     'Then'
