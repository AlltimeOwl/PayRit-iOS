//
//  VersionService.swift
//  PayRit
//
//  Created by 임대진 on 4/13/24.
//

import Foundation

@Observable
final class VersionService {
    var isOldVersion: Bool = false
    
    let bundleID = "com.alltimeowl.PayRit"
    let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/6480038044"
    
    func loadAppStoreVersion(completion: @escaping (String?) -> Void) {
        let appStoreUrl = "https://itunes.apple.com/kr/lookup?bundleId=\(bundleID)"
        
        let task = URLSession.shared.dataTask(with: URL(string: appStoreUrl)!) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results[0]["version"] as? String {
                    completion(appStoreVersion)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func nowVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        return version
    }
}
