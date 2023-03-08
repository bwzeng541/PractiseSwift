//
//  UrlHistoryItemFTS.m
//  PractiseSwift
//
//  Created by zengbiwang on 2023/3/2.
//

#import "UrlHistoryItem.h"
#import <WCDB/WCDB.h>

@implementation UrlHistoryItem
WCDB_IMPLEMENTATION(UrlHistoryItem)

WCDB_SYNTHESIZE(UrlHistoryItem, urlUid)
WCDB_SYNTHESIZE(UrlHistoryItem, iconUrl)
WCDB_SYNTHESIZE(UrlHistoryItem, url)
WCDB_SYNTHESIZE(UrlHistoryItem, webTitle)
WCDB_SYNTHESIZE(UrlHistoryItem, timeDate)



WCDB_VIRTUAL_TABLE_MODULE(UrlHistoryItem, WCTModuleNameFTS3)
WCDB_VIRTUAL_TABLE_TOKENIZE(UrlHistoryItem, WCTTokenizerNameWCDB)

WCDB_PRIMARY(UrlHistoryItem, urlUid)

@end
