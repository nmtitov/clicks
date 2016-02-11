//
//  ViewController.m
//  DoubleClick
//
//  Created by Nikita on 08/02/16.
//  Copyright © 2016 Nikita Mikhailovich Titov. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RACSignal *touch = [self.button rac_signalForControlEvents:UIControlEventTouchUpInside];
    RACSignal *touches = [[[touch takeUntil:[touch throttle:0.25]] collect] repeat];
    
    RACSignal *click = [[touches filter:^BOOL(NSArray *xs) {
        return xs.count == 1;
    }] mapReplace:@"Click"];

    RACSignal *clicks = [[touches filter:^BOOL(NSArray *xs) {
        return xs.count >= 2;
    }] map:^id(NSArray *xs) {
        return [NSString stringWithFormat:@"Clicks: %lu", (long unsigned)xs.count];
    }];

    RACSignal *clear = [[touches throttle:1] mapReplace:nil];
    
    RAC(self.label, text) = [RACSignal merge:@[click, clicks, clear]];
}

@end
