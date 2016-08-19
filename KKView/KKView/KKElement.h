//
//  KKElement.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKElement;

typedef void (^KKElementCBFunction)(KKElement * element);

typedef KKElement * (^KKElementGetFunction)(KKElementCBFunction);


@interface KKElement : NSObject

@property(nonatomic,strong,readonly) KKElementGetFunction get;

@property(nonatomic,weak) KKElement * parent;
@property(nonatomic,strong) KKElement * firstChild;
@property(nonatomic,strong) KKElement * lastChild;
@property(nonatomic,strong) KKElement * nextSibling;
@property(nonatomic,weak) KKElement * prevSibling;
@property(nonatomic,readonly) NSArray * children;

-(void) append:(KKElement *) element;

-(void) appendTo:(KKElement *) element;

-(void) remove;

-(void) didRemovedChild:(KKElement *) element;

-(void) before:(KKElement *) element;

-(void) beforeTo:(KKElement *) element;

-(void) after:(KKElement *) element;

-(void) afterTo:(KKElement *) element;

@end
