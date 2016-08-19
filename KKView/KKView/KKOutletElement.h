//
//  KKOutletElement.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <KKView/KKViewElement.h>


@class KKOutletElement;

typedef id (^KKOutletElementValueFunction)(id value);

@interface KKOutletElement : KKElement

@property(nonatomic,strong) NSString * fromKeyPath;
@property(nonatomic,strong) NSString * toKeyPath;
@property(nonatomic,strong) KKOutletElementValueFunction valueFunction;

@end


typedef KKViewElement * (^KKElementAddOutletFunction)(NSString * fromKeyPath,NSString * toKeyPath,KKOutletElementValueFunction valueFunction);


@interface KKViewElement(KKOutletElement)

@property(nonatomic,strong,readonly) KKElementAddOutletFunction outlet;

-(void) setOutletObject:(id) object;

@end