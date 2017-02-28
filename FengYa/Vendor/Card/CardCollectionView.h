//
//  CardCollectionView.h
//  CardAnimationDemo
//
//  Created by ShiMac on 15/10/17.
//  Copyright (c) 2015年 guoyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@protocol CardCollectionViewDelegate;
@interface CardCollectionView : UIView

@property (nonatomic, strong) NSArray *colorsArr;

@property (nonatomic, assign) id<CardCollectionViewDelegate> delegate;

- (void)reloadData;

@end

@protocol CardCollectionViewDelegate <NSObject>

- (void)cardCollectionView:(CardCollectionView *)cardCollectionView didTapCardWithIndex:(NSInteger)index;

@end
