//  项目中使用到的宏集合
//  AppMacro.h
//  WeChatStickers
//
//  Created by Amon on 15/7/9.
//  Copyright (c) 2015年 iPin. All rights reserved.
//

#ifndef WeChatStickers_AppMacro_h
#define WeChatStickers_AppMacro_h


///  判断设备版本是否是iOS8
#define ISIOS8  ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)


/// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

///  RIGHTOF:    位于某个视图右侧，坐标为该视图的 x+width
///  BOTTEMOF:   位于某个视图下方，坐标为该视图的 y+height
#define RIGHTOF(v)              ((v).frame.origin.x + (v).frame.size.width)
#define BOTTEMOF(v)             ((v).frame.origin.y + (v).frame.size.height)
#define LEFTOF(v)               ((v).frame.origin.x)


#define HEIGHT_OF_NAVIGATION_BAR    self.navigationController.navigationBar.frame.size.height
#define HEIGHT_OF_STATUS_BAR        [[UIApplication sharedApplication] statusBarFrame].size.height
#define SIZE_OF_SCREEN    [[UIScreen mainScreen] bounds].size
#define HEIGHT_OF_TAB_BAR   49.f
#define HEIGHT_OF_TOP_BAR   64.f
#define HEIGHT_OF_TOOL_BAR   44.f

///  旧版标注基于iPhone5，计算屏幕与iPhone5屏幕的比例，进行适配
#define SCALE_OF_SCREEN ([[UIScreen mainScreen] bounds].size.width/320.)

///  标注基于iPhone6，计算屏幕与iPhone6屏幕的比例，进行适配
#define SCALE_OF_IPHONE6_SCREEN ([[UIScreen mainScreen] bounds].size.width/375.)

#define WIDTH_OF_STANDARD_SIZE 320.f
#define HEIGHT_OF_4S 480.f
#define HEIGHT_OF_5S 568.f

#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#define TEXTRECT(text, constraintSize, font) [text boundingRectWithSize:constraintSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font } context:nil]

#define WeakSelf __weak typeof(self) weakSelf = self;
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;


///  SVProgressHUD显示
#define showHUDInfo(text) {\
[self showHudInfo:text];\
}

///  显示网络运行状态
#define showNetworkActivityIndicator(flag) {[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:flag];}

///  获取PNG文件
#define PNGIMAGEWITHFILE(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]]

///  获取JPG文件
#define JPGIMAGEWITHFILE(name) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"jpg"]]


/// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

///  View加边框
#define ViewBorder(View, BorderColor, BorderWidth )\
\
View.layer.borderColor = BorderColor.CGColor;\
View.layer.borderWidth = BorderWidth;

#define ViewRandomColor(View)\
\
View.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];

///  RGB转UIColor
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

#define RGBCOLOR(R,G,B) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

#define RGBACOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

///  随机颜色
#define UIColorRandom [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]


///  系统语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


/// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]

#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]

#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

#define FONT_CC(FONTSIZE) [UIFont fontWithName:@"Wyue-GutiFangsong-NC" size:(FONTSIZE)]

#define FONT_XX    [UIFont systemFontOfSize:18]
#define FONT_X    [UIFont systemFontOfSize:14]
#define FONT_M    [UIFont systemFontOfSize:12]
#define FONT_S    [UIFont systemFontOfSize:10]


//  卡片圆角为4
#define CORNER_RADIUS_X 4
//  按钮圆角为2
#define CORNER_RADIUS_M 2

#define ViewBorderWidth  0.5
#define BorderWidthBar  1

//  通用 Bar 高度
#define MAIN_BAR_HEIGHT 38.f


#endif
