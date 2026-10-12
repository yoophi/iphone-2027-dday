# 2027

2027년 1월 1일까지 남은 날짜와 이번 달 달력을 보여주는 iPhone 홈 화면 위젯.

- 흰색 배경에 검정·회색만 사용
- 남은 날짜는 `D-81` 형식으로 표시하고 `D-`는 작게, 숫자는 큰 볼드로 표시
- 지난 날짜는 흐린 회색, 오늘은 검정 원으로 강조
- 중형(가로형)·대형 위젯 지원
- 기기 현지 시간대의 자정을 기준으로 날짜 계산 및 일주일치 위젯 타임라인 생성
- 목표일 이후는 `0` 표시

![위젯 미리보기](docs/preview.png)

## 홈 화면에 추가

앱 설치 후 홈 화면의 빈 공간을 길게 누르고 **편집 → 위젯 추가 → 2027**을 선택한다. 원하는 크기를 선택해 추가한다. iOS 홈 화면 위젯 배치는 사용자가 직접 수행한다. 흰색 배경을 유지하려면 홈 화면 아이콘 스타일을 기본/라이트로 사용한다. iOS의 틴트 스타일은 시스템에서 위젯 색상을 변경할 수 있다.

## 개발

Xcode 26.3에서 빌드 검증. iOS 17 이상 지원.

`NewYear2027.xcodeproj`를 Xcode에서 열고 Signing & Capabilities에서 개인 개발 팀을 선택해 실제 iPhone으로 실행한다. 설치에는 유효한 Apple 개발 계정과 프로비저닝이 필요하다.

프로젝트 재생성:

```sh
brew install xcodegen
xcodegen generate
```

날짜·시간대·월 경계 검증:

```sh
./scripts/check.sh
```

서명 없이 iPhone 대상 빌드 검증:

```sh
xcodebuild -project NewYear2027.xcodeproj -target NewYear2027 \
  -sdk iphoneos -configuration Debug CODE_SIGNING_ALLOWED=NO \
  SYMROOT="$PWD/build/unsigned" build
```

macOS에서 공유 SwiftUI 화면 미리보기 생성:

```sh
swiftc Shared/CountdownModel.swift Shared/CountdownView.swift scripts/Preview.swift -o /tmp/2027-preview
/tmp/2027-preview /tmp/2027-preview.png
```

## 작업 관리

`td init --store=gh-issue`로 GitHub Issues 저장소를 사용한다. `td task list`로 작업 상태를 조회한다.

WidgetKit 타임라인과 배경은 [Apple WidgetKit 문서](https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension) 및 [위젯 배경 문서](https://developer.apple.com/documentation/widgetkit/displaying-the-right-widget-background)를 기준으로 구현했다.
