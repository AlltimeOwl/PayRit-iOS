//
//  CertificateImage.swift
//  PayRit
//
//  Created by 임대진 on 3/11/24.
//
import SwiftUI
import UIKit

struct CertificateImageView: UIViewRepresentable {
//    let title: String
//    init(title: String) {
//        self.title = title
//    }

    func makeUIView(context: Context) -> UIView {
        let uiView = CertificateUIView()
        return uiView
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

class CertificateUIView: UIView {
    private let title: UILabel = {
        let label = UILabel()
        label.text = "차 용 증"
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    private let money: UILabel = {
        let label = UILabel()
        label.text = "차 용 증"
        return label
    }()
    private let content: UILabel = {
        let label = UILabel()
        label.text = "차 용 증"
        return label
    }()
    private let title1: UILabel = {
        let label = UILabel()
        label.text = "차 용 증"
        return label
    }()
    private let title2: UILabel = {
        let label = UILabel()
        label.text = "차 용 증"
        return label
    }()
    
    private let guideSubLabel: UILabel = {
        let label = UILabel()
        let text = """
                    위 금액을 채무자가 채권자로부터 0000년 00월 00일 빌렸습니다. 이자는 연 0할 0푼 ( 00% )으로 하여 매월 00일까지 갚겠으며, 원금은 0000년 00월 00일까지 채권자에게 갚겠습니다.
                    """
        let attributedText = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedText.length))
        
        label.attributedText = attributedText
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let day: UILabel = {
        let label = UILabel()
        label.text = "2024년 00년 00월"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        makeConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubview() {
        [title, guideSubLabel, day].forEach { addSubview($0) }
    }
    
    private func makeConstraints() {
        self.title.translatesAutoresizingMaskIntoConstraints = false
        self.guideSubLabel.translatesAutoresizingMaskIntoConstraints = false
        self.day.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: super.topAnchor, constant: 20),
            title.centerXAnchor.constraint(equalTo: super.centerXAnchor),
            
            guideSubLabel.topAnchor.constraint(equalTo: super.topAnchor),
            guideSubLabel.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: 20),
            guideSubLabel.trailingAnchor.constraint(equalTo: super.trailingAnchor, constant: -20),
            guideSubLabel.bottomAnchor.constraint(equalTo: super.bottomAnchor),
            
            day.centerXAnchor.constraint(equalTo: super.centerXAnchor),
            day.bottomAnchor.constraint(equalTo: super.bottomAnchor),
        ])
    }
}

#Preview {
    CertificateImageView()
}
