//
//  sd.h
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

#import <Foundation/Foundation.h>
#import "UrlHistoryItem.h"
#import <WCDB/WCDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface UrlHistoryItem (WCTTableCoding) <WCTTableCoding>
WCDB_PROPERTY(iconUrl)
WCDB_PROPERTY(url)
WCDB_PROPERTY(webTitle)
WCDB_PROPERTY(timeDate)
WCDB_PROPERTY(urlUid)
@end

NS_ASSUME_NONNULL_END
