import Foundation
import SwiftUI
import UIKit
import WebKit
import iamport_ios

struct IMPCertificationView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var viewModel: IamportStore

    func makeUIViewController(context: Context) -> UIViewController {
        let view = IMPCertificationViewController()
        view.viewModel = viewModel
        view.presentationMode = presentationMode
        return view
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

}

class IMPCertificationViewController: UIViewController, WKNavigationDelegate {
    var viewModel: IamportStore?
    var presentationMode: Binding<PresentationMode>?

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
        
//        let userCode = viewModel.cert.userCode // iamport 에서 부여받은 가맹점 식별코드
        let userCode = "imp28882037"
        let certification = viewModel.createCertificationData()
        dump(certification)

        // WebViewContorller 용 닫기버튼 생성
        Iamport.shared.useNavigationButton(enable: true)

        // use for UIViewController
        Iamport.shared.certification(viewController: self,
                userCode: userCode, certification: certification) { [weak self] iamportResponse in
            viewModel.iamportCallback(iamportResponse)
            self?.presentationMode?.wrappedValue.dismiss()
        }
    }

}

struct IMPCertificationView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IMPCertificationView()
                .environmentObject(IamportStore())
        }
    }
}
