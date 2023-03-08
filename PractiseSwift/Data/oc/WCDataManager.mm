//
//  WCDataManager.m
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

#import "WCDataManager.h"
#import <WCDB/WCDB.h>
#import "UrlHistoryItem+Fts.h"
NSString *urlHistoryTable = @"urlHistoryTable";
NSString *searchHotsTable = @"searchHotsTable";
@interface WCDataManager()
{
    WCTDatabase * databaseFTS;
}

@end
@implementation WCDataManager
+(WCDataManager*)shared{
    static WCDataManager *wcdData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wcdData = [[WCDataManager alloc] init];
    });
    return wcdData;
}

-(id)init{
    self = [super init];
    NSString *pathFTS = [NSString stringWithFormat:@"%@%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0],@"/WCDB/FYIM.db"];
   databaseFTS = [[WCTDatabase alloc] initWithPath:pathFTS];
   [databaseFTS setTokenizer:WCTTokenizerNameWCDB];
    return self;
}

//e81c1f5749545c5f7d247b3a100ffe62
-(void)insertOrReplace:(id)item tableName:(NSString*)tableName{
    UrlHistoryItem *ret = (UrlHistoryItem*)item;
    NSArray<UrlHistoryItem *> *ftsDatas = [databaseFTS getObjectsOfClass:[ret class]
                                                    fromTable:tableName
                                                      where:UrlHistoryItem.urlUid == ret.urlUid];
    if (ftsDatas.count>0) {
        BOOL result = [databaseFTS updateRowsInTable:tableName
                                          onProperties:UrlHistoryItem.AllProperties
                                            withObject:item
                                                 where:UrlHistoryItem.urlUid == ret.urlUid];
            }
    else{
    [databaseFTS insertOrReplaceObject:item   into:tableName];
    }
}

-(void)createTable:(NSString*)tableName clas:(Class)clas{
    [databaseFTS createVirtualTableOfName:tableName withClass:clas];
    //[databaseFTS createTableAndIndexesOfName:tableName withClass:clas];

}

-(NSArray<UrlHistoryItem*>*)getObject:(Class)clas tableName:(NSString*)tableName word:(NSString*)word{
    if([word length]<1){
        return   [databaseFTS getObjectsOfClass:clas fromTable:tableName orderBy:UrlHistoryItem.timeDate.order(WCTOrderedDescending)];
    }
    NSString *nword = [NSString stringWithFormat:@"*%@*",word];
    NSArray<UrlHistoryItem *> *ftsDatas = [databaseFTS getObjectsOfClass:clas fromTable:tableName where:UrlHistoryItem.PropertyNamed(tableName).match(nword) orderBy:UrlHistoryItem.timeDate.order(WCTOrderedDescending)];

    return ftsDatas;
}
@end
