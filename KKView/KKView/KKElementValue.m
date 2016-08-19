//
//  KKElementValue.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKElementValue.h"

CGFloat KKElementValueUnitPX = 1;

CGFloat KKElementValueUnitDP = 1;

CGFloat KKElementValueUnitAuto = -1;

KKElementValue KKElementValueAuto = {0,0,0};

KKElementValue KKElementValueFill = {100,0,1};


CGFloat KKElementValueToCGFloat(KKElementValue value, CGFloat baseValue) {
    return value.scale * baseValue * 0.01 + value.value * value.unit;
}

KKElementValue KKElementValueMakePX(CGFloat value) {
    KKElementValue v = {0,value,KKElementValueUnitPX};
    return v;
}

KKElementValue KKElementValueMakeDP(CGFloat value) {
    KKElementValue v = {0,value,KKElementValueUnitDP};
    return v;
}

KKElementValue KKElementValueMake(CGFloat scale,CGFloat value,CGFloat unit) {
    KKElementValue v = {scale,value,unit};
    return v;
}

KKElementEdge KKElementEdgeMake(KKElementValue left,KKElementValue top, KKElementValue right, KKElementValue bottom) {
    KKElementEdge v = {left,top,right,bottom};
    return v;
}

KKElementValue KKElementValueFromString(NSString * string) {
    
    KKElementValue v = {0,0,KKElementValueUnitPX};
    
    if([string isEqualToString:@"auto"]) {
        v.unit = KKElementValueUnitAuto;
        return v;
    }
    
    NSArray * vs = [string componentsSeparatedByString:@"%"];
    NSString * vv = [vs objectAtIndex:0];
    
    if([vs count] > 1) {
        v.scale = [[vs objectAtIndex:0] doubleValue];
        vv = [vs objectAtIndex:1];
    }
    
    if([vv hasSuffix:@"dp"]) {
        v.unit = KKElementValueUnitDP;
        v.value = [[vv substringToIndex:[vv length] -2] doubleValue];
    }
    else if([vv hasSuffix:@"px"]) {
        v.unit = KKElementValueUnitPX;
        v.value = [[vv substringToIndex:[vv length] -2] doubleValue];
    }
    else {
        v.value = [vv doubleValue];
    }
    
    return v;
}
