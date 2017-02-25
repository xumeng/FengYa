//
//  ViewController.m
//  ChineseColor
//
//  Created by Amon on 16/4/17.
//  Copyright © 2016年 GodPlace. All rights reserved.
//

#import "ViewController.h"
#import "WriteViewController.h"
#import "SelectFontController.h"
#import "UserViewController.h"

#import "AppMacro.h"
#import "UIView+Extension.h"
#import "CustomUITableViewCell.h"

#import <DCPathButton/DCPathButton.h>
#import "CardCollectionView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DCPathButtonDelegate, CardCollectionViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) CardCollectionView *cardView;

@property (nonatomic, strong) NSMutableArray *colorsArr;

@property NSInteger tapIndex;

@end

extern NSString *appFontName;

typedef NS_ENUM(NSInteger, TOOLS_ACTION) {
    TOOLS_ACTION_ABOUT = 0,
    TOOLS_ACTION_SELECT_FONT,
    TOOLS_ACTION_SWITCH,
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureData];
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSelectedFont)
                                                 name:NOTIFICATION_SELECTED_FONT
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)configureData {
    _tapIndex = 0;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadColorsData];
//    });
}

- (void)loadColorsData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"colors" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:NULL];
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
    _colorsArr = (NSMutableArray *)json;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView reloadData];
    });
}

- (void)initUI {
    self.view.backgroundColor = UIColorFromRGB(0xefefef);
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.text = NSLocalizedString(@"app_name", nil);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = FONT(appFontName, 40);
    [_titleLabel sizeToFit];
    _titleLabel.height = 100;
    _titleLabel.centerX = self.view.centerX;
    [self.view addSubview:_titleLabel];
    
    
    //  表格视图
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    
    //  格子视图
    CGFloat itemSize = (SIZE_OF_SCREEN.width - 10*3)/2;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(itemSize, itemSize);
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    [self.view addSubview:_collectionView];
    
    //  卡片视图
    _cardView = [[CardCollectionView alloc] initWithFrame:CGRectMake(40, 100, WIDTH(self.view)-40*2, HEIGHT(self.view)-200)];
    _cardView.colorsArr = _colorsArr;
    _cardView.delegate = self;
    [self.view addSubview:_cardView];
    
    //  操作按钮
    DCPathButton *pathButton = [[DCPathButton alloc] initWithCenterImage:[UIImage imageNamed:@"more"]
                                                        highlightedImage:[UIImage imageNamed:@"more"]];
    pathButton.delegate = self;
    
    DCPathItemButton *itemButton1 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"about"]
                                                           highlightedImage:[UIImage imageNamed:@"about"]
                                                            backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                 backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    DCPathItemButton *itemButton2 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"refresh"]
                                                          highlightedImage:[UIImage imageNamed:@"refresh"]
                                                           backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    DCPathItemButton *itemButton3 = [[DCPathItemButton alloc]initWithImage:[UIImage imageNamed:@"aa"]
                                                          highlightedImage:[UIImage imageNamed:@"aa"]
                                                           backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]
                                                backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    
    [pathButton addPathItems:@[itemButton1, itemButton3, itemButton2]];
    pathButton.bloomRadius = 120.0f;
    pathButton.allowSounds = YES;
    pathButton.allowCenterButtonRotation = YES;
    
    pathButton.bloomDirection = kDCPathButtonBloomDirectionTopLeft;
    pathButton.dcButtonCenter = CGPointMake(self.view.frame.size.width - 10 - pathButton.frame.size.width/2, self.view.frame.size.height - pathButton.frame.size.height/2 - 10);
    pathButton.bottomViewColor = [UIColor blackColor];
    [self.view addSubview:pathButton];
    
    _tableView.hidden = YES;
    _collectionView.hidden = YES;
}

