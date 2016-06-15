//
//  YBStationInfoCollectionViewController.swift
//  YouBike
//
//  Created by SK on 5/17/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import UILoadControl

private let reuseIdentifier = "YBStationInfoCollectionViewCell"

class YBStationInfoCollectionViewController: UICollectionViewController {

    let ybManager = YouBikeManager.sharedManager
    
    struct Constant {
        static let identifier = "YBStationInfoCollectionViewController"
//        static let numberOfColumn = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: YBStationInfoCollectionViewCell.Constant.identifier, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: YBStationInfoCollectionViewCell.Constant.identifier)
        self.collectionView?.backgroundColor = UIColor.ybkDarkSandColor()
        
        
        self.collectionView?.loadControl = UILoadControl(target: self, action: #selector(loadMoreData(_:)))
        self.collectionView?.loadControl?.heightLimit = 50.0 //The default is 80.0
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.registerClass(YBStationInfoCollectionViewController.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
    
    
    func loadMoreData(sender: AnyObject?) {
        let loadDelaySeg = 1.0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(loadDelaySeg * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.ybManager.getYBDataFromHTTPByAlamofireWithJWT() {
                [unowned self] in
                self.collectionView?.loadControl!.endLoading()
                self.collectionView?.reloadData()
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(ybManager.ybStationInfos.count)
        
        return ybManager.ybStationInfos.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! YBStationInfoCollectionViewCell
    
        let ybStationInfo = ybManager.ybStationInfos[indexPath.row]
        
        cell.stationNameLabel.text = ybStationInfo.area + " / " + ybStationInfo.name
        cell.stationAvailableBikeLabel.text = "\(ybStationInfo.availableBike)"

        cell.ybStationInfo = ybStationInfo
    
        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let ybStationInfoWithMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("YBStationInfoWithMapViewController") as! YBStationInfoWithMapViewController
        
        ybStationInfoWithMapViewController.ybStationInfo = ybManager.ybStationInfos[indexPath.row]
        
        self.navigationController?.pushViewController(ybStationInfoWithMapViewController, animated: true)
        
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 166, height: 166)
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}

extension YBStationInfoCollectionViewController {
    class func controller() -> YBStationInfoCollectionViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.identifier) as! YBStationInfoCollectionViewController
    }
}
