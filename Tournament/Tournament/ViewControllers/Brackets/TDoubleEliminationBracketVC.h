//
//  TDoubleEliminationBracketVC.h
//  Tournament
//
//  Created by Eugene Heckert on 6/22/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TTournamentBracketVC.h"

@interface TDoubleEliminationBracketVC : TTournamentBracketVC

@property (weak, nonatomic) IBOutlet UIView *tournamentInfoView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gameLabel;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewWidthConstraint;

@end
