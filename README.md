# WWS-iOS

<div align="center">
 <img alt="websosoMainImage" src="https://github.com/Team-WSS/WSS-iOS/assets/87518742/7dbfadfe-c721-4ec0-8937-bd212edd2b69">
 
 ### _**🌠 웹소소, 새로운 세상으로의 포털을 열다. 🌠**_
 _**쉽게 기록하고, 재밌게 기억하고, 마음껏 몰입하기 위해.**_ 
 </div>


## 🌠 About WSS
> 📅 1차 스프린트 기간: 2023.12.17 - 2024.01.20

"웹소설도 소설이다." 33기 DO SOPT 앱잼에서 탄생한 웹소소는 웹소설을 더욱 간편하게 기록하고 기억할 수 있는 플랫폼입니다. 웹소설 헤비 이용자들을 타겟으로 하며, 사용자들의 편의를 증진시키고 웹소설에 대한 몰입감을 더욱 깊게 만들어주는 특별한 경험을 제공합니다. 간단하게 기록하고, 재미있게 기억하며, 마음껏 몰입하기 위한 새로운 앱 서비스로 여러분을 초대합니다.
<br>

## 🎈[Guest book](https://github.com/Team-WSS/WSS-iOS/issues/14) 

<br>


## 🧑‍💻 Authors
> 🎠 백마 탄 패왕흑막의 아요대공자들이 살아남는 법

</div>
</details>

|<img width="250px" alt="지원" src="https://github.com/Team-WSS/WSS-iOS/assets/87518742/c902ad7d-4a2a-4964-b3e6-76c4ab5fbdb0">|<img width="250px" alt="윤학" src="https://github.com/Team-WSS/WSS-iOS/assets/87518742/e09c52e1-2876-49c0-9a32-33eb204590ea">|<img width="250px" alt="서연" src="https://github.com/Team-WSS/WSS-iOS/assets/87518742/b2b350b4-cf4a-4469-8e3d-320b4a7fd7fa">|<img width="250px" alt="효원" src="https://github.com/Team-WSS/WSS-iOS/assets/87518742/e46f7d9c-41cb-4fcb-8ba5-52acbd208bb3">|
|:----:|:----:|:----:|:----:|
|[신지원](https://github.com/ena-isme)|[이윤학](https://github.com/Naknakk)|[최서연](https://github.com/chetseoo)|[전효원](https://github.com/hyowon612)|

<br>

## 📕 Coding Convention
> StyleShare 프로젝트 Convention을 기본으로 하되, 구성원들의 합의 하에 필요한 부분들을 수정하였다.
<details>
<summary> 살펴보기 </summary>
<div>
 
## 코드 레이아웃

### 들여쓰기 및 띄어쓰기

- 들여쓰기에는 탭(tab)
- 콜론(`:`)을 쓸 때에는 콜론의 오른쪽에만 공백을 둡니다.
    
    ```
    let names: [String: String]?
    ```
    
- 연산자 오버로딩 함수 정의에서는 연산자와 괄호 사이에 한 칸 띄어씁니다.
    
    ```
    func ** (lhs: Int, rhs: Int)
    ```
    

### 줄바꿈

- 함수를 호출하는 코드가 최대 길이를 초과하는 경우에는 **파라미터** 이름을 기준으로 줄바꿈합니다.
    
    ```
    let actionSheet = UIActionSheet(
      title: "정말 계정을 삭제하실 건가요?",
      delegate: self,
      cancelButtonTitle: "취소",
      destructiveButtonTitle: "삭제해주세요"
    )
    ```
    
    단, 파라미터에 클로저가 2개 이상 존재하는 경우에는 무조건 내려쓰기합니다.
    
    +) 후행 클로저 사용은 안됨!
    
    ```
    UIView.animate(
      withDuration: 0.25,
      animations: {
        // doSomething()
      },
      completion: { finished in
        // doSomething()
      }
    )
    ```
    
- `if let` 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다.
    
    ```
    if let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
       let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
      user.gender == .female {
      // ...
    }
    ```
    
