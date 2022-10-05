//
//  SolarDesign.swift
//  SolCalc
//
//  Created by Jomo Smith on 1/31/22.
//

import Foundation
import Accessibility

class SolarDesign: ObservableObject {
    
    var priceModel = PriceService()
    
    var client = Client()
    
    @Published var id:UUID?
    @Published var kwhPerDay:Double
    @Published var numberOfPanels:Int
    @Published var brandOfPanels : String
    @Published var solarArraySize:Double
    @Published var inverterSize: Double
    @Published var batteryStorage: Double
    @Published var commercial:Bool
    @Published var parish: SolarUtilities.Parish
    @Published var estimatedCost :Double
    @Published var estimatedCostFormatted :String?
    @Published var numberOfInverters: Int
    @Published var inverterModel : String
    @Published var inverterUnitPrice : Double
    @Published var solarPanelUnitPrice : Double
    @Published var numberOfBatteries: Int
    @Published var batteryModel : String
    
    
    let costPerkwh:Double = 61.40
    let solarPanelWattRating:Double = 545
    let peakSunHours = 4.6
    let daysInAMonthOnAverage = 30.0
    
    public var skytrak6k = "Skytrak 6k Hybrid Inverter"
    public var  skytrak8k = "Skytrak 8k Hybrid Inverter"
    public var xliion = "x-lion Lithium Battery"
    public var GSW545 = "545 Watt Solar Panels"
    
    init(){
        
            self.kwhPerDay = 0.0
            self.solarArraySize = 0.0
            self.numberOfPanels = 0
            self.brandOfPanels = ""
            self.inverterSize = 0.0
            self.batteryStorage = 0.0
            self.commercial = false
            self.parish = SolarUtilities.Parish.Kingston
            self.estimatedCost = 0.0
            self.numberOfInverters = 0
            self.numberOfBatteries = 0
            self.inverterModel = ""
            self.inverterUnitPrice = 0.0
            self.solarPanelUnitPrice = 0.0
            self.batteryModel = ""
    
        }
    
    init(jpsMonthlyBill:Double){
        
        self.kwhPerDay = 0.0
        self.solarArraySize = 0.0
        self.numberOfPanels = 0
        self.brandOfPanels = ""
        self.inverterSize = 0.0
        self.batteryStorage = 0.0
        self.commercial = false
        self.parish = SolarUtilities.Parish.Kingston
        self.estimatedCost = 0.0
        self.numberOfInverters = 0
        self.numberOfBatteries = 0
        self.inverterModel = ""
        self.batteryModel = ""
        self.inverterUnitPrice = 0.0
        self.solarPanelUnitPrice = 0.0
        designResidentialSystem(jpsMonthlyBill: jpsMonthlyBill)

    }
    
