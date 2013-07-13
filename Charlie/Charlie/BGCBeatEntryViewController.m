//
//  BGCBeatEntryViewController.m
//  Charlie
//
//  Created by Adam Gluck on 7/13/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCBeatEntryViewController.h"
#import "BGCMapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BGCBeatEntryViewController () <UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *numberField;

@end

@implementation BGCBeatEntryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self configureView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

-(void) backgroundTapped{
    [self.view endEditing:YES];
    

}




-(void) configureView{
    
    CAGradientLayer * gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.frame;
    gradient.colors =  @[(id)[[UIColor colorWithRed: 255.0/255.0 green: 255.0/255.0 blue: 255.0/255.0 alpha: 1.0f] CGColor],
                         (id)[[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:214.0/255.0 alpha:1.0f] CGColor]];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    BGCMapViewController * dest = (BGCMapViewController *) segue.destinationViewController;
    dest.beat = self.numberField.text.integerValue;
    dest.shouldBeHeatMap = NO;
    dest.shouldBeRoute = YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
