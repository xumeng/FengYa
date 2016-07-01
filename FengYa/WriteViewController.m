//
//  WriteViewController.m
//  FengYa
//
//  Created by Amon on 16/4/23.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "WriteViewController.h"
#import "AppMacro.h"

#import <YYText/YYText.h>
#import <YYCategories/UIImage+YYAdd.h>
#import <YYCategories/UIView+YYAdd.h>
#import <YYCategories/NSBundle+YYAdd.h>
#import <YYCategories/NSString+YYAdd.h>
#import <YYCategories/UIControl+YYAdd.h>
#import <YYCategories/CALayer+YYAdd.h>
#import <YYCategories/NSData+YYAdd.h>
#import <YYCategories/UIGestureRecognizer+YYAdd.h>


@interface WriteViewController () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, assign) YYTextView *textView;

@end

@implementation WriteViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initToolBar];
//    [self initImageView];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"天净沙・秋思\n枯藤老树昏鸦，\n小桥流水人家，\n古道西风瘦马，\n夕阳西下，\n断肠人在天涯。"];
//    text.yy_font = [UIFont fontWithName:@"Times New Roman" size:20];
    text.yy_font = FONT_CC(20);
    text.yy_lineSpacing = 10;
    text.yy_firstLineHeadIndent = 20;
    text.yy_color = _color;
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.verticalForm = YES;

    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    textView.tintColor = _color;
    [self.view addSubview:textView];
    [self.view sendSubviewToBack:textView];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
    
    

    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

- (void)initToolBar {
    CGFloat buttonSize = 60;
    UIButton *backButton = [[UIButton alloc] init];
    UIImage *backImage = [UIImage imageNamed:@"icon_back"];
    backImage = [backImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setImage:backImage forState:UIControlStateNormal];
    backButton.tintColor = _color;
    [backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    backButton.left = 0;
    backButton.top = 0;
    backButton.width = buttonSize;
    backButton.height = buttonSize;
    [self.view addSubview:backButton];
    
    UIButton *shareButton = [[UIButton alloc] init];
    UIImage *shareImage = [UIImage imageNamed:@"icon_share"];
    shareImage = [shareImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [shareButton setImage:shareImage forState:UIControlStateNormal];
    shareButton.tintColor = _color;
    [shareButton addTarget:self action:@selector(gotoShare) forControlEvents:UIControlEventTouchUpInside];
    shareButton.left = SIZE_OF_SCREEN.width - buttonSize;
    shareButton.top = 0;
    shareButton.width = buttonSize;
    shareButton.height = buttonSize;
    [self.view addSubview:shareButton];
    
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}

- (void)edit:(UIBarButtonItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

#pragma mark text view

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}


#pragma mark - keyboard

- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    BOOL clipped = NO;
    if (_textView.isVerticalForm && transition.toVisible) {
        CGRect rect = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
        if (CGRectGetMaxY(rect) == self.view.height) {
            CGRect textFrame = self.view.bounds;
            textFrame.size.height -= rect.size.height;
            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        _textView.frame = self.view.bounds;
    }
}

#pragma mark - Action
- (void)gotoBack {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)gotoShare {
    [self.view endEditing:YES];
    
    UIImageWriteToSavedPhotosAlbum([self imageWithView:self.textView], self, nil, nil);
    
//    UIGraphicsBeginImageContext(self.textView.bounds.size);
//    
//    [self.textView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    
//    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
}

- (UIImage *) imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}


@end
