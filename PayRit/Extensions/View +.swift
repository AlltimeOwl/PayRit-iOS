//
//  View +.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

extension View {
    public func customXmarkbutton(action: (() -> ())? = nil) -> some View {
        modifier(CustomBackButton(action: action))
    }
    public func customBackbutton(action: (() -> ())? = nil) -> some View {
        modifier(CustomBackButton(action: action))
    }
    
    // MARK: 키보드 올라온 상태에서, 빈공간 터치시 키보드 내리는 코드
    // 키보드를 내리고싶은 뷰에서 .onTapGesture { self.endTextEditing() } 추가
    public func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    // MARK: 토스트 메세지
    // 토스트 메세지를 띄우고싶은 뷰에서 .toast(isShowing: $showToast, message: message) 추가
//    public func toast(isShowing: Binding<Bool>, message: String) -> some View {
//        self.modifier(ToastMessageModifier(isShowing: isShowing, message: message))
//    }
}
