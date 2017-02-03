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

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *colorsArr;

@end

extern NSString *appFontName;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self configureData];
    
    [self initUI];
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
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s", __FUNCTION__);
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s", __FUNCTION__);
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
    NSLog(@"%s", __FUNCTION__);
    
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
        cell.highlighted = NO;
    }
    cell.textLabel.text = @"风雅";
    cell.textLabel.font = FONT(appFontName, 40);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *fontButton = [[UIButton alloc] init];
    [fontButton setTitle:@"字體" forState:UIControlStateNormal];
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
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellId %ld, %ld", indexPath.section, indexPath.row];
    CustomUITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIView *roundView = [cell.contentView viewWithTag:999];
    UILabel *textLabel = [cell.contentView viewWithTag:998];
    
    NSDictionary *tempColorDict = _colorsArr[indexPath.row];
    
    NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
    
    if(cell == nil) {
        cell = [[CustomUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"风雅";
            cell.textLabel.font = FONT(appFontName, 40);
        }
        
        UIView *bgView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        bgView.backgroundColor = UIColorFromRGB(0xD3D3D3);
        cell.selectedBackgroundView = bgView;
        
        roundView = [[UIView alloc] init];
        roundView.tag = 999;
        [roundView sizeToFit];
        roundView.centerY = cell.contentView.centerY;
        roundView.size = CGSizeMake(60, 60);
        roundView.centerX = tableView.centerX - 50;
        //        roundView.x = 100;
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
    textLabel.text = tempColorDict[@"name"];
    //    cell.backgroundColor = UIColorRandom;
    roundView.backgroundColor = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tempColorDict = _colorsArr[indexPath.row];
    NSArray *rgbArr = [tempColorDict[@"RGB"] componentsSeparatedByString:@","];
    
    WriteViewController *vc = [[WriteViewController alloc] init];
    vc.color = RGBCOLOR([rgbArr[0] doubleValue], [rgbArr[1] doubleValue], [rgbArr[2] doubleValue]);
    vc.colorString = tempColorDict[@"name"];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - action
- (void)gotoSelectFont
{
    SelectFontController *vc = [[SelectFontController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
