//
//  HotSearchKeyView.m
//  ChinaWealth
//
//  Created by  yiwanjun on 15/4/13.
//  Copyright (c) 2015年 ChuanMao. All rights reserved.
//

#import "HTKeyView.h"

@interface HTKeyView ()
@property (nonatomic,copy) NSMutableArray *buttons;
@property (nonatomic,copy) NSArray *hotKeys;
@property (nonatomic,assign) NSInteger buttonTag;
@end

@implementation HTKeyView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.buttons = [[NSMutableArray alloc]init];
        self.buttonTag = 0;
    }
    return self;
}

- (void)loadKeys:(NSArray*)keys{
    self.hotKeys = keys;
}

- (void)layoutContentView{
    self.buttonTag = 0;
    [self.buttons removeAllObjects];
    if (self.spaceing==0) {
        self.spaceing = 12;
    }
    
    NSMutableArray* mkeys = [self.hotKeys mutableCopy];
    
    //核心算法：每次加载新的key的时候都判断加上去之后的宽度是否会超出容器的宽度，超出就在剩下的key里找一个最合适的来顶替当前这个，然后在换行，否则直接放置在当前行，每加载一个搜索关键字，就记录当前的行数和当前行所有key的宽度和间距之和，换行的的时候最大宽度就被重新初始化
    
    NSInteger row = 0 ;//行数
    CGFloat height = 30 ;
    UIFont *font =  [UIFont systemFontOfSize:14];
    CGFloat maxWidth = self.frame.size.width-16;
    CGFloat currentRowMaxWidth = self.spaceing ;//当前行最大宽度，就是所有key的宽度和间距之和，起始值为0
    
    for (NSInteger i = 0; i < mkeys.count;i++) {
        NSString *key = mkeys[i];
        CGFloat kWidth = [self stringWidth:key Font:font RectWithSize:CGSizeMake(maxWidth, 500)] + self.spaceing;
        if (currentRowMaxWidth  + kWidth < maxWidth) {//最大宽度和新增宽度的和是否超出屏幕宽度，超出就在剩下的key里找一个最合适的来顶替当前这个，然后在换行
            [self addNewButton:key RowMaxWidth:currentRowMaxWidth Row:row StringWidth:kWidth Height:height];
            currentRowMaxWidth += kWidth;
            currentRowMaxWidth += self.spaceing;
            continue;
        }
        //找出最合适这一行的一个key
        NSInteger index = [self findFixOne:maxWidth - currentRowMaxWidth Keys:[mkeys subarrayWithRange:NSMakeRange(i, mkeys.count-i)] Font:font Spaceing:self.spaceing];
        if (index>=10000) {//大于等于10000的时候表示没找到合适的
            //重启一行
            currentRowMaxWidth = self.spaceing;
            row++;
            [self addNewButton:key RowMaxWidth:currentRowMaxWidth Row:row StringWidth:kWidth Height:height];
            currentRowMaxWidth += kWidth;
            currentRowMaxWidth += self.spaceing;
            continue;
        }
        //找到了最合适这一行的一个key
        //交换当前key和最合适的key的位置
        [mkeys exchangeObjectAtIndex:i+index withObjectAtIndex:i];
        //重新取得key，这个key已经是最合适的key
        key = mkeys[i];
        //重新取得key的宽度
        kWidth = [self stringWidth:key Font:font RectWithSize:CGSizeMake(maxWidth, 500)] + self.spaceing;
        [self addNewButton:key RowMaxWidth:currentRowMaxWidth Row:row StringWidth:kWidth Height:height];
        currentRowMaxWidth = self.spaceing;
        row++;
    }
    CGRect frame = self.frame;
    frame.size.height = 10 * 2 + row * (height + 12) + height;
    [self setFrame:frame];
    [self setNeedsLayout];
}
/**
 *  添加一个key
 *
 *  @param key                key的值
 *  @param currentRowMaxWidth 当前行的最大宽度
 *  @param row                当前行
 *  @param sWidth             绘制key所需的宽度
 *  @param height             行搞
 */
- (void)addNewButton:(NSString*)key RowMaxWidth:(CGFloat)currentRowMaxWidth Row:(NSInteger)row StringWidth:(CGFloat)sWidth Height:(CGFloat)height{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(currentRowMaxWidth, row * (height + 12) + self.spaceing, sWidth, height)];
    [btn setTitle:key forState:UIControlStateNormal];
    [self configButton:btn];
    if ([self.choosen isEqualToString:key]) {
        [self highLighted:btn];
    }
    [self addSubview:btn];
    [self.buttons addObject:btn];
}


- (void)keyButtonPressed:(UIButton*)button{
    
    for (UIButton *floor in self.buttons) {
        if ([floor.titleLabel.text isEqualToString:self.choosen]) {
            [self deHighLighted:floor];
            break;
        }
    }
    [self highLighted:button];
    self.choosen = button.titleLabel.text;
}

/**
 *  定制按钮
 */
- (void)configButton:(UIButton *)button{
    [button setBackgroundColor:self.keyBackgroudColor?self.keyBackgroudColor:[UIColor colorWithRed:0.400 green:0.400 blue:1.000 alpha:1.000]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(keyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = self.buttonTag;
    button.adjustsImageWhenDisabled = NO;
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonTag ++;
}

/**
 *  按钮高亮状态
 */
- (void)highLighted:(UIButton *)button{
   //
}

/**
 *  取消高亮状态
 */
- (void)deHighLighted:(UIButton *)button{
  //
}

/**
 *
 *  用来找出剩下的集合里面最合适的一个key
 *  @param maxWidth 当前行剩下的最大宽度
 *  @param keys     余下的集合
 *  @param font     字体
 *  @param spaceing key之间的间距
 *
 *  @return 最合适的一个key的索引
 */

- (NSInteger)findFixOne:(CGFloat)maxWidth Keys:(NSArray*)keys Font:(UIFont*)font Spaceing:(CGFloat)spaceing{
    NSInteger selectIndex = 10000;
    CGFloat deltaWidth = 1000.00;//用来记录与maxWidth最接近的key的宽度
    for (NSInteger i=0; i<keys.count;i++) {
        NSString *key = keys[i];
        CGFloat kwidth = [self stringWidth:key Font:font RectWithSize:CGSizeMake(maxWidth, 500)] + spaceing;
        CGFloat temp = kwidth - maxWidth;//key的宽度与
        if(temp > 0){//超出最大宽度不合适
            continue;
        }
        if(fabs(temp) < fabs(deltaWidth)){//用绝对值来比较得出最接近最大宽度的key
            deltaWidth = temp;
            selectIndex = i;
        }
    }
    return selectIndex;
}

- (CGFloat)stringWidth:(NSString*)string Font:(UIFont*)font RectWithSize:(CGSize)rectSize{
    NSDictionary *attrDic = @{ NSFontAttributeName : [UIFont systemFontOfSize:font.pointSize]};
    NSStringDrawingOptions options =   NSStringDrawingUsesFontLeading;
    CGRect rect =  [string boundingRectWithSize:rectSize options:options attributes:attrDic context:nil];
    return rect.size.width;
}

#pragma mark - setter
- (void)keyBackgroudColor:(UIColor *)keyBackgroudColor{
    for (UIButton *btn  in self.buttons) {
        [btn setBackgroundColor:keyBackgroudColor];
    }
}
@end
