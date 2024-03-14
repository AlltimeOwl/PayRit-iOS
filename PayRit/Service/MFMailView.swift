//
//  MFMailService.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    var configure: (MFMailComposeViewController) -> Void

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = context.coordinator
        configure(mailComposer)
        return mailComposer
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView

        init(_ parent: MailView) {
            self.parent = parent
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                parent.presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                parent.result = .failure(error!)
                return
            }
            parent.result = .success(result)
        }
    }
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
