//
//  ViewModifier.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

public struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    public typealias Action = () -> ()
    
    var action: Action?
    public func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        action?()
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
    }
}

struct CertificateToDoucumentModifier: ViewModifier {
    public typealias Action = () -> ()
    let primaryAction: Action?
    let primaryAction2: Action?
    @Binding var isPresented: Bool
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .ignoresSafeArea()
                        .onTapGesture {
                            isPresented = false // 외부 영역 터치시 내려감
                        }
                    
                    CertificateToDoucumentView(primaryAction: primaryAction, primaryAction2: primaryAction2, isPresented: $isPresented)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(
                isPresented
                ? .spring(response: 0.3)
                : .none,
                value: isPresented
            )
        }
    }
}

struct PrimaryAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    @Environment(TabBarStore.self) var tabStore
    let title: String
    let content: String
    let primaryButtonTitle: String?
    let cancleButtonTitle: String
    let primaryAction: (() -> Void)?
    let cancleAction: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            ZStack {
                if isPresented {
                    Rectangle()
                        .fill(.black.opacity(0.5))
                        .ignoresSafeArea()
                        .onTapGesture {
                            self.isPresented = false // 외부 영역 터치 시 내려감
                        }
                        .onAppear {
                            tabStore.tabBarOpacity = true
                        }
                        .onDisappear {
                            tabStore.tabBarOpacity = false
                        }
                    
                    PrimaryAlert(isPresented: $isPresented,
                                 title: self.title,
                                 content: self.content,
                                 primaryButtonTitle: self.primaryButtonTitle,
                                 cancleButtonTitle: self.cancleButtonTitle,
                                 primaryAction: self.primaryAction,
                                 cancleAction: self.cancleAction)
                }
            }
//            .animation(
//                isPresented
//                ? .spring(response: 0.3)
//                : .none,
//                value: isPresented
//            )
        }
    }
}

struct ToastMessageModifier: ViewModifier {
    @Binding var isShowing: Bool
    var title: String?
    var message: String
    
    func body(content: Content) -> some View {
        ZStack {
            content
            if isShowing {
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
//                            .stroke(Color.gray07, lineWidth: 1)
                            .fill(Color(hex: "E3FFF6"))
                            .frame(width: 280, height: title == nil ? 50 : 90)
                            .transition(.scale)
                        VStack {
                            if let title {
                                Text(title)
                                    .font(Font.caption01)
                                    .padding(.bottom, 4)
                                Text(message)
                                    .font(Font.caption03)
                            } else {
                                Text(message)
                                    .font(Font.caption01)
                            }
                        }
                        .foregroundStyle(Color(hex: "818181"))
                        .multilineTextAlignment(.center)
                        .frame(width: 250, height: title == nil ? 50 : 90)
                    }
                }
                .padding(.bottom, 80)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isShowing = false
                        }
                    }
                }
                .zIndex(1)
            }
        }
    }
}

//struct ViewDidLoadModifier: ViewModifier {
//    @State private var viewDidLoad = false
//    let action: (() -> Void)?
//    
//    func body(content: Content) -> some View {
//        content
//            .onAppear {
//                if viewDidLoad == false {
//                    viewDidLoad = true
//                    action?()
//                }
//            }
//    }
//}

struct DismissOnDrag: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var minimumDragDistance: CGFloat

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { _ in }
                    .onEnded { gesture in
                        if gesture.translation.width > minimumDragDistance {
                            dismiss()
                        }
                    }
            )
    }
}

struct DismissOnEdgeDrag: ViewModifier {
    @State private var startLocation: CGFloat? // 드래그 시작 위치
    @Environment(\.dismiss) var dismiss
    var minimumDragDistance: CGFloat = 100
    var edgeWidth: CGFloat = 20 // 화면 왼쪽 끝에서 인식할 영역의 너비

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        // 처음 드래그를 인식했을 때 시작 위치를 설정
                        if startLocation == nil {
                            startLocation = gesture.startLocation.x
                        }
                    }
                    .onEnded { gesture in
                        // 드래그 시작 위치가 화면 왼쪽 끝에서 edgeWidth 이내인지,
                        // 그리고 드래그 거리가 minimumDragDistance 이상인지 확인
                        if let startLocation = startLocation,
                           startLocation <= edgeWidth,
                           gesture.translation.width > minimumDragDistance {
                            dismiss()
                        }
                        // 드래그 상태 리셋
                        self.startLocation = nil
                    }
            )
    }
}
