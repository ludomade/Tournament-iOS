//
//  SecondViewController.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "SecondViewController.h"
#import <Parse/Parse.h>
#import "User.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)onImportAction:(id)sender
{
    if([TNetworkManager sharedInstance].user.challongeAPIKey)
    {
        [[[TNetworkManager sharedInstance] importChallongeTournaments] subscribeError:^(NSError *error) {
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                           }];
            
            [alert addAction:deleteAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } completed:^{
            
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"All tournament information has been imported." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *action)
                                           {
                                           }];
            
            [alert addAction:deleteAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
    }
    
}

@end
