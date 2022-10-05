//
//  SolCalcApp.swift
//  SolCalc
//
//  Created by Jomo Smith on 1/17/22.
//

import SwiftUI

@main
struct SolCalcApp: App {
   @StateObject var model = SolarDesignModel()
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(model)
            //ResidentialView()
            //CommericalView()
        }
    }
}
