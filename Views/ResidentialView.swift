//
//  ResidentialView.swift
//  SolCalc
//
//  Created by Jomo Smith on 2/6/22.
//

import SwiftUI

struct ResidentialView: View {
    
    //This is the source of truth for the solarDesign
    @EnvironmentObject var  model: SolarDesignModel
    
    
    @State private var jpsBill:String = ""
    @State private var fullName:String = ""
    
    
    @State private var parish:  SolarUtilities.Parish = SolarUtilities.Parish.Kingston
    
    
    @ObservedObject private var viewModel: CreateClientViewModel
    
    enum Field {
        case clientName
        case jpsBill
    }
    
    @FocusState private var focusedField: Field?
    
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
    
    
    func calculate ()
    {
        
        let jpsAmount = (viewModel.monthlyBill as NSString).doubleValue
        
        model.solarDesign.client.fullName = viewModel.clientName
        
        model.solarDesign.designResidentialSystem(jpsMonthlyBill: jpsAmount, parish: parish)
        
    }
    
    func goto () -> AnyView{
        
        calculate()
        
        return AnyView(SolarDesignView())
    }
    
    var body: some View {
        
        
        ScrollView {
            VStack(alignment: .leading){
                
                Image("logo2")
                    .resizable()
                    .frame(width: 140.0, height:160.0)  .frame(maxWidth: .infinity, alignment: .center)
                
                
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
                }.padding(.all).frame(height: 400)
                
                
                NavigationLink(destination: goto()) {
                    HStack {
                        Text("Calculate").padding([.top, .leading, .bottom]).frame(maxWidth: .infinity, alignment: .center)
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



struct ResidentialView_Previews: PreviewProvider {
    static var previews: some View {
        ResidentialView()
            .previewInterfaceOrientation(.portraitUpsideDown).environmentObject(SolarDesignModel())
        
    }
}
