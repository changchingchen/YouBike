//
//  UserInfoViewController.swift
//  YouBike
//
//  Created by SK on 5/9/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SafariServices

class UserInfoViewController: UIViewController {

    
    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var logOutBarButton: UIBarButtonItem!
    @IBOutlet weak var profilePictureBorderView: UIView!
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var cardView: UIView!
    
    
    // FB Link Button
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var fbLinkButton: UIButton!
    @IBOutlet weak var reflectingLightView: UIView!
    
    
    
    @IBAction func pressLogOutButton(sender: UIBarButtonItem) {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logOut()
        
        defaults.removeObjectForKey("name")
        defaults.removeObjectForKey("link")
        defaults.removeObjectForKey("email")
        defaults.removeObjectForKey("profilePictureURL")
        
        let landingPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LandingPageViewController") as! LandingPageViewController
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.window?.rootViewController = landingPageViewController
//        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func pressFBLinkButton(sender: UIButton) {
       
        guard let fbLinkURL = defaults.URLForKey("link") else { return }
        
        let systemVersionComparison = UIDevice.currentDevice().systemVersion.compare("9.0.0", options: NSStringCompareOptions.NumericSearch)
        
        switch systemVersionComparison {
        case .OrderedSame, .OrderedDescending:
            let fbViewController = SFSafariViewController(URL: fbLinkURL, entersReaderIfAvailable: true)
            self.presentViewController(fbViewController, animated: true, completion: nil)
        case .OrderedAscending:
            UIApplication.sharedApplication().openURL(fbLinkURL)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImage(named: "pattern-wood.png")!
        view.backgroundColor = UIColor(patternImage: backgroundImage)
        
        if let logOutBarButtonFont = UIFont(name: "PingFang-TC", size: 17) {
            self.logOutBarButton.setTitleTextAttributes([NSFontAttributeName: logOutBarButtonFont], forState: UIControlState.Normal)
        }

        initView()

    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func initView() {
        
        // Init Profile Picture
        profilePictureBorderView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3)
        profilePictureBorderView.layer.cornerRadius = profilePictureBorderView.frame.width / 2
        guard let profilePictureURL = defaults.URLForKey("profilePictureURL") else { return }
        
        if let profilePictureNSData = NSData(contentsOfURL: profilePictureURL) {
            let profilePicture = UIImage(data: profilePictureNSData)
            profilePictureImageView.image = profilePicture
        }
        profilePictureImageView.layer.cornerRadius = profilePictureImageView.frame.width / 2
        profilePictureImageView.clipsToBounds = true
        
        // Init Label
        if let name = defaults.objectForKey("name") as? String {
            userNameLabel.text = name
            userNameLabel.font = UIFont.ybkTextStyleHelvetica(50.0)
            userNameLabel.textColor = UIColor.ybkCharcoalGreyColor()
        }
        
        // Init Shadow of Card View
        cardView.layer.cornerRadius = 20.0
        cardView.layer.shadowColor = UIColor.blackColor().CGColor
        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        cardView.layer.shadowOpacity = 0.25
        cardView.layer.shadowRadius = 4.0
        
        // Init Button Container View and its subviews or buttons
        buttonContainerView.layer.cornerRadius = 10.0
        fbLinkButton.layer.cornerRadius = 10.0
        fbLinkButton.setTitle("Facebook Page".localized, forState: .Normal)
        reflectingLightView.userInteractionEnabled = false
        
        // Init Log Out Bar Button
        logOutBarButton.title = "Log Out".localized
    
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
