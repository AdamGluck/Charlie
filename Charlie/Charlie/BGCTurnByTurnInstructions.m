//
//  BGCTurnByTurnInstructions.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCTurnByTurnInstructions.h"
#import "GoogleRoute.h"

@interface BGCTurnByTurnInstructions() <GoogleRouteDelegate>

@property (assign, nonatomic) NSInteger step;


@end

@implementation BGCTurnByTurnInstructions


-(BGCTurnByTurnInstructions *) initWithSteps: (NSArray *) steps{
    self = [super init];
    
    if (self){
        
        NSAssert([steps count], @"Steps must be filled");
        
        self.steps = [steps copy];
        self.step = 0;
        
        NSLog(@"%@", self.steps);
    }
    
    return self;
}

-(NSString *) stepAtIndex:(NSInteger)index{
    
    NSString * html_instruction = (NSString *)self.steps[index][@"html_instructions"];
    
    return [self stringByStrippingHTML:html_instruction];
}

-(NSString *) next {
    
    NSAssert(self.steps, @"Steps must be set");

    self.step++;
    
    if (self.step >= [self.steps count])
        self.step = 0;
    
    
    [self grabRouteForStepIndex:self.step];
    
    self.currentStep = [self stepAtIndex:self.step];
    
    return self.currentStep;
}

-(NSString *) last {
    NSAssert(self.steps, @"Steps must be set");

    self.step--;
    
    if (self.step < 0)
        self.step = [self.steps count] - 1;
    
    self.currentStep = [self stepAtIndex:self.step];

    return self.currentStep;
}

#pragma mark - utility method

-(NSString *) stringByStrippingHTML: (NSString *) string {
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    return string;
}

#pragma mark - lazy instantiation

-(NSString *) currentStep{
    
    if (!_currentStep){
        _currentStep = [[NSString alloc] init];
    }
    
    return _currentStep;
}

-(NSArray *) steps{
    if (!_steps){
        _steps = [[NSArray alloc] init];
    }
    
    return _steps;
}

-(GMSPolyline *) stepPolyline{
    
    if (!_stepPolyline){
        _stepPolyline = [[GMSPolyline alloc] init];
    }
    
    return _stepPolyline;
}

#pragma mark - Google Route implementation

-(void) grabRouteForStepIndex: (NSInteger) step{
    
    NSString * startLocation = [NSString stringWithFormat:@"%f,%f", ((NSString *)self.steps[step][@"start_location"][@"lat"]).doubleValue, ((NSString *) self.steps[step][@"start_location"][@"lng"]).doubleValue];
    NSString * endLocation = [NSString stringWithFormat:@"%f,%f", ((NSString *)self.steps[step][@"end_location"][@"lat"]).doubleValue, ((NSString *)self.steps[step][@"end_location"][@"lng"]).doubleValue];
    
    GoogleRoute * route = [[GoogleRoute alloc] initWithWaypoints:@[startLocation, endLocation] sensorStatus:YES andDelegate:self];
    [route goWithTransportationType:kTransportationTypeDriving];
    
}

-(void) routeWithPolyline: (GMSPolyline *) polyline{
    
    if ([self.delegate respondsToSelector:@selector(currentStepPolyline:)])
        [self.delegate currentStepPolyline:polyline];
    
    self.stepPolyline = polyline;
}


@end
