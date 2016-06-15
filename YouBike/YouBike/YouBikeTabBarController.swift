//
//  YouBikeTabBarController.swift
//  YouBike
//
//  Created by SK on 5/9/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

class YouBikeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UIApplication.sharedApplication().statusBarHidden = false
        
        self.tabBar.barTintColor = UIColor.ybkCharcoalGreyColor()
        self.tabBar.tintColor = UIColor.ybkPaleGoldColor()
        
        
//        for item in tabBar.items! {
//            let originalImage = UIImage(named: "colorful-image")?.imageWithRenderingMode(.AlwaysOriginal)
//            let templateImage = UIImage(named: "colorful-image")?.imageWithRenderingMode(.AlwaysTemplate)
//            
//            let templateImageView = UIImageView(image: templateImage)
//            templateImageView.tintColor! = .blueColor()
//            
//            item.selectedImage = UIImage(named:)
//            item.image
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
