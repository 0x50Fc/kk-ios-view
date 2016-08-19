//
//  KKViewElement.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKViewElement.h"

#include <objc/runtime.h>

@implementation KKViewElement

-(instancetype) init {
    
    if((self = [super init])) {
        
        __weak KKViewElement * this = self;
        
        _getView = ^KKViewElement *(KKViewElementGetViewCBFunction cb) {
            
            if(this != nil && cb != nil) {
                cb(this.view,this);
            }
            
            return this;
        };
        
        _setLeft = ^KKViewElement*(KKElementValue value) {
            [this setLeft:value];
            return this;
        };
        
        _setRight = ^KKViewElement*(KKElementValue value) {
            [this setRight:value];
            return this;
        };
        
        _setTop = ^KKViewElement*(KKElementValue value) {
            [this setTop:value];
            return this;
        };
        
        _setBottom = ^KKViewElement*(KKElementValue value) {
            [this setBottom:value];
            return this;
        };
        
        _setWidth = ^KKViewElement*(KKElementValue value) {
            [this setWidth:value];
            return this;
        };
        
        _setHeight = ^KKViewElement*(KKElementValue value) {
            [this setHeight:value];
            return this;
        };
        
        _setPadding = ^KKViewElement*(KKElementValue left,KKElementValue top, KKElementValue right, KKElementValue bottom) {
            [this setPadding:KKElementEdgeMake(left,top,right,bottom)];
            return this;
        };
        
        _setMargin = ^KKViewElement*(KKElementValue left,KKElementValue top, KKElementValue right, KKElementValue bottom) {
            [this setMargin:KKElementEdgeMake(left,top,right,bottom)];
            return this;
        };
        
    }
    
    return self;
}

+(instancetype) elementWithView:(UIView *) view {
    KKViewElement * e = [[self alloc] init];
    e.view = view;
    return e;
}

@end

@implementation KKElement(KKViewElement)

-(void) appendViewElement:(KKViewElement *) element {
    [self append:element];
    
    UIView * v = element.view;
    
    if(v != nil) {
        
        KKElement * p = self;
        
        while(p != nil) {
            
            if([p isKindOfClass:[KKViewElement class]] && [(KKViewElement *)p view] != nil) {
                [[(KKViewElement *)p view] addSubview:v];
                break;
            }
            p = p.parent;
        }
    }
}

-(KKViewElement *) parentView {
    KKElement * p = [self parent];
    if([p isKindOfClass:[KKViewElement class]]) {
        return (KKViewElement *) p;
    }
    return nil;
}

-(KKViewElementAddViewFunction) addView {
    
    KKViewElementAddViewFunction func = objc_getAssociatedObject(self, "_addView");
    
    if(func == nil) {
        
        __weak KKElement * this = self;
        
        func = ^KKViewElement*(UIView * view) {
            
            KKViewElement * e = [KKViewElement elementWithView:view];
            
            [this appendViewElement:e];
            
            return e;
        };
        
        objc_setAssociatedObject(self, "_addView", func, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return func;
}

@end
