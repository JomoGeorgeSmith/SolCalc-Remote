//
//  CustomMailService.swift
//  SolCalc
//
//  Created by Jomo Smith on 9/28/22.
//

import Foundation
import MessageUI
import SwiftUI

class CustomMailService: MFMailComposeViewController{
    
    init(recipients:[String]? , subject : String = "Solar System Invoice" , messageBody: String = "Here is the invoice for your solar System" , messageBodyIsHTML: Bool = false, attachment:Data){
        super.init(nibName: nil, bundle: nil)
        setToRecipients(recipients)
        setSubject(subject)
        setMessageBody(messageBody, isHTML: messageBodyIsHTML)
        addAttachmentData(attachment, mimeType: "application/pdf", fileName: "SolarSystemInvoice.pdf")
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
