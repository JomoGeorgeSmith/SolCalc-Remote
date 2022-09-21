//
//  ResidentialView.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/6/22.
//

import SwiftUI

struct ResidentialView: View {
    
    var model = SolarDesignModel()
    var priceModel = PriceService()
    
    @State private var jpsBill:String = ""
    @State private var numberOfPanels:String = ""
    @State private var arraySize:String = ""
    @State private var requiredStorage:String = ""
    @State private var inverterCapacity:String = ""
    @State private var estimatedCost:String = ""
    
    @State private var parish:  SolarUtilities.Parish = SolarUtilities.Parish.Kingston
    
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
        
        model.solarDesign.designResidentialSystem(jpsMonthlyBill: jpsAmount, parish: parish)
        
        numberOfPanels = String( model.solarDesign.numberOfPanels)
        
        arraySize = String(model.solarDesign.solarArraySize)
        
        arraySize += kW
        
        requiredStorage = String(model.solarDesign.batteryStorage)
        
        requiredStorage += kWh
        
        inverterCapacity = String(model.solarDesign.inverterSize)
        
        inverterCapacity += kW
        
        estimatedCost =
        convertDoubleToCurrency( amount: priceModel.calculateEstimateForDesign(design: model.solarDesign).totalEstimate )
        
    }
    
    var body: some View {
        
        NavigationView {
            
        VStack(alignment: .leading){
      
             Image("logo2")
                    .resizable()
                    .frame(width: 140.0, height:160.0)  .frame(maxWidth: .infinity, alignment: .center)
        
            
            HStack{
                
                Text("Monthly Payments : ")
                    .multilineTextAlignment(.leading)
                    .lineLimit(16)
                TextField("$ " , text: $jpsBill)
                    .padding([.top, .bottom, .trailing], 4.0)
                    .frame(width: 220.0)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(/*@START_MENU_TOKEN@*/.default/*@END_MENU_TOKEN@*/)
                    .keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
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
            
            
            Button("Calculate", action: calculate).padding()  .frame(maxWidth: .infinity, alignment: .center)
            
            
            Section{
                
           
            HStack{
                Text("Solar Array Size : ")
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
                
            }.listStyle(GroupedListStyle())
            
                
            //}

      
            
        }
        }
    }
}

struct ResidentialView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentialView()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
