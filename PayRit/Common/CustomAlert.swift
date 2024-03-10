//
//  CustomAlert.swift
//  PayRit
//
//  Created by 임대진 on 3/5/24.
//
import SwiftUI

struct PrimaryAlert: View {
    
    @Binding var isPresented: Bool
    let title: String
    let content: String
    let primaryButtonTitle: String?
    let cancleButtonTitle: String
    let primaryAction: (() -> Void)?
    let cancleAction: () -> Void
    
    var body: some View {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.top, 22)
                
                VStack(alignment: .center) {
                    Text(content)
                        .font(.system(size: 15))
                        .opacity(0.5)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .frame(width: 250)
                }
                .padding(.vertical, 20)
                
                Divider()
                HStack(alignment: .center) {
                    if let primaryButtonTitle = primaryButtonTitle {
                        Button {
                            cancleAction()
                            isPresented = false
                        } label: {
                            Text(cancleButtonTitle)
                                .bold()
                                .font(.system(size: 17))
                                .foregroundStyle(Color(hex: "777777"))
                                .frame(width: 120, height: 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        Button {
                            primaryAction?()
                            isPresented = false
                        } label: {
                            Text(primaryButtonTitle)
                                .bold()
                                .font(.system(size: 17))
                                .foregroundStyle(.white)
                                .frame(width: 120, height: 40)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.payritMint)
                    } else {
                        Button {
                            cancleAction()
                            isPresented = false
                        } label: {
                            Text(cancleButtonTitle)
                                .bold()
                                .font(.system(size: 17))
                                .foregroundStyle(.white)
                                .frame(width: 300, height: 50)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.payritMint)
                    }
                }
                .frame(height: 50)
                .frame(width: 300)
            }
            .frame(width: 300)
            .background(
                Color.white
            )
            .clipShape(.rect(cornerRadius: 16))
            .frame(maxHeight: 200)
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.7)
        PrimaryAlert(isPresented: .constant(true),
                title: "작성 중단",
                content: """
                        지금 작성을 중단하시면
                        처음부터 다시 작성해야해요.
                        처음부터 다시 작성해야해요.
                        """,
                primaryButtonTitle: nil,
                cancleButtonTitle: "아니오",
                primaryAction: {},
                cancleAction: {}
    )
    }
    .ignoresSafeArea()
}
