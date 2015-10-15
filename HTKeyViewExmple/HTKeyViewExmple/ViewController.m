//
//  ViewController.m
//  HTKeyViewExmple
//
//  Created by  易万军 on 15/7/24.
//  Copyright (c) 2015年 yiwanjun. All rights reserved.
//

#import "ViewController.h"
#import "HTKeyView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)awakeFromNib{
    NSLog(@"%@",self.htView);
}

-(void)viewDidLayoutSubviews{
    
    //如需支持xib，这个方法必须在viewDidLayoutSubviews中执行，因为这时self.htView的width才是正确的
    [self.htView layoutContentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *keys = @[@"additional",@"loading",@"the",@"typically",@"layoutContentView",@"stringWithFormat",@"setKeyBackgroudColor",@"recreated",@"of",@"resources",@"Dispose",@"that",@"be",@"self",@"loadKeys",@"grayColor"];
    
    
    NSString *inputString = @"";
    for (NSString *key in keys) {

        inputString = [NSString stringWithFormat:@"%@  %@",inputString,key];
    }
    [self.inputLabel setText:inputString];
    
    
    

    [self.htView setKeyBackgroudColor:[UIColor grayColor]];
    [self.htView loadKeys:keys];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
