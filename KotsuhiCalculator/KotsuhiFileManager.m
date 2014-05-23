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
    
    NSArray* dirpaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* rootdirpath = [dirpaths objectAtIndex:0];
    NSString* dirpath = [rootdirpath stringByAppendingPathComponent:@"kotsuhi"];
    NSArray* filenameArray = [[NSFileManager defaultManager]subpathsAtPath:dirpath];
    
//    NSLog(@"find %d files at %@",filenameArray.count, dirpath);
    
    for (int i=0; i<filenameArray.count; i++) {
        NSString* filename = [filenameArray objectAtIndex:i];
        NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
        
//        NSLog(@"load filepath : %@",filepath);
        
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
        myPattern.mypatternid = [self getNewMyPatternId];
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
    
    for (int i=0; i<filenameArray.count; i++) {
        NSString* filename = [filenameArray objectAtIndex:i];
        NSString* filepath = [dirpath stringByAppendingPathComponent:filename];
        
//        NSLog(@"load filepath : %@",filepath);
        
        NSData* readdata = [NSData dataWithContentsOfFile:filepath];
        
        MyPattern* myPattern = [MyPattern makeMyPattern:readdata];
        
        // nilが返ってきたらリストに追加しない
        if(myPattern != nil){
            [myPatternList addObject:myPattern];
        }
    }
    
    NSArray* returnArray = [myPatternList sortedArrayUsingSelector:@selector(compareMyPatternId:)];
    
    return returnArray;
}

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

@end