- (void)updateShow
{
    [UIView animateWithDuration:.25 animations:^{
        _collectionView.hidden = YES;
        _tableView.hidden = YES;
        _cardView.hidden = YES;
    } completion:^(BOOL finished) {
        if (_tapIndex % 3 == 0) {
            _cardView.hidden = NO;
        } else if (_tapIndex % 2 == 0) {
            _collectionView.hidden = NO;
        } else {
            _tableView.hidden = NO;
        }
    }];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_colorsArr) {
        return 0;
    }
    if (section == 0) {
        return 1;
    } else {
        return _colorsArr.count;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (CustomUITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [self configureHeaderCell:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self configureColorCell:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (CustomUITableViewCell *)configureHeaderCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    CustomUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[CustomUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = NSLocalizedString(@"app_name", nil);
    cell.textLabel.font = FONT(appFontName, 40);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

- (CustomUITableViewCell *)configureColorCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellId %li, %li", indexPath.section, indexPath.row];
    CustomUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIView *roundView = [cell.contentView viewWithTag:999];
    UILabel *textLabel = [cell.contentView viewWithTag:998];
    
    NSDictionary *tempColorDict = _colorsArr[indexPath.row];
    
    NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
    
    if(cell == nil) {
        cell = [[CustomUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        bgView.backgroundColor = UIColorFromRGB(0xD3D3D3);
        cell.selectedBackgroundView = bgView;
        
        roundView = [[UIView alloc] init];
        roundView.tag = 999;
        [roundView sizeToFit];
        roundView.centerY = cell.contentView.centerY;
        roundView.size = CGSizeMake(60, 60);
        roundView.centerX = tableView.centerX - 50;
        ViewRadius(roundView, roundView.width/2);
        roundView.opaque = YES;
        
        [cell.contentView addSubview:roundView];
        
        textLabel = [[UILabel alloc] init];
        textLabel.tag = 998;
        textLabel.text = @"月白色";
        textLabel.font = FONT(appFontName, 25);
        [textLabel sizeToFit];
        textLabel.centerY = roundView.centerY;
        textLabel.centerX = tableView.centerX + 60;
        textLabel.opaque = YES;
        [cell.contentView addSubview:textLabel];
        
        cell.highlighted = NO;
    }
    textLabel.font = FONT(appFontName, 25);
    textLabel.text = tempColorDict[@"name"];
    roundView.backgroundColor = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [self gotoSelectFont];
    } else {
        [self gotoWrite:indexPath.row];
    }
}

#pragma mark - UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    NSDictionary *tempColorDict = _colorsArr[indexPath.row];
    
    NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
    cell.contentView.backgroundColor = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
    
    UILabel *textLabel = [cell.contentView viewWithTag:998];
    if (!textLabel) {
        textLabel = [[UILabel alloc] init];
        textLabel.tag = 998;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = FONT(appFontName, 25);
        textLabel.opaque = YES;
        textLabel.text = tempColorDict[@"name"];
        [textLabel sizeToFit];
        [cell.contentView addSubview:textLabel];
        textLabel.centerY = cell.contentView.centerY;
        textLabel.centerX = cell.contentView.centerX;
    }
    double x = [rgbArr[0] doubleValue] + [rgbArr[1] doubleValue] + [rgbArr[2] doubleValue];
    if (x < 150) {
        textLabel.textColor = [UIColor whiteColor];
    } else {
        textLabel.textColor = [UIColor blackColor];
    }
    
    textLabel.text = tempColorDict[@"name"];
    [textLabel sizeToFit];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    UILabel *label = [headerView viewWithTag:888];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:headerView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        label.tag = 888;
    }
    label.text = NSLocalizedString(@"app_name", nil);
    label.font = FONT(appFontName, 40);
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self gotoWrite:indexPath.row];
}

#pragma mark DCPathButton Delegate
- (void)pathButton:(DCPathButton *)dcPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    if (itemButtonIndex == TOOLS_ACTION_ABOUT) {
        [self gotoAbout];
    } else if (itemButtonIndex == TOOLS_ACTION_SWITCH) {
        [self gotoSwitch];
    } else if (itemButtonIndex == TOOLS_ACTION_SELECT_FONT) {
        [self gotoSelectFont];
    }
}

#pragma mark CardCollectionView Delegate
- (void)cardCollectionView:(CardCollectionView *)cardCollectionView didTapCardWithIndex:(NSInteger)index
{
    [self gotoWrite:index];
}


#pragma mark - action
- (void)gotoSelectFont
{
    SelectFontController *vc = [[SelectFontController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)gotoAbout
{
    UserViewController *vc = [[UserViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)gotoSwitch
{
    _tapIndex ++;
    [self updateShow];
}

- (void)gotoWrite:(NSInteger)index
{
    NSDictionary *tempColorDict = _colorsArr[index];
    NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
    
    WriteViewController *vc = [[WriteViewController alloc] init];
    vc.color = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
    vc.colorString = tempColorDict[@"name"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Notification
- (void)handleSelectedFont
{
    [_tableView reloadData];
    [_collectionView reloadData];
    [_cardView reloadData];
    _titleLabel.font = FONT(appFontName, 40);
}

@end
