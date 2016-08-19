//
//  KKElement.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKElement.h"

@implementation KKElement

-(instancetype) init {
    if((self = [super init])) {
        __weak KKElement * this = self;
        _get = ^KKElement*(KKElementCBFunction cb) {
            if(this && cb) {
                cb(this);
            }
            return this;
        };
    }
    return self;
}

// 添加子节点 element
-(void) append:(KKElement *) element {
    
    if(element == nil) {
        return;
    }
    
    [element remove];
    
    if(_lastChild) {
        _lastChild->_nextSibling = element;
        element->_prevSibling = _lastChild;
        _lastChild = element;
    }
    else {
        _firstChild = element;
        _lastChild = element;
    }
    
    element->_parent = self;
}

// 作为子节点添加到 element
-(void) appendTo:(KKElement *) element {
    
    if(element == nil) {
        return;
    }
    
    [element append:self];
    
    return;
}

// 将 element 添加到当前节点上面
-(void) before:(KKElement *) element {
    
    if(element == nil) {
        return;
    }
    
    [element remove];
    
    if(_parent) {
        
        element->_parent = _parent;
        
        if(_prevSibling) {
            _prevSibling->_nextSibling = element;
            element->_prevSibling = _prevSibling;
            element->_nextSibling = self;
            _prevSibling = element;
        }
        else {
            _parent->_firstChild = element;
            element->_nextSibling = self;
            _prevSibling = element;
        }
        
    }
}

// 将当前节点添加到 element 上面
-(void) beforeTo:(KKElement *) element {
    
    if(element == nil) {
        return ;
    }
    
    [element before:self];
    
}

// 将 element 添加到当前节点下面
-(void) after:(KKElement *) element {
    
    if(element == nil) {
        return;
    }
    
    [element remove];
    
    if(_parent) {
        
        element->_parent = _parent;
        
        if(_nextSibling) {
            element->_nextSibling = _nextSibling;
            element->_prevSibling = self;
            _nextSibling->_prevSibling = element;
            _nextSibling = element;
        }
        else {
            _parent->_lastChild = element;
            element->_prevSibling = self;
            _nextSibling = element;
        }
    
    }
    
}

// 将当前节点添加到 element 下面
-(void) afterTo:(KKElement *) element {
    
    if(element == nil) {
        return;
    }
    
    [element after:self];

}

// 从父级节点中移除
-(void) remove {

    __strong KKElement * p = _parent;
    __strong KKElement * el = self;
    
    if(_prevSibling) {
        
        _prevSibling->_nextSibling = _nextSibling;
        
        if(_nextSibling){
            _nextSibling->_prevSibling = _prevSibling;
        }
        else if(_parent) {
            _parent->_lastChild = _prevSibling;
        }
        
    }
    else if(_parent) {
        _parent->_firstChild = _nextSibling;
        if(_nextSibling) {
            _nextSibling->_prevSibling = nil;
        }
        else {
            _parent->_lastChild = _nextSibling;
        }
    }
    
    _parent = nil;
    _nextSibling = nil;
    _prevSibling = nil;
    
    [p didRemovedChild:el];
    
}

-(void) didRemovedChild:(KKElement *) element {
    
}

-(NSArray *) children {
    NSMutableArray * v = [NSMutableArray arrayWithCapacity:4];
    KKElement * p = _firstChild;
    while(p != nil) {
        [v addObject:p];
        p = p.nextSibling;
    }
    return v;
}


@end
