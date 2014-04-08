//
//  PTUIKitAdditionsDemoViewController.m
//  Demo
//
//  Created by Ryne Cheow on 3/23/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "PTUIKitAdditionsDemoViewController.h"
#import <PTUIKitAdditions/PTUIKitAdditions.h>

@interface PTUIKitAdditionsDemoViewController ()
{
@private
    UIColor *_originalColor;
}
@end

@implementation PTUIKitAdditionsDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[@"ffffff" toColor]];
    _originalColor = [[self sampleColorView] backgroundColor];
    self.hexStringTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)lightenSliderChanged:(UISlider*)sender
{
    [[self sampleColorView] setBackgroundColor:[_originalColor lightenColorByValue:sender.value]];
}

- (IBAction)darkenSliderChanged:(UISlider*)sender
{
    [[self sampleColorView] setBackgroundColor:[_originalColor darkenColorByValue:sender.value]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.sampleColorView setBackgroundColor:[textField.text toColor]];
    _originalColor = [[self sampleColorView] backgroundColor];
    return YES;
}



@end
