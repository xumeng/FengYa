//
//  WriteViewController.m
//  FengYa
//
//  Created by Amon on 16/4/23.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "WriteViewController.h"
#import "AppMacro.h"
#import "DBUtil.h"
#import "Utils.h"

#import <AVFoundation/AVFoundation.h>

#import <YYText/YYText.h>
#import <YYCategories/UIImage+YYAdd.h>
#import <YYCategories/UIView+YYAdd.h>
#import <YYCategories/NSBundle+YYAdd.h>
#import <YYCategories/NSString+YYAdd.h>
#import <YYCategories/UIControl+YYAdd.h>
#import <YYCategories/CALayer+YYAdd.h>
#import <YYCategories/NSData+YYAdd.h>
#import <YYCategories/UIGestureRecognizer+YYAdd.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "WXApi.h"


@interface WriteViewController () <YYTextViewDelegate, YYTextKeyboardObserver>
@property (nonatomic, assign) YYTextView *textView;
@property (nonatomic, strong) NSDictionary *poetryDict;

@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;

@end

extern NSString *appFontName;

#define kHeaderHeight 60
@implementation WriteViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configData
{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DBUtil *dbUtil = [DBUtil sharedInstance];
        [dbUtil openDB];
        NSMutableArray *resultList = [dbUtil selectPoetryByIndex:[Utils getRandomNumber:1 to:4452]];
        if (resultList && resultList.count > 0) {
            _poetryDict = resultList[0];
            NSLog(@"");
        }
        NSLog(@"");
//    });
}

//  如果内容中已经包含了title，则直接在框内显示内容，否则将标题加入内容中显示在框内
- (NSString *)composeTitle
{
    NSString *trueTitle = _poetryDict[@"title"];
    NSRange range = [_poetryDict[@"title"] rangeOfString:@"（"];
    if (range.location != NSNotFound) {
        trueTitle = [trueTitle substringToIndex:range.location];
        if ([_poetryDict[@"poetry"] rangeOfString:trueTitle].location != NSNotFound) {
            return @"";
        }
    }
    return trueTitle;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configData];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self initToolBar];
    
    NSString *textString = [NSString stringWithFormat:@"%@\n%@",
                            [self composeTitle],
                            _poetryDict[@"poetry"]];
//    @"天净沙・秋思\n枯藤老树昏鸦，\n小桥流水人家，\n古道西风瘦马，\n夕阳西下，\n断肠人在天涯。";
//    textString = @"天";
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:textString];
    text.yy_font = FONT(appFontName, 20);
    text.yy_lineSpacing = 10;
    text.yy_firstLineHeadIndent = 20;
    text.yy_color = _color;
    text.yy_kern = @5.f;
    
    
    YYTextView *textView = [YYTextView new];
    textView.backgroundColor = [UIColor whiteColor];
    textView.attributedText = text;
    textView.origin = CGPointMake(5, kHeaderHeight+HEIGHT_OF_TOP_BAR);
    textView.size = CGSizeMake(self.view.size.width-10, self.view.size.height-kHeaderHeight*2-HEIGHT_OF_TOP_BAR);
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    textView.verticalForm = YES;
    textView.opaque = NO;
    ViewBorder(textView, _color, 1);

    textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    textView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    textView.tintColor = _color;
    [self.view addSubview:textView];
    [self.view sendSubviewToBack:textView];
    self.textView = textView;
    
    [self initHeader];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [textView becomeFirstResponder];
//    });

    [[YYTextKeyboardManager defaultManager] addObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopSpeak];
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
    
    UIButton *speakButton = [[UIButton alloc] init];
    UIImage *speakImage = [UIImage imageNamed:@"voice"];
    speakImage = [speakImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [speakButton setImage:speakImage forState:UIControlStateNormal];
    speakButton.tintColor = _color;
    [speakButton addTarget:self action:@selector(gotoSpeak) forControlEvents:UIControlEventTouchUpInside];
    speakButton.left = SIZE_OF_SCREEN.width - buttonSize*1.75 - 15;
    speakButton.top = 0;
    speakButton.width = buttonSize;
    speakButton.height = buttonSize;
    [self.view addSubview:speakButton];
}

