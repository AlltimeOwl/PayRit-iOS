import Foundation
import SwiftUI
import UIKit
import WebKit
import iamport_ios

struct IMPCertificationView: UIViewControllerRepresentable {
    @Binding var certType: AuthType
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: IamportStore
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = IMPCertificationViewController()
        view.viewModel = viewModel
        view.presentationMode = presentationMode
        view.certType = certType
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

}

class IMPCertificationViewController: UIViewController, WKNavigationDelegate {
    var viewModel: IamportStore?
    var presentationMode: Binding<PresentationMode>?
    var certType: AuthType = .account

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestCertification()
    }

    // 아임포트 SDK 본인인증 요청
    func requestCertification() {
        guard let viewModel = viewModel else {
            print("viewModel 이 존재하지 않습니다.")
            return
        }
        viewModel.acceptAuthResult = false
        
        let userCode = "imp28882037"
        let certification = viewModel.createCertificationData()
        dump(certification)

        Iamport.shared.useNavigationButton(enable: true)

        Iamport.shared.certification(viewController: self,
                userCode: userCode, certification: certification) { iamportResponse in
            viewModel.acceptAuthResult = viewModel.iamportCallback(type: self.certType, iamportResponse)
            self.presentationMode?.wrappedValue.dismiss()
        }
    }

}
