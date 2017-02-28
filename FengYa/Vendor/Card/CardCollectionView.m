//
//  CardCollectionView.m
//  CardAnimationDemo
//
//  Created by ShiMac on 15/10/17.
//  Copyright (c) 2015年 guoyan. All rights reserved.
//

#import "CardCollectionView.h"
#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

@interface CardCollectionView ()<CardAniamtionDelegate>



@end

extern NSString *appFontName;
@implementation CardCollectionView


-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setColorsArr:(NSArray *)colorsArr
{
    UITapGestureRecognizer *tap;
    for (NSInteger i = colorsArr.count - 1; i >= 0; i --) {
        NSDictionary *tempColorDict = colorsArr[i];
        CardView *card=[[CardView alloc] initWithFrame:self.bounds];
        card.delegate=self;
        [self addSubview:card];
        
        NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
        
        card.backgroundColor = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
        
        UILabel *label = [[UILabel alloc] init];
        label.text = tempColorDict[@"name"];
        label.font = [UIFont fontWithName:appFontName size:25];
        label.frame = CGRectMake(10, card.bounds.size.height-40, card.bounds.size.width, 0);
        [label sizeToFit];
        double x = [rgbArr[0] doubleValue] + [rgbArr[1] doubleValue] + [rgbArr[2] doubleValue];
        if (x < 150) {
            label.textColor = [UIColor whiteColor];
        } else {
            label.textColor = [UIColor blackColor];
        }
        [card addSubview:label];
        
        card.tag = i + 100;
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)];
        card.userInteractionEnabled = YES;
        [card addGestureRecognizer:tap];
    }
}

- (void)reloadData
{
    UILabel *label;
    for (UIView *subview in self.subviews) {
        for (UIView *subview2 in subview.subviews) {
            if ([subview2 isKindOfClass:[UILabel class]]) {
                label = (UILabel *)subview2;
                label.font = [UIFont fontWithName:appFontName size:25];
            }
        }
    }
}

- (void)tapCard:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag - 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cardCollectionView:didTapCardWithIndex:)]) {
        [self.delegate cardCollectionView:self didTapCardWithIndex:index];
    }
}

-(void)didResetCard
{
    
    
}

-(void)didMoveCard:(BOOL)isRight
{
    
}

-(void)didMoveCardWithPersent:(float)persent
{
    
    
    
}

@end
