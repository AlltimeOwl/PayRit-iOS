//
//  LoanDetailImageView.swift
//  PayRit
//
//  Created by 임대진 on 3/4/24.
//

import SwiftUI

struct CertificateDetailImageView: View {
    @Binding var isPresented: Bool
    @Binding var isButtonShowing: Bool
    var body: some View {
        VStack {
            VStack {
                CertificateImageView()
                    .background(Color.white)
            }
            .clipShape(.rect(cornerRadius: 12))
            
            if isButtonShowing {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 60))
                }
                .foregroundStyle(.gray).opacity(0.5)
                .background(
                    Circle().frame(width: 60, height: 60)
                        .foregroundStyle(.white)
                )
                .padding(.top, 20)
            }
            
        }
        .padding(16)
    }
}

#Preview {
    CertificateDetailImageView(isPresented: .constant(true), isButtonShowing: .constant(true))
        .background(Color.black)
}
