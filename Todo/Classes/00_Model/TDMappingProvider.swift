//
//  TDMappingProvider.swift
//  Todo
//
//  Created by Donovan on 11/20/14.
//  Copyright (c) 2014 Donovan. All rights reserved.
//

import UIKit

class TDMappingProvider: NSObject
{
    class func userMapping() -> RKObjectMapping
    {
        var mapping: RKObjectMapping = RKObjectMapping(forClass: TDUser.self);
        
        var mappingDic: [String: String] = [ "id":         "userId",
                                             "first_name": "firstName",
                                             "last_name":  "lastName",
                                             "email":      "email",
                                             "token":      "token"
                                            ];
        
        mapping.addAttributeMappingsFromDictionary(mappingDic);
        
        return mapping;
    }
    
    class func taskMapping() -> RKObjectMapping
    {
        var mapping: RKObjectMapping = RKObjectMapping(forClass: TDTask.self);
        
        var mappingDic: [String: String] = [ "id":          "taskId",
                                             "title":       "title",
                                             "completed":   "completed",
                                             "user_id":     "userId"
                                            ];
        
        mapping.addAttributeMappingsFromDictionary(mappingDic);
        
        return mapping;
    }
}
