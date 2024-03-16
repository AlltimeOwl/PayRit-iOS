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
    var body: some View {
        VStack {
            VStack {
                CertificateDocumentView()
                //                    .foregroundColor(.black)
                //                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.white)
            }
            .clipShape(.rect(cornerRadius: 12))
            .padding(.bottom, 10)
            
//            Button {
//                isPresented = false
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.system(size: 60))
//            }
//            .foregroundStyle(.gray).opacity(0.5)
//            .background(
//                Circle().frame(width: 60, height: 60)
//                    .foregroundStyle(.white)
//            )
//            .padding(.top, 20)
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
}
