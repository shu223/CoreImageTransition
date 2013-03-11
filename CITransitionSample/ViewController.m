//
//  ViewController.m
//  CITransitionSample
//
//  Created by shuichi on 13/03/10.
//  Copyright (c) 2013年 Shuichi Tsutsumi. All rights reserved.
//

#import "ViewController.h"
#import "TransitionView.h"


@interface ViewController ()
@property (nonatomic, weak) IBOutlet TransitionView *transitionView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.transitionView changeTransition:0];
    self.nameLabel.text = [self.transitionView currentFilterName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -------------------------------------------------------------------
#pragma mark Private

- (IBAction)segmentChanged:(UISegmentedControl *)sender {

    [self.transitionView changeTransition:sender.selectedSegmentIndex];
    
    self.nameLabel.text = [self.transitionView currentFilterName];
}

@end
