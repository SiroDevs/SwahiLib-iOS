//
//  SubsRepo.swift
//  SwahiLib
//
//  Created by @sirodevs on 24/08/2025.
//

import Combine
import RevenueCat

protocol SubsRepoProtocol {
    func isProUser(isOnline: Bool, completion: @escaping (Bool) -> Void)
}

final class SubsRepo: SubsRepoProtocol {
    func isProUser(isOnline: Bool, completion: @escaping (Bool) -> Void) {
        #if DEBUG
            completion(true)
        #else
        let cachePolicy: CacheFetchPolicy = isOnline ? .fetchCurrent : .fromCacheOnly
            
            Purchases.shared.getCustomerInfo(fetchPolicy: cachePolicy) { customerInfo, error in
                guard let customerInfo = customerInfo, error == nil else {
                    completion(false)
                    return
                }

                let isActive = customerInfo.entitlements[AppConstants.entitlements]?.isActive == true
                completion(isActive)
            }
        #endif
    }
}
