//
//  HomeViewModel.swift
//  PayRit
//
//  Created by 임대진 on 3/2/24.
//

import Foundation

enum SortingType: String, CodingKey, CaseIterable {
    case recent = "최근 작성일 순"
    case old = "작성 오래된 순"
    case expiration = "기간 만료일 순"
}

@Observable
final class HomeStore {
    var sortingType: SortingType = .recent
    var certificates: [Certificate] = Certificate.samepleDocument
    
    func sortingCertificates() {
        self.certificates = Certificate.samepleDocument.sorted {
            switch sortingType {
            case .recent:
                return $0.writingDayCal < $1.writingDayCal
            case .old:
                return $0.writingDayCal > $1.writingDayCal
            case .expiration:
                return $0.dDay < $1.dDay
            }}
    }
    
    func todayString() -> String {
        let today = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd" // 원하는 날짜 형식 지정
        let dateString = dateFormatter.string(from: today)
        return dateString
    }
    
    func memoSave(certificate: Certificate, today: String, text: String) {
        if let index = certificates.firstIndex(where: { $0.id == certificate.id }) {
            var updatedCertificate = certificate
            let newMemo = Memo(today: today, text: text)
            updatedCertificate.memo.append(newMemo)
            certificates[index] = updatedCertificate
        }
    }
    
    func deductedSave(certificate: Certificate, date: String, money: Int) {
        if let index = certificates.firstIndex(where: { $0.id == certificate.id }) {
            var updatedCertificate = certificate
            let newMemo = Deducted(date: date, money: money)
            updatedCertificate.deductedHistory.append(newMemo)
            certificates[index] = updatedCertificate
        }
    }
}
