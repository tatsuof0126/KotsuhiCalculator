//
//  DataItem.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/12/05.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ITEMID_YEAR      1
#define ITEMID_MONTH     2
#define ITEMID_DAY       3
#define ITEMID_YYYYMMDD  4
#define ITEMID_VISIT     5
#define ITEMID_DEPARTURE 6
#define ITEMID_ARRIVAL   7
#define ITEMID_TRANSPORTATION 8
#define ITEMID_AMOUNT_ONEWAY 9
#define ITEMID_AMOUNT    10
#define ITEMID_ROUNDTRIP 11
#define ITEMID_PURPOSE   12
#define ITEMID_ROUTE     13
#define ITEMID_TREATED   14

@interface DataItem : NSObject

@property int itemId;
@property (strong, nonatomic, readwrite) NSString *name;
@property int order;
@property BOOL usecsv;

+ (NSArray*)getInitDataItemList;

+ (NSData*)getDataItemArrayData:(NSArray*)dataItemArray;

+ (NSArray*)makeDataItemArray:(NSData*)data;

+ (DataItem*)makeDataItem:(NSString*)dataItemString;

- (NSComparisonResult)compareOrder:(DataItem*)data;

@end
