import Foundation
import SwiftUI
import UIKit
import WebKit
import iamport_ios

struct IMPPaymentView: UIViewControllerRepresentable {
    @EnvironmentObject var viewModel: IamportStore
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = IMPPaymentViewController()
        view.viewModel = viewModel
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

class IMPPaymentViewController: UIViewController, WKNavigationDelegate {
    var viewModel: IamportStore?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PaymentView viewDidLoad")
        
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PaymentView viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PaymentView viewDidAppear")
        requestPayment()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("PaymentView viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("PaymentView viewDidDisappear")
    }
    
    // 아임포트 SDK 결제 요청
    func requestPayment() {
        guard let viewModel = viewModel else {
            print("viewModel 이 존재하지 않습니다.")
            return
        }
        viewModel.paymentResult = false
        
        viewModel.createPaymentData() { payment, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                dump(payment)
                
                Iamport.shared.useNavigationButton(enable: true)
                
                if let payment = payment {
                    Iamport.shared.payment(viewController: self,
                                           userCode: "imp28882037", payment: payment) { response in
                        viewModel.paymentResult = viewModel.iamportCallback(type: .payment, response)
                    }
                }
            }
        }
    }
    
}

struct PaymentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IMPPaymentView()
                .environmentObject(IamportStore())
        }
    }
}
