//
//  PDFService.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/28/22.
//

import Foundation



class PDFService{
    

    
    
    static func downloadPDFAsync(pdfURL: String, solarDesign: SolarDesign) {
        let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                        in: .userDomainMask)[0]
        let pdfName = documentDirectory.appendingPathComponent("Invoice.PDF")
        
        let urlString = pdfURL

        if let pdfUrl =  URL(string: urlString)  {
            // 3
             URLSession.shared.downloadTask(with: pdfUrl) { (tempFileUrl, response, error) in
                
                if let pdfTempFileUrl = tempFileUrl {
                    do {
                        
                        //returnData = try await Data(contentsOf: pdfTempFileUrl)
                        
                        let pdfData = try Data(contentsOf: pdfTempFileUrl)
                      
                        try pdfData.write(to: pdfName)
                    
                        solarDesign.client.pdfFile = pdfData
                        
                        
                    } catch {
                        print("Error")
                    }
                }
            }.resume()
        }

    }

 func SavePDfFromURL(pdfURL: String) {
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask)[0]
    let pdfName = documentDirectory.appendingPathComponent("Invoice.PDF")
    
    let urlString = pdfURL

    if let pdfUrl = URL(string: urlString) {
        // 3
        URLSession.shared.downloadTask(with: pdfUrl) { (tempFileUrl, response, error) in
            
            if let pdfTempFileUrl = tempFileUrl {
                do {
                    
                    let pdfData = try Data(contentsOf: pdfTempFileUrl)
                    
                    try pdfData.write(to: pdfName)
                    
                    
                } catch {
                    print("Error")
                }
            }
        }.resume()
    }
    
}

    
}
