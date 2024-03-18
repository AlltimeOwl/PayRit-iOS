//
//  SwiftUIView.swift
//  PayRit
//
//  Created by 임대진 on 3/15/24.
//
import SwiftUI

struct CertificateToDoucumentView: View {
    public typealias Action = () -> ()
    let primaryAction: Action?
    let primaryAction2: Action?
    @Binding var isPresented: Bool
    @Environment(HomeStore.self) var homeStore
    var body: some View {
        VStack {
            VStack {
                let pdfURL: URL? = homeStore.generatePDF()
                if let url = pdfURL {
                    PDFKitView(url: url)
                }
            }
            .clipShape(.rect(cornerRadius: 12))
            .padding(.bottom, 10)
            
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    Button {
                        primaryAction?()
                    } label: {
                        Text("PDF 다운")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                Divider().frame(height: 1)
                HStack(alignment: .center) {
                    Button {
                        primaryAction2?()
                    } label: {
                        Text("이메일 전송")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }
            .frame(height: 120)
            .font(.system(size: 20))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 12))
            
            Button {
                isPresented.toggle()
            } label: {
                Text("취소")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 60)
            .font(.system(size: 20))
            .background(Color.white)
            .clipShape(.rect(cornerRadius: 12))

        }
        .padding(16)
    }
}

#Preview {
    CertificateToDoucumentView(primaryAction: nil, primaryAction2: nil, isPresented: .constant(false))
        .background(Color.gray)
        .environment(HomeStore())
}
