//
//  YBStationInfoHandler.swift
//  YouBike
//
//  Created by SK on 5/2/16.
//  Copyright © 2016 AppWorks School Snakeking. All rights reserved.
//

import Foundation
import Alamofire
import JWT
import CoreData

struct YBStationInfo {

    var number = 0 //sno
    var nameCn = "" //sna
    //    let stationTotalParkingSpaceAmount: Int = 0 //tot
    var availableBike = 0 //sbi
    var areaCn = "" //sarea
    //    let stationInfoUpdateTime: String = "" //mday
    var latitude = 0.0 //lat
    var longitude = 0.0 //lng
    var addressCn = "" //ar
    var areaEn = "" //sareaen
    var nameEn = "" //snaen
    var addressEn = "" //aren
    //    var stat ionEmptyParkingSpaceAmount: Int = 0 //bemp
    //    var stationActivationStatus: Int = 0 //act
}

extension YBStationInfo {
    var name: String {
        let currentLanguage = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) ?? "en"
        return (currentLanguage as? String == "zh") ? nameCn : nameEn
    }

    var address: String {
        let currentLanguage = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) ?? "en"
        return (currentLanguage as? String == "zh") ? addressCn : addressEn
    }
    
    var area: String {
        let currentLanguage = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) ?? "en"
        return (currentLanguage as? String == "zh") ? areaCn : areaEn
    }
}


extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
//class YBStationInfo {
//    
//    let number: Int //sno
//    let nameCn: String //sna
//    //    let totalParkingSpaceAmount: Int = 0 //tot
//    let availableBike: Int //sbi
//    //    let areaCn: String = "" //sarea
//    //    let stationInfoUpdateTime: String = "" //mday
//    let latitude: Double //lat
//    let longitude: Double //lng
//    let addressCn: String //ar
//    //    let areaEn: String = "" //sareaen
//    //    let nameEn: String = "" //snaen
//    //    let addressEn: String = "" //aren
//    //    let emptyParkingSpaceAmount: Int = 0 //bemp
//    //    let activationStatus: Int = 0 //act
//    
//    init (number: Int, nameCn: String, availableBike: Int, latitude: Double, longitude: Double, addressCn: String) {
//        self.number = number
//        self.nameCn = nameCn
//        self.availableBike = availableBike
//        self.latitude = latitude
//        self.longitude = longitude
//        self.addressCn = addressCn
//    }
//    
//}


class YouBikeManager {

    
    static let sharedManager = YouBikeManager()
//    let id: String
    private init() {
//        self.id = NSUUID().UUIDString
    }
    
    var ybStationInfos = [YBStationInfo]()

    
    var dataSourceURLBaseString = "http://139.162.32.152:3000/stations?paging="
    var dataSourceURLNextPageString: String? = "febe5ekd32dkl923jkdlde"
    var dataSourceURLPreviousPageString: String?
    
    
    
    let dataSourceURL: NSURL = NSURL(string: "http://139.162.32.152:3000/stations?paging=febe5ekd32dkl923jkdlde")!
    let dataDestinationURL: NSURL = NSURL(string: "http://139.162.32.152:3000/check_in")!
    
    let ybStationMOC = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    // Load youbike station info from local JSON file
    func getYBDataFromFile() {
        
        let url = NSBundle.mainBundle().URLForResource("youbike", withExtension: "json")!
        let data = NSData(contentsOfURL: url)!
        
        do {
            let ybJsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
            parseYBJSONObject(ybJsonObject)

        } catch {
            print(error)
        }
        
    }
    
//    func parseYBJSONObjectOlderVersion(ybJsonObject: AnyObject) {
//        
//        if let ybJsonObjectResults = ybJsonObject["result"] as? [String:AnyObject] {
//            
//            guard let results = ybJsonObjectResults["results"] as? [[String:AnyObject]]
//                else {
//                    return
//            }
//            
//            for result in results {
//                if let stationNumber = result["sno"] as? String,
//                    let stationNameCn = result["sna"] as? String,
//                    let stationAvailableBike = result["sbi"] as? String,
//                    let stationAddressCn = result["ar"] as? String,
//                    let stationLatitude = result["lat"] as? String,
//                    let stationLongitude = result["lng"] as? String,
//                    let stationNameEn = result["snaen"] as? String,
//                    let stationAddressEn = result["aren"] as? String {
//                    
//                    let ybStationInfo = YBStationInfo(
//                        number: Int(stationNumber)!,
//                        nameCn: stationNameCn,
//                        availableBike: Int(stationAvailableBike)!,
//                        latitude: Double(stationLatitude)!,
//                        longitude: Double(stationLongitude)!,
//                        addressCn: stationAddressCn,
//                        nameEn: stationNameEn,
//                        addressEn: stationAddressEn
//                    )
//                    self.ybStationInfos.append(ybStationInfo)
//                }
//            }
//        }
//    }
    
