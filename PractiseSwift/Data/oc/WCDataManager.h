//
//  WCDataManager.h
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

#import <Foundation/Foundation.h>
//#import <WCDB/WCDB.h>
#import "UrlHistoryItem.h"
extern NSString * _Nullable urlHistoryTable ;
extern NSString * _Nullable searchHotsTable ;
NS_ASSUME_NONNULL_BEGIN
@interface WCDataManager : NSObject
+(WCDataManager*)shared;
-(void)createTable:(NSString*)tableName clas:(Class)clas;
-(void)insertOrReplace:(id)item tableName:(NSString*)tableName;
-(NSArray<UrlHistoryItem *>*)getObject:(Class)clas tableName:(NSString*)tableName word:(NSString*)word;
@end

NS_ASSUME_NONNULL_END
