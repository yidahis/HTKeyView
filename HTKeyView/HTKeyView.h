//
//  HotSearchKeyView.h
//  ChinaWealth
//
//  Created by  易万军 on 15/4/13.
//  Copyright (c) 2015年 ChuanMao. All rights reserved.
//  热门搜索的contentView


#import <UIKit/UIKit.h>


@interface HTKeyView : UIView

@property (strong,nonatomic) NSString *choosen;//选中的key

@property (assign,nonatomic) CGFloat spaceing;//边距：和屏幕的边距，key之间的间距

@property (assign,nonatomic) UIColor* keyBackgroudColor;//key的背景色
/**
 *  加载数据，字符串
 *
 *  @param keys
 */
- (void)loadKeys:(NSArray*)keys;

- (void) layoutContentView;


@end
