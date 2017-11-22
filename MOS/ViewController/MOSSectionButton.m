//
//  MOSSectionButton.m
//  MOS
//
//  Created by RussFenenga on 7/20/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import "MOSSectionButton.h"

@implementation MOSSectionButton

- (id)initWithSection:(MOSSection *)section
{
    self = [super init];
    if (self) {
        self.section = section;
        [self setTitle:section.name forState:UIControlStateNormal];
        self.titleLabel.minimumScaleFactor = 0.25;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.titleLabel setTextColor:[UIColor whiteColor]];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
        self.active = NO;
    }
    return self;
}

@end
