//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by bc0067042 on 2016/06/22.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import Social
import MessageUI

class ShareViewController: SLComposeServiceViewController, MFMailComposeViewControllerDelegate {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
             guard let extensionContext = self.extensionContext else {
            return
        }
        
        guard let inputItem = extensionContext.inputItems.first as? NSExtensionItem else {
            return
        }
        
        guard let itemProvider = inputItem.attachments![0] as? NSItemProvider else {
            return
        }
        
//        let inputItem = self.extensionContext!.inputItems.first as! NSExtensionItem
//        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        
        if (itemProvider.hasItemConformingToTypeIdentifier("public.url")) {
            itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (urlItem, error) in
                
                let url = urlItem as! NSURL;
                // 取得したURLを表示
                print("\(url.absoluteString)")
                
                self.extensionContext!.completeRequestReturningItems([], completionHandler: nil)
                
            })
        }
    }

    override func configurationItems() -> [AnyObject]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if MFMailComposeViewController.canSendMail()==false {
            print("Email Send Failed")
            return
        }
        
        var mailViewController = MFMailComposeViewController()
        var toRecipients = ["hoge@gmail.com"] //Toのアドレス指定
        //        var CcRecipients = ["cc@1gmail.com","Cc2@1gmail.com"] //Ccのアドレス指定
        //        var BccRecipients = ["Bcc@1gmail.com","Bcc2@1gmail.com"] //Bccのアドレス指定
        
        mailViewController.mailComposeDelegate = self
        mailViewController.setSubject("メールの件名")
        mailViewController.setToRecipients(toRecipients) //Toアドレスの表示
        //        mailViewController.setCcRecipients(CcRecipients) //Ccアドレスの表示
        //        mailViewController.setBccRecipients(BccRecipients) //Bccアドレスの表示
        mailViewController.setMessageBody("メールの本文", isHTML: false)
        self.presentViewController(mailViewController, animated: true, completion: nil)
        
    }
    
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result {
        case MFMailComposeResultCancelled:
            print("Email Send Cancelled")
            break
        case MFMailComposeResultSaved:
            print("Email Saved as a Draft")
            break
        case MFMailComposeResultSent:
            print("Email Sent Successfully")
            break
        case MFMailComposeResultFailed:
            print("Email Send Failed")
            break
        default:
            break
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
