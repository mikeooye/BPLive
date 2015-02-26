//
//  VideoPlayerViewController.m
//  BPLive
//
//  Created by LiHaozhen on 15/2/26.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import "VideoPlayerViewController.h"

@interface VideoPlayerViewController ()

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.player play];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
