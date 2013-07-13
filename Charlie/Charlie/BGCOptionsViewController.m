//
//  BGCOptionsViewController.m
//  Charlie
//
//  Created by Adam Gluck on 7/13/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCOptionsViewController.h"
#import "BGCMapViewController.h"

@interface BGCOptionsViewController ()
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (assign, nonatomic) NSInteger time;
@property (strong, nonatomic) IBOutlet UILabel *timeText;
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
    self.slider.value = 0.0;
    [self.slider addTarget:self action:@selector(sliderMove) forControlEvents:UIControlEventValueChanged];
    

    [self.slider setMinimumTrackImage:[UIImage imageNamed:@"minimage"] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageNamed:@"minimage"] forState:UIControlStateNormal];
    [self.slider setThumbImage:[UIImage imageNamed:@"cap"] forState:UIControlStateNormal];
}

-(void) sliderMove{
    
    NSLog(@"%f", self.slider.value * 100);
    NSInteger hour = [self hourScale:(self.slider.value * 100)];
    NSLog(@"%i", hour);
    NSString * formattedString;
    
    if (hour == 25 || hour == 24) hour = 23;
    
    if (hour < 9)
        formattedString = [NSString stringWithFormat:@"0%i:00", hour];
    else
        formattedString = [NSString stringWithFormat:@"%i:00", hour];
    
    self.timeText.text = formattedString;
    self.time = hour;
    
}

-(NSInteger) hourScale: (float) value{
 
    return (NSInteger) value / 4;
}

-(void) back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)suggestedRoute:(id)sender {
    
    int navigationNum = [self.navigationController.viewControllers count];
    
    BGCMapViewController * dst = self.navigationController.viewControllers[navigationNum - 2];
    dst.shouldBeRoute = YES;
    dst.shouldBeHeatMap = NO;
    dst.time = self.time;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)heatMap:(id)sender {
     int navigationNum = [self.navigationController.viewControllers count];
    
    BGCMapViewController * dst = self.navigationController.viewControllers[navigationNum - 2];
    dst.shouldBeRoute = NO;
    dst.shouldBeHeatMap = YES;
    dst.time = self.time;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
