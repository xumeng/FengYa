//
//  SelectFontController.m
//  FengYa
//
//  Created by Amon on 2017/1/22.
//  Copyright © 2017年 GodPlace. All rights reserved.
//

#import "SelectFontController.h"
#import "AppMacro.h"
#import "UIView+Extension.h"
#import "CustomUITableViewCell.h"
#import "Utils.h"

@interface SelectFontController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *fontsArr;

@end

extern NSString *appFontName;

@implementation SelectFontController

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
    [self loadFontsData];
}

- (void)loadFontsData {
    _fontsArr = @[
                  @"H-GungSeo",
                  @"Wyue-GutiFangsong-NC",
                  @"H-SiuNiu-Regular",
                  @"STHeitiTC-Medium",
                  @"H-LiHei-Regular",
                  @"PingFangTC-Thin"
                  ];
}

- (void)initUI {
    self.title = NSLocalizedString(@"title_select_font", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.tableFooterView = [UIView new];
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!_fontsArr) {
        return 0;
    }
    return _fontsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self configureFontCell:tableView cellForRowAtIndexPath:indexPath];
}


- (UITableViewCell *)configureFontCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [NSString stringWithFormat:@"CellId %ld, %ld", indexPath.section, indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    NSString *fontName = _fontsArr[indexPath.row];
    

    
    if(cell == nil) {
        cell = [[CustomUITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.textLabel.text = @"人生得意須盡歡";
        cell.textLabel.font = FONT(fontName, 40);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *fontName = _fontsArr[indexPath.row];
    appFontName = fontName;
    NSDictionary *appDict = [Utils getAppConfig];
    [appDict setValue:appFontName forKey:@"app_font_name"];
    [Utils saveAppConfigToNSUserDefaults:appDict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_SELECTED_FONT object:nil];
    [self gotoBack];
}

#pragma mark - action
- (void)gotoBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
