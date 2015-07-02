//
//  TSingleEliminationBracketVCViewController.m
//  Tournament
//
//  Created by Eugene Heckert on 6/19/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TSingleEliminationBracketVC.h"
#import "Tournament.h"
#import "Match.h"
#import "TRoundHeaderView.h"

#define X_POS_DEFAULT_VALUE     30.0
#define Y_POS_DEFAULT_VALUE     30.0

#define LINE_THICKNESS_VALUE    3.0

@interface TSingleEliminationBracketVC ()

@property(nonatomic, strong) NSMutableDictionary* matchViews;

@end

@implementation TSingleEliminationBracketVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.selectedTournament.name;
    
    self.typeLabel.text = [NSString stringWithFormat:@"%i player %@", self.selectedTournament.participantsCount, self.selectedTournament.tournamentType];
    
    if(self.selectedTournament.gameName.length > 0)
    {
        self.gameLabel.text = self.selectedTournament.gameName;
    }
    else
    {
        self.gameLabel.text = @"Unspecified game";
    }
    
    self.contentViewHeightConstraint.constant = self.view.frame.size.height - self.tournamentInfoView.frame.size.height;
    self.contentViewWidthConstraint.constant = self.view.frame.size.width;
    
    [self.scrollView setMaximumZoomScale:4.0f];
    [self.scrollView setMinimumZoomScale:0.25f];
    
    self.matchViews = [NSMutableDictionary new];
    
    [self buildTournamentBrackets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [[TActivityIndicator sharedInstance] removeActivityIndicator];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.selectedTournament saveTournament];
}

