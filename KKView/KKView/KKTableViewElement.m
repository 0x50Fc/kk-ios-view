//
//  KKTableViewElement.m
//  KKView
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "KKTableViewElement.h"

#include <objc/runtime.h>

@implementation KKTableViewRowElement

-(instancetype) init {
    if((self = [super init])) {
        
        __weak KKTableViewRowElement * this = self;
        
        _addRow = ^KKTableViewRowElement *(NSString * reuseIdentity,id object) {
            
            KKTableViewRowElement * e = [[KKTableViewRowElement alloc] init];
            
            e.reuseIdentity = reuseIdentity;
            e.object = object;
            
            [this.parentTableViewSection append:e];
            
            return e;
        };
        
    }
    return self;
}

@end

@interface KKTableViewSectionElement() {
     NSMutableArray * _rows;
}

@end

@implementation KKTableViewSectionElement

@synthesize title = _title;
@synthesize addRow = _addRow;

-(instancetype) init {
    if((self = [super init])) {
        _rows = [[NSMutableArray alloc] initWithCapacity:4];
        
        __weak KKTableViewSectionElement * this = self;
        
        _addRow = ^KKTableViewRowElement *(NSString * reuseIdentity,id object) {
            
            KKTableViewRowElement * e = [[KKTableViewRowElement alloc] init];
            
            e.reuseIdentity = reuseIdentity;
            e.object = object;
            
            [this append:e];
            
            return e;
        };
        
    }
    return self;
}

-(NSInteger) numberOfRows {
    return [_rows count];
}

-(KKTableViewRowElement *) rowElementAtIndex:(NSInteger)index {
    if(index >=0 && index < [_rows count]) {
        return [_rows objectAtIndex:index];
    }
    return nil;
}

-(void) append:(KKElement *)element {
    [super append:element];
    if([element isKindOfClass:[KKTableViewRowElement class]]) {
        [_rows addObject:element];
    }
}

-(void) didRemovedChild:(KKElement *)element {
    [super didRemovedChild:element];
    if([element isKindOfClass:[KKTableViewRowElement class]]) {
        [_rows removeObject:element];
    }
}

@end

@interface KKTableViewElement() {
    NSMutableDictionary * _cells;
    NSMutableArray * _sections;
}

-(void) setCell:(KKTableViewElementCellLoadFunction) load reuseIdentity:(NSString *) reuseIdentity;

-(void) _reloadData;

@end

@implementation KKTableViewElement

-(UITableView *) tableView {
    return (UITableView *) self.view;
}


@synthesize addCell = _addCell;
@synthesize addSection = _addSection;
@synthesize reloadData = _reloadData;

-(instancetype) init {
    
    if((self = [super init])) {
        
        _cells = [[NSMutableDictionary alloc] initWithCapacity:4];
        _sections = [[NSMutableArray alloc] initWithCapacity:4];
        
        __weak KKTableViewElement * this = self;
        
        _addCell = ^KKTableViewElement*(NSString * reuseIdentity,KKTableViewElementCellLoadFunction load) {
            
            if(this) {
                [this setCell:load reuseIdentity:reuseIdentity];
            }
            
            return this;
        };
        
        _addSection =^KKTableViewSectionElement*(NSString * title) {
            
            KKTableViewSectionElement * e = [[KKTableViewSectionElement alloc] init];
            
            e.title = title;
            
            [this append:e];
            
            return e;
        };
        
        _reloadData = ^KKTableViewElement*() {
            
            [this _reloadData];
            return this;
        };
    }
    
    return self;
}

-(void) setCell:(KKTableViewElementCellLoadFunction) load reuseIdentity:(NSString *) reuseIdentity {
    [_cells setValue:load forKey:reuseIdentity];
}

-(void) append:(KKElement *)element {
    [super append:element];
    [_sections addObject:element];
}

-(void) didRemovedChild:(KKElement *) element {
    if([element isKindOfClass:[KKTableViewSectionElement class]]) {
        [_sections removeObject:element];
    }
    [super didRemovedChild:element];
}

-(void) _reloadData {
    [self.tableView reloadData];
}

-(KKTableViewSectionElement *) sectionElementByIndex:(NSInteger) index {
    if(index < [_sections count]) {
        return [_sections objectAtIndex:index];
    }
    return nil;
}

-(KKTableViewRowElement *) rowElementAtIndexPath:(NSIndexPath *) indexPath {
    return [[_sections objectAtIndex:indexPath.section] rowElementAtIndex:indexPath.row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section < [_sections count]) {
        return [[_sections objectAtIndex:section] numberOfRows];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KKTableViewRowElement * row = [self rowElementAtIndexPath:indexPath];
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:row.reuseIdentity];
    
    KKTableViewElementCellLoadFunction fn = [_cells valueForKey:row.reuseIdentity];
   
    return fn(row,cell);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sections count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionElementByIndex:section] title];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self rowElementAtIndexPath:indexPath] canEdit];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[self rowElementAtIndexPath:indexPath] canMove];
}

// Index

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
}

@end

@implementation KKElement(KKTableViewElement)

-(KKTableViewElement *) parentTableView {
    KKElement * p = [self parent];
    if([p isKindOfClass:[KKTableViewElement class]]) {
        return (KKTableViewElement *) p;
    }
    return nil;
}

-(KKTableViewSectionElement *) parentTableViewSection {
    KKElement * p = [self parent];
    if([p isKindOfClass:[KKTableViewSectionElement class]]) {
        return (KKTableViewSectionElement *) p;
    }
    return nil;
}

-(KKTableViewRowElement *) parentTableViewRow {
    KKElement * p = [self parent];
    if([p isKindOfClass:[KKTableViewRowElement class]]) {
        return (KKTableViewRowElement *) p;
    }
    return nil;
}

-(KKViewElementAddTableViewFunction) addTableView {
    
    KKViewElementAddTableViewFunction func = objc_getAssociatedObject(self, "_addTableView");
    
    if(func == nil) {
        
        __weak KKElement * this = self;
        
        func = ^KKTableViewElement*() {
            
            UITableView * v = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            
            KKTableViewElement * e = [KKTableViewElement elementWithView:v];
            
            [v setDelegate:e];
            [v setDataSource:e];
            
            [this appendViewElement:e];
            
            return e;
        };
        
        objc_setAssociatedObject(self, "_addTableView", func, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    return func;
}


@end


@implementation UITableViewCell(KKTableViewElement)

-(KKViewElement *) viewElement {
    
    KKViewElement * e = objc_getAssociatedObject(self, "_viewElement");
    
    if(e == nil) {
        e = [KKViewElement elementWithView:self.contentView];
        objc_setAssociatedObject(self, "_viewElement", e, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return e;
}

@end