    func parseYBJSONObject(ybJsonObject: AnyObject) {
        
        guard let ybJsonObjectResults = ybJsonObject["data"] as? [[String:AnyObject]]
            else {
                print("Data type casting failed!!")
                return
        }
        
        for result in ybJsonObjectResults {
            if let stationNumber = result["sno"] as? String,
                let stationNameCn = result["sna"] as? String,
                let stationAvailableBike = result["sbi"] as? String,
                let stationAreaCn = result["sarea"] as? String,
                let stationAddressCn = result["ar"] as? String,
                let stationLatitude = result["lat"] as? String,
                let stationLongitude = result["lng"] as? String,
                let stationAreaEn = result["sareaen"] as? String,
                let stationNameEn = result["snaen"] as? String,
                let stationAddressEn = result["aren"] as? String {
                
                let ybStationInfo = YBStationInfo(
                    number: Int(stationNumber)!,
                    nameCn: stationNameCn,
                    availableBike: Int(stationAvailableBike)!,
                    areaCn:  stationAreaCn,
                    latitude: Double(stationLatitude)!,
                    longitude: Double(stationLongitude)!,
                    addressCn: stationAddressCn,
                    areaEn: stationAreaEn,
                    nameEn: stationNameEn,
                    addressEn: stationAddressEn
                )
                self.ybStationInfos.append(ybStationInfo)
                
                createYBData(ybStationInfo)
                
            }
        }
        
    }
    
    // Use closure for passing data to table view controller
    func getYBDataFromHTTP(completion: () -> Void) {
        
        dispatch_async(GlobalPriorityDefaultQueue) {
            
            let urlRequest = NSMutableURLRequest(URL: self.dataSourceURL)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(urlRequest) {
                (dat, resp, err) in
                
                if let error = err {
                    print("Error in :\(error)")
                    return
                }
                
                guard let data = dat, let response = resp as? NSHTTPURLResponse
                    else {
                        return
                }
                
                if response.statusCode == 200 {
                    
                    do {

                        let ybJsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                        self.parseYBJSONObject(ybJsonObject)
                        
                    
                    } catch {
                        print(error)
                    }
                    
                    dispatch_async(GlobalMainQueue) {
                        completion()
                    }
                }
                
            }
            
            task.resume()
        }

    }
    
    func postYBDataToHTTP() {
        
        dispatch_async(GlobalPriorityDefaultQueue) {
            let jsonData = [
                "latitude": 123.0,
                "longitude": 567.0
            ]
            
            let urlRequest = NSMutableURLRequest(URL: self.dataDestinationURL)
            urlRequest.HTTPMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = NSURLSession.sharedSession()
            do {
                urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(jsonData, options: NSJSONWritingOptions.PrettyPrinted)
                let task = session.dataTaskWithRequest(urlRequest) {
                    dat, resp, err in
                    
                    if let error = err {
                        print(error)
                        return
                    }
                    
                    guard let _ = dat, let response = resp as? NSHTTPURLResponse else {
                        print("data or response is nil in httpPostJSON")
                        return
                    }
                    
                    
                    if response.statusCode == 200 {
                        print("Finish post JSON")
                    } else {
                        print("\(response.statusCode)")
                    }
                }
                
                task.resume()
                
            } catch {
                print("Something Wrong with data to JSON")
            }
        }
        
    }
    
