//
//  YBInfoTableViewController.swift
//  YouBike
//
//  Created by SK on 4/25/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import UIKit
import UILoadControl


class YBStationInfoTableViewController: UITableViewController {

    let ybManager = YouBikeManager.sharedManager
    

    struct Constant {
        static let identifier = "YBStationInfoTableViewController"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ybkDarkSandColor()

        
        // 3rd Party UILoadControl for scroll to load more
        tableView.loadControl = UILoadControl(target: self, action: #selector(loadMoreData(_:)))
        tableView.loadControl?.heightLimit = 80.0
//        ybManager.getYBDataFromFile()
        
        
        let nib = UINib(nibName: YBStationInfoTableViewCell.Constant.identifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: YBStationInfoTableViewCell.Constant.identifier)

//        ybManager.getYBDataFromHTTPByAlamofireWithJWT {
//            [unowned self] in
//            self.tableView.reloadData()
//        }
        
        
        ybManager.getYBDataFromDataTaipei {
            [unowned self] in
            self.tableView.reloadData()
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ybManager.ybStationInfos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "YBStationInfoTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! YBStationInfoTableViewCell

        let ybStationInfo = ybManager.ybStationInfos[indexPath.row]
        
        cell.stationNameCnLabel.text = ybStationInfo.area + " / " + ybStationInfo.name
        cell.stationAddressCnLabel.text = ybStationInfo.address
        cell.stationAvailableBikeLabel.text = "\(ybStationInfo.availableBike)"
        
        cell.ybStationInfo = ybStationInfo

        cell.delegate = self
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 122.0
    }
 
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ybStationInfoWithMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("YBStationInfoWithMapViewController") as! YBStationInfoWithMapViewController
        
        ybStationInfoWithMapViewController.ybStationInfo = ybManager.ybStationInfos[indexPath.row]
        
        self.navigationController?.pushViewController(ybStationInfoWithMapViewController, animated: true)
//        
//        let ybStationMapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("YBStationMapViewController") as! YBStationMapViewController
//        
//        ybStationMapViewController.ybStationInfo = ybManager.ybStationInfos[indexPath.row]
//        ybStationMapViewController.isSelectedByRow = true
//        
//        self.navigationController!.pushViewController(ybStationMapViewController, animated: true)


    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.navigationController!.navigationBar.topItem!.title = "YouBike"
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tableView.reloadData()
        
    }
    
//    func didFinishFetchingYBData() {
//        self.tableView.reloadData()
//    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollView.loadControl?.update()
    }
    
    
    func loadMoreData(sender: AnyObject?) {
        let loadDelaySeg = 1.0
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(loadDelaySeg * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.ybManager.getYBDataFromHTTPByAlamofireWithJWT() {
                [unowned self] in
                
                self.tableView.loadControl!.endLoading()
                self.tableView.reloadData()
            }
        }

    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMap" {
            print("ShowMap segue is called")
            let mapViewController = segue.destinationViewController as! YBStationMapViewController
            
           print(sender.debugDescription)
            
            if let selectedButton = sender as? UIButton {
                print("It is a button")
            }
     
        }
        
    }
    */
    

}

extension YBStationInfoTableViewController: YBStationInfoTableViewCellDelegate {
    
    func tapViewMap(cell: YBStationInfoTableViewCell, viewMap sender: AnyObject?) {
        
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("YBStationMapViewController") as! YBStationMapViewController
        
        mapViewController.ybStationInfo = cell.ybStationInfo
        
        self.navigationController!.pushViewController(mapViewController, animated: true)
        
    }
}

extension YBStationInfoTableViewController {
    class func controller() -> YBStationInfoTableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(Constant.identifier) as! YBStationInfoTableViewController
    }
}
