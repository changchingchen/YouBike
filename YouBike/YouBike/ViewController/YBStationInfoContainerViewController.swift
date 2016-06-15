//
//  YBStationInfoContainerViewController.swift
//  YouBike
//
//  Created by SK on 5/18/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit

enum YBStationInfoViewType: Int {
    case List
    case Grid
}

class YBStationInfoContainerViewController: UIViewController {

    let ybManager = YouBikeManager.sharedManager
    
    private lazy var ybStationInfoTableViewController: YBStationInfoTableViewController = { [unowned self] in
        return YBStationInfoTableViewController.controller()
        }()
    
    private lazy var ybStationInfoCollectionViewController: YBStationInfoCollectionViewController = { [unowned self] in
        return YBStationInfoCollectionViewController.controller()
        }()
    
    private var activeViewController: UIViewController? {
        didSet {
            removeInactiveViewController(oldValue)
            updateActiveViewController()
        }
    }
    
    @IBOutlet weak var ybStationInfoViewTypeSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = UIRectEdge.None
        
        self.activeViewController = self.ybStationInfoTableViewController
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ybStationInfoViewTypeChanged(sender: UISegmentedControl) {
        
        guard let ybStationInfoViewType = YBStationInfoViewType(rawValue: ybStationInfoViewTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        switch ybStationInfoViewType {
        case .List:
            activeViewController = ybStationInfoTableViewController
        case .Grid:
            activeViewController = ybStationInfoCollectionViewController
        }
        
    }
    
    private func removeInactiveViewController(inactiveViewController: UIViewController?) {
        if let inactiveVC = inactiveViewController {
            inactiveVC.willMoveToParentViewController(nil)
            inactiveVC.view.removeFromSuperview()
            inactiveVC.removeFromParentViewController()
        }
    }
    
    private func updateActiveViewController() {
        if let activeVC = activeViewController {
            self.addChildViewController(activeVC)
            activeVC.view.frame = view.bounds
            view.addSubview(activeVC.view)
            activeVC.didMoveToParentViewController(self)
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
