//
//  AHTextView.m
//  催眠器
//
//  created by 黄安华 on 15/10/25.
//  Copyright © 2015年 黄安华. All rights reserved.
//

#import "AHTextView.h"

@interface AHTextView()<UITextViewDelegate>
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, strong) NSMutableDictionary *textAttribute;
@property (nonatomic, strong) NSMutableDictionary *wordsCountAttribute;
@property (nonatomic, strong) UIFont  *countFont;
@property (nonatomic, strong) UIColor *countColor;

@property (nonatomic,   copy) NSString *imgName;
@property (nonatomic,   copy) NSString *placeholderString;
@property (nonatomic,   copy) NSString *renewString;

@property (nonatomic,   weak) UILabel *placeholderLabel;//沉底文字
@property (nonatomic,   weak) UILabel *wordsCountLabel;  //字数统计
@property (nonatomic,   weak) UITextView *textView;     //输入框

@property (nonatomic, assign) CGRect selfFrame;  //整个view的frame
@property (nonatomic, assign) BOOL isWordCount;  //是否存在字数统计label
@property (nonatomic, assign) CGFloat baseline;
@property (nonatomic, assign) CGFloat wordsCountHei;
@end
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@implementation AHTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (NSMutableDictionary *)wordsCountAttribute{
    if (!_wordsCountAttribute) {
        _wordsCountAttribute = [NSMutableDictionary dictionary];
    }
    return _wordsCountAttribute;
}

#pragma mark - create方法
+ (instancetype)createTextViewWithFrame: (CGRect)frame
                       backgroundColor: (UIColor *)color
                         textAttribute: (NSMutableDictionary *)textAttribute
                           up_LowSpace: (CGFloat)up_LowSpace
                             maxWorlds: (CGFloat)maxWorlds
                             minWorlds: (CGFloat)minWolrds
                             maxHeight: (CGFloat)maxHei
                             minHeight: (CGFloat)minHei
                     placeholderString: (NSString *)placeholderString
                  placeholderAttribute: (NSMutableDictionary *)placeholderAttribute
                          cornerRadius: (CGFloat)cornerRadius
                       wordsCountFrame: (CGRect)countFrame
                        countAttribute: (NSMutableDictionary *)countAttr
{
    return [[self alloc] initWithFrame:frame backgroundColor:color  textAttribute:textAttribute up_LowSpace:up_LowSpace maxWorlds:maxWorlds minWorlds:maxHei maxHeight:maxHei minHeight:minHei placeholderString:placeholderString placeholderAttribute:placeholderAttribute cornerRadius: (CGFloat)cornerRadius wordsCountFrame:countFrame countAttribute:countAttr];
}

#pragma mark - 总的初始化方法
- (instancetype)initWithFrame: (CGRect)frame
              backgroundColor: (UIColor *)color
                textAttribute: (NSMutableDictionary *)textAttribute
                  up_LowSpace: (CGFloat)up_LowSpace
                    maxWorlds: (CGFloat)maxWorlds
                    minWorlds: (CGFloat)minWolrds
                    maxHeight: (CGFloat)maxHei
                    minHeight: (CGFloat)minHei
            placeholderString: (NSString *)placeholderString
         placeholderAttribute: (NSMutableDictionary *)placeholderAttribute
                 cornerRadius: (CGFloat)cornerRadius
              wordsCountFrame: (CGRect)countFrame
               countAttribute: (NSMutableDictionary *)countAttr

{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.cornerRadius = cornerRadius;
        if (countFrame.size.height > 0) {
            self.isWordCount = YES;
            self.wordsCountHei = countFrame.size.height;
            CGRect tempFrame = frame;
            tempFrame.size.height -= countFrame.size.height ;
            frame = tempFrame;
        }
        //处理只需要执行一次的代码,获取根据最大最小高度和上下间距处理之后的frame值
        CGRect tempFrame = [self dealWithFrame:frame backgroundColor:color textAttribute:textAttribute up_LowSpace:up_LowSpace maxWorlds:maxWorlds minWorlds:minWolrds maxHeight:maxHei minHeight:minHei];
        
        if (self.isWordCount) {
            tempFrame.origin = CGPointMake(0, countFrame.size.height + 1);
        }else{
            tempFrame.origin = CGPointMake(0, 0);

        }
        //创建textview，placeholder，字数统计label
        [self initialzeTextViewWithFrame:tempFrame textAttribute:textAttribute up_LowSpace:up_LowSpace placeholderString:placeholderString placeholderAttribute:placeholderAttribute cornerRadius:cornerRadius wordsCountFrame:countFrame countAttribute:countAttr];
    }
    return self;
}

