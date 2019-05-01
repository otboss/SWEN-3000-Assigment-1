//
//  ViewController.swift
//  FileExplorer
//
//  Created by Otboss on 2019/4/28.
//  Copyright © 2019 Otboss. All rights reserved.
//

import UIKit;
import WebKit;

class ViewController: UIViewController, WKNavigationDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadHtmlFile();
    }
    
    @IBOutlet var webView: WKWebView!;
    

    override func loadView() {
        webView = WKWebView();
        webView.navigationDelegate = self;
        view = webView;
    }
    
    
    func loadHtmlFile() {
        let url = Bundle.main.url(forResource: "file_explorer", withExtension:"html")
        let request = NSURLRequest(url: url!)
        webView.load(request as URLRequest)
    }
    
}

