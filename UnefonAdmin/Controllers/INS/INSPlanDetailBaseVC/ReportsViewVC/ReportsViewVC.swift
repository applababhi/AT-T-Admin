//
//  ReportsViewVC.swift
//  UnefonAdmin
//
//  Created by Shalini Sharma on 9/10/19.
//  Copyright © 2019 Shalini Sharma. All rights reserved.
//

import UIKit
import WebKit
import MobileCoreServices

class ReportsViewVC: UIViewController, UIDocumentInteractionControllerDelegate {

    @IBOutlet weak var btnShare:UIButton!
    var webView: WKWebView!
    @IBOutlet weak var viewWeb:UIView!
    
    var csvFilePath = ""
    
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: viewWeb.frame.size.width, height: viewWeb.frame.size.height))
        
        viewWidth = viewWeb.frame.size.width
        viewHeight = viewWeb.frame.size.height
                
        self.webView.navigationDelegate = self
        let urlRequest = URLRequest.init(url: URL(string: csvFilePath)!)
        webView.load(urlRequest)
        self.viewWeb.addSubview(webView)
    }
    
    override func viewWillLayoutSubviews() {
        
        if webView != nil
        {
            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight
            {
                webView.frame = CGRect(x: 0, y: 0, width: viewHeight, height: viewWidth)
            }
            else
            {
                webView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
            }

        }        
    }

    @IBAction func backClicked(btn:UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func btnShareClick(btn:UIButton)
    {
        let docController = UIDocumentInteractionController(url: URL(string: csvFilePath)!)
        docController.uti = kUTTypePlainText as String
         //"public.data, public.content" //URL(string: csvFilePath)!.uti //"public.comma-separated-values-text"
        docController.delegate = self
        docController.presentPreview(animated: true)

    }
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

}

extension ReportsViewVC : WKNavigationDelegate
{
    func webView(_ webView: WKWebView, didFinish navigation:
        WKNavigation!) {
        self.hideSpinner()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation
        navigation: WKNavigation!) {
        self.showSpinnerWith(title: "Cargando...")
    }
    
    func webView(_ webView: WKWebView, didFail navigation:
        WKNavigation!, withError error: Error) {
        self.hideSpinner()
    }
    
}
