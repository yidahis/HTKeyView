//
//  HotSearchKeyView.h
//  ChinaWealth
//
//  Created by  yiwanjun on 15/4/13.
//  Copyright (c) 2015年 ChuanMao. All rights reserved.
//  热门搜索的contentView


#import <UIKit/UIKit.h>


@interface HTKeyView : UIView
@property (nonatomic,copy) NSString *choosen;//选中的key
@property (nonatomic,assign) CGFloat spaceing;//边距：和屏幕的边距，key之间的间距
@property (nonatomic,assign) UIColor* keyBackgroudColor;//key的背景色
/**
 *  加载数据，字符串
 *
 *  @param keys
 */
- (void)loadKeys:(NSArray*)keys;
/**
 * 布局
 */
- (void)layoutContentView;


@end