- `guard let` 구문이 길 경우에는 줄바꿈하고 한 칸 들여씁니다. `else`는 `guard`와 같은 들여쓰기를 적용합니다.
    
    ```
    guard let user = self.veryLongFunctionNameWhichReturnsOptionalUser(),
          let name = user.veryLongFunctionNameWhichReturnsOptionalName(),
          user.gender == .female
    else {
      return
    }
    ```
    

### 빈 줄

- 모든 파일은 빈 줄로 끝나도록 합니다.
- MARK 구문 위와 아래에는 공백이 필요합니다.
    
    ```
    // MARK: Layout
    
    override func layoutSubviews() {
      // doSomething()
    }
    
    // MARK: Actions
    
    override func menuButtonDidTap() {
      // doSomething()
    }
    ```
    

### 임포트

모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.

import는 최소화한다. - ex. UIKit은 Foundation을 포함하고 있음.

```
import UIKit

import SwiftyColor
import SwiftyImage
import Then
import URLNavigator
```

## 네이밍

### 클래스와 구조체

- 클래스와 구조체의 이름에는 UpperCamelCase를 사용합니다.
- 클래스 이름에는 접두사Prefix를 붙이지 않습니다.
    
    **좋은 예:**
    
    ```swift
    class SomeClass {
      // class definition goes here
    }
    
    struct SomeStructure {
      // structure definition goes here
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    class someClass {
    // class definition goes here
    }
    
    struct someStructure {
    // structure definition goes here
    }
    ```
    

### 함수

- 함수 이름에는 lowerCamelCase를 사용합니다.
- 함수 이름 앞에는 되도록이면 `get`을 붙이지 않습니다.
- 매개변수 명은 함수명과 이어져서 이해하기 편하게
    
    **좋은 예:**
    
    ```swift
    func name(for user: User) -> String?
    ```
    
    **나쁜 예:**
    
    ```swift
    func getName(for user: User) -> String?
    ```
    
- Action 함수의 네이밍은 '주어 + 동사 + 목적어' 형태를 사용합니다.
    - Tap(눌렀다 뗌)*은 `UIControlEvents`의 `.touchUpInside`에 대응하고, *Press(누름)*는 `.touchDown`에 대응합니다.
    - *will~*은 특정 행위가 일어나기 직전이고, *did~*는 특정 행위가 일어난 직후입니다.
    - *should~*는 일반적으로 `Bool`을 반환하는 함수에 사용됩니다.
    
    **좋은 예:**
    
    ```swift
    func backButtonDidTap() {
      // ...
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    func back() {
      // ...
    }
    
    func pressBack() {
      // ...
    }
    ```
    

### 변수

- 변수 이름에는 lowerCamelCase를 사용합니다.

### 상수

- 상수 이름에도 lowerCamelCase를 사용합니다.
    
    **좋은 예:**
    
    ```
    let maximumNumberOfLines = 3
    ```
    
    **나쁜 예:**
    
    ```
    let MaximumNumberOfLines = 3
    let MAX_LINES = 3
    ```
    

### 열거형

- enum의 이름에는 UpperCamelCase를 사용합니다.
- enum의 각 case에는 lowerCamelCase를 사용합니다.
    
    **좋은 예:**
    
    ```
    enum Result {
      case .success
      case .failure
    }
    ```
    
    **나쁜 예:**
    
    ```
    enum Result {
      case .Success
      case .Failure
    }
    
    enum result {
      case .Success
      case .Failure
    }
    ```
    

### 프로토콜

- 프로토콜의 이름에는 UpperCamelCase를 사용합니다.
- 구조체나 클래스에서 프로토콜을 채택할 때는 콜론과 빈칸을 넣어 구분하여 명시합니다.
- extension을 통해 채택할 때도 동일하게 적용됩니다.
- 최대한 요구사항이 있는 프로토콜을 채택할 때는 extension에서 채택하고 구현합시다!
    
    **좋은 예:**
    
    ```swift
    protocol SomeProtocol {
      // protocol definition goes here
    }
    
    struct SomeStructure: SomeProtocol, AnotherProtocol {
      // structure definition goes here
    }
    
    class SomeClass: SomeSuperclass, SomeProtocol, AnotherProtocol {
        // class definition goes here
    }
    
    extension UIViewController: SomeProtocol, AnotherProtocol {
      // doSomething()
    }
    ```
    

### 약어

