import UIKit
import SolCalc
//


var commericalSolarDesign = SolarDesign()
//
//var residentialSolarDesign = SolarDesign()

//var o = SolarDesign(jpsMonthlyBill: 33304.00, openingTime: "7:00AM", closingTime: "8:00PM",daysOfWeekOpen: 6.0)

//var l = SolarDesign(jpsMonthlyBill: 45000.00)
//
//
commericalSolarDesign.designCommercialSolarSystem(jpsMonthlyBill: 50000.00, openingTime: "7:00AM", closingTime: "9:00PM",daysOfWeekOpen: 6.0)
//
print("kWh used per day: ", commericalSolarDesign.kwhPerDay, "Array Size: " , commericalSolarDesign.solarArraySize, "Number of panels:", commericalSolarDesign.numberOfPanels, "Storage: ", commericalSolarDesign.batteryStorage)
///
//residentialSolarDesign.designResidentialSystem(jpsMonthlyBill: 50000.00)
//
//print("kWh used per day: ", residentialSolarDesign.kwhPerDay, "Array size: ", residentialSolarDesign.solarArraySize, "Number Of Panels: ", residentialSolarDesign.numberOfPanels, "Storage: ", residentialSolarDesign.batteryStorage)

//
//print("kWh used per day: ", o.kwhPerDay, "Array size: ", o.solarArraySize, "Number Of Panels: ", o.numberOfPanels, "Storage: ", o.batteryStorage)

////
//print("kWh used per day: ", l.kwhPerDay, "Array Size: " , l.solarArraySize, "Number of panels:", l.numberOfPanels, "Storage: ", l.batteryStorage)


var date1 = Date.now


let formatter = DateFormatter()
formatter.dateFormat = "H:mma"
//let someDateTime = formatter.date(from: "2016/10/08 22:31")!
let someDateTimeClosing = formatter.date(from: "10:00PM")!
let someDateTime2Opening = formatter.date(from: "09:00AM")!

let difference = someDateTimeClosing.timeIntervalSince(someDateTime2Opening)

let difference2 = someDateTime2Opening.timeIntervalSince(someDateTimeClosing)


print(difference/3600)

print(difference2/3600)
