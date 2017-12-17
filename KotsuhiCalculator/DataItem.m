//
//  DataItem.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/12/05.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import "DataItem.h"
#import "Utility.h"

@implementation DataItem

+ (NSArray*)getInitDataItemList {
    NSMutableArray* retArray = [NSMutableArray array];
    
    NSArray* nameArray = [NSArray arrayWithObjects:@"年",@"月",@"日",@"年月日",@"訪問先",
                          @"出発地",@"到着地",@"交通手段",@"金額(片道)",@"金額",@"往復",
                          @"目的補足",@"経路",@"処理済み",nil];
    
    int count = 1;
    for(NSString* nameStr in nameArray){
        DataItem* dataItem = [[DataItem alloc] init];
        dataItem.itemId = count;
        dataItem.name = nameStr;
        dataItem.order = count;
        dataItem.usecsv = YES;
        // dataItem.usecsv = count == 4 ? NO : YES;
        [retArray addObject:dataItem];
        count++;
    }
    
    return retArray;
}

+ (NSData*)getDataItemArrayData:(NSArray*)dataItemArray {
    NSMutableString* dataItemArrayString = [NSMutableString string];
    for(DataItem* dataItem in dataItemArray){
        NSString* dataItemString = [dataItem getDataItemString];
        [dataItemArrayString appendString:dataItemString];
        [dataItemArrayString appendString:@"\n"];
    }
    
    NSData* data = [dataItemArrayString dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

- (NSString*)getDataItemString {
    // TODO nameのエスケープ
    NSString* escapedName = [Utility replaceComma:_name];
    
    NSString* dataItemString = [NSString stringWithFormat:@"%d,%@,%d,%d", _itemId, escapedName, _order, _usecsv];
    
    return dataItemString;
}

+ (NSArray*)makeDataItemArray:(NSData*)data {
    NSMutableArray* retArray = [NSMutableArray array];
    
    NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray* dataItemStringArray = [dataString componentsSeparatedByString:@"\n"];
    
    // NSLog(@"readdata : ");
    // NSLog(@"%@", dataString);
    
    for(NSString* dataItemString in dataItemStringArray){
        DataItem* dataItem = [self makeDataItem:dataItemString];
        if(dataItem != nil){
            [retArray addObject:dataItem];
        }
    }
    
    return retArray;
}

+ (DataItem*)makeDataItem:(NSString*)dataItemString {
    DataItem* dataItem = [[DataItem alloc] init];
    
    // NSLog(@"dataItemString : [%@]", dataItemString);
    
    // データはItemId, Name, Order, UseCsv
    NSArray* dataStringArray = [dataItemString componentsSeparatedByString:@","];
    if(dataStringArray.count <= 3){
        return nil;
    }
    dataItem.itemId = [[dataStringArray objectAtIndex:0] intValue];
    dataItem.name = [dataStringArray objectAtIndex:1];
    dataItem.order = [[dataStringArray objectAtIndex:2] intValue];
    dataItem.usecsv = [[dataStringArray objectAtIndex:3] boolValue];
    
    return dataItem;
}

- (NSComparisonResult)compareOrder:(DataItem*)data {
    if (self.order < data.order) {
        return NSOrderedAscending;
    } else {
        return NSOrderedDescending;
    }
}

@end
