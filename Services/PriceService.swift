//
//  PriceService.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/6/22.
//

import Foundation
import UIKit


class PriceService
{
    
    let costGSWSolarPanel545watt: Double = 40000.0
    let costSkyTrack8k:Double = 580000.0
    let costSkyTrack6k:Double = 500000.0
    let costXliionBattery:Double = 600000.0
    let exchangeaRateJMDtoUSD:Double = 157.8
    let costOfAirBnBPerNight:Double = 17347.0
    let costElectricalMaterialAndWiring = 300000.0
    
    
   public var estimate = Estimate()
    
    public func calculateEstimateForDesign(design:SolarDesign) -> Estimate
    {

        estimate.costOfPanels = Double(design.numberOfPanels) * costGSWSolarPanel545watt
        estimate.costOfInveter = getCostOfInverterModel(design: design) * Double(design.numberOfInverters)
        estimate.costOfBatteries = Double(design.numberOfBatteries) * costXliionBattery
        estimate.costOfElectricalMaterial = costElectricalMaterialAndWiring
        estimate.costOfRacking = getRailingEstimate(arraySize: design.solarArraySize)
        
        if(design.parish.id.rawValue != "Kingston")
        {
            estimate.costOfAirBnB = (90.0 * exchangeaRateJMDtoUSD) * 3
            estimate.costOfTransportation = 65000.0

        }
        
        else{
            estimate.costOfAirBnB = 0.0
            estimate.costOfTransportation = 20000.0
        }
        
        estimate.costOfContractors = ( 0.1 * (estimate.costOfElectricalMaterial + estimate.costOfBatteries
                                            + estimate.costOfInveter + estimate.costOfPanels + estimate.costOfElectricalMaterial + estimate.costOfRacking) ) + estimate.costOfAirBnB

        estimate.costOfManagementAndDesign = ( 0.1  *   (estimate.costOfElectricalMaterial + estimate.costOfBatteries
                                                     + estimate.costOfInveter + estimate.costOfPanels + estimate.costOfElectricalMaterial +  estimate.costOfRacking) )
    
        
        estimate.totalEstimate =  estimate.costOfPanels + estimate.costOfInveter
        + estimate.costOfBatteries +  estimate.costOfElectricalMaterial
        + estimate.costOfTransportation
        + estimate.costOfManagementAndDesign
        + estimate.costOfRacking
        + estimate.costOfContractors
        
        return estimate
    }
    

    //Racking is 0.10 US Dollars per watt. I'm using 0.15 to include shipping and transporatation.
    private func getRailingEstimate(arraySize:Double)-> Double
    {
        let costPerWatt = 0.15 * exchangeaRateJMDtoUSD
        
        //Convert kWh to watt
        let solarArrayInWatts = arraySize * 1000
        
        return solarArrayInWatts * costPerWatt
    }
    
    private func getCostOfInverterModel(design: SolarDesign)-> Double{
        
        if(design.inverterModel == design.skytrak6k)
        {
            return costSkyTrack6k * Double(design.numberOfInverters)
        }
        else{
            return costSkyTrack8k * Double(design.numberOfInverters)
        }
    }
}

 struct Estimate {
    
    var costOfPanels: Double = 0.0
    var costOfInveter: Double = 0.0
    var costOfBatteries:Double = 0.0
    var costOfLabor:Double = 0.0
    var costOfManagementAndDesign:Double = 0.0
    var costOfElectricalMaterial:Double = 0.0
    var costOfRacking: Double = 0.0
    var costOfTransportation:Double = 0.0
    var costOfAirBnB:Double = 0.0
    var costOfContractors:Double = 0.0
    var totalEstimate:Double = 0.0
    
    
}




