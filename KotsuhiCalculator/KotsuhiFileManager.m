//
//  KotsuhiFileManager.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/08.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "KotsuhiFileManager.h"

@implementation KotsuhiFileManager

+ (Kotsuhi*)loadKotsuhi:(int)kotsuhiid {
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"kotsuhi"];
    NSString* filename = [NSString stringWithFormat:@"kotsuhi%d.dat",kotsuhiid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
    
//    NSLog(@"load by filename : %@",filename);
    
    NSData* readdata = [NSData dataWithContentsOfFile:filepath];
    
    Kotsuhi* kotsuhi = [Kotsuhi makeKotsuhi:readdata];
    
    // nilが返ってきたらとりあえずresultidだけセットした空オブジェクトを返す
    if(kotsuhi == nil){
        kotsuhi = [[Kotsuhi alloc] init];
        kotsuhi.kotsuhiid = kotsuhiid;
    }
    
    return kotsuhi;
}

+ (void)saveKotsuhi:(Kotsuhi*)kotsuhi {
    if(kotsuhi.kotsuhiid == 0){
        kotsuhi.kotsuhiid = [self getNewKotsuhiId];
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"kotsuhi"];
    
    if([fileManager fileExistsAtPath:dirpath] == NO){
        // kotsuhiディレクトリが未作成の場合はディレクトリを作る
        [fileManager createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString* filename = [NSString stringWithFormat:@"kotsuhi%d.dat",kotsuhi.kotsuhiid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];

//    NSLog(@"save filepath : %@",filepath);
    
    NSData* data = [kotsuhi getKotsuhiNSData];
    
    [data writeToFile:filepath atomically:YES];
}

+ (void)removeKotsuhi:(int)kotsuhiid {
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"kotsuhi"];
    NSString* filename = [NSString stringWithFormat:@"kotsuhi%d.dat",kotsuhiid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

+ (NSArray*)loadKotsuhiList {
    NSMutableArray* kotsuhiList = [NSMutableArray array];
    
    NSArray* filePathArray = [self getKotsuhiFilePathList];
    
    for(NSString* filepath in filePathArray){
        NSData* readdata = [NSData dataWithContentsOfFile:filepath];
        
        Kotsuhi* kotsuhi = [Kotsuhi makeKotsuhi:readdata];
        
        // nilが返ってきたらリストに追加しない
        if(kotsuhi != nil){
            [kotsuhiList addObject:kotsuhi];
        }
    }
    
    NSArray* returnArray = [kotsuhiList sortedArrayUsingSelector:@selector(compareDate:)];
    
    return returnArray;
}

+ (NSArray*)loadUntreatedList {
    NSMutableArray* kotsuhiList = [NSMutableArray array];
    
    NSArray* filePathArray = [self getKotsuhiFilePathList];
    
    for(NSString* filepath in filePathArray){
        NSData* readdata = [NSData dataWithContentsOfFile:filepath];
        
        Kotsuhi* kotsuhi = [Kotsuhi makeKotsuhi:readdata];
        
        // nilが返ってきたらリストに追加しない
        // 未処理の交通費のみ登録
        if(kotsuhi != nil && kotsuhi.treated == NO){
            [kotsuhiList addObject:kotsuhi];
        }
    }
    
    NSArray* returnArray = [kotsuhiList sortedArrayUsingSelector:@selector(compareDate:)];
    
    return returnArray;
}

+ (NSArray*)getKotsuhiFilePathList {
    NSMutableArray* filePathArray = [NSMutableArray array];
    
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"kotsuhi"];
    NSArray* filenameArray = [[NSFileManager defaultManager]subpathsAtPath:dirpath];
    
    for(NSString* filename in filenameArray){
        [filePathArray addObject:[dirpath stringByAppendingPathComponent:filename]];
    }
    
    return filePathArray;
}


+ (int)getNewKotsuhiId {
    NSArray* array = [KotsuhiFileManager loadKotsuhiList];
    int maxid = 0;
    
    for(Kotsuhi* kotsuhi in array){
        if(maxid < kotsuhi.kotsuhiid){
            maxid = kotsuhi.kotsuhiid;
        }
    }
    
    return maxid+1;
}

+ (MyPattern*)loadMyPattern:(int)mypatternid {
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"mypattern"];
    NSString* filename = [NSString stringWithFormat:@"mypattern%d.dat",mypatternid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
    
//    NSLog(@"filename : %@",filename);
    
    NSData* readdata = [NSData dataWithContentsOfFile:filepath];
    
    MyPattern* myPattern = [MyPattern makeMyPattern:readdata];
    
    // nilが返ってきたらとりあえずresultidだけセットした空オブジェクトを返す
    if(myPattern == nil){
        myPattern = [[MyPattern alloc] init];
        myPattern.mypatternid = mypatternid;
    }
    
    return myPattern;
}

+ (void)saveMyPattern:(MyPattern*)myPattern {
    if(myPattern.mypatternid == 0){
        // 新規登録の場合はmypatternidとsort順の設定を行う
        [self setMyPatternId:myPattern];
    }
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error;
    
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"mypattern"];
    
    if([fileManager fileExistsAtPath:dirpath] == NO){
        // kotsuhiディレクトリが未作成の場合はディレクトリを作る
        [fileManager createDirectoryAtPath:dirpath withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    NSString* filename = [NSString stringWithFormat:@"mypattern%d.dat",myPattern.mypatternid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];

//    NSLog(@"save filepath : %@",filepath);

    NSData* data = [myPattern getMyPatternNSData];
    
    [data writeToFile:filepath atomically:YES];
}

+ (void)removeMyPattern:(int)mypatternid {
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"mypattern"];
    NSString* filename = [NSString stringWithFormat:@"mypattern%d.dat",mypatternid];
    NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
}

+ (NSArray*)loadMyPatternList {
    NSMutableArray* myPatternList = [NSMutableArray array];
    
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"mypattern"];
    NSArray* filenameArray = [[NSFileManager defaultManager]subpathsAtPath:dirpath];
    
//    NSLog(@"find %d files at %@",filenameArray.count, dirpath);
    
    for(NSString* filename in filenameArray){
        NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
        
//        NSLog(@"load filepath : %@",filepath);
        
        NSData* readdata = [NSData dataWithContentsOfFile:filepath];
        
        MyPattern* myPattern = [MyPattern makeMyPattern:readdata];
        
        // nilが返ってきたらリストに追加しない
        if(myPattern != nil){
            [myPatternList addObject:myPattern];
        }
    }
    
    NSArray* returnArray = [myPatternList sortedArrayUsingSelector:@selector(compareMyPattern:)];
    
    return returnArray;
}

/*
+ (int)getNewMyPatternId {
    NSArray* array = [KotsuhiFileManager loadMyPatternList];
    int maxid = 0;
    
    for(MyPattern* myPattern in array){
        if(maxid < myPattern.mypatternid){
            maxid = myPattern.mypatternid;
        }
    }
    
    return maxid+1;
}
*/

+ (void)setMyPatternId:(MyPattern*)targetMyPattern {
    NSArray* array = [KotsuhiFileManager loadMyPatternList];
    
    int maxid = 0;
    int maxsort = 0;
    for(MyPattern* myPattern in array){
        if(maxid < myPattern.mypatternid){
            maxid = myPattern.mypatternid;
        }
        if(maxsort < myPattern.sort){
            maxsort = myPattern.sort;
        }
    }
    
    targetMyPattern.mypatternid = maxid+1;
    targetMyPattern.sort = maxsort+1;
}

+ (void)makeSampleData {
    
    NSArray* sampleKotsuhiArray =
    [NSArray arrayWithObjects:
     @"V2,1,F8FD4C79-FD9F-4A98-9A36-3BF18C74681D\n2016,10,21\n(株)トラトラ設計\n新宿\n高田馬場\n電車\n133\n進捗会議\n\n0\n",
     @"V2,2,8AAA66D9-42CB-4EED-8D4B-F48D78EDF58C\n2016,10,12\n(株)アイフォン\n新宿\n虎ノ門\n電車\n165\n開発打ち合わせ\n赤坂見附\n1\n",
     @"V2,3,A83CC806-46F8-4F19-AF1D-823F2146274B\n2016,10,7\n(株)トラトラ設計\n新宿\n高田馬場\n電車\n133\n進捗会議\n\n0\n",
     @"V2,4,EA745169-984E-46D6-849B-9C94B7AD29B6\n2016,10,26\n東京国際フォーラム\n新宿\n有楽町\n電車\n194\nフォーラム参加\n\n0\n",
     @"V2,5,325EC746-A9ED-45B7-8F49-836E0177230F\n2016,10,9\n四ツ谷開発(株)\n新宿\n四ツ谷\n電車\n154\n打合せ\n\n1\n",
     nil];
    
    for (NSString* kotsuhiStr in sampleKotsuhiArray){
        NSData* data = [kotsuhiStr dataUsingEncoding:NSUTF8StringEncoding];
        Kotsuhi* kotsuhi = [Kotsuhi makeKotsuhi:data];
        [self saveKotsuhi:kotsuhi];
    }
    
    NSArray* sampleMyPatternArray =
    [NSArray arrayWithObjects:
     @"V2,1\n進捗会議\n(株)トラトラ設計\n新宿\n高田馬場\n電車\n133\n進捗会議\n\n0\n",
     @"V2,2\n開発打合せ\n(株)アイフォン\n新宿\n虎ノ門\n電車\n165\n開発打合せ\n赤坂見附\n1\n",
     @"V2,3\n技術ミーティング\n四ツ谷開発(株)\n新宿\n四ツ谷\n電車\n150\n打合せ\n\n0\n",
     nil];
    
    for (NSString* myPatternStr in sampleMyPatternArray){
        NSData* data = [myPatternStr dataUsingEncoding:NSUTF8StringEncoding];
        MyPattern* myPattern = [MyPattern makeMyPattern:data];
        [self saveMyPattern:myPattern];
    }
    
}

@end
