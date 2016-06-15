//
//  LandingPageViewController.swift
//  YouBike
//
//  Created by SK on 5/9/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class LandingPageViewController: UIViewController {

    let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    
    @IBOutlet weak var buttonContainerView: UIView!
    @IBOutlet weak var reflectingLightView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
   
    @IBAction func pressLoginButton(sender: UIButton) {
        let fbLoginManager = FBSDKLoginManager()
        let readPermissions = ["public_profile", "email"]
        fbLoginManager.logInWithReadPermissions(readPermissions, fromViewController: self) {
            (fbLoginResult, err) -> Void in
            if let error = err {
                print(error)
                return
            }
            
            if fbLoginResult.isCancelled {

            } else {
                if fbLoginResult.grantedPermissions.contains("email") && fbLoginResult.grantedPermissions.contains("public_profile") {
                    self.loginFB()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().statusBarHidden = true
        
        initView()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initView() {

        guard let backgroundImage = UIImage(named: "pattern-wood.png") else {
            print("backgroundImage in LandingPageViewController is nil")
            return
        }
        view.backgroundColor = UIColor(patternImage: backgroundImage)
        
        // Set Logo ImageView
        logoImageView.backgroundColor = UIColor(red: 254/255, green: 241/255, blue: 220/255, alpha: 1.0)
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        logoImageView.layer.borderWidth = 1.0
        logoImageView.layer.borderColor = UIColor.ybkCharcoalGreyColor().CGColor
        
        // Set Button Container View
        buttonContainerView.layer.cornerRadius = 10.0
        
        // Set Login Button
        loginButton.layer.cornerRadius = 10.0
        loginButton.setTitle("Log in with Facebook".localized, forState: .Normal)
        
        reflectingLightView.userInteractionEnabled = false
        
    }
    
    
    
    func loginFB() {

        let fbParameters = ["fields": "name, picture.type(large), link, email"]
        FBSDKGraphRequest.init(graphPath: "me", parameters: fbParameters).startWithCompletionHandler {
            (connection, result, err) -> Void in
            
            if let error = err {
                print(error)
                // Error Handling
            }
            
            if let name = result.objectForKey("name") as? String,
                let profilePictureURL = result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String,
                let link = result.objectForKey("link") as? String,
                let email = result.objectForKey("email") as? String
            {
                self.defaults.setObject(name, forKey: "name")
                self.defaults.setURL(NSURL(string: link)!, forKey: "link")
                self.defaults.setObject(email, forKey: "email")
                self.defaults.setURL(NSURL(string: profilePictureURL)!, forKey: "profilePictureURL")

            }
        }
        
        if let ybTabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("YouBikeTabBarController") {
            self.presentViewController(ybTabBarController, animated: true, completion: nil)
        }

    
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