- (void) buildTournamentBrackets
{
    CGFloat xPos = X_POS_DEFAULT_VALUE;
    CGFloat yPos = Y_POS_DEFAULT_VALUE;
    int lastGoodMatch = 0;
    
    for(int i = 1; i <= self.selectedTournament.maxNumberRounds; i++)
    {
        TRoundHeaderView* headerView = [TRoundHeaderView new];
        
        [headerView setFrame:(CGRect){{xPos, yPos}, headerView.frame.size}];
        
        if(i == self.selectedTournament.maxNumberRounds)
        {
            headerView.headerLabel.text = @"Finals";
        }
        else
        if(i == (self.selectedTournament.maxNumberRounds-1))
        {
            headerView.headerLabel.text = @"Semifinals";
        }
        else
        {
            headerView.headerLabel.text = [NSString stringWithFormat:@"Round %i", i];
        }
        
        [self.contentView addSubview:headerView];
        
        yPos += (headerView.frame.size.height + Y_POS_DEFAULT_VALUE);
        
        for(int j = lastGoodMatch; j < [self.selectedTournament.tournamentMatches count];j++)
        {
            Match* match = self.selectedTournament.tournamentMatches[j];
            
            if(match.round == i)
            {
                TMatchView* matchView = [TMatchView new];
                
                [matchView setFrame:(CGRect){{xPos, yPos}, matchView.frame.size}];
                
                if(match.round != 1)
                {
                    TMatchView* playerOnePreredMatch = nil;
                    TMatchView* playerTwoPreredMatch = nil;
                    
                    if(match.playerOnePreReqMatchID)
                    {
                        playerOnePreredMatch = [self.matchViews objectForKey:match.playerOnePreReqMatchID];
                    }
                    
                    if(match.playerTwoPreReqMatchID)
                    {
                        playerTwoPreredMatch = [self.matchViews objectForKey:match.playerTwoPreReqMatchID];
                    }
                    
                    if(playerOnePreredMatch && playerTwoPreredMatch)
                    {
                        CGFloat playerOneCenterY = playerOnePreredMatch.center.y;
                        CGFloat playerTwoCenterY = playerTwoPreredMatch.center.y;
                        
                        [matchView setCenter:(CGPoint){matchView.center.x, ((playerOneCenterY + playerTwoCenterY)/2)}];
                        
                        
                        CGFloat matchOneStartingXPos = ((playerOnePreredMatch.frame.origin.x + playerOnePreredMatch.frame.size.width));
                        
                        //Match one right line
                        UIBezierPath* playerOneRightPath = [UIBezierPath bezierPath];
                        
                        [playerOneRightPath moveToPoint:(CGPoint){matchOneStartingXPos, playerOnePreredMatch.center.y}];
                        
                        [playerOneRightPath addLineToPoint:(CGPoint){(((matchOneStartingXPos + xPos) / 2 )), playerOnePreredMatch.center.y}];
                        
                        CAShapeLayer* playerOneRightShapeLayer = [CAShapeLayer layer];
                        playerOneRightShapeLayer.path = [playerOneRightPath CGPath];
                        playerOneRightShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        playerOneRightShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        playerOneRightShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:playerOneRightShapeLayer];
                        
                        //Match one down line
                        UIBezierPath* playerOneDownPath = [UIBezierPath bezierPath];
                        
                        [playerOneDownPath moveToPoint:(CGPoint){((matchOneStartingXPos + xPos) / 2 ), (playerOnePreredMatch.center.y - (LINE_THICKNESS_VALUE/2))}];
                        
                        [playerOneDownPath addLineToPoint:(CGPoint){((matchOneStartingXPos + xPos) / 2 ), matchView.center.y}];
                        
                        CAShapeLayer* playerOneDownShapeLayer = [CAShapeLayer layer];
                        playerOneDownShapeLayer.path = [playerOneDownPath CGPath];
                        playerOneDownShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        playerOneDownShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        playerOneDownShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:playerOneDownShapeLayer];
                        
                        
                        CGFloat matchTwoStartingXPos = ((playerTwoPreredMatch.frame.origin.x + playerTwoPreredMatch.frame.size.width));
                        
                        //Match one right line
                        UIBezierPath* playerTwoRightPath = [UIBezierPath bezierPath];
                        
                        [playerTwoRightPath moveToPoint:(CGPoint){matchTwoStartingXPos, playerTwoPreredMatch.center.y}];
                        
                        [playerTwoRightPath addLineToPoint:(CGPoint){(((matchTwoStartingXPos + xPos) / 2 )), playerTwoPreredMatch.center.y}];
                        
                        CAShapeLayer* playerTwoRightShapeLayer = [CAShapeLayer layer];
                        playerTwoRightShapeLayer.path = [playerTwoRightPath CGPath];
                        playerTwoRightShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        playerTwoRightShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        playerTwoRightShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:playerTwoRightShapeLayer];
                        
                        //Match one down line
                        UIBezierPath* playerTwoUpPath = [UIBezierPath bezierPath];
                        
                        [playerTwoUpPath moveToPoint:(CGPoint){((matchTwoStartingXPos + xPos) / 2 ), (playerTwoPreredMatch.center.y + (LINE_THICKNESS_VALUE/2))}];
                        
                        [playerTwoUpPath addLineToPoint:(CGPoint){((matchTwoStartingXPos + xPos) / 2 ), matchView.center.y}];
                        
                        CAShapeLayer* playerTwoUpShapeLayer = [CAShapeLayer layer];
                        playerTwoUpShapeLayer.path = [playerTwoUpPath CGPath];
                        playerTwoUpShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        playerTwoUpShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        playerTwoUpShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:playerTwoUpShapeLayer];
                        
                        //Match line
                        UIBezierPath* matchPath = [UIBezierPath bezierPath];
                        
                        [matchPath moveToPoint:(CGPoint){((matchTwoStartingXPos + xPos) / 2 ), matchView.center.y}];
                        
                        [matchPath addLineToPoint:(CGPoint){matchView.frame.origin.x, matchView.center.y}];
                        
                        CAShapeLayer* matchShapeLayer = [CAShapeLayer layer];
                        matchShapeLayer.path = [matchPath CGPath];
                        matchShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        matchShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        matchShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:matchShapeLayer];
                    }
                    else
                    if(playerOnePreredMatch || playerTwoPreredMatch)
                    {
                        TMatchView* vaildPreredMatch = nil;
                        
                        if(playerOnePreredMatch)
                        {
                            vaildPreredMatch = playerOnePreredMatch;
                        }
                        else
                        {
                            vaildPreredMatch = playerTwoPreredMatch;
                        }
                        
                        [matchView setCenter:(CGPoint){matchView.center.x, vaildPreredMatch.center.y}];
                        
                        
                        CGFloat startingXPos = ((vaildPreredMatch.frame.origin.x + vaildPreredMatch.frame.size.width));
                        
                        //Match line
                        UIBezierPath* matchPath = [UIBezierPath bezierPath];
                        
                        [matchPath moveToPoint:(CGPoint){startingXPos, matchView.center.y}];
                        
                        [matchPath addLineToPoint:(CGPoint){matchView.frame.origin.x, matchView.center.y}];
                        
                        CAShapeLayer* matchShapeLayer = [CAShapeLayer layer];
                        matchShapeLayer.path = [matchPath CGPath];
                        matchShapeLayer.strokeColor = [LUDOMADE_YELLOW CGColor];
                        matchShapeLayer.lineWidth = LINE_THICKNESS_VALUE;
                        matchShapeLayer.fillColor = [[UIColor clearColor] CGColor];
                        
                        [self.contentView.layer addSublayer:matchShapeLayer];
                    }
                    
                }
                
                [matchView loadMatch:match AndCurrentTournament:self.selectedTournament];
                
                [self.contentView addSubview:matchView];
                
                matchView.delegate = self;
                
                [self.matchViews setObject:matchView forKey:match.matchID];
                
                yPos += (matchView.frame.size.height*1.5);
                
                if(yPos > self.contentViewHeightConstraint.constant)
                {
                    self.contentViewHeightConstraint.constant = yPos;
                }
            }
            else
            {
                TMatchView* view = [TMatchView new];
                
                xPos += (view.frame.size.width * 1.5);
                
                if((xPos + (view.frame.size.width + X_POS_DEFAULT_VALUE)) > self.contentViewWidthConstraint.constant)
                {
                    self.contentViewWidthConstraint.constant = (xPos + (view.frame.size.width + X_POS_DEFAULT_VALUE));
                }
                
                lastGoodMatch = j;
                
                yPos = Y_POS_DEFAULT_VALUE;
                
                break;
            }
        }
    }
}

#pragma mark - ScrollView Delegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.contentView;
}

#pragma mark - TMatchView Delegate methods

- (void)matchHasBeenUpdated:(Match *)updatedMatch
{
    TMatchView* matchView = nil;
    
    for(Match* match in self.selectedTournament.tournamentMatches)
    {
        if([match.playerOnePreReqMatchID isEqualToString:updatedMatch.matchID])
        {
            match.playerOneID = updatedMatch.winnerID;
            
            matchView = self.matchViews[match.matchID];
            
            [matchView matchUpdated];
        }
        else
        if([match.playerTwoPreReqMatchID isEqualToString:updatedMatch.matchID])
        {
            match.playerTwoID = updatedMatch.winnerID;
            
            matchView = self.matchViews[match.matchID];
            
            [matchView matchUpdated];
        }
    }
}

@end
