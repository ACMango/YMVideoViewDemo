//
//  ViewController.m
//  test6666
//
//  Created by SL设计 on 2019/12/31.
//  Copyright © 2019 Mango. All rights reserved.
//

#import "ViewController.h"
#import "YMVideoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)touchButton:(id)sender {
    
    YMVideoViewController *nextVC = [YMVideoViewController new];
    nextVC.urlString = @"http://cdn.hivilla.com/FghNqu5tbq9JMhQxsVBBIHToyuG7";
    [nextVC showFromViewController:self];
}


@end
