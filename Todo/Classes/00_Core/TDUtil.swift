//
//  TDUtil.swift
//  Todo
//
//  Created by Donovan on 11/19/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import Foundation

class TDUtil
{
    // MARK: - App Framework Functions
    class func appDelegate() -> AppDelegate
    {
        return UIApplication.sharedApplication().delegate as AppDelegate;
    }
    
    class func messageFromError(error: NSError) -> String
    {
        let text = error.localizedRecoverySuggestion
        
        let jsonDict = dictFromJSONString(text!)
        
        return jsonDict["message"]!
    }
    
    class func messageFromResponseObject(object: AnyObject) -> String
    {
        let jsonDict = dictFromJSONData(object as NSData)
        
        return jsonDict["message"]!
    }
    
    // MARK: - Storyboard Functions
    class func mainStoryboard() -> UIStoryboard
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil);
        return storyboard;
    }
    
    class func instantiateViewControllerWithIdentifier(storyBoardID: String) -> AnyObject
    {
        return self.mainStoryboard().instantiateViewControllerWithIdentifier(storyBoardID);
    }
    
    class func vcFromSegue(segue: UIStoryboardSegue) -> UIViewController
    {
        if segue.destinationViewController is UINavigationController
        {
            let nc = segue.destinationViewController as UINavigationController
            return nc.viewControllers[0] as UIViewController
        }
        return segue.destinationViewController as UIViewController
    }

    // MARK: - AlertController Functions
    class func defaultAlert(title: String, message: String) -> UIAlertController
    {
        var alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert);
        alertController.addAction(alertDefaultAction);
        
        return alertController;
    }
    
    // MARK: - Validation Functions
    class func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        var predicate: NSPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)!;
        return predicate.evaluateWithObject(testStr);
    }
    
    // MARK: - JSON Serialization Functions
    
    class func dictFromJSONString(text: String) -> Dictionary<String, String>
    {
        var error2: NSError?
        let jsonData: NSData = text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error2) as Dictionary<String, String>
        
        return jsonDict
    }
    
    class func dictFromJSONData(data: NSData) -> Dictionary<String, String>
    {
        var error: NSError?
        let jsonData = data
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as Dictionary<String, String>
        
        return jsonDict
    }
    
    // MARK: - MBProgressHUD Functions
    class func hudWithCheckMark(hud: MBProgressHUD, text: String) -> MBProgressHUD
    {
        let image       = UIImage(named: COMMON_IMAGE_HUD_CHECKMARK)
        let imageView   = UIImageView(image: image)
        
        hud.customView  = imageView
        hud.mode        = MBProgressHUDModeCustomView
        hud.labelText   = text
        
        return hud
    }
}