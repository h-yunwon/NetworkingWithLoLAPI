## 개요
리그 오브 레전드 API를 활용한 소환사 정보 검색 및 리그 정보 조회 애플리케이션입니다. 이 프로젝트는 Open API 사용법, 네트워킹 처리, 데이터 모델링, UserDefault를 활용한 데이터 저장과 불러오기 등을 구현을 통해 학습합니다.

## 학습 목표
- Open API의 사용 방법을 익히고 API 요청과 응답 처리하는 방법을 학습합니다.
- 네트워킹 처리를 위해 URLSession을 활용하는 방법을 배웁니다. 
- JSON 데이터 모델링과 파싱을 통해 API 응답 데이터를 구조화합니다.
- UserDefault를 사용하여 데이터를 영구적으로 저장하고 불러오는 방법을 학습합니다.


## 주요 기능
1.  소환사 정보 검색 : 소환사 이름을 입력하여 해당 소환사의 레벨, 티어, 랭크, 리그 포인트 등을 확인할 수 있습니다.
2.  내 소환사 정보 등록 : 내 소환사 정보 등록 버튼을 누르면 검색한 소환사 정보 데이터를 영구 저장합니다.
3.  내 소환사 정보 확인 : 내 소환사 정보 등록에서 저장한 데이터를 내 소환사 정보 창에서 확인할 수 있습니다.

## 시현 영상
![NetworkingWithLoLAPIGif](https://github.com/h-yunwon/NetworkingWithLoLAPI/assets/134713788/93aadbdd-6016-4c69-8ab5-6cceb3e667e0)


## 사용 기술 및 도구
- 언어: Swift
- 프레임워크: SwiftUI
- 디자인패턴: MVVM


## 배운 점

1. 리그 오브 레전드 API와의 상호작용 방법을 학습하였습니다. API 키를 발급받고, 요청을 보내고, 응답을 처리하는 과정을 경험하였습니다.
2. URLSession을 사용하여 API 요청을 보내고, 비동기 작업을 처리하는방법을 통해 네트워킹 처리를 익혔습니다.
3. 데이터 모델링과 JSON 파싱에 대한 경험을 쌓았습니다. API 응답 데이터를 적절한 데이터 모델로 변환하고, 필요한 정보를 추출하는 방법을 배웠습니다.
4. UserDefault를 사용하여 데이터를 저장하고 불러오는 방법을 배웠습니다. 
5. MVVM 패턴을 적용하여 코드의 구조를 명확하게 유지하고 데이터의 유기적인 흐름을 나타낼수 있게 익혔습니다.

## 참고자료
- [리그오브레전드 디벨로퍼](https://developer.riotgames.com/)   
- [Urlsession | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/urlsession)   
- [UserDefaults | Apple Developer Documentation](https://developer.apple.com/documentation/foundation/userdefaults)   

- [Android에서 Riot API 를 이용해 롤 전적 검색 어플 만들기, 션 쿠](https://shyunku.tistory.com/56)   
- [Asset Image(티어이미지) 가져온 사이트](https://www.unrankedsmurfs.com/blog/lol-ranks-explained)   
- [Secure Secrets in iOS app](https://medium.com/swift-india/secure-secrets-in-ios-app-9f66085800b4)   