- 약어로 시작하는 경우 소문자로 표기하고, 그 외의 경우에는 항상 대문자로 표기합니다.
    
    **좋은 예:**
    
    ```swift
      let userID: Int?
      let html: String?
      let websiteURL: URL?
      let urlString: String?
    
    ```
    
    **나쁜 예:**
    
    ```swift
      let userId: Int?
      let HTML: String?
      let websiteUrl: NSURL?
      let URLString: String?
    
    ```
    

### Delegate

- Delegate 메서드는 프로토콜명으로 네임스페이스를 구분합니다.
    
    **좋은 예:**
    
    ```swift
    protocol UserCellDelegate {
      func userCellDidSetProfileImage(_ cell: UserCell)
      func userCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    protocol UserCellDelegate {
      func didSetProfileImage()
      func followPressed(user: User)
    
      // `UserCell`이라는 클래스가 존재할 경우 컴파일 에러 발생
      func UserCell(_ cell: UserCell, didTapFollowButtonWith user: User)
    }
    ```
    

## 클로저

- 파라미터와 리턴 타입이 없는 Closure 정의시에는 `() -> Void`를 사용합니다.
    
    **좋은 예:**
    
    ```swift
    let completionBlock: (**() -> Void**)?
    ```
    
    **나쁜 예:**
    
    ```swift
    let completionBlock: (() -> ())?
    let completionBlock: ((Void) -> (Void))?
    ```
    
- Closure 정의시 파라미터에는 괄호를 사용하지 않습니다.
    
    **좋은 예:**
    
    ```swift
    { operation, responseObject in
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    { (operation, responseObject) in
      // doSomething()
    }
    ```
    
- Closure 정의시 가능한 경우 타입 정의를 생략합니다.
    
    **좋은 예:**
    
    ```swift
    ...,
    completion: { finished in
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    ...,
    completion: { (finished: Bool) -> Void in
      // doSomething()
    }
    ```
    
- Closure 호출시 또다른 유일한 Closure를 마지막 파라미터로 받는 경우, 파라미터 이름을 생략합니다. (클로저가 하나인 경우에만! 두 개 이상인 경우 생략하지 말고 파라미터 이름을 명시해 줄 것.)
    
    **좋은 예:**
    
    ```swift
    UIView.animate(withDuration: 0.5) {
      // doSomething()
    }
    ```
    
    **나쁜 예:**
    
    ```swift
    UIView.animate(withDuration: 0.5, animations: { () -> Void in
      // doSomething()
    })
    ```
    

## 클래스와 구조체

- 클래스와 구조체 내부에서는 `self`를 명시적으로 사용합니다.
- 구조체를 생성할 때에는 Swift 구조체 생성자를 사용합니다.
    
    **좋은 예:**
    
    ```swift
    let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    ```
    
    **나쁜 예:**
    
    ```swift
    let frame = CGRectMake(0, 0, 100, 100)
    ```
    

## 타입

- `Array<T>`와 `Dictionary<T: U>` 보다는 `[T]`, `[T: U]`를 사용합니다.
    
    **좋은 예:**
    
    ```swift
    var messages: [String]?
    var names: [Int: String]?
    ```
    
    **나쁜 예:**
    
    ```swift
    var messages: Array<String>?
    var names: Dictionary<Int, String>?
    ```
    

## 주석

- `///`를 사용해서 문서화에 사용되는 주석을 남깁니다.
    
    ```
    /// 사용자 프로필을 그려주는 뷰
    class ProfileView: UIView {
    
      /// 사용자 닉네임을 그려주는 라벨
      var nameLabel: UILabel!
    }
    ```
    
- `// MARK:`를 사용해서 연관된 코드를 구분짓습니다.
    
    Objective-C에서 제공하는 `#pragma mark`와 같은 기능으로, 연관된 코드와 그렇지 않은 코드를 구분할 때 사용합니다.
    
    ```
    // MARK: Init
    
    override init(frame: CGRect) {
      // doSomething()
    }
    
    deinit {
      // doSomething()
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
      // doSomething()
    }
    
    // MARK: Actions
    
    override func menuButtonDidTap() {
      // doSomething()
    }
    ```
    

## 프로그래밍 권장사항

- 가능하다면 변수를 정의할 때 함께 초기화하도록 합니다. [Then](https://github.com/devxoul/Then)을 사용하면 초기화와 함께 속성을 지정할 수 있습니다.
- **우리는 위에서 어떤 프로퍼티들이 사용되는지 선언만 해주고, 함수에서 `do` 를 이용해 속성 정의하는걸로!**
    
    ```swift
    	label = UILabel()
    
    	label.do {
    	  $0.textAlignment = .center
    	  $0.textColor = .black
    	  $0.text = "Hello, World!"
    	}
    ```
    
- 상수를 정의할 때에는 `enum`를 만들어 비슷한 상수끼리 모아둡니다. 재사용성과 유지보수 측면에서 큰 향상을 가져옵니다. `struct` 대신 `enum`을 사용하는 이유는, 생성자가 제공되지 않는 자료형을 사용하기 위해서입니다.
    
    ```swift
    final class ProfileViewController: UIViewController {
    
      private enum Metric {
        static let profileImageViewLeft = 10.f
        static let profileImageViewRight = 10.f
        static let nameLabelTopBottom = 8.f
        static let bioLabelTop = 6.f
      }
    
      private enum Font {
        static let nameLabel = UIFont.boldSystemFont(ofSize: 14)
        static let bioLabel = UIFont.boldSystemFont(ofSize: 12)
      }
    
      private enum Color {
        static let nameLabelText = 0x000000.color
        static let bioLabelText = 0x333333.color ~ 70%
      }
    
    }
    ```
    
    이렇게 선언된 상수들은 다음과 같이 사용될 수 있습니다.
    
    ```swift
    self.profileImageView.frame.origin.x = Metric.profileImageViewLeft
    self.nameLabel.font = Font.nameLabel
    self.nameLabel.textColor = Color.nameLabelText
    ```
    
- 더이상 상속이 발생하지 않는 클래스는 항상 `final` 키워드로 선언합니다.
- 프로토콜을 적용할 때에는 extension을 만들어서 관련된 메서드를 모아둡니다.
    
    **좋은 예**:
    
    ```swift
    final class MyViewController: UIViewController {
      // ...
    }
    
    // MARK: - UITableViewDataSource
    
    extension MyViewController: UITableViewDataSource {
      // ...
    }
    
    // MARK: - UITableViewDelegate
    
    extension MyViewController: UITableViewDelegate {
      // ...
    }
    ```
    **나쁜 예**:

    ```
    final class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
      // ...
    }
    ```

    ##

</div>
</details>
<br>

## 🗂 Folder Structure

```swift
WSSiOS
├── App
├── Resource
│   ├── Assets.xcassets
│   ├── Constants
│   │   ├── Fonts
│   │   ├── Images
│   │   └── Strings
│   └── Extensions
├── Source
│   ├── Data
│   │   └── Repository
│   ├── Presentation
│   │   ├── Home
│   │   │   ├── HomeView
│   │   │   │   ├── HomeView.swift
│   │   │   │   ├── HomeAssistantView
│   │   │   │   └── HomeCell
│   │   │   ├── HomeViewController
│   │   │   │   └── HomeViewController.swift
│   │   │   └── HomeViewModel
│   │   │       └── HomeViewModel.swift
│   │   ├── Search
│   │   │   └──  .....
│   │   ├── RegisterNormal
 ....
```
<br>

## 🔀 Git Convention

### Github Flow
> 앱잼 기간 동안은, 실시간으로 소통가능하기에 복잡한 관리 전략의 필요성이 적고 빠른 완성을 목표로 깃 관리에 적은 리소스를 쓰는 것이 개발에 용이하므로 Github-Flow를 채택한다.

- **main** : 개발이 완료된 산출물이 저장될 공간
- **develop** :  개발 작업이 이루어지는 브랜치, 이슈별/작업별로 브랜치를 생성하여 기능을 개발한다

### 브랜치 룰
``` Swift
1. main 브랜치에서의 작업은 원칙적으로 금지한다.
2. Pull Request를 작성한 후 PR알림 카톡방에 코드리뷰 요청을 올린다.
3. 빠른 협업 속도를 위해 코드리뷰는 최대한 빨리 완료한다.
4. 최소 2명의 Approved 이후 Merge할 수 있으며, 본인의 Pull Request는 본인이 Merge한다.
5. Merge시, 최신 main를 본인 브랜치에 먼저 Merge하여 로컬에서 Conflict를 해결한 뒤, 앱이 정상적으로 실행되는 지 빌드한 후 Merge한다.
```

### 브랜치 플로우
**1 이슈 - 1 브랜치 - n 개의 PR** 의 대응 관계로 작성한다.
``` Swift
1. 여러 PR을 포함할 수 있는 큰 작업 단위로 Issue를 생성한다.
2. Project에 해당 이슈의 진행상황을 추가한다.
3. Issue와 대응되는 브랜치를 하나 생성한다.
4. Issue보다 작은 단위의 작업이 끝나면, PR을 작성한다. (하나의 Issue에 PR이 여러개일 수 있다.)
5. PR이 종료되어도 branch는 바로 삭제하지 않으며, Issue가 종료될 때 branch를 삭제한다.
```

### 코드리뷰
**1. Reviewer**
 - 온화한 뉘앙스로 피드백을 단다.
 - 유효한 리뷰가 될 수 있도록 염두에 두고 리뷰한다.

**2. 커뮤니케이션 비용을 줄이기 위한 Wn 룰**
``` Swift
W1: 꼭 반영해주세요 (Request changes)
W2: 반영해도 좋고 넘어가도 좋습니다 (Approve)
W3: 그냥 사소한 의견입니다 (Approve)
```

### ISSUE & PR
**1. ISSUE와 PR**
 - 큰 단위의 ISSUE 와 작은 단위의 PR 로 구분한다.
 ex) HomeView 의 기능 구현을 목적으로 하는 ISSUE, 기능별로 나눈 PR
 
 **2. PR Label**
 - reviewPlz : 처음 코드리뷰를 요청할 때
 - reviewMore : 수정한 바를 기반으로 다시 코드리뷰를 요청할 때
 - veryGoodDeveloper : 최종적으로 머지할 때

