//
//  SolarDesign.swift
//  SolCalc
//
//  Created by Jomo Smith on 1/31/22.
//

import Foundation
import Accessibility

class SolarDesign: Identifiable {
    
    var id:UUID?
    var kwhPerDay:Double
    var numberOfPanels:Double
    var solarArraySize:Double
    var inverterSize: Double
    var batteryStorage: Double
    var commercial:Bool
    var parish: SolarUtilities.Parish
    
    //replace these with services to get up to date info
    //furthermore residential vs comerical will need differnt panels & storage calculations
    let costPerkwh:Double = 61.40
    let solarPanelWattRating:Double = 545
    let peakSunHours = 4.6
    let daysInAMonthOnAverage = 30.0
    
    // need a variable for commerical that says, days operational in the week
    // then to get the kWh per day I divide it by that.
    
    init(){
            self.kwhPerDay = 0.0
            self.solarArraySize = 0.0
            self.numberOfPanels = 0.0
            self.inverterSize = 0.0
            self.batteryStorage = 0.0
            self.commercial = false
            self.parish = SolarUtilities.Parish.Kingston
    
        }
    
    init(jpsMonthlyBill:Double){
        
        self.kwhPerDay = 0.0
        self.solarArraySize = 0.0
        self.numberOfPanels = 0.0
        self.inverterSize = 0.0
        self.batteryStorage = 0.0
        self.commercial = false
        self.parish = SolarUtilities.Parish.Kingston
        designResidentialSystem(jpsMonthlyBill: jpsMonthlyBill)
    }
    
    init(jpsMonthlyBill:Double ,openingTime:String, closingTime:String, daysOfWeekOpen:Double){
        
        self.kwhPerDay = 0.0
        self.solarArraySize = 0.0
        self.numberOfPanels = 0.0
        self.inverterSize = 0.0
        self.batteryStorage = 0.0
        self.commercial = true
        self.parish = SolarUtilities.Parish.Kingston
        designCommercialSolarSystem(jpsMonthlyBill: jpsMonthlyBill, openingTime: openingTime, closingTime: closingTime, daysOfWeekOpen: daysOfWeekOpen)
        
    }
    
    private func getkwhUsedPerDay(monthlyLightBillPayment:Double) -> Double{
        var kwhPerDay:Double
        kwhPerDay = (monthlyLightBillPayment/costPerkwh)/daysInAMonthOnAverage
        return round(kwhPerDay * 10)/10
        
    }
    
    private func getkwhUsedPerDayCommerical(monthlyLightBill:Double, daysOfTheWeekOpen: Double) ->Double
    {
        let daysInMonthOpen =  daysOfTheWeekOpen * 4.0
        let kwhPerDay = (monthlyLightBill/costPerkwh)/daysInMonthOpen
        return round(kwhPerDay * 10)/10
    }
    
    private func calculateSizeOfSolarArray(kwhPerDay: Double) -> Double{
        let size  =  kwhPerDay/peakSunHours
        return round(size * 10)/10 
    }
    
    
    private func calculateNumberOfSolarPanelsRequired(solarArraySize: Double) -> Double{
        //return ceil(solarArraySize/(solarPanelWattRating))
        return (round((solarArraySize * 1000/(solarPanelWattRating) *  10))/10).rounded(.up)
    }
    
    
    private func calculateInverterSize(solarArraySize : Double) -> Double{
    
        // for now the inverter size will be equal to the array size
        //self.inverterSize = self.solarArraySize
        return solarArraySize
    }
    
    private func calculateLithiumBatteryStorageCapacityResidential()-> Double{
        //The assumption is that the residence will use roughly 45% of thier power in the day
        //and 65% at night
        //self.batteryStorage = self.kwhPerDay * 0.65
        return round((self.kwhPerDay * 0.65) * 10) / 10 
    }
    
    private func calculateRequiredBatteryStorageHoursForBusiness(openingTime:String, closingTime:String) -> Double{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        
        let closingTimeParsed = timeConversion12(time24: closingTime)
        
        let _openingTime = formatter.date(from: openingTime)!
        //let _closingTime = formatter.date(from: closingTime)!
        let _closingTime = formatter.date(from: closingTimeParsed)!
        
        let useableSunLightStart = formatter.date(from: "8:00AM")!
        let useableSunLightEnd =  formatter.date(from: "4:00PM")!

        

        var storageMorningHours = floor( useableSunLightStart.timeIntervalSince(_openingTime) / 60 / 60 )
        
        if(storageMorningHours < 0)
        {
            storageMorningHours = 0
        }

        var storageEveningHours = floor( _closingTime.timeIntervalSince(useableSunLightEnd) / 60 / 60 )
        
        if(storageEveningHours < 0 )
        {
            storageEveningHours = 0
        }

        
        return storageMorningHours + storageEveningHours
        
    }
    

    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24.replacingOccurrences(of: "[PM]", with: "", options: [.regularExpression, .caseInsensitive]).trimmingCharacters(in: .whitespacesAndNewlines)

