//
//  TDUser.swift
//  Todo
//
//  Created by Donovan on 11/20/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

let TDUserCodingUserIDKey       = "userId";
let TDUserCodingFirstNameKey    = "firstName";
let TDUserCodingLastNameKey     = "lastName";
let TDUserCodingEmailKey        = "email";
let TDUserCodingTokenKey        = "token";

class TDUser: NSObject, NSCoding
{
    var userId:     String?;
    var firstName:  String?;
    var lastName:   String?;
    var email:      String?;
    var token:      String?;
    
    override init() {}
    
    // MARK: - NSCoding Functions
    
    required init(coder aDecoder: NSCoder)
    {
        self.userId     = aDecoder.decodeObjectForKey(TDUserCodingUserIDKey)    as? String;
        self.firstName  = aDecoder.decodeObjectForKey(TDUserCodingFirstNameKey) as? String;
        self.lastName   = aDecoder.decodeObjectForKey(TDUserCodingLastNameKey)  as? String;
        self.email      = aDecoder.decodeObjectForKey(TDUserCodingEmailKey)     as? String;
        self.token      = aDecoder.decodeObjectForKey(TDUserCodingTokenKey)     as? String;
    }
    
    func encodeWithCoder(aCoder: NSCoder)
    {
        if let userid = self.userId
        {
            aCoder.encodeObject(userid, forKey:TDUserCodingUserIDKey)
        }
        if let firstname = self.firstName
        {
            aCoder.encodeObject(firstname, forKey:TDUserCodingFirstNameKey)
        }
        if let lastname = self.lastName
        {
            aCoder.encodeObject(lastname, forKey:TDUserCodingLastNameKey)
        }
        if let email2 = self.email
        {
            aCoder.encodeObject(email2, forKey:TDUserCodingEmailKey)
            
        }
        if let token2 = self.token
        {
            aCoder.encodeObject(token2, forKey:TDUserCodingTokenKey)
        }
    }
    
    // MARK: - NSUserDefaults Functions
    func storeToUserDefaults()
    {
        let data = NSKeyedArchiver.archivedDataWithRootObject(self);
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: kNSUserDefaultsCurrentUserKey)
    }
    
    func clearFromUserDefaults()
    {
        NSUserDefaults.standardUserDefaults().removeObjectForKey(kNSUserDefaultsCurrentUserKey);
    }
    
    class func currentUser() -> TDUser?
    {
        if let data: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey(kNSUserDefaultsCurrentUserKey)
        {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data as NSData) as? TDUser
        }
        return nil;
    }
    
    // MARK: - Utility Functions
    
    func fullName() -> String
    {
        return "\(firstName!) \(lastName!)"
    }
}
