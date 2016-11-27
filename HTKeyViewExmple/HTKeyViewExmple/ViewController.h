//
//  ViewController.h
//  HTKeyViewExmple
//
//  Created by  yiwanjun on 15/7/24.
//  Copyright (c) 2015年 yiwanjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HTKeyView;
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet HTKeyView *htView;

@end

