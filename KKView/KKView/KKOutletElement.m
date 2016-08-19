//
//  KKOutletElement.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKOutletElement.h"
#import "KKViewElement.h"

#include <objc/runtime.h>

@implementation KKOutletElement


@end

@implementation KKViewElement(KKOutletElement)

-(void) elemnet:(KKElement *) element setOutletObject:(id) object{
    
    if([element isKindOfClass:[KKOutletElement class]]) {
        
        KKOutletElement * e = (KKOutletElement *) element;
        
        id v = [object valueForKeyPath:e.fromKeyPath];
        
        if(e.valueFunction != nil) {
            v = e.valueFunction(v);
        }
        
        KKViewElement * p = [e parentView];
        
        if(p) {
            [p.view setValue:v forKeyPath:e.toKeyPath];
        }
        
    }
    
    KKElement * e = element.firstChild;
    
    while(e != nil) {
        [self elemnet:e setOutletObject:object];
        e = e.nextSibling;
    }
    
}

-(void) setOutletObject:(id) object {
    [self elemnet:self setOutletObject:object];
}

-(KKElementAddOutletFunction) outlet {
    
    KKElementAddOutletFunction fn = objc_getAssociatedObject(self, "_outlet");
    
    if(fn == nil) {
        __weak KKViewElement * this = self;
        fn = ^KKViewElement *(NSString * fromKeyPath,NSString * toKeyPath,KKOutletElementValueFunction valueFunction) {
            KKOutletElement * e = [[KKOutletElement alloc] init];
            e.fromKeyPath = fromKeyPath;
            e.toKeyPath = toKeyPath;
            e.valueFunction = valueFunction;
            [this append:e];
            return this;
        };
    }
    
    return fn;
}

@end