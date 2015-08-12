//
//  CharController.m
//  DChar
//
//  Created by iMuse on 15-8-5.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "CharController.h"
#import "lineController.h"

@interface CharController ()
{
    NSArray * array;
}

@end

@implementation CharController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array = @[@"折线图",@"柱状图"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   

  
    UITableView * table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return   [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * idfiner = @"charCell";
    
      UITableViewCell*  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idfiner];
    cell.textLabel.text = [array objectAtIndex:[indexPath row]];
        

    
    return  cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    lineController * line = [[lineController alloc] init];
    [self.navigationController pushViewController:line animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
}


-(BOOL)shouldAutorotate
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation==UIInterfaceOrientationPortrait;
}



@end
