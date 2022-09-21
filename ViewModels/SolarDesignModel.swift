//
//  SolarDesignModel.swift
//  SolCalc
//
//  Created by Jomo Smith on 1/31/22.
//

import Foundation

class SolarDesignModel: ObservableObject{
    
    var solarDesign: SolarDesign
    
    var priceService: PriceService
    

    init(){
        self.solarDesign = SolarDesign()
        self.priceService = PriceService()
    }
    
}
