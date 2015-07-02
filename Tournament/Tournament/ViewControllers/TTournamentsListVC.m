//
//  TTournamentsListVC.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TTournamentsListVC.h"
#import "User.h"
#import "Tournament.h"
#import "TTournamentCell.h"
#import "TTournamentBracketVC.h"
#import "TSingleEliminationBracketVC.h"
#import "TDoubleEliminationBracketVC.h"
#import "TCreateTournamentVC.h"


#define HEADER_HEIGHT                30.0f

@interface TTournamentsListVC ()

@property(nonatomic, strong) NSMutableArray* pendingTournaments;
@property(nonatomic, strong) NSMutableArray* underwayTournaments;
@property(nonatomic, strong) NSMutableArray* awaitingTournaments;
@property(nonatomic, strong) NSMutableArray* completedTournaments;

@property(nonatomic, strong) Tournament* selectedTournament;

@property(nonatomic, assign) int pendingSection;
@property(nonatomic, assign) int underwaySection;
@property(nonatomic, assign) int awaitingSection;
@property(nonatomic, assign) int completedSection;

@property(nonatomic, assign) BOOL respondingToTouch;

@property(nonatomic, assign) BOOL refreshOnAppear;

@end

@implementation TTournamentsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView addSubview:self.refreshControl];
    
    self.tableAnimationStyle = FADE_IN;
    
    self.refreshOnAppear = NO;
    
    [self fetchTournamentData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIImage* image = [[UIImage imageNamed:@"white_plus"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem* addTournamentBtn = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(onAddTournamentAction:)];
    self.parentViewController.navigationItem.rightBarButtonItem = addTournamentBtn;
    
    if(self.refreshOnAppear)
    {
        self.refreshOnAppear = NO;
        
        [self fetchTournamentData];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.respondingToTouch = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(self.selectedTournament)
    {
        TTournamentBracketVC* vc = segue.destinationViewController;
        
        [vc loadTournament:self.selectedTournament];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)onAddTournamentAction:(id)sender
{
    DLog(@"Todo add a tournament now.");
    TCreateTournamentVC* vc = [TCreateTournamentVC new];
    
    self.refreshOnAppear = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshData
{
    [self.refreshControl endRefreshing];
    
    [self fetchTournamentData];
}

- (void) fetchTournamentData
{
    
    if([TNetworkManager sharedInstance].user)
    {
        [self.tableView setScrollEnabled:YES];
        [self.tableView setContentOffset:CGPointZero animated:YES];
        
        [[TActivityIndicator sharedInstance] showActivityIndicator:self.tabBarController.view];
        
        [self.pendingTournaments removeAllObjects];
        self.pendingTournaments = nil;
        self.pendingTournaments = [NSMutableArray new];
        
        [self.underwayTournaments removeAllObjects];
        self.underwayTournaments = nil;
        self.underwayTournaments = [NSMutableArray new];
        
        [self.awaitingTournaments removeAllObjects];
        self.awaitingTournaments = nil;
        self.awaitingTournaments = [NSMutableArray new];
        
        [self.completedTournaments removeAllObjects];
        self.completedTournaments = nil;
        self.completedTournaments = [NSMutableArray new];
        
        @weakify(self)
        [[[TNetworkManager sharedInstance] getTournamentList] subscribeNext:^(NSArray* tournaments) {
            @strongify(self)
            
            for(int i = 0;i < [tournaments count];i++)
            {
                Tournament* tour = tournaments[i];
                
                if([tour getTournamentState] == TOURNAMENT_PENDING)
                {
                    [self.pendingTournaments addObject:tour];
                }
                else
                if([tour getTournamentState] == TOURNAMENT_UNDERWAY)
                {
                    [self.underwayTournaments addObject:tour];
                }
                else
                if([tour getTournamentState] == TOURNAMENT_AWAITING_REVIEW)
                {
                    [self.awaitingTournaments addObject:tour];
                }
                else
                if([tour getTournamentState] == TOURNAMENT_COMPLETE)
                {
                    [self.completedTournaments addObject:tour];
                }
            }
            
            
        } error:^(NSError *error) {
            
            [[TActivityIndicator sharedInstance] removeActivityIndicator];
            
        } completed:^{
            @strongify(self)
            
            
            if([self hasTournamentsToDisplay])
            {
                [self.tableView reloadData];
                
                [[TNoDataView sharedInstance] removeNoDataView];
            }
            else
            {
                [[TNoDataView sharedInstance] showNoDataView:self.view WithText:@"You currently do not have any tournaments to display."];
            }
            
            
            [[TActivityIndicator sharedInstance] removeActivityIndicator];
            
        }];
    }
}

- (BOOL) hasTournamentsToDisplay
{
    
    if([self.pendingTournaments count])
    {
        return YES;
    }
    
    if([self.underwayTournaments count])
    {
        return YES;
    }
    
    if([self.awaitingTournaments count])
    {
        return YES;
    }
    
    if([self.completedTournaments count])
    {
        return YES;
    }
    
    return NO;
}

#pragma mark -
#pragma mark TableView Delegate and DataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int numberOfSection = 0;
    
    if([self.pendingTournaments count])
    {
        self.pendingSection = numberOfSection;
        numberOfSection++;
    }
    if([self.underwayTournaments count])
    {
        self.underwaySection = numberOfSection;
        numberOfSection++;
    }
    if([self.awaitingTournaments count])
    {
        self.awaitingSection = numberOfSection;
        numberOfSection++;
    }
    if([self.completedTournaments count])
    {
        self.completedSection = numberOfSection;
        numberOfSection++;
    }
    
    return numberOfSection;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = 0;
    
    if (section == self.pendingSection)
    {
        rowCount = [self.pendingTournaments count];
    }
    else
    if (section == self.underwaySection)
    {
        rowCount = [self.underwayTournaments count];
    }
    else
    if (section == self.awaitingSection)
    {
        rowCount = [self.awaitingTournaments count];
    }
    else
    if(section == self.completedSection)
    {
        rowCount = [self.completedTournaments count];
    }
    
    return rowCount;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //UITableViewHeaderFooterView *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionHeaderCell"];
    
    UITableViewHeaderFooterView *view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, tableView.frame.size.width, HEADER_HEIGHT)];
//    [label setFont:FONT_SOLIDO_BOOK(18)];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    
    //UILabel *label = (UILabel *)[cell viewWithTag:1];
    
    if (section == self.pendingSection)
    {
        label.text = [NSString stringWithFormat:@"Pending (%lu)",(unsigned long)[self.pendingTournaments count]];
    }
    else
    if (section == self.underwaySection)
    {
        label.text = [NSString stringWithFormat:@"Underway (%lu)",(unsigned long)[self.underwayTournaments count]];
    }
    else
    if (section == self.awaitingSection)
    {
        label.text = [NSString stringWithFormat:@"Awaiting (%lu)",(unsigned long)[self.awaitingTournaments count]];
    }
    else
    if(section == self.completedSection)
    {
        label.text = [NSString stringWithFormat:@"Completed (%lu)",(unsigned long)[self.completedTournaments count]];
    }
    
    [view.contentView setBackgroundColor:LUDOMADE_YELLOW];
    
    [view addSubview:label];
    
    tableView.tableHeaderView.frame = view.frame;
    
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    UIView *cell = [tableView dequeueReusableCellWithIdentifier:@"sectionHeaderCell"];
    
    return cell.frame.size.height;
}


-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.000001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    
    Tournament* tour = nil;
    
    if (section == self.pendingSection)
    {
        if(row >= [self.pendingTournaments count])
        {
            UITableViewCell* cell = [UITableViewCell new];
            
            return cell;
        }
        
        tour = self.pendingTournaments[row];
    }
    else
    if (section == self.underwaySection)
    {
        if(row >= [self.underwayTournaments count])
        {
            UITableViewCell* cell = [UITableViewCell new];
            
            return cell;
        }
        
        tour = self.underwayTournaments[row];
    }
    else
    if (section == self.awaitingSection)
    {
        if(row >= [self.awaitingTournaments count])
        {
            UITableViewCell* cell = [UITableViewCell new];
            
            return cell;
        }
        
        tour = self.awaitingTournaments[row];
    }
    else
    if(section == self.completedSection)
    {
        if(row >= [self.completedTournaments count])
        {
            UITableViewCell* cell = [UITableViewCell new];
            
            return cell;
        }
        
        tour = self.completedTournaments[row];
    }
    
    if(!tour)
    {
        UITableViewCell* cell = [UITableViewCell new];
        
        return cell;
    }
    
    TTournamentCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TTournamentCell"];
    
    [cell loadTournament:tour];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if(self.respondingToTouch)
    {
        return;
    }
    
    self.respondingToTouch = YES;
    
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    
    Tournament* tour = nil;
    
    if (section == self.pendingSection)
    {
        if(row >= [self.pendingTournaments count])
        {
            return;
        }
        
        tour = self.pendingTournaments[row];
    }
    else
    if (section == self.underwaySection)
    {
        if(row >= [self.underwayTournaments count])
        {
            return;
        }
        
        tour = self.underwayTournaments[row];
    }
    else
    if (section == self.awaitingSection)
    {
        if(row >= [self.awaitingTournaments count])
        {
            return;
        }
        
        tour = self.awaitingTournaments[row];
    }
    else
    if(section == self.completedSection)
    {
        if(row >= [self.completedTournaments count])
        {
            return;
        }
        
        tour = self.completedTournaments[row];
    }
    
    if(!tour)
    {
        return;
    }
    
    [[TActivityIndicator sharedInstance] showActivityIndicator:tableView];
    
    self.selectedTournament = tour;
    
    if(![self.selectedTournament.tournamentMatches count])
    {
        [self.selectedTournament convertMatches];
    }
    
    if(![self.selectedTournament.tournamentParticipants count])
    {
        [self.selectedTournament convertParticipants];
    }
    
    switch ([self.selectedTournament getTournamentType])
    {
        case SINGLE_ELIMINATION:
        {
            [self performSegueWithIdentifier:TOURNAMENT_SINGLE_ELIMINATION_BRACKET_SEGUE sender:self];
            break;
        }
        case DOUBLE_ELIMINATION:
        {
            [self performSegueWithIdentifier:TOURNAMENT_DOUBLE_ELIMINATION_BRACKET_SEGUE sender:self];
            break;
        }
        case ROUND_ROBIN:
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This bracket type is not currently supported." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case SWISS:
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This bracket type is not currently supported." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
        case UNKNOWN_TOURNAMENT_TYPE:
        {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"This bracket type is not currently supported." preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            break;
        }
            
        default:
            break;
    }
    
//    @weakify(self)
//    [[[TNetworkManager sharedInstance] getTournamentDetail:tour.objectId] subscribeNext:^(Tournament* tournament) {
//        DLog(@"Next");
//        @strongify(self)
//
//        self.selectedTournament = tournament;
//
//    } error:^(NSError *error) {
//        DLog(@"error: %@", error);
//        @strongify(self)
//        self.selectedTournament = nil;
//
//    } completed:^{
//        DLog(@"Completed");
//        @strongify(self)
//        
//        
//    }];
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        
        if(self.respondingToTouch)
        {
            return;
        }
        
        self.respondingToTouch = YES;
        
        int section = (int)indexPath.section;
        int row = (int)indexPath.row;
        
        Tournament* tour = nil;
        
        if (section == self.pendingSection)
        {
            if(row >= [self.pendingTournaments count])
            {
                return;
            }
            
            tour = self.pendingTournaments[row];
        }
        else
        if (section == self.underwaySection)
        {
            if(row >= [self.underwayTournaments count])
            {
                return;
            }
            
            tour = self.underwayTournaments[row];
        }
        else
        if (section == self.awaitingSection)
        {
            if(row >= [self.awaitingTournaments count])
            {
                return;
            }
            
            tour = self.awaitingTournaments[row];
        }
        else
        if(section == self.completedSection)
        {
            if(row >= [self.completedTournaments count])
            {
                return;
            }
            
            tour = self.completedTournaments[row];
        }
        
        if(!tour)
        {
            return;
        }
        
        [[TActivityIndicator sharedInstance] showActivityIndicator:self.navigationController.view];
        
        [[TNetworkManager sharedInstance].user removeTournamentName:tour.name];
        [[TNetworkManager sharedInstance].user save];
        
        [tour deleteInBackgroundWithBlock:^(BOOL success, NSError* error){
            
            self.respondingToTouch = NO;
            
            [self fetchTournamentData];
        }];
        
    }
}

@end
