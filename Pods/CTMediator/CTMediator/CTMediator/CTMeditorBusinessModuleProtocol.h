//
//  BusinessObjectProtocol.h
//  VoIP_iPhone
//
//  Created by lvyi on 11-4-19.
//  Copyright 2011年 Cienet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTMediatorBusinessModuleInfo.h"

//业务模块协议接口
@protocol CTMeditorBusinessModuleProtocol

//初始化业务模块
- (int)initBusinessModule:(CTMediatorBusinessModuleInfo*)info;

//调用业务模块功能处理
- (int)callBusinessProcess:(int)capabilityId withInParam:(id)inParam ;
//- (int)callBusinessDataProcess:(int)capabilityId withInParam:(id)inParam  ;

@optional


@end
