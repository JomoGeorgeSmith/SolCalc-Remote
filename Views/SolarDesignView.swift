//
//  SolarDesignView.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/21/22.
//

import SwiftUI
import PDFKit

struct SolarDesignView: View {
    
    @EnvironmentObject var model:SolarDesignModel
    
    let invoiceService = InvoiceService()
    
    private func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    
    
    var body: some View {
        VStack {
            
            List {
                
                Section(header:Text("System Components")) {
                    VStack(alignment: .leading){
                        
                        Section {
                            HStack{
                                Image(systemName: "sun.and.horizon")
                                Text("Solar Panels :")
                                Text(String(model.solarDesign.numberOfPanels)).padding()
                                
                                
                            }
                        }
                        
                        Section {
                            HStack{
                                Image(systemName: "xserve")
                                Text("Inverters :")
                                
                                Text(String(model.solarDesign.numberOfInverters)).padding()
                            }
                        }
                        
                        
                        Section {
                            HStack{
                                Image(systemName: "macpro.gen2")
                                Text("Batteries :")
                                Text(String(model.solarDesign.numberOfBatteries)).padding()
                                
                            }
                        }
                        
                        Section {
                            HStack{
                                Image(systemName: "dollarsign.circle")
                                Text("Cost :")
                                Text(convertDoubleToCurrency(amount : model.solarDesign.estimatedCost)).padding()
                            }
                        }
                    }
                }.headerProminence(.increased)
                
            }
            .listStyle(.insetGrouped)
            
            
            Button(action: {
                
                let invoiceService = InvoiceService()
                
                invoiceService.generateInvoice(design: model.solarDesign, completion: { _ in
                    
                    DispatchQueue.main.async {
                        
                        EmailService.shared.sendEmail(subject: (model.solarDesign.client.fullName + " " + "Solar System Invoice") , body: "", to: "", attachment:  model.solarDesign.client.pdfFile!) { (isWorked) in
                            if !isWorked{ //if mail couldn't be presented
                                // do action
                            }
                            
                        }
                    }})
                
            }, label: {
                Text("Send")
            })
            
            
        }
    }
}

struct SolarDesignView_Previews: PreviewProvider {
    static var previews: some View {
        SolarDesignView()
        //.environmentObject(SolarDesignModel())
    }
}