    func getYBDataFromHTTPByAlamofire(completion: ()-> Void) {
       
        dispatch_async(GlobalPriorityDefaultQueue) {
            Alamofire.request(.GET, String(self.dataSourceURL)).validate().responseJSON {
                response -> Void in
                guard response.result.isSuccess else {
                    return
                }
                
                guard let ybJSONObject = response.result.value as? [String:AnyObject] else {
                    return
                }
                
                self.parseYBJSONObject(ybJSONObject)
                
                dispatch_async(GlobalMainQueue) {
                    completion()
                }
            }
        }
        
        
    }
    
    func postYBDataToHTTPByAlamofire() {

        dispatch_async(GlobalPriorityDefaultQueue) {
            let jsonData = [
                "latitude": 123.0,
                "longitude": 567.0
            ]
            
            Alamofire.request(.POST, String(self.dataDestinationURL), parameters: jsonData, encoding: .JSON).validate().response {
                req, resp, dat, err in
                if let error = err {
                    print(error)
                    return
                }
                
                guard let response = resp else {
                    return
                }
                
                if response.statusCode == 200 {
                    print("Success!!")
                }
                
//                print(req)
//                print(resp)
                
            }
        }
        
        
        
    }
    
    
    func generateJSONWebToken() -> String? {
        let secret = "appworks"
        let expTime = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])?.timeIntervalSince1970
        
        guard let expiryTime = expTime else {
            return nil
        }
        
        let claim: [String:AnyObject] = [
            "exp": expiryTime,
            "name": "Snakeking",
            ]
        
        let jsonWebToken = JWT.encode(claim, algorithm: .HS256(secret))
        
