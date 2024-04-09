//
//  ImportPassView.swift
//  PayRit
//
//  Created by 임대진 on 4/8/24.
//

import SwiftUI
import WebKit

struct ImportPassView: UIViewControllerRepresentable {
    @Binding var rsp: String
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> ImportPassVC {
        let viewController = ImportPassVC()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ImportPassVC, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ImportPassDelegate {
        var parent: ImportPassView
        
        init(_ parent: ImportPassView) {
            self.parent = parent
        }
        
        func addressReceived(_ rsp: String) {
            parent.rsp = rsp
            parent.isPresented = false
        }
    }
}

protocol ImportPassDelegate: AnyObject {
    func addressReceived(_ rsp: String)
}

class ImportPassVC: UIViewController, WKScriptMessageHandler, WKNavigationDelegate {
    weak var delegate: ImportPassDelegate?
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
        contentController.add(self, name: "authSuccess")
        contentController.add(self, name: "authFail")
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self
        
        guard let url = URL(string: "https://daejinlim.github.io/ImportSMS/"),
              let webView = webView else { return }
        let request = URLRequest(url: url)
        webView.load(request)
        indicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.indicator.stopAnimating()
        }
    }
    
    private func setConstraints() {
        guard let webView = webView else { return }
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: webView.centerYAnchor)
        ])
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if message.name == "authSuccess" {
            // 인증 성공 시 처리할 로직
            print("본인 인증 성공")
            if let jsonString = message.body as? String,
               let data = jsonString.data(using: .utf8),
               let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("본인 인증 response: \(response)")
                let impUid = response["imp_uid"] as? String ?? ""
                delegate?.addressReceived(impUid)
            }
        } else if message.name == "authFail" {
            // 인증 취소, 실패 시 처리할 로직
            print("본인 인증 실패")
            if let jsonString = message.body as? String,
               let data = jsonString.data(using: .utf8),
               let response = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                print("본인 인증 response: \(response)")
                let impUid = response["imp_uid"] as? String ?? ""
                delegate?.addressReceived(impUid)
            }
        } else if message.name == "reqFail" {
            print("본인 인증 reqFail")
        }
    }
}
