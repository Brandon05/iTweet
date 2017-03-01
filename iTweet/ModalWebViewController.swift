//
//  ModalWebViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 3/1/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class ModalWebViewController: UIViewController {
    
    @IBOutlet var webView: UIWebView!
    
    var urlString = String() {
        didSet {
            print(urlString)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if urlString != nil {
            open(urlString: urlString)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onDone(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    func open(urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            if request != nil {
                if webView != nil {
                    webView.loadRequest(URLRequest(url: URL(string: urlString)!))
                }
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
