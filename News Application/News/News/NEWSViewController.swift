//
//  NEWSViewController.swift
//  News
//
//  Created by zs-mac-6 on 09/11/22.
//

import UIKit
import WebKit

class NEWSViewController: UIViewController {
    
    var webPage:WKWebView!
    
    var link:String?
   
    var progressBar:UIProgressView = {
        let bar=UIProgressView(frame: .zero)
       
        return bar
    }()
    
    override func loadView() {
        super.loadView()
        self.webPage=WKWebView()
        self.webPage.navigationDelegate=self
        self.view=webPage
        guard let urlToNexgPage=link else{return}
        guard let url=URL(string: urlToNexgPage) else{return}
        webPage.load(URLRequest(url: url))
        webPage.allowsBackForwardNavigationGestures=true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden=false

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.config()
        
    }

    func config(){
        
        webPage.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        
        //MARK: configure NavigationBar
        self.navigationItem.largeTitleDisplayMode = .never
        self.tabBarController?.tabBar.isHidden=true
        
        
        //MARK: progress Bar
        self.view.addSubview(progressBar)
        progressBar.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([
            progressBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            progressBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        
            
        ])
        
    }
    

}


extension NEWSViewController:WKNavigationDelegate{
 
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress"{
            progressBar.progress=Float()
            progressBar.progress = Float(webPage.estimatedProgress)
            
            if self.webPage.estimatedProgress >= 1.0{
                UIView.animate(withDuration: 0.3, delay: 0.1) {
                   ()->Void in
                    self.progressBar.progress=0.0
                }
            }
                
        }
    }
   
    
    
}



