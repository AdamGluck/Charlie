//
//  BGCTurnByTurnInstructions.h
//  Charlie
//
//  Created by Adam Gluck on 7/12/13.
//  Copyright (c) 2013 Charlie Corp (Team BGC). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol TurnByTurnInstructionDelegate <NSObject>

-(void) instructionFoundWithText: (NSString *) instruction;

@end

@interface BGCTurnByTurnInstructions : NSObject 

@property (strong, nonatomic) NSArray * steps;

-(void) stop;

@end