        let df = DateFormatter()
        df.dateFormat = "HH:mm"

        let date = df.date(from: dateAsString)
        df.dateFormat = "h:mm a"

        let time12 = df.string(from: date!)
        return time12
        
    }

    private func calculateTotalOperationalHours(openingTime:String,
                                                closingTime:String) -> Double{

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        
        let convertedClosingTime = timeConversion12(time24: closingTime)

        let _openingTime = formatter.date(from: openingTime)!
        //let _closingTime = formatter.date(from: closingTime)!
        let _closingTime = formatter.date(from: convertedClosingTime)!
        
        let operationalHours = floor(
            _closingTime.timeIntervalSince(_openingTime) / 60 / 60 )
        
//Case where operational hours are negative. switch the variables

        return operationalHours
    }

    
    
    private func calculateLithiumBatteryStorageCapacityCommercial(openingTime:String, closingTime:String, kwhPerDay:Double)-> Double{

        let requiredStorageHours = calculateRequiredBatteryStorageHoursForBusiness(openingTime: openingTime, closingTime: closingTime)
        
        
        let operationalHours =
        calculateTotalOperationalHours(openingTime: openingTime,
                                       closingTime: closingTime)
        
        //represent requiredStorageHours as a percentage of total operational hours, then
        //multiply that percentage by total kwh used per day
        
        let storageCapacityPerDay = (requiredStorageHours/operationalHours) * kwhPerDay
        return round(storageCapacityPerDay * 10)/10
        
    }
    
    
    public func designCommercialSolarSystem(jpsMonthlyBill: Double,openingTime:String, closingTime:String, daysOfWeekOpen:Double)
    {
        self.commercial = true
        self.kwhPerDay = getkwhUsedPerDayCommerical(monthlyLightBill: jpsMonthlyBill, daysOfTheWeekOpen: daysOfWeekOpen)
        self.solarArraySize = calculateSizeOfSolarArray(kwhPerDay: self.kwhPerDay)
        self.numberOfPanels = calculateNumberOfSolarPanelsRequired(solarArraySize: self.solarArraySize)
        self.inverterSize = calculateInverterSize(solarArraySize: self.solarArraySize)
        self.batteryStorage = calculateLithiumBatteryStorageCapacityCommercial(openingTime: openingTime, closingTime: closingTime, kwhPerDay: self.kwhPerDay)
    }
    
    public func designResidentialSystem(jpsMonthlyBill: Double)
    {
        self.commercial = false
        self.kwhPerDay = getkwhUsedPerDay(monthlyLightBillPayment: jpsMonthlyBill)
        self.solarArraySize = calculateSizeOfSolarArray(kwhPerDay: self.kwhPerDay)
        self.numberOfPanels = calculateNumberOfSolarPanelsRequired(solarArraySize: self.solarArraySize)
        self.inverterSize = calculateInverterSize(solarArraySize: self.solarArraySize)
        self.batteryStorage = calculateLithiumBatteryStorageCapacityResidential()
        
    }
    
    
    public func designResidentialSystem(jpsMonthlyBill: Double , parish:SolarUtilities.Parish)
    {
        self.commercial = false
        self.kwhPerDay = getkwhUsedPerDay(monthlyLightBillPayment: jpsMonthlyBill)
        self.solarArraySize = calculateSizeOfSolarArray(kwhPerDay: self.kwhPerDay)
        self.numberOfPanels = calculateNumberOfSolarPanelsRequired(solarArraySize: self.solarArraySize)
        self.inverterSize = calculateInverterSize(solarArraySize: self.solarArraySize)
        self.batteryStorage = calculateLithiumBatteryStorageCapacityResidential()
        self.parish = parish.id
        
    }
    
    
    
    
    //No Battery Option
    //Cut By A Percentage
    //Number Of Batteries
    //Bill after installation
    //ROI
    //Value Im saving each year/month
    //Need a function to account for netbilling.
    //Talk to JPS about a netbilling tariff API

    //Design system based on a percentage cut
    //Generate Invoice from app , send to email or watts app
    //Add client details


}
