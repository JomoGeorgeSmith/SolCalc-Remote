//
//  CommericalView.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/12/22.
//

import SwiftUI

struct CommericalView: View {
    
    //This is the source of truth for the solarDesign
    @EnvironmentObject var  model: SolarDesignModel
    
    @State private var jpsBill:String = ""
    
    @State private var fullName:String = ""
    
    @State private var parish:  SolarUtilities.Parish = SolarUtilities.Parish.Kingston
    
    @State private var businessDays:String = ""
    
    @State private var startTime:String = ""
    
    @State private var endTime:String = ""
    
    @State private var numberOfDaysInWeek:
    SolarUtilities.NumberOfDaysInWeek = SolarUtilities.NumberOfDaysInWeek.Five
    
    @State private var openingHours = Date.now
    
    @State private var closingHours = Date.now
    
    @ObservedObject private var viewModel: CreateClientViewModel
    
    
    init(viewModel: CreateClientViewModel = CreateClientViewModel()) {
        self.viewModel = viewModel
    }
    
    var buttonOpacity: Double {
        return viewModel.formIsValid ? 1 : 0.5
    }
    
    
    private func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    func goto () -> AnyView{
        
        calculate()
        
        return AnyView(SolarDesignView())
    }

    func calculate ()
    {
        
        let jpsAmount = (viewModel.monthlyBill as NSString).doubleValue
        
        let dateFormater = DateFormatter()
        
        dateFormater.timeStyle = .medium
        
        dateFormater.dateFormat = "HH:mma"
        
        let openingTimeString = dateFormater.string(from: openingHours)
        
        let closingTimeString = dateFormater.string(from: closingHours)
        
        model.solarDesign.client.fullName = viewModel.clientName
        
        model.solarDesign.designCommercialSolarSystem(jpsMonthlyBill: jpsAmount, openingTime: openingTimeString, closingTime: closingTimeString , daysOfWeekOpen: Double(numberOfDaysInWeek.rawValue))
        
    }
    
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            
            Image("logo2")
                .resizable()
                .frame(width: 120.0, height:140.0)  .frame(maxWidth: .infinity, alignment: .center)
            
            
            ScrollView {
                
                
                VStack(alignment: .leading)
                {
                    
                    
                    Form{
                        Section{
                            TextField("Client Name", text: $viewModel.clientName)
                            
                            
                            TextField("Monthly Bill", text: $viewModel.monthlyBill).keyboardType(/*@START_MENU_TOKEN@*/.decimalPad/*@END_MENU_TOKEN@*/)
                            
                            
                            Picker(selection: $parish, label: Text("Parish : ")) {
                                ForEach(Array(SolarUtilities.Parish.allCases), id: \.self) {
                                    Text($0.rawValue)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                        
                        
                        Picker(selection: $numberOfDaysInWeek, label: Text("Business Days :")) {
                            ForEach(Array(SolarUtilities.NumberOfDaysInWeek.allCases), id: \.self) {
                                Text(String( $0.rawValue))
                            }
                        }
                        .pickerStyle(DefaultPickerStyle())
                        
                        
                        HStack{
                            
                            DatePicker("Opening Hours" , selection: $openingHours , displayedComponents: .hourAndMinute).labelsHidden().padding()
                            
                            
                            
                            DatePicker("" , selection: $closingHours , displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .padding()
                        }
                        
                        
                        
                    }.padding(.all).frame(height: 500)
                    
                    
                    NavigationLink(destination: goto()) {
                        HStack {
                            Text("Calculate").padding(.all).frame(maxWidth: .infinity, alignment: .center)
                        }
                    }.padding()
                        .frame(maxWidth: .infinity)
                        .opacity(buttonOpacity)
                        .disabled(!viewModel.formIsValid)
                    
                }
                
            }
            .padding(.all)
            
        }
    }
    
}


struct CommericalView_Previews: PreviewProvider {
    static var previews: some View {
        CommericalView().environmentObject(SolarDesignModel())
    }
}
