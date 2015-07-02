//
//  TTournamentBracketVC.m
//  Tournament
//
//  Created by Eugene Heckert on 6/18/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TTournamentBracketVC.h"


@interface TTournamentBracketVC ()

@end


@implementation TTournamentBracketVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTournament:(Tournament *)tour
{
    _selectedTournament = tour;
}

@end
