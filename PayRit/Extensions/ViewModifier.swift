//
//  ViewModifier.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

public struct CustomXmarkButton: ViewModifier {
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
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                    }
                }
            }
    }
}

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

struct LoanDetailImageViewModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var isButtonShowing: Bool
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
                    
                    LoanDetailImageView(isPresented: $isPresented, isButtonShowing: $isButtonShowing)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
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

struct PrimaryAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
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
