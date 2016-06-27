//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by bc0067042 on 2016/06/22.
//  Copyright © 2016年 maru.ishi. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        
        //全体的に if let か gard letに書き換える★ as!→as? に
        //send grid swift など使う？
        
        let inputItem = self.extensionContext!.inputItems.first as! NSExtensionItem
        let itemProvider = inputItem.attachments![0] as! NSItemProvider
        
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

}
