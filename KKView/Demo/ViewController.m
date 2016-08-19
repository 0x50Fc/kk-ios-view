//
//  ViewController.m
//  Demo
//
//  Created by zhanghailong on 16/8/19.
//  Copyright © 2016年 kkserver.cn. All rights reserved.
//

#import "ViewController.h"

#import <KKView/KKView.h>

@interface ViewController ()

@property(nonatomic,strong) KKElement * rootElement;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    self.rootElement = [KKViewElement elementWithView:self.view]
        .addLayout(KKLayoutElementTypeNone)
            .addTableView()
            .addCell(@"Cell",^UITableViewCell * (KKTableViewRowElement * element,UITableViewCell * cell){
                
                if(cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    cell.viewElement
                        .addLayout(KKLayoutElementTypeNone)
                            .addView([[UILabel alloc] init])
                            .outlet(@"title",@"text",nil)
                            .setWidth(KKElementValueMake(100, 0, KKElementValueUnitPX))
                            .setHeight(KKElementValueMake(100, 0, KKElementValueUnitPX))
                        .parentLayoutElement
                        .layout();
                }
                
                [cell.viewElement setOutletObject:element.object];
                
                return cell;
            })
            .addSection(nil)
                .addRow(@"Cell",@{@"title":@"title1"})
                .addRow(@"Cell",@{@"title":@"title2"})
                .addRow(@"Cell",@{@"title":@"title3"})
                .parentTableViewSection
            .parentTableView
            .reloadData()
            .setWidth(KKElementValueMake(100, 0, KKElementValueUnitPX))
            .setHeight(KKElementValueMake(100, 0, KKElementValueUnitPX))
            .parentLayoutElement
            .layout();
}

-(void) viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.rootElement.layout();
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
