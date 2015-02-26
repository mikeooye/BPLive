//
//  PathCollectionViewCell.m
//  BPLive
//
//  Created by LiHaozhen on 15/2/26.
//  Copyright (c) 2015年 ihojin. All rights reserved.
//

#import "PathCollectionViewCell.h"

@implementation PathCollectionViewCell{
    
    IBOutlet UILabel *_nameLabel;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    _nameLabel.text = self.name;
}
@end
