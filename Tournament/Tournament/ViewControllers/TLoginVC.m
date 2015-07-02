//
//  TLoginVC.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TLoginVC.h"
#import "User.h"
#import "TRegisterUserVC.h"

@interface TLoginVC ()

@property (strong, nonatomic) NSArray* localUserList;
@property (strong, nonatomic) User* selectedUser;

@end

@implementation TLoginVC

- (id) init
{
    self = [super init];
    
    if (self)
    {
        // Custom initialization
        
        //        self.navigationItem.title = @"YOUR DETAILS";
        
        [[NSBundle mainBundle] loadNibNamed:@"TLoginVC" owner:self options:nil];
    }
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([TNetworkManager sharedInstance].user)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (BOOL) validateUserInformation
{
    if(self.usernameTextField.text.length <= 0)
    {
        return NO;
    }
    
    if(self.passwordTextField.text.length < 6)
    {
        return NO;
    }
    
    return YES;
}

- (IBAction)onLoginAction:(id)sender
{
    if([self validateUserInformation])
    {
        [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                                // Do stuff after successful login.
                                                
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                                
                                            }
                                            else
                                            {
                                                // The login failed. Check error to see why.
                                                
                                                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.description preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"OK"
                                                                                                       style:UIAlertActionStyleDefault
                                                                                                     handler:^(UIAlertAction *action)
                                                                               {
                                                                               }];
                                                
                                                [alert addAction:deleteAction];
                                                
                                                [self presentViewController:alert animated:YES completion:nil];
                                            }
                                        }];
    }
}

- (IBAction)onSignUpAction:(id)sender
{
    TRegisterUserVC* registerVC = [[TRegisterUserVC alloc] initWithNibName:@"TRegisterUserVC" bundle:nil];
    
    [self presentViewController:registerVC animated:YES completion:nil];
}

@end