<br>

## 📝 Name Convention
### Issue Naming
- **이슈 Title**
  
  ```
  [Prefix] 이슈 타이틀
  ```
- **사용 단어 Align**
  
  ```
  [Design] Home UI 구현
  [Network] Mypage API 연동
  [Fix] TabBar 터치 안되는 버그 수정 (상세 설명 필수)
  ```
- **Prefix**
  
  ```
  [Design]: 뷰 짜기
  [Feat]: 새로운 기능 구현
  [Network]: 네트워크 연결
  [Fix]: 버그, 오류 해결, 코드 수정
  [Refactor]: 전면 수정이 있을 때 사용
  [Chore]: 그 이외
  [Docs]: README나 WIKI 등의 문서 개정
  [Setting]: 세팅
  ```
  
### 2. Branch Naming
 ```
 prefix/#이슈번호

 Ex) Design/#11, Docs/#20
 ```

### 3. Commit Naming
- **Commit Summary**
  
  ```
  [prefix] #이슈번호 - 이슈 내용
  더 자세한 내용이 필요할 때는 Commit Description에 작성
  
  Ex)
  // 1번 이슈에서 새로운 기능(Feat)을 구현한 경우
  [Feat] #1 - 기능 구현
  // 1번 이슈에서 레이아웃(Design)을 구현한 경우
  [Design] #1 - 레이아웃 구현
  ```
- **Prefix**
  
  ```
  [Design]: 뷰 짜기
  [Feat]: 새로운 기능 구현
  [Network]: 네트워크 연결
  [Fix]: 버그, 오류 해결, 코드 수정
  [Add]: Feat 이외의 부수적인 코드 추가, 라이브러리 추가, 새로운 View 생성
  [Del]: 쓸모없는 코드, 주석 삭제
  [Refactor]: 전면 수정이 있을 때 사용합니다
  [Remove]: 파일 삭제
  [Chore]: 그 이외의 잡일/ 버전 코드 수정, 패키지 구조 변경, 파일 이동, 파일이름 변경
  [Docs]: README나 WIKI 등의 문서 개정
  [Setting]: 세팅
  [Test]: 테스트 코드
  [Merge]: merge
  ```
