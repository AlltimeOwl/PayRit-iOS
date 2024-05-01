//
//  VersionService.swift
//  PayRit
//
//  Created by 임대진 on 4/13/24.
//

import Foundation

enum UpdateType {
    case force, select, latest
}

@Observable
final class VersionService {
    var uadateType: UpdateType = .latest
    var isShowingForceAlert: Bool = false
    var isShowingSelectAlert: Bool = false
    
    let bundleID = "com.alltimeowl.PayRit"
    let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/6480038044"
    
    func calVersion(now: String, store: String) -> UpdateType {
        
        var currentComponents = now.split(separator: ".").compactMap { Int($0) }
        var latestComponents = store.split(separator: ".").compactMap { Int($0) }
        
        if currentComponents.count == 2 {
            currentComponents.append(0)
        }
        if latestComponents.count == 2 {
            latestComponents.append(0)
        }
        
        let currentMajor = currentComponents[0]
        let currentMinor = currentComponents[1]
        let currentPatch = currentComponents[2]
        
        let latestMajor = latestComponents[0]
        let latestMinor = latestComponents[1]
        let latestPatch = latestComponents[2]
        
        if currentMajor < latestMajor || (currentMajor == latestMajor && currentMinor < latestMinor) {
            return .force
        }
        
        if currentMajor == latestMajor && currentMinor == latestMinor && currentPatch < latestPatch {
            return .select
        }
        
        return .latest
    }
    
    func loadAppStoreVersion(completion: @escaping (String?) -> Void) {
        let appStoreUrl = "http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)"
        
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
