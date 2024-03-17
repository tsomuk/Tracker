//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Nikita Tsomuk on 13/03/2024.
//

import Foundation
import YandexMobileMetrica

struct AnalyticsService {
    static func activate() {
        let configuration = YMMYandexMetricaConfiguration(apiKey: "e1c291a2-d77b-426b-9a33-caa61a0af392")
        YMMYandexMetrica.activate(with: configuration!)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
