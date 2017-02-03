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
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [self loadFontsData];
    //    });
}

- (void)loadFontsData {
    _fontsArr = @[
                  @"Wyue-GutiFangsong-NC",
                  @"H-SiuNiu-Regular",
                  @"H-SiuNiu-Bold"
                  ];
}

- (void)initUI {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(gotoBack)];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
    
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"%s", __FUNCTION__);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%s", __FUNCTION__);
    if (!_fontsArr) {
        return 0;
    }
    return _fontsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    
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
        
    }
    
    return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

#pragma mark - action
- (void)gotoBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