#pragma mark - 预处理 最大最小字数，最大最小高度等只需要在初始化时执行一次的代码
#pragma mark 返回处理之后的frame
- (CGRect)dealWithFrame: (CGRect)frame
        backgroundColor: (UIColor *)color
          textAttribute: (NSMutableDictionary *)textAttribute
            up_LowSpace: (CGFloat)up_LowSpace
              maxWorlds: (CGFloat)maxWorlds
              minWorlds: (CGFloat)minWolrds
              maxHeight: (CGFloat)maxHei
              minHeight: (CGFloat)minHei
{
    //计算一行的高度
    NSString *tempContent = @"hah";
    UIFont *textFont = [textAttribute objectForKey:NSFontAttributeName];
    NSDictionary *tempAttr;
    //设置了字体大小就使用自定义的，否则使用默认值15.0f,黑色
    if (textFont)
    {
        tempAttr = @{NSFontAttributeName:textFont};
    }
    else
    {
        tempAttr = @{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]};
    }
    //单行字所占据的size
    CGSize textSize = [tempContent boundingRectWithSize:CGSizeMake(frame.size.width, maxHei) options:NSStringDrawingUsesFontLeading attributes:tempAttr context:nil].size;
    
    //获取只有单行时textview的高度，最小高度设置为单行高度
//    CGFloat singleLineH = self.isWordCount? textSize.height + self.wordsCountHei + 1:textSize.height;
    CGFloat singleLineH = textSize.height;
    
    if (minHei < singleLineH)
    {
        minHei = singleLineH;
    }

    //根据最大最小高度调整frame.size.height
    if (frame.size.height < minHei)
    {
        frame.size.height = minHei;
        
    }
    else if (frame.size.height <= maxHei)
    {
        minHei = frame.size.height;
    }
    else
    {
        frame.size.height = maxHei;
    }
    
    NSUInteger i = frame.size.height / singleLineH;
    frame.size.height = (i+1) * singleLineH;
    //处理最大最小字数
    if (minWolrds < 0)
    {
        minWolrds = 0;
    }
    else if (maxWorlds < minWolrds)
    {
        maxWorlds = minWolrds + 20;
    }
    
    self.backgroundColor = color;
    self.up_LowSpace = up_LowSpace;
    self.baseline  = frame.size.height + frame.origin.y;
    self.maxWorlds = maxWorlds;
    self.minWolrds = minWolrds;
    self.maxHei = maxHei;
    self.minHei = minHei;
    
    return frame;
}

#pragma mark 创建textview
- (void)initialzeTextViewWithFrame: (CGRect)frame
                     textAttribute: (NSMutableDictionary *)textAttribute
                       up_LowSpace: (CGFloat)up_LowSpace
                 placeholderString: (NSString *)placeholderString
              placeholderAttribute: (NSMutableDictionary *)placeholderAttribute
                      cornerRadius: (CGFloat)cornerRadius
                   wordsCountFrame: (CGRect)countFrame
                    countAttribute: (NSMutableDictionary *)countAttr
{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.delegate = self;
    //根据属性字典设置字体属性，取不到的情况下使用默认值：黑色 15号
    UIFont  *textFont  = [textAttribute objectForKey:NSFontAttributeName];
    UIColor *textColor = [textAttribute objectForKey:NSForegroundColorAttributeName];
    
    //字体属性处理
    if (!textFont)
    {
        textFont = [UIFont systemFontOfSize:20];
    }
    textView.font = textFont;
    if (!textColor)
    {
        textColor = [UIColor blackColor];
    }
    textView.textColor = textColor;
    
    
    //设置输入框可编辑部分的view上下间距
    textView.textContainerInset = UIEdgeInsetsMake(up_LowSpace, 0, up_LowSpace, 0);
    textView.backgroundColor = [UIColor clearColor];
    
    //小于0设置为圆形
    cornerRadius = cornerRadius < 0?  frame.size.height/2:cornerRadius;
    textView.layer.cornerRadius = cornerRadius;
    textView.layer.masksToBounds = YES;
    textView.delegate = self;
    [self addSubview:textView];
    self.textView = textView;
    //有placeholderString才创建label
    if (placeholderString && ![placeholderString isEqualToString:@""] && ![placeholderString isEqualToString:@" "])
    {
        [self initialzePlaceholderViewWithString:placeholderString stringAttribute:placeholderAttribute superView:textView];
    }
    
    if (countFrame.size.width > 0) {
        self.isWordCount = YES;
        [self initialzeWordsCountLabelWithFrame:countFrame stringAttribute:countAttr];
    }
    
    
}

