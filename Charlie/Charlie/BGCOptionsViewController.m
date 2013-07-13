//
//  BGCOptionsViewController.m
//  Charlie
//
//  Created by Adam Gluck on 7/13/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCOptionsViewController.h"

@interface BGCOptionsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;

@end

@implementation BGCOptionsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureRightBarButtonItem];
    [self configureSlider];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:204.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]; // 204, 51, 51
}


-(void) configureRightBarButtonItem{
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"xbutton.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = 10;
    
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.rightBarButtonItems = [NSArray
                                              arrayWithObjects:negativeSpacer, rightButtonItem, nil];
    
    
}

-(void) configureSlider{
    
    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"minimage"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"minimage"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"cap"] forState:UIControlStateNormal];
}

-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
