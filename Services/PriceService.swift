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
    
    let exchangeaRateJMDtoUSD:Double = 157.8
    
    let costOf545WattTrinaSolarPanels: Double = 50000.0
    
    //Tier 1
    let costOfInverter: Double = 500000.0
    let costOf10kwhBattery:Double = 610000.0
    let rosenStorageCapacity:Double = 8.0
    
    //Tier 2
    let costOf3500WGrowattInverter: Double = 221900.0
    let costOf2400WLithiumBattery : Double = 123007.5

    
    let costOfAirBnBPerNight:Double = 17347.0
    
    
    //For now we are just going for estimates will refine the class properly over time
    
    public func calculateEstimateForDesign(design:SolarDesign) -> Estimate
    {
        var estimate = Estimate()
        estimate.costOfPanels = design.numberOfPanels * costOf545WattTrinaSolarPanels
        estimate.costOfInveter = costOfInverter
        estimate.costOfBatteries = getNumberOfBatteries(requiredStorageCapacity: design.batteryStorage) * costOf10kwhBattery
        estimate.costOfElectricalMaterial = 215000.0
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
        
        estimate.costOfManagementAndDesign = 350000
        
        
        estimate.totalEstimate =  estimate.costOfPanels + estimate.costOfInveter
        + estimate.costOfBatteries +  estimate.costOfElectricalMaterial
        + estimate.costOfAirBnB +  estimate.costOfTransportation
        + estimate.costOfManagementAndDesign
        + estimate.costOfRacking
        
        return estimate
    }
    
    private func getNumberOfBatteries(requiredStorageCapacity: Double) -> Double
    {
        var numberOfBatteries = requiredStorageCapacity/rosenStorageCapacity
        
        return numberOfBatteries.rounded()
        
    }
    

    //Racking is 0.10 US Dollars per watt. Im using 0.15 to include shipping and transporatation
    private func getRailingEstimate(arraySize:Double)-> Double
    {
        let costPerWatt = 0.15 * exchangeaRateJMDtoUSD
        
        //Convert kWh to watt
        let solarArrayInWatts = arraySize * 1000
        
        return solarArrayInWatts * costPerWatt
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
    var totalEstimate:Double = 0.0
    
}




