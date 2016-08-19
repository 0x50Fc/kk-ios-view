//
//  KKLayoutElement.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKLayoutElement.h"

#include <objc/runtime.h>

@implementation KKLayoutElement

@synthesize layoutType = _layoutType;
@synthesize contentSize = _contentSize;

-(void) elementLayoutChildren:(KKViewElement *) element {
    
    KKElement * p = element.firstChild;
    
    while(p) {
        
        if([p isKindOfClass:[KKLayoutElement class]]) {
            [(KKLayoutElement * )p layoutChildren];
        }
        
        p = p.nextSibling;
    }
    
}

-(void) layoutChildren  {
    
    KKViewElement * p = [self parentView];
    
    if(p != nil && p.view != nil) {
        
        KKElementEdge padding = p.padding;
        
        CGRect bounds = p.view.bounds;
        
        CGFloat paddingLeft = KKElementValueToCGFloat(padding.left,bounds.size.width);
        CGFloat paddingTop = KKElementValueToCGFloat(padding.top,bounds.size.height);
        CGFloat paddingRight = KKElementValueToCGFloat(padding.right,bounds.size.width);
        CGFloat paddingBottom = KKElementValueToCGFloat(padding.bottom,bounds.size.height);
        
        if(p.width.unit == KKElementValueUnitAuto) {
            bounds.size.width = MAXFLOAT;
        }
        
        if(p.height.unit == KKElementValueUnitAuto) {
            bounds.size.height = MAXFLOAT;
        }
        
        if(_layoutType == KKLayoutElementTypeFlow || _layoutType == KKLayoutElementTypeFlowNowarp) {
            
            CGFloat x = paddingLeft;
            CGFloat y = paddingTop;
            CGFloat lineHeight = 0;
            CGFloat maxWidth = paddingLeft + paddingRight;
            
            KKElement * el = self.firstChild;
            
            while(el) {
                
                if([el isKindOfClass:[KKViewElement class]]) {
                    
                    KKViewElement * viewElement = (KKViewElement *) el;
                    
                    CGRect b = viewElement.view.bounds;
                    
                    if(viewElement.width.unit != KKElementValueUnitAuto) {
                        b.size.width = KKElementValueToCGFloat(viewElement.width,bounds.size.width - paddingLeft - paddingRight);
                    }
                    
                    if(viewElement.height.unit != KKElementValueUnitAuto) {
                        b.size.height = KKElementValueToCGFloat(viewElement.height,bounds.size.height - paddingBottom - paddingBottom);
                    }
                    
                    viewElement.view.bounds = b;
                    
                    [self elementLayoutChildren:viewElement];
                    
                    KKElementEdge margin = viewElement.margin;
                    
                    CGRect r = [viewElement.view frame];
                    
                    CGFloat marginLeft = KKElementValueToCGFloat(margin.left,r.size.width);
                    CGFloat marginTop = KKElementValueToCGFloat(margin.top,r.size.height);
                    CGFloat marginRight = KKElementValueToCGFloat(margin.right,r.size.width);
                    CGFloat marginBottom = KKElementValueToCGFloat(margin.bottom,r.size.height);
                    
                    if(_layoutType != KKLayoutElementTypeFlowNowarp
                       && x + marginLeft + marginRight + paddingRight > bounds.size.width) {
                        y += lineHeight;
                        x = paddingLeft;
                    }
                    
                    r.origin.x = x + marginLeft;
                    r.origin.y = y + marginTop;
                    
                    x += marginLeft + marginRight + r.size.width;
                    
                    if(lineHeight< r.size.height + marginTop + marginBottom) {
                        lineHeight = r.size.height + marginTop + marginBottom;
                    }
                    
                    if(maxWidth < x + paddingRight) {
                        maxWidth = x + paddingRight;
                    }
                    
                }
                
                el = el.nextSibling;
            }
            
            _contentSize.width = maxWidth;
            _contentSize.height = y + lineHeight + paddingBottom;
            
            
        } else {
            
            _contentSize.width = paddingLeft + paddingRight;
            _contentSize.height = paddingTop + paddingBottom;
            
            KKElement * el = self.firstChild;
            
            while(el) {
                
                if([el isKindOfClass:[KKViewElement class]]) {
                    
                    KKViewElement * viewElement = (KKViewElement *) el;
                    
                    CGRect b = viewElement.view.bounds;
                    
                    if(viewElement.width.unit != KKElementValueUnitAuto) {
                        b.size.width = KKElementValueToCGFloat(viewElement.width,bounds.size.width - paddingLeft - paddingRight);
                    }
                    
                    if(viewElement.height.unit != KKElementValueUnitAuto) {
                        b.size.height = KKElementValueToCGFloat(viewElement.height,bounds.size.height - paddingBottom - paddingBottom);
                    }
                    
                    viewElement.view.bounds = b;
                    
                    [self elementLayoutChildren:viewElement];
                    
                    CGRect r = [viewElement.view frame];
                    
                    if(viewElement.left.unit == KKElementValueUnitAuto) {
                        if(viewElement.right.unit == KKElementValueUnitAuto) {
                            r.origin.x = paddingLeft + (bounds.size.width - paddingLeft - paddingRight) * 0.5;
                        }
                        else {
                            r.origin.x = bounds.size.width - paddingRight - r.size.width -KKElementValueToCGFloat(viewElement.right,bounds.size.width - paddingLeft - paddingRight);
                        }
                    }
                    else {
                        r.origin.x = paddingLeft + KKElementValueToCGFloat(viewElement.left,bounds.size.width - paddingLeft - paddingRight);
                    }
                    
                    if(viewElement.top.unit == KKElementValueUnitAuto) {
                        if(viewElement.bottom.unit == KKElementValueUnitAuto) {
                            r.origin.y = paddingTop + (bounds.size.height - paddingTop - paddingBottom) * 0.5;
                        }
                        else {
                            r.origin.y = bounds.size.height - paddingTop
                            - r.size.height -KKElementValueToCGFloat(viewElement.bottom,bounds.size.height - paddingTop - paddingBottom);
                        }
                    }
                    else {
                        r.origin.y = paddingTop + KKElementValueToCGFloat(viewElement.top
                                                                          ,bounds.size.height - paddingTop - paddingBottom);
                    }
                    
                    viewElement.view.frame = r;
                    
                    if(r.origin.x + r.size.width + paddingRight > _contentSize.width) {
                        _contentSize.width = r.origin.x + r.size.width + paddingRight;
                    }
                    
                    if(r.origin.y + r.size.height + paddingBottom > _contentSize.height) {
                        _contentSize.height = r.origin.y + r.size.height + paddingBottom;
                    }
                    
                }
                
                el = el.nextSibling;
            }
            
        }
        
        if(p.width.unit == KKElementValueUnitAuto) {
            bounds.size.width = _contentSize.width;
        }
        
        if(p.height.unit == KKElementValueUnitAuto) {
            bounds.size.height = _contentSize.height;
        }
        
        p.view.bounds = bounds;
        
    }
    
}

@end

@implementation KKElement(KKLayoutElement)

-(KKElementAddLayoutFunction) addLayout {
    KKElementAddLayoutFunction fn = objc_getAssociatedObject(self, "_addLayout");
    if(fn == nil) {
        __weak KKElement * this = self;
        fn = ^KKLayoutElement *(KKLayoutElementType layoutType) {
            KKLayoutElement * e = [[KKLayoutElement alloc] init];
            e.layoutType = layoutType;
            [this append:e];
            return e;
        };
    }
    return fn;
}

-(KKLayoutElement *) parentLayoutElement {
    KKElement * p = self.parent;
    if([p isKindOfClass:[KKLayoutElement class]] ) {
        return (KKLayoutElement *) p;
    }
    return nil;
}

-(KKElementLayoutFunction) layout {
    KKElementLayoutFunction fn = objc_getAssociatedObject(self, "_layout");
    if(fn == nil) {
        __weak KKElement * this = self;
        fn = ^KKElement*() {
            [this layoutChildren];
            return this;
        };
    }
    return fn;
}

-(void) layoutChildren  {
    
    KKElement * p = self.firstChild;
    
    while(p) {
        
        [p layoutChildren];
        
        p = p.nextSibling;
    }
    
}

@end


