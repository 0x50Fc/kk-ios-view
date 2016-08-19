//
//  KKTableViewElement.h
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import <KKView/KKViewElement.h>

@class KKTableViewSectionElement,KKTableViewRowElement,KKTableViewElement;

typedef KKTableViewRowElement * (^KKTableViewSectionElementAddRowFunction)(NSString * reuseIdentity,id object);

@interface KKTableViewSectionElement : KKElement

@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong,readonly) KKTableViewSectionElementAddRowFunction addRow;
@property(nonatomic,readonly,assign) NSInteger numberOfRows;

-(KKTableViewRowElement *) rowElementAtIndex:(NSInteger) index;

@end


@interface KKTableViewRowElement : KKElement

@property(nonatomic,strong) NSString * reuseIdentity;
@property(nonatomic,strong) id object;
@property(nonatomic,readonly,assign) BOOL canEdit;
@property(nonatomic,readonly,assign) BOOL canMove;

@property(nonatomic,strong,readonly) KKTableViewSectionElementAddRowFunction addRow;

@end


typedef UITableViewCell * (^KKTableViewElementCellLoadFunction)(KKTableViewRowElement * element,UITableViewCell * cell);

typedef KKTableViewElement * (^KKTableViewElementAddCellFunction)(NSString * reuseIdentity
                                                                  ,KKTableViewElementCellLoadFunction load);
typedef KKTableViewSectionElement * (^KKTableViewElementAddSectionFunction)(NSString * title);
typedef KKTableViewElement * (^KKTableViewElementReloadDataFunction)();

@interface KKTableViewElement : KKViewElement<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong,readonly) UITableView * tableView;
@property(nonatomic,strong,readonly) KKTableViewElementAddCellFunction addCell;
@property(nonatomic,strong,readonly) KKTableViewElementAddSectionFunction addSection;
@property(nonatomic,strong,readonly) KKTableViewElementReloadDataFunction reloadData;
@property(nonatomic,strong,readonly) NSArray * sectionIndexTitles;

@end


typedef KKTableViewElement * (^KKViewElementAddTableViewFunction)();

@interface KKElement(KKTableViewElement)

@property(nonatomic,strong,readonly) KKViewElementAddTableViewFunction addTableView;
@property(nonatomic,strong,readonly) KKTableViewElement * parentTableView;
@property(nonatomic,strong,readonly) KKTableViewSectionElement * parentTableViewSection;
@property(nonatomic,strong,readonly) KKTableViewRowElement * parentTableViewRow;

@end


@interface UITableViewCell(KKTableViewElement)

@property(nonatomic,strong,readonly) KKViewElement * viewElement;

@end
