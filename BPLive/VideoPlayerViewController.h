//
//  VideoPlayerViewController.h
//  BPLive
//
//  Created by LiHaozhen on 15/2/26.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerViewController : AVPlayerViewController

@property (copy, nonatomic) NSString *url;
@end
