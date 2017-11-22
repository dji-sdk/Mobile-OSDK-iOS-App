//
//  MOSSectionButton.h
//  MOS
//
//  Created by RussFenenga on 7/20/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSSection.h"

@interface MOSSectionButton : UIButton

@property (strong, nonatomic) MOSSection *section;
@property (readwrite, nonatomic) BOOL active;

- (id)initWithSection:(MOSSection *)section;

@end
