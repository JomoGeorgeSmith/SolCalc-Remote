//
//  CommericalView.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/12/22.
//

import SwiftUI

struct CommericalView: View {
    
    var model = SolarDesignModel()
    var priceModel = PriceService()
    
    @State private var jpsBill:String = ""
    
    @State private var numberOfPanels:String = ""
    
    @State private var arraySize:String = ""
    
    @State private var requiredStorage:String = ""
    
    @State private var inverterCapacity:String = ""
    
    @State private var estimatedCost:String = ""
    
    @State private var businessDays:String = ""
    
    @State private var startTime:String = ""
    
    @State private var endTime:String = ""
    
    @State private var parish:  SolarUtilities.Parish = SolarUtilities.Parish.Kingston
    
    @State private var numberOfDaysInWeek:
    SolarUtilities.NumberOfDaysInWeek = SolarUtilities.NumberOfDaysInWeek.Five
    
    @State private var openingHours = Date.now
    
    @State private var closingHours = Date.now
    
    
    private func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
    func calculate ()
    {
        
        let kW = " kW"
        
        let kWh = " kWh"
        
        let jpsAmount = (jpsBill as NSString).doubleValue
        
        let dateFormater = DateFormatter()
        
        dateFormater.timeStyle = .medium
        
        dateFormater.dateFormat = "HH:mma"
        
        var openingTimeString = dateFormater.string(from: openingHours)
        
        var closingTimeString = dateFormater.string(from: closingHours)
        
        model.solarDesign.designCommercialSolarSystem(jpsMonthlyBill: jpsAmount, openingTime: openingTimeString, closingTime: closingTimeString , daysOfWeekOpen: Double(numberOfDaysInWeek.rawValue))
        
        numberOfPanels = String( model.solarDesign.numberOfPanels)
        
        arraySize = String(model.solarDesign.solarArraySize)
        
        arraySize += kW
        
        requiredStorage = String(model.solarDesign.batteryStorage)
        
        requiredStorage += kWh
        
        inverterCapacity = String(model.solarDesign.inverterSize)
        
        inverterCapacity += kW
        
        estimatedCost =
        convertDoubleToCurrency(amount: priceModel.calculateEstimateForDesign(design: model.solarDesign).totalEstimate )
        
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            
            Image("logo2")
                .resizable()
                .frame(width: 120.0, height:140.0)  .frame(maxWidth: .infinity, alignment: .center)
            
            
            ScrollView {
                
                
                VStack(alignment: .leading)
                {
                    
                    HStack{
                        
                        Text("Monthly Payments : ")
                            .multilineTextAlignment(.leading)
                        TextField("JPS Average Monthly Payments " , text: $jpsBill)
                            .padding([.top, .bottom, .trailing], 4.0)
                            .frame(width: 220.0)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                            
                    }.padding()
                    
                    HStack{
                        Text("Business Days : ")
                        
                        Picker(selection: $numberOfDaysInWeek, label: Text("")) {
                            ForEach(Array(SolarUtilities.NumberOfDaysInWeek.allCases), id: \.self) {
                                Text(String( $0.rawValue))
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        
                    }.padding()
                    
                    
                    HStack(spacing: 0.0){
                        
                        Text("Select Parish : ").multilineTextAlignment(.leading)
                            .padding()
                        
                        Picker(selection: $parish, label: Text("Parish : ")) {
                            ForEach(Array(SolarUtilities.Parish.allCases), id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                    }
                    
                    
                    ZStack{
                        Text("Business Hours : ").padding()
                    }
                    
                    HStack{
                        
                        DatePicker("Select opening hours" , selection: $openingHours , displayedComponents: .hourAndMinute).labelsHidden().padding()
                        
                        Text("to :").padding()
                        
                        DatePicker("Select closing hours" , selection: $closingHours , displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .padding()
                    }
                    
                    Group
                    {
                        
                        HStack{
                            Text("Array Size : ")
                                .multilineTextAlignment(.leading)
                            Text(arraySize)
                        }.padding()
                        
                        HStack{
                            Text("Number Of Solar Panels : ")
                            Text(numberOfPanels)
                        }.padding()
                        
                        HStack{
                            Text("Inverter Capacity : ")
                            Text(inverterCapacity)
                        }.padding()
                        
                        
                        HStack{
                            Text("Battery Storage : ")
                            Text(requiredStorage)
                        }.padding()
                        
                        
                        HStack{
                            Text("Estimated Cost : ")
                            Text(estimatedCost)
                        }.padding()
                        
                        
                    }
                    
                    Button("Calculate", action: calculate).padding()  .frame(maxWidth: .infinity, alignment: .center)
                    
                }
                
            }
            
        }
    }
    
}

struct CommericalView_Previews: PreviewProvider {
    static var previews: some View {
        CommericalView()
    }
}
