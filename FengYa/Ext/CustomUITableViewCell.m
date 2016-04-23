//
//  CustomUITableViewCell.m
//  ChineseColor
//
//  Created by Amon on 16/4/17.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "CustomUITableViewCell.h"

@implementation CustomUITableViewCell

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.7 animations:^{
            [self setHighlighted:highlighted];
        }];
    } else {
        [self setHighlighted:highlighted];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:.7 animations:^{
            [self setSelected:selected];
        }];
    } else {
        [self setSelected:selected];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    self.backgroundColor = highlighted ? self.selectedBackgroundView.backgroundColor : [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected {
    self.backgroundColor = selected ? self.selectedBackgroundView.backgroundColor : [UIColor whiteColor];
}
@end
