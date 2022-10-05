//
//  PDFResponse.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/28/22.
//

import Foundation

struct  PDFResponse : Codable{
    
    var status: String = ""
    var download_url: String = ""
    var template_id: String = ""
    var transaction_ref: String = "" 
}


//public func SavePDfFromURL(pdfURL: String) {
//    
//    let documentDirectory = FileManager.default.urls(for: .documentDirectory,
//                                                    in: .userDomainMask)[0]
//    let pdfName = documentDirectory.appendingPathComponent("Invoice.PDF")
//    
//    let urlString = pdfURL
//
//    if let pdfUrl = URL(string: urlString) {
//        // 3
//        URLSession.shared.downloadTask(with: pdfUrl) { (tempFileUrl, response, error) in
//            
//            if let pdfTempFileUrl = tempFileUrl {
//                do {
//                    
//                    let pdfData = try Data(contentsOf: pdfTempFileUrl)
//                    
//                    try pdfData.write(to: pdfName)
//                    
//                    
//                } catch {
//                    print("Error")
//                }
//            }
//        }.resume()
//    }
//    
//}
