//
//  AHTextView.h
//  催眠器
//
//  created by 黄安华 on 15/10/25.
//  Copyright © 2015年 黄安华. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AHTextView;
typedef BOOL (^shouldBlock) (AHTextView *textView);
typedef void (^didBlock)    (AHTextView *textView);
typedef void (^changeHeightBlock) (AHTextView *textView,CGFloat height);

@interface AHTextView : UIView

//通过以下属性自定义textivew的各种属性
@property (nonatomic, assign) CGFloat up_LowSpace; //字体上下间距
@property (nonatomic, assign) NSUInteger maxWorlds;//最多字数
@property (nonatomic, assign) CGFloat minWolrds;   //最少字数
@property (nonatomic ,assign) CGFloat maxHei;      //最大高度
@property (nonatomic, assign) CGFloat minHei;      //最小高度
@property (nonatomic, assign) BOOL isPositiveCount; //YES:提示已经输入的字数；NO:提示还可以输入的字数
@property (nonatomic, assign) BOOL upwoardExtension;//YES:textview向上增加高度，NO:向下增加高度;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;//键盘的返回键类型

//以下为能被外部获取的信息
@property (nonatomic, assign) NSUInteger wordsCount;//当前的已经输入的字数

/**
 *  textview delegate方法，提供给外部的block回调方法
 */
@property (nonatomic, copy) shouldBlock shouldBeginEditing;
@property (nonatomic, copy) shouldBlock shouldEndEditing;
@property (nonatomic, copy) didBlock didChangeSelection;
@property (nonatomic, copy) didBlock didBeginEditing;
@property (nonatomic, copy) didBlock didEndEditing;
@property (nonatomic, copy) didBlock didChangedText;
@property (nonatomic, copy) didBlock textDidChanged;

@property (nonatomic, copy) didBlock comeToMaxWorlds;//达到最大字数自动方法block
@property (nonatomic, copy) didBlock tapReturn;      //点击回车键自定方法block

@property (nonatomic, copy) changeHeightBlock changeHeightOption;//高度改变block

//弹出键盘
- (void)popUpKeyboard;
//隐藏键盘
- (void)resignKeyBoard;

/**
 test
 */
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
                         countAttribute: (NSMutableAttributedString *)countAttr;

+ (instancetype)createTextviewWithFrame: (CGRect)frame
                       backgroundColor: (UIColor *)color
                         backImageName: (NSString *)imgName
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
                        countAttribute: (NSMutableAttributedString *)countAttr;

+ (instancetype)createTextviewWithFrame: (CGRect)frame
                       backgroundColor: (UIColor *)color
                         textAttribute: (NSMutableDictionary *)textAttribute
                           up_LowSpace: (CGFloat)up_LowSpace
                             maxWorlds: (CGFloat)maxWorlds
                             minWorlds: (CGFloat)minWolrds
                             maxHeight: (CGFloat)maxHei
                             minHeight: (CGFloat)minHei
                          cornerRadius: (CGFloat)cornerRadius;

+ (instancetype)createTextviewWithFrame: (CGRect)frame
                       backgroundColor: (UIColor *)color
                         textAttribute: (NSMutableDictionary *)textAttribute
                             maxHeight: (CGFloat)maxHei
                             minHeight: (CGFloat)minHei
                          cornerRadius: (CGFloat)cornerRadius;


+ (instancetype)createTextviewWithFrame: (CGRect)frame
                       backgroundColor: (UIColor *)color
                         textAttribute: (NSMutableDictionary *)textAttribute
                           up_LowSpace: (CGFloat)up_LowSpace
                             maxWorlds: (CGFloat)maxWorlds
                             minWorlds: (CGFloat)minWolrds
                             maxHeight: (CGFloat)maxHei
                             minHeight: (CGFloat)minHei
                          cornerRadius: (CGFloat)cornerRadius
                       wordsCountFrame: (CGRect)countFrame
                        countAttribute: (NSMutableAttributedString *)countAttr;


@end
