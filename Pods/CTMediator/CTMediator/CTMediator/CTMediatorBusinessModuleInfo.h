//
//  BusinessObjectInfo.h
//  VoIP_iPhone
//
//  Created by lvyi on 11-4-19.
//  Copyright 2011年 Cienet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CTMediator;

@interface CTMediatorBusinessModuleInfo : NSObject {
    
@private
    
    int businessModuleId_;

    __unsafe_unretained CTMediator* businessFramework_;
}

@property(nonatomic, assign) int businessModuleId;
@property(nonatomic, assign) CTMediator* businessFramework;

- (id)init;


@end
