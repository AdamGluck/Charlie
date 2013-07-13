//
//  BGCViewController.h
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGCMapViewController : UIViewController

@property (assign, nonatomic) NSInteger beat;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) BOOL shouldBeHeatMap;
@property (assign, nonatomic) BOOL shouldBeRoute;

@end
