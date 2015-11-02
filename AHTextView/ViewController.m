//
//  ViewController.m
//  AHTextView
//
//  Created by 黄安华 on 15/11/2.
//  Copyright (c) 2015年 黄安华. All rights reserved.
//

#import "ViewController.h"
#import "AHTextView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    AHTextView *ahtext = [AHTextView createTextViewWithFrame:CGRectMake(15, 200, SCREEN_WIDTH-200, 100) backgroundColor:[UIColor redColor] textAttribute:nil up_LowSpace:0 maxWorlds:300 minWorlds:0 maxHeight:200 minHeight:30 placeholderString:@"hahhaha" placeholderAttribute:nil cornerRadius:5 wordsCountFrame:CGRectZero countAttribute:nil];
    [self.scrollView addSubview:ahtext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
