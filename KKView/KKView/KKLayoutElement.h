//
//  KKLayoutElement.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <KKView/KKViewElement.h>
#import <KKView/KKElementValue.h>

typedef enum _KKLayoutElementType{
    KKLayoutElementTypeNone,
    KKLayoutElementTypeFlow,
    KKLayoutElementTypeFlowNowarp
} KKLayoutElementType;

@class KKLayoutElement;


@interface KKLayoutElement : KKElement

@property(nonatomic,assign) KKLayoutElementType layoutType;
@property(nonatomic,assign,readonly) CGSize contentSize;



@end

typedef KKLayoutElement * (^KKElementAddLayoutFunction)(KKLayoutElementType layoutType);
typedef KKElement * (^KKElementLayoutFunction)();

@interface KKElement(KKLayoutElement)

@property(nonatomic,strong,readonly) KKElementAddLayoutFunction addLayout;
@property(nonatomic,strong,readonly) KKLayoutElement * parentLayoutElement;
@property(nonatomic,strong,readonly) KKElementLayoutFunction layout;

-(void) layoutChildren ;

@end

