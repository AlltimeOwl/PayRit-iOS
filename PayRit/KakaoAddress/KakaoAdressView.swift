//
//  KakaoAdressView.swift
//  PayRit
//
//  Created by 임대진 on 3/6/24.
//

import SwiftUI
import WebKit

struct KakaoAdressView: UIViewControllerRepresentable {
    @Binding var address: String
    @Binding var zonecode: String
    @Binding var isPresented: Bool

    func makeUIViewController(context: Context) -> KakaoAdressVC {
        let viewController = KakaoAdressVC()
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: KakaoAdressVC, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, KakaoAdressDelegate {
        var parent: KakaoAdressView

        init(_ parent: KakaoAdressView) {
            self.parent = parent
        }

        func addressReceived(_ address: String, _ zonecode: String) {
            parent.address = address
            parent.zonecode = zonecode
            parent.isPresented = false
        }
    }
}

protocol KakaoAdressDelegate: AnyObject {
    func addressReceived(_ address: String, _ zonecode: String)
}

class KakaoAdressVC: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    weak var delegate: KakaoAdressDelegate?
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.backgroundColor = .white
        setAttributes()
        setConstraints()
    }

    private func setAttributes() {
        let contentController = WKUserContentController()
        contentController.add(self, name: "callBackHandler")

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self

        guard let url = URL(string: "https://daejinlim.github.io/daumAdressSearch/"),
              let webView = webView else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
    }

    private func setConstraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let data = message.body as? [String: Any] {
            let address = data["roadAddress"] as? String ?? ""
            let zonecode = data["zonecode"] as? String ?? ""
            delegate?.addressReceived(address, zonecode)
        }
    }
}
