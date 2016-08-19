//
//  KKElementValue.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat KKElementValueUnitPX;

extern CGFloat KKElementValueUnitDP;

extern CGFloat KKElementValueUnitAuto;

typedef struct KKElementValue {
    CGFloat scale;
    CGFloat value;
    CGFloat unit;
} KKElementValue;

extern KKElementValue KKElementValueAuto;
extern KKElementValue KKElementValueFill;

typedef struct KKElementEdge {
    KKElementValue left;
    KKElementValue top;
    KKElementValue right;
    KKElementValue bottom;
} KKElementEdge;


CGFloat KKElementValueToCGFloat(KKElementValue value, CGFloat baseValue);

KKElementValue KKElementValueMakePX(CGFloat value);
KKElementValue KKElementValueMakeDP(CGFloat value);

KKElementValue KKElementValueMake(CGFloat scale,CGFloat value,CGFloat unit);

KKElementEdge KKElementEdgeMake(KKElementValue left,KKElementValue top, KKElementValue right, KKElementValue bottom);
