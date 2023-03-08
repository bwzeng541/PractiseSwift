//
//  UrlHistoryItemFTS.h
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UrlHistoryItem : NSObject

@property(strong)NSString *urlUid;
@property(strong)NSString *iconUrl;
@property(strong)NSString *url;
@property(strong)NSString *webTitle;
@property(strong)NSString *timeDate;

@end

NS_ASSUME_NONNULL_END
