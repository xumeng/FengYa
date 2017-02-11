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

#import "AppMacro.h"
#import "UIView+Extension.h"
#import "CustomUITableViewCell.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *colorsArr;

@end

extern NSString *appFontName;

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
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
    
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
    _tableView.hidden = YES;
    
    UIButton *actionButton = [[UIButton alloc] init];
    [actionButton setTitle:@"..." forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [actionButton sizeToFit];
    [self.view addSubview:actionButton];
    actionButton.bottom = _tableView.height - 15;
    actionButton.right = _tableView.width - 15;
    
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
    
    UIButton *fontButton = [[UIButton alloc] init];
    [fontButton setTitle:NSLocalizedString(@"#", nil) forState:UIControlStateNormal];
    [fontButton addTarget:self action:@selector(gotoSelectFont) forControlEvents:UIControlEventTouchUpInside];
    
    fontButton.width = 100;
    fontButton.height = 30;
    fontButton.right = self.view.width - 10;
    fontButton.top = 35;
//    fontButton.centerY = cell.contentView.centerY;
    fontButton.backgroundColor = UIColorRandom;
    [cell.contentView addSubview:fontButton];
    
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
        NSDictionary *tempColorDict = _colorsArr[indexPath.row];
        NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
        
        WriteViewController *vc = [[WriteViewController alloc] init];
        vc.color = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
        vc.colorString = tempColorDict[@"name"];
        [self presentViewController:vc animated:YES completion:nil];
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
        
    cell.contentView.backgroundColor = UIColorRandom;
    
    UILabel *textLabel;
    textLabel = [[UILabel alloc] init];
    textLabel.tag = 998;
    textLabel.text = @"月白色";
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = FONT(appFontName, 25);
    [textLabel sizeToFit];
    textLabel.opaque = YES;
    [cell.contentView addSubview:textLabel];
    textLabel.centerY = cell.contentView.centerY;
    textLabel.centerX = cell.contentView.centerX;
    
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
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = NSLocalizedString(@"app_name", nil);
    label.font = FONT(appFontName, 25);
    [headerView addSubview:label];
    return headerView;
}

//点击item方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"----%li",indexPath.row);
}



#pragma mark - action
- (void)gotoSelectFont
{
    SelectFontController *vc = [[SelectFontController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showMore
{
    _tableView.hidden = !_tableView.hidden;
    _collectionView.hidden = !_collectionView.hidden;
}

#pragma mark - Notification
- (void)handleSelectedFont
{
    [_tableView reloadData];
}

@end