    init(jpsMonthlyBill:Double ,openingTime:String, closingTime:String, daysOfWeekOpen:Double){
        
        self.kwhPerDay = 0.0
        self.solarArraySize = 0.0
        self.numberOfPanels = 0
        self.brandOfPanels = ""
        self.inverterSize = 0.0
        self.batteryStorage = 0.0
        self.commercial = true
        self.parish = SolarUtilities.Parish.Kingston
        self.estimatedCost = 0.0
        self.numberOfInverters = 0
        self.numberOfBatteries = 0
        self.inverterModel = ""
        self.batteryModel = ""
        self.inverterUnitPrice = 0.0
        self.solarPanelUnitPrice = 0.0
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
    
    private func calculateNumberOfSolarPanelsRequired(solarArraySize: Double) -> Int{
        
        let number = Int((round((solarArraySize * 1000/(solarPanelWattRating) *  10))/10).rounded(.up))
        self.brandOfPanels = GSW545;
        if (number % 2 != 0 ){
        return number + 1
        }
        else{
        return number
        }
    
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
        let _closingTime = formatter.date(from: convertedClosingTime)!
        
        let operationalHours = floor(
            _closingTime.timeIntervalSince(_openingTime) / 60 / 60 )

        return operationalHours
    }

    private func calculateLithiumBatteryStorageCapacityCommercial(openingTime:String, closingTime:String, kwhPerDay:Double)-> Double{

        let requiredStorageHours = calculateRequiredBatteryStorageHoursForBusiness(openingTime: openingTime, closingTime: closingTime)
        
        
        let operationalHours =
        calculateTotalOperationalHours(openingTime: openingTime,
                                       closingTime: closingTime)
        
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
        self.batteryStorage = calculateLithiumBatteryStorageCapacityResidential()
        //self.batteryStorage = calculateRequiredBatteryStorageHoursForBusiness(openingTime: openingTime, closingTime: closingTime)
        self.parish = parish.id
        self.numberOfInverters = selectInverterResidential(solarArraySize: self.solarArraySize)
        self.numberOfBatteries = selectNumberOfBatteries(storageRequired: self.batteryStorage)
        self.estimatedCost =  priceModel.calculateEstimateForDesign(design: self).totalEstimate
        self.estimatedCostFormatted = convertDoubleToCurrency( amount: self.estimatedCost)
        
    }
    
    public func designResidentialSystem(jpsMonthlyBill: Double)
    {
        self.commercial = false
        self.kwhPerDay = getkwhUsedPerDay(monthlyLightBillPayment: jpsMonthlyBill)
        self.solarArraySize = calculateSizeOfSolarArray(kwhPerDay: self.kwhPerDay)
        self.numberOfPanels = calculateNumberOfSolarPanelsRequired(solarArraySize: self.solarArraySize)
        self.inverterSize = calculateInverterSize(solarArraySize: self.solarArraySize)
        self.batteryStorage = calculateLithiumBatteryStorageCapacityResidential()
        self.numberOfInverters = selectInverterResidential(solarArraySize: self.solarArraySize)
        self.numberOfBatteries = selectNumberOfBatteries(storageRequired: self.batteryStorage)
        self.estimatedCost =  priceModel.calculateEstimateForDesign(design: self).totalEstimate
        self.estimatedCostFormatted = convertDoubleToCurrency( amount: self.estimatedCost)
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
        self.numberOfInverters = selectInverterResidential(solarArraySize: self.solarArraySize)
        self.numberOfBatteries = selectNumberOfBatteries(storageRequired: self.batteryStorage)
        self.estimatedCost =  priceModel.calculateEstimateForDesign(design: self).totalEstimate
        self.estimatedCostFormatted = convertDoubleToCurrency( amount: self.estimatedCost)
    }
    
    public func designResidentialSystem(jpsMonthlyBill: Double , fullName: String, parish:SolarUtilities.Parish)
    {
        self.commercial = false
        self.kwhPerDay = getkwhUsedPerDay(monthlyLightBillPayment: jpsMonthlyBill)
        self.solarArraySize = calculateSizeOfSolarArray(kwhPerDay: self.kwhPerDay)
        self.numberOfPanels = calculateNumberOfSolarPanelsRequired(solarArraySize: self.solarArraySize)
        self.inverterSize = calculateInverterSize(solarArraySize: self.solarArraySize)
        self.batteryStorage = calculateLithiumBatteryStorageCapacityResidential()
        self.parish = parish.id
        self.numberOfInverters = selectInverterResidential(solarArraySize: self.solarArraySize)
        self.numberOfBatteries = selectNumberOfBatteries(storageRequired: self.batteryStorage)
        self.estimatedCost =  priceModel.calculateEstimateForDesign(design: self).totalEstimate
        self.estimatedCostFormatted = convertDoubleToCurrency( amount: self.estimatedCost)
        self.client.fullName = fullName

    }
    
    private func convertDoubleToCurrency(amount: Double) -> String {
         let numberFormatter = NumberFormatter()
         numberFormatter.numberStyle = .currency
         numberFormatter.locale = Locale.current
         return numberFormatter.string(from: NSNumber(value: amount))!
     }
    
    private func selectInverterResidential(solarArraySize: Double) -> Int
    {
        if(self.solarArraySize == 0){
            return 0
        }
        
        if(self.solarArraySize < 4 ) {
            self.inverterModel = skytrak6k
            self.inverterUnitPrice = priceModel.costSkyTrack6k
            return Int(ceil(solarArraySize/6).rounded(.up))
        }
        
        else{
            self.inverterModel = skytrak8k
            self.inverterUnitPrice = priceModel.costSkyTrack8k
            return Int(ceil(solarArraySize/8).rounded(.up))
        }
    }
    
    private func selectNumberOfBatteries(storageRequired:Double)-> Int{
        if(self.batteryStorage == 0){
            return 0
        }
        else {
            self.batteryModel = xliion
            return Int(round(batteryStorage/8).rounded(.up))
        }
    }
}