#pragma mark placehloder
- (void)initialzePlaceholderViewWithString: (NSString *)placeholderString stringAttribute: (NSMutableDictionary *)placeholderAttribute superView: (UIView *)superView
{
    
    UILabel *label = [[UILabel alloc] init];
    CGRect textRect = self.textView.frame;
    label.frame = CGRectMake(5, textRect.origin.y, textRect.size.width - 5, textRect.size.height);
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    UIFont  *textFont  = [placeholderAttribute objectForKey:NSFontAttributeName];
    UIColor *textColor = [placeholderAttribute objectForKey:NSForegroundColorAttributeName];
    if (textFont)
    {
        label.font = textFont;
    }
    else
    {
        label.font = [UIFont systemFontOfSize:15];
    }
    
    if (textColor) {
        label.textColor = textColor;
    }
    else
    {
        label.textColor = [UIColor grayColor];
    }
    
    //将placeholder显示文字置顶
    CGFloat totalHeight = [placeholderString boundingRectWithSize:label.frame.size options:NSStringDrawingTruncatesLastVisibleLine attributes:placeholderAttribute context:nil].size.height;
    CGFloat singleHeight = [placeholderString boundingRectWithSize:label.frame.size options:NSStringDrawingUsesFontLeading attributes:placeholderAttribute context:nil].size.height;
    NSUInteger lineCount = (label.frame.size.height - totalHeight)/ singleHeight ;
    
    for (int i = 0; i < lineCount; i ++) {
       placeholderString = [placeholderString stringByAppendingString:@" \n "];
    }
    label.text = placeholderString;
    
    label.hidden = NO;
    [superView addSubview:label];
    self.placeholderLabel = label;
}

#warning word count
- (void)initialzeWordsCountLabelWithFrame: (CGRect)countFrame stringAttribute: (NSMutableDictionary *)countAttr{
    UILabel *countLabel = [[UILabel alloc] initWithFrame:countFrame];
    
    [countLabel setBackgroundColor:[UIColor clearColor]];
    
    if (!countAttr) {
        countAttr = [NSMutableDictionary dictionaryWithDictionary:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    }
    self.wordsCountAttribute = countAttr;
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:@"您已输入0个字" attributes:countAttr];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] range:NSMakeRange(4, 1)];
    countLabel.attributedText = attributeStr;
    
    UIFont  *textFont  = [countAttr objectForKey:NSFontAttributeName];
    UIColor *textColor = [countAttr objectForKey:NSForegroundColorAttributeName];
    if (textFont)
    {
        self.countFont = textFont;
    }
    else
    {
        self.countFont = [UIFont systemFontOfSize:12];
    }
    
    if (textColor) {
        self.countColor = textColor;
    }
    else
    {
        self.countColor = [UIColor grayColor];
    }
    self.wordsCountLabel = countLabel;
    [self addSubview:countLabel];
    
    CGRect lineFrame = countFrame;
    lineFrame.origin.x = self.bounds.origin.x;
    lineFrame.origin.y = countFrame.origin.y + countFrame.size.height+1;
    lineFrame.size.width = self.frame.size.width;
    lineFrame.size.height = 0.5;
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    line.backgroundColor = [UIColor grayColor];
    [self addSubview:line];
}

#pragma mark - setter 方法
- (void)setUp_LowSpace:(CGFloat)up_LowSpace{
    _up_LowSpace = up_LowSpace;
    [self.textView setContentInset:UIEdgeInsetsMake(up_LowSpace, 0, up_LowSpace, up_LowSpace)];
    [self setNeedsLayout];
}

- (void)setReturnKeyType:(UIReturnKeyType)returnKeyType{
    _returnKeyType = returnKeyType;
    self.textView.returnKeyType = returnKeyType;
}

- (void)setMaxHei:(CGFloat)maxHei{
    
    if (maxHei < self.minHei) {
        maxHei = self.minHei;
    }
    _maxHei = maxHei;
}

- (void)setMinHei:(CGFloat)minHei{
    if (minHei < 20) {
        minHei = 20;
    }
    _minHei = minHei;
}

#pragma mark - textview delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.shouldBeginEditing)
    {
        return self.shouldBeginEditing(self);
    }
    else
    {
        return YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (self.shouldEndEditing) {
        return self.shouldEndEditing(self);
    }
    else
    {
        return YES;
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [textView becomeFirstResponder];
    NSString *lengthStr = [NSString stringWithFormat:@"%lu",(unsigned long)textView.text.length];
    if (textView.text.length > 0) {
        self.placeholderLabel.hidden = YES;
        if (self.isWordCount) {
            NSString *wordCountString = [NSString stringWithFormat:@"您已输入%@个字",lengthStr];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:wordCountString];
            [attr addAttributes:self.wordsCountAttribute range:NSMakeRange(0, wordCountString.length)];
            
            [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] range:NSMakeRange(4, lengthStr.length)];
            
            self.wordsCountLabel.attributedText = attr;
        }
        
    }else{
        self.placeholderLabel.hidden = NO;
    }
    
    if (self.didBeginEditing)
    {
        self.didBeginEditing(self);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSUInteger textLength = textView.text.length;
    if (textLength == 0) {
        self.placeholderLabel.hidden = NO;
    }else{
        self.placeholderLabel.hidden = YES;
    }
    if (self.didEndEditing) {
        self.didEndEditing(self);
    }
}

