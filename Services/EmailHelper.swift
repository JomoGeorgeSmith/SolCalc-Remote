import Foundation
import MessageUI

class EmailService: NSObject, MFMailComposeViewControllerDelegate {
public static let shared = EmailService()

func sendEmail(subject:String, body:String, to:String, attachment:Data, completion: @escaping (Bool) -> Void){
 if MFMailComposeViewController.canSendMail(){
    let picker = MFMailComposeViewController()
    picker.setSubject(subject)
    picker.setMessageBody(body, isHTML: true)
    picker.setToRecipients([to])
    picker.mailComposeDelegate = self
    picker.addAttachmentData(attachment as Data, mimeType: "application/pdf", fileName: "SolarSystemInvoice.pdf")
    
   UIApplication.shared.windows.first?.rootViewController?.present(picker,  animated: true, completion: nil)
}
  completion(MFMailComposeViewController.canSendMail())
}

func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
     }
}


