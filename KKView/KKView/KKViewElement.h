//
//  KKViewElement.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <KKView/KKElement.h>
#import <KKView/KKElementValue.h>

@class KKViewElement;

typedef void (^KKViewElementGetViewCBFunction)(UIView * view,KKViewElement * element);

typedef KKViewElement * (^KKViewElementGetViewFunction)(KKViewElementGetViewCBFunction);

typedef KKViewElement * (^KKViewElementSetValueFunction)(KKElementValue value);

typedef KKViewElement * (^KKViewElementSetEdgeFunction)(KKElementValue left,KKElementValue top,KKElementValue right,KKElementValue bottom);

@interface KKViewElement : KKElement

@property(nonatomic,strong) UIView * view;
@property(nonatomic,strong,readonly) KKViewElementGetViewFunction getView;

+(instancetype) elementWithView:(UIView *) view;

@property(nonatomic,assign) KKElementValue left;
@property(nonatomic,assign) KKElementValue top;
@property(nonatomic,assign) KKElementValue right;
@property(nonatomic,assign) KKElementValue bottom;
@property(nonatomic,assign) KKElementValue width;
@property(nonatomic,assign) KKElementValue height;
@property(nonatomic,assign) KKElementEdge padding;
@property(nonatomic,assign) KKElementEdge margin;

@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setLeft;
@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setTop;
@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setRight;
@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setBottom;
@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setWidth;
@property(nonatomic,strong,readonly) KKViewElementSetValueFunction setHeight;
@property(nonatomic,strong,readonly) KKViewElementSetEdgeFunction setPadding;
@property(nonatomic,strong,readonly) KKViewElementSetEdgeFunction setMargin;

@end

typedef KKViewElement * (^KKViewElementAddViewFunction)(UIView * view);


@interface KKElement(KKViewElement)

@property(nonatomic,strong,readonly) KKViewElementAddViewFunction addView;
@property(nonatomic,strong,readonly) KKViewElement * parentView;

-(void) appendViewElement:(KKViewElement *) element;

@end