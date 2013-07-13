//
//  BGCTurnByTurnInstructions.m
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import "BGCTurnByTurnInstructions.h"

@interface BGCTurnByTurnInstructions()

@property (strong, nonatomic) CLLocationManager * manager;

@end

@implementation BGCTurnByTurnInstructions

-(BGCTurnByTurnInstructions *) initWithSteps: (NSArray *) steps andShouldStart: (BOOL) starts{
    self = [super init];
    
    if (self){
        self.steps = [steps copy];
        
        if (starts)
            [self start];
    }
    
    return self;
}

-(void) start {
    
}
-(void) stop {
    
}

@end
