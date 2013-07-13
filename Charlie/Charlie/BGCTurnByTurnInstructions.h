//
//  BGCTurnByTurnInstructions.h
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>

@protocol TurnByTurnInstructionsDelegate <NSObject>

@optional
-(void) currentStepPolyline: (GMSPolyline *) polyline;
-(void) lastStepPolyline: (GMSPolyline *) polyline;

@end

@interface BGCTurnByTurnInstructions : NSObject 

@property (strong, nonatomic) NSArray * steps;
@property (strong, nonatomic) NSString * currentStep;
@property (weak, nonatomic) id <TurnByTurnInstructionsDelegate> delegate;
@property (strong, nonatomic) GMSPolyline * stepPolyline;

-(NSString *) next;
-(NSString *) last;
-(NSString *) stepAtIndex: (NSInteger) index;

-(BGCTurnByTurnInstructions *) initWithSteps: (NSArray *) steps;

@end