-(void)textViewDidChange:(UITextView *)textView{
    
    self.placeholderLabel.hidden = YES;
    NSString *text = textView.text;
    NSString *lengthStr = [NSString stringWithFormat:@"%lu",(unsigned long)text.length];;
    //获取当前键盘类型
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) {
        //获取高亮部分
        UITextRange *hightLightedRange = [textView markedTextRange];
        UITextPosition *position = [textView positionFromPosition:hightLightedRange.start offset:0];
        if (position) {
            //获取高亮部分的字符串,有高亮部分
            NSString *hightLightedString = [textView textInRange:hightLightedRange];
            lengthStr = [NSString stringWithFormat:@"%lu",text.length - hightLightedString.length];
        }
    }
    if (!textView.markedTextRange && [lengthStr intValue]> self.maxWorlds) {
        textView.text = [text substringToIndex:self.maxWorlds];
        lengthStr = [NSString stringWithFormat:@"%lu",(unsigned long)self.maxWorlds];
        
        if (self.comeToMaxWorlds) {
            self.comeToMaxWorlds(self);
        }
       
    }
    
    if (self.isWordCount) {
        //实时显示输入字数
        NSString *wordCountString = [NSString stringWithFormat:@"您已输入%@个字",lengthStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:wordCountString];
        [attr addAttributes:self.wordsCountAttribute range:NSMakeRange(0, wordCountString.length)];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.6 green:0 blue:0 alpha:1] range:NSMakeRange(4, lengthStr.length)];
        self.wordsCountLabel.attributedText = attr;
    }
    
    if (self.didChangedText) {
        self.didChangedText(self);
    }
    if (self.maxHei == self.minHei) {
        return;
    }
    
    //动态计算高度
#pragma mark 高度调整
    //获取textview中的文本输入框高度
    CGFloat textContainerHei = [[self.textView layoutManager] usedRectForTextContainer:self.textView.textContainer].size.height ;
    
    // 获取textview的实际高度
    CGRect textFrame = self.textView.frame;
    if (textContainerHei < self.minHei) {
        textFrame.size.height = self.minHei;
    }else if (textContainerHei > self.maxHei){
        textFrame.size.height = self.maxHei;
    }else{
        textFrame.size.height = textContainerHei;
    }
    
    //获取自身大小
    [UIView animateWithDuration:0.25 animations:^{
        self.textView.frame = textFrame;
        CGRect rect = self.frame;
        if (self.wordsCountLabel) {
//            if (self.upwoardExtension) {
//                rect.origin.y = self.baseline - textFrame.size.height;
//            }
            rect.size.height = textFrame.size.height + self.wordsCountHei;
            NSLog(@"%@",NSStringFromCGRect(self.frame));
        }else{
            rect.size.height = textFrame.size.height;
        }
        
        self.frame = rect;
        
        if (self.changeHeightOption) {
            self.changeHeightOption(self,rect.size.height);
        }
    }];
    
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        if (self.tapReturn) {
            self.tapReturn(self);
        }
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

//- (void)textViewDidChangeSelection:(UITextView *)textView{
//    if (![self.renewString isEqualToString:textView.text]) {
//        if (textView.text.length >= self.maxWorlds) {
//            if (self.renewString.length < textView.text.length) {
//                if (self.comeToMaxWorlds) {
//                    self.comeToMaxWorlds(self);
//                }
//            }
//        }
//        self.renewString = textView.text;
//    }
//    if (self.didChangeSelection) {
//        self.didChangeSelection(self);
//    }
//}

//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    //
//    if ([textView.text isEqualToString:@"\n"])
//    {
//        if (self.tapReturn) {
//            self.tapReturn(self);
//        }
//        return NO;
//    }
//    NSString *new = [textView.text stringByReplacingCharactersInRange:range withString:text];
//    NSInteger res = self.maxWorlds - new.length;
//    if (res >= 0) {
//        [self textViewDidChange:self.textView];
//        return YES;
//    }else{
//        NSRange rg = NSMakeRange(0, self.maxWorlds);
//        if (rg.length > 0) {
//            NSString *s = [new substringWithRange:rg];
//            [textView setText:s];
//            [self textViewDidChange:self.textView];
//            return NO;
//        }
//    }
//    return YES;
//}
//
//- (void)textViewDidChange:(UITextView *)textView{
//
//}

#pragma 焦点方法
- (void)popUpKeyboard{
    [self.textView becomeFirstResponder];
}

- (void)resignKeyBoard{
    [self.textView resignFirstResponder];
}
@end
