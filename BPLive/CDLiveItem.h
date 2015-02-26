//
//  CDLiveItem.h
//  BPLive
//
//  Created by LiHaozhen on 15/2/27.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CDLiveItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * rank;

@end