// Another way to generate JWT
//        let jsonWebToken2 = JWT.encode(.HS256(secret)) {
//            builder in
//            builder.issuer = "Snakeking"
//            builder.expiration = NSCalendar.currentCalendar().dateByAddingUnit(.Minute, value: 5, toDate: NSDate(), options: [])
//        }
        
        return jsonWebToken
    }

    func getYBDataFromHTTPByAlamofireWithJWT(completion: (()-> Void)?) {
        
        if let nextPageString = dataSourceURLNextPageString {
        
            dispatch_async(GlobalPriorityDefaultQueue) {

                guard let jsonWebToken = self.generateJSONWebToken() else {
                    print("JSON Web Token Generation Fail")
                    return
                }
                
//                print(jsonWebToken)
                
                let headers = [ "Authorization": "Bearer " + jsonWebToken ]
                let urlString = self.dataSourceURLBaseString + nextPageString
                
                Alamofire.request(.GET, urlString, parameters: nil, encoding: .URL, headers: headers).validate().responseJSON {
                    response -> Void in
    //                guard response.result.isSuccess else {
    //                    return
    //                }
                    
                    if let ybJSONObject = response.result.value as? [String:AnyObject] {

                        self.dataSourceURLPreviousPageString = ybJSONObject["paging"]?["previous"] as? String
                        self.dataSourceURLNextPageString = ybJSONObject["paging"]?["next"] as? String
                        
                        if self.dataSourceURLPreviousPageString == nil {
                            self.cleanUpYBData()
                        }

                        self.parseYBJSONObject(ybJSONObject)
                        
                        print(self.dataSourceURLPreviousPageString)
                        print(self.dataSourceURLNextPageString)
                        
                    }
                    
                    if let ybStationInfosFromCoreData = self.readYBData() {
                        self.ybStationInfos = ybStationInfosFromCoreData
                    }                        
                
                    dispatch_async(GlobalMainQueue) {
                        completion?()
                    }
                }
                
            }
        } else {
            completion?()
        }
        
    }
    
    
    // CRUD of CoreData
    func createYBData(ybStation: YBStationInfo) {
        guard let newStation = NSEntityDescription.insertNewObjectForEntityForName("YBStation", inManagedObjectContext: self.ybStationMOC) as? YBStation
            else {
                print("createData Failed")
                return
        }
        
        newStation.setValue(ybStation.number, forKey: "number")
        newStation.setValue(ybStation.nameCn, forKey: "nameCn")
        newStation.setValue(ybStation.availableBike, forKey: "availableBike")
        newStation.setValue(ybStation.areaCn, forKey: "areaCn")
        newStation.setValue(ybStation.latitude, forKey: "latitude")
        newStation.setValue(ybStation.longitude, forKey: "longitude")
        newStation.setValue(ybStation.addressCn, forKey: "addressCn")
        newStation.setValue(ybStation.areaEn, forKey: "areaEn")
        newStation.setValue(ybStation.nameEn, forKey: "nameEn")
        newStation.setValue(ybStation.addressEn, forKey: "addressEn")
        
        do {
            try self.ybStationMOC.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
    }
    
    func readYBData() -> [YBStationInfo]? {
        
        var ybStationInfos = [YBStationInfo]()
        
        let request = NSFetchRequest(entityName: "YBStation")
        
        do {
            guard let results = try ybStationMOC.executeFetchRequest(request) as? [YBStation]
                else {
                return nil
            }
            
            for result in results {
                if let stationNumber = result.valueForKey("number") as? Int,
                    let stationNameCn = result.valueForKey("nameCn") as? String,
                    let stationAvailableBike = result.valueForKey("availableBike") as? Int,
                    let stationAreaCn = result.valueForKey("areaCn") as? String,
                    let stationAddressCn = result.valueForKey("addressCn") as? String,
                    let stationLatitude = result.valueForKey("latitude") as? Double,
                    let stationLongitude = result.valueForKey("longitude") as? Double,
                    let stationAreaEn = result.valueForKey("areaEn") as? String,
                    let stationNameEn = result.valueForKey("nameEn") as? String,
                    let stationAddressEn = result.valueForKey("areaEn") as? String {
                    
                    let ybStationInfo = YBStationInfo(
                        number: stationNumber,
                        nameCn: stationNameCn,
                        availableBike: stationAvailableBike,
                        areaCn:  stationAreaCn,
                        latitude: stationLatitude,
                        longitude: stationLongitude,
                        addressCn: stationAddressCn,
                        areaEn: stationAreaEn,
                        nameEn: stationNameEn,
                        addressEn: stationAddressEn
                    )
                    ybStationInfos.append(ybStationInfo)
                    
                }
            }
            
            return ybStationInfos
            
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
    }
    
    func updateYBData(ybStationInfo: YBStationInfo) {
        let request = NSFetchRequest(entityName: "YBStation")
        
        request.predicate = NSPredicate(format: "number == %@", ybStationInfo.number)
        
        do {
            guard let results = try ybStationMOC.executeFetchRequest(request) as? [YBStation]
                else {
                    print("Fail to type cast in updateYBData")
                    return
            }
            
            if !results.isEmpty {
                let ybStation = results[0]
                ybStation.setValue(ybStationInfo.nameCn, forKey: "nameCn")
                ybStation.setValue(ybStationInfo.availableBike, forKey: "availableBike")
                ybStation.setValue(ybStationInfo.areaCn, forKey: "areaCn")
                ybStation.setValue(ybStationInfo.latitude, forKey: "latitude")
                ybStation.setValue(ybStationInfo.longitude, forKey: "longitude")
                ybStation.setValue(ybStationInfo.addressCn, forKey: "addressCn")
                ybStation.setValue(ybStationInfo.areaEn, forKey: "areaEn")
                ybStation.setValue(ybStationInfo.nameEn, forKey: "nameEn")
                ybStation.setValue(ybStationInfo.addressEn, forKey: "addressEn")

                try self.ybStationMOC.save()
            }
        } catch {
            fatalError("Failed to update data: \(error)")
        }
        
    }
    
    func cleanUpYBData() {
        let request = NSFetchRequest(entityName: "YBStation")
        
        do {
            guard let results = try ybStationMOC.executeFetchRequest(request) as? [YBStation]
                else {
                print("Fail to type cast in cleanUpYBData")
                return
            }
            
            for result in results {
                ybStationMOC.deleteObject(result)
            }
            
            do {
                try ybStationMOC.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        } catch {
            fatalError("Failed to fetch data: \(error)")
        }
        
    }
    
}



