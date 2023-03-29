//
//  CTMediator.h
//  CTMediator
//
//  Created by casa on 16/3/13.
//  Copyright © 2016年 casa. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "CTMeditorBusinessModuleProtocol.h"
#import "CTMeditorBusinessModuleProtocol.h"
//CTMeditorBusinessModuleProtocol.h
//#define MakeID(x, y) (((x)<<16) + (y))
//#define ModuleID(x) ((x)>>16)
//#define CapabilityID(x) (((x)<<16)>>16)

int MakeID(int moudleID,int capabilityID);

extern NSString * _Nonnull const kCTMediatorParamsKeySwiftTargetModuleName;

@protocol CTMediatorBusinessListenerProtocol <NSObject>
@optional
//- (void)processBusinessNotify:(NSString*_Nullable)moudel capacity:(NSString*_Nullable)capcity withInParam:(nullable id)inParam;
- (void)processBusinessNotify:(int)notifcationId withInParam:(id)inParam;
@end

@interface CTMediator : NSObject

+ (instancetype _Nonnull)sharedInstance;

//注册业务模块
- (void)registerBusinessModule:(id<CTMeditorBusinessModuleProtocol>_Nonnull) businessModule;
//ui层注册
//注册业务事件监听对象
- (void)registerBusinessListener:(nullable id<CTMediatorBusinessListenerProtocol>) businessListener;
//取消某个业务事件监听对象
- (void)unregisterBusinessListener:(nullable id<CTMediatorBusinessListenerProtocol>)businessListener ;
////在所有业务事件监听对象上广播业务通知,通知ui
- (void)broadcastBusinessNotify:(int)notifcationId  withInParam:(nullable id)inParam ;

//调用具体某个业务处理，需要返回输出参数
//- (int)callBusinessProcess:(NSString*_Nullable)moudel withInParam:(id)inParam andOutParam:(id*)outParam;

//调用具体某个业务处理，不需要返回输出参数
- (int)callBusinessProcess:(int)funcId withInParam:(id)inParam   ;

// 远程App调用入口
- (id _Nullable)performActionWithUrl:(NSURL * _Nullable)url completion:(void(^_Nullable)(NSDictionary * _Nullable info))completion;
// 本地组件调用入口
- (id _Nullable )performTarget:(NSString * _Nullable)targetName action:(NSString * _Nullable)actionName params:(NSDictionary * _Nullable)params shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithFullTargetName:(NSString * _Nullable)fullTargetName;

@end
  

// 简化调用单例的函数
CTMediator* _Nonnull CT(void);
