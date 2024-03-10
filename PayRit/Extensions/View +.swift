//
//  View +.swift
//  PayRit
//
//  Created by 임대진 on 2/28/24.
//

import SwiftUI

extension View {
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
    public func toast(isShowing: Binding<Bool>, message: String) -> some View {
        self.modifier(ToastMessageModifier(isShowing: isShowing, message: message))
    }
    
    public func LoanDetailImage(isPresented: Binding<Bool>, isButtonShowing: Binding<Bool>) -> some View {
        return modifier(
            LoanDetailImageViewModifier(isPresented: isPresented, isButtonShowing: isButtonShowing)
        )
    }
    
    public func PrimaryAlert(isPresented: Binding<Bool>, title: String, content: String, primaryButtonTitle: String?, cancleButtonTitle: String, primaryAction: ( () -> Void)?, cancleAction: @escaping () -> Void) -> some View {
        return modifier(
            PrimaryAlertModifier(isPresented: isPresented, title: title, content: content, primaryButtonTitle: primaryButtonTitle, cancleButtonTitle: cancleButtonTitle, primaryAction: primaryAction, cancleAction: cancleAction)
        )
    }
}

extension UINavigationController: ObservableObject, UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
