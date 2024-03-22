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
    
    public func endTextEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    public func toast(isShowing: Binding<Bool>, title: String?, message: String) -> some View {
        self.modifier(ToastMessageModifier(isShowing: isShowing, title: title, message: message))
    }
    
    public func certificateToDoucument(isPresented: Binding<Bool>, primaryAction: (() -> ())? = nil, primaryAction2: (() -> ())? = nil) -> some View {
        return modifier(
            CertificateToDoucumentModifier(primaryAction: primaryAction, primaryAction2: primaryAction2, isPresented: isPresented)
        )
    }
    
    public func primaryAlert(isPresented: Binding<Bool>, title: String, content: String, primaryButtonTitle: String?, cancleButtonTitle: String, primaryAction: ( () -> Void)?, cancleAction: @escaping () -> Void) -> some View {
        return modifier(
            PrimaryAlertModifier(isPresented: isPresented, title: title, content: content, primaryButtonTitle: primaryButtonTitle, cancleButtonTitle: cancleButtonTitle, primaryAction: primaryAction, cancleAction: cancleAction)
        )
    }
    
//    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
//        self.modifier(ViewDidLoadModifier(action: action))
//    }
    
    func dismissOnDrag(minimumDragDistance: CGFloat = 60) -> some View {
        self.modifier(DismissOnDrag(minimumDragDistance: minimumDragDistance))
    }
    
    func dismissOnEdgeDrag(minimumDragDistance: CGFloat = 60, edgeWidth: CGFloat = 20) -> some View {
        self.modifier(DismissOnEdgeDrag(minimumDragDistance: minimumDragDistance, edgeWidth: edgeWidth))
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

struct CustomLinearProgressViewStyle: ProgressViewStyle {
    var trackColor: Color
    var progressColor: Color

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 4)
                    .foregroundColor(trackColor)

                Rectangle().frame(width: min(CGFloat(configuration.fractionCompleted ?? 0) * geometry.size.width, geometry.size.width), height: 4)
                    .foregroundColor(progressColor)
                    .cornerRadius(45.0)
                    .animation(.linear, value: configuration.fractionCompleted)
            }
            .cornerRadius(45.0)
        }
    }
}
