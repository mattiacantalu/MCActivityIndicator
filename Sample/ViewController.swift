//
//  ViewController.swift
//  MCActivityIndicator
//
//  Created by Mattia Cantalù on 01/09/16.
//  Copyright © 2016 Mattia Cantalù. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let activityIndicator = self.defaultActivityInidicator()
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        self.view .addSubview(activityIndicator)
        
    }

    func defaultActivityInidicator() -> ActivityIndicatorView {
        let activityIndicatorView : ActivityIndicatorView = ActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        activityIndicatorView.setLineWidth(width: 5.0)
        activityIndicatorView.tintColor = UIColor.black
        return activityIndicatorView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