- (void)initHeader
{
    UIView *headerView = [[UIView alloc] init];
    [_textView addSubview:headerView];
    headerView.height = kHeaderHeight;
    headerView.top = _textView.height - 20 - 50;
    headerView.width = self.view.width;
    
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.font = FONT(appFontName, 14);
    authorLabel.numberOfLines = 0;
    authorLabel.text = _poetryDict[@"author"];
    [_textView addSubview:authorLabel];
    authorLabel.width = 20;
    authorLabel.height = 100;
    authorLabel.left = 10;
    authorLabel.bottom = headerView.bottom;
    
    
    
    UIView *colorView = [[UIView alloc] init];
    colorView.backgroundColor = _color;
    ViewRadius(colorView, 15);
    [_textView addSubview:colorView];
    colorView.width = 30;
    colorView.height = 30;
    colorView.centerY = authorLabel.centerY;
    colorView.left = authorLabel.right + 10;
    
    UILabel *colorLabel = [[UILabel alloc] init];
    colorLabel.font = FONT(appFontName, 14);
    colorLabel.numberOfLines = 0;
    colorLabel.text = _colorString;
    [_textView addSubview:colorLabel];
    [colorLabel sizeToFit];
    colorLabel.left = colorView.right + 10;
    colorLabel.width = 20;
    colorLabel.height = 100;
    colorLabel.bottom = headerView.bottom;
    
}

-(NSString *)reverseWordsInString:(NSString *)str
{
    id buf[str.length];
    for (int i = 0; i < str.length; i++) {
        buf[i] = [str substringWithRange:NSMakeRange(i, 1)];
    }
    NSMutableString * mstr = [[NSMutableString alloc]init];
    for (int i = (int)str.length-1; i >= 0; i--) {
        [mstr appendString:buf[i]];
    }
    return mstr;
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
//            _textView.frame = textFrame;
            clipped = YES;
        }
    }
    
    if (!clipped) {
        //_textView.frame = self.view.bounds;
    }
}

#pragma mark - Action
- (void)gotoBack {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)captureScrollView:(YYTextView *)textView
{
    UIImage* image = nil;
    CGFloat scale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContextWithOptions(textView.contentSize, textView.opaque, scale);
    {
        CGPoint savedContentOffset = textView.contentOffset;
        CGRect savedFrame = textView.frame;
        textView.contentOffset = CGPointZero;
        textView.frame = CGRectMake(0, 0, textView.contentSize.width, textView.contentSize.height);
        
        [textView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        textView.contentOffset = savedContentOffset;
        textView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}

- (void)gotoSpeak
{
    if ([_synthesizer isSpeaking]) {
        [self stopSpeak];
    }
    //  过滤掉句子中的阿拉伯数字
    NSString *resultStr = _textView.text;
    NSString * regExpStr = @"[0-9].";
    NSString * replacement = @"";
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regExpStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    resultStr = [regExp stringByReplacingMatchesInString:resultStr
                                                 options:NSMatchingReportProgress
                                                   range:NSMakeRange(0, resultStr.length)
                                            withTemplate:replacement];
    [self speak:resultStr];
}

- (void)gotoShare
{
    [self.view endEditing:YES];
    
    UIImage *snapImg = [self captureScrollView:self.textView];
    
    UIAlertController *av = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"share_write_title", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"share_to_wechat", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareToWeChat:snapImg scene:WXSceneSession];
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:NSLocalizedString(@"share_to_wechat_timeline", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self shareToWeChat:snapImg scene:WXSceneTimeline];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"share_to_save", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (snapImg) {
            UIImageWriteToSavedPhotosAlbum(snapImg, self, nil, nil);
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"share_to_save_success", nil)];
        } else {
            [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"share_to_save_failed", nil)];
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"action_cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [av addAction:action1];
    [av addAction:action4];
    [av addAction:action2];
    [av addAction:action3];
    [self presentViewController:av animated:YES completion:nil];
}

- (void)speak:(NSString *)content
{
    NSString *voiceLang = @"zh-TW";
    NSString *currentLang = CurrentLanguage;
    if ([currentLang hasPrefix:@"zh-Hans"]) {
        voiceLang = @"zh-CN";
    } else if ([currentLang hasPrefix:@"zh-Hant"]) {
        if ([currentLang hasSuffix:@"HK"]) {
            voiceLang = @"zh-HK";
        } else {
            voiceLang = @"zh-TW";
        }
    }
    // 创建嗓音，指定嗓音不存在则返回nil
    AVSpeechSynthesisVoice *voice = [AVSpeechSynthesisVoice voiceWithLanguage:voiceLang];
    // 朗读的内容
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
    utterance.voice = voice;
    utterance.rate = 0.3;
    [self.synthesizer speakUtterance:utterance];
}
- (void)stopSpeak
{
    [_synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
}

- (void)shareToWeChat:(UIImage *)image scene:(int)scene
{
    WXMediaMessage *msg = [WXMediaMessage message];
    WXImageObject *imageObj = [WXImageObject object];
    imageObj.imageData = UIImageJPEGRepresentation(image, 0.75);
    msg.mediaObject = imageObj;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = msg;
    req.scene = scene;
    [WXApi sendReq:req];
}


#pragma mark - delegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - getter/setter
//AVSpeechSynthesizer *synthesizer
- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer) {
        // 创建语音合成器
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        
    }
    return _synthesizer;
}


@end
