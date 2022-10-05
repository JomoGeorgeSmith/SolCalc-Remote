//
//  InvoiceService.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/23/22.
//

import SwiftUI
import PDFKit
import MessageUI

class InvoiceService {
    
    static let shared = InvoiceService()
    
    func generateInvoice(design:SolarDesign , completion: @escaping (Result<Any,Error> ) -> Void)  {
        
        let url = URL(string: "https://invoice-generator.com")!
        
        
        var postRequest = URLRequest(url: url)
        postRequest.httpMethod = "POST"
        
        postRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        postRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var items = [Items]()
        
        items.append(Items(name: String(design.brandOfPanels), quantity: Double(design.numberOfPanels), unit_cost: Double(design.priceModel.costGSWSolarPanel545watt)))

        items.append(Items(name: String(design.inverterModel), quantity: Double(design.numberOfInverters), unit_cost: Double(design.inverterUnitPrice)))

        items.append(Items(name: String(design.batteryModel), quantity: Double(design.numberOfBatteries), unit_cost: Double(design.priceModel.costXliionBattery)))

        items.append(Items(name: "Electrical Material & Wiring", quantity: 1, unit_cost: Double(design.priceModel.costElectricalMaterialAndWiring)))

        items.append(Items(name: "Transportation", quantity: 1, unit_cost: Double(design.priceModel.estimate.costOfTransportation)))

        items.append(Items(name: "Railing For Solar Panels", quantity: 1, unit_cost: Double(design.priceModel.estimate.costOfRacking)))

        items.append(Items(name: "Design, Installation & Consulting", quantity: 1, unit_cost: (Double(design.priceModel.estimate.costOfContractors) + Double(design.priceModel.estimate.costOfManagementAndDesign))))
        
        let newInvoice = InvoiceGenerator(logo: "https://i.postimg.cc/W3xCqGY1/logo2.png" ,  from: "STARWIND TECH LIMITED" , to : design.client.fullName , items: items , currency: "JMD")
       
        let jsonEncoder = JSONEncoder()
        
        do{
            
            let jsonData = try jsonEncoder.encode(newInvoice)
            postRequest.httpBody = jsonData
            
            
        } catch {
            print("Encoding Error")
        }
        
          URLSession.shared.dataTask(with: postRequest) {(data, response, error)
            in
            
            if let httpResponse = response as? HTTPURLResponse{
                print("Status code: \(httpResponse.statusCode)")
                design.client.pdfFile = data
            }
            
            
            guard let validData = data, error == nil else {
                //completion(.failure(error!))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: validData, options: [.fragmentsAllowed])
                completion(.success(json))

           } catch let serializationError {
                completion(.failure(serializationError))
            }
        }.resume()
        
    }
}


