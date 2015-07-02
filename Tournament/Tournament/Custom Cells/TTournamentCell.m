//
//  TTournamentCell.m
//  Tournament
//
//  Created by Eugene Heckert on 5/7/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TTournamentCell.h"
#import "Tournament.h"

@interface TTournamentCell ()

@property(nonatomic, strong) Tournament* selectedTournament;

@end

@implementation TTournamentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadTournament:(Tournament *)tour
{
    self.selectedTournament = tour;
    
    self.tournamentNameLabel.text = self.selectedTournament.name;
    
    self.tournamentTypeLabel.text = tour.tournamentType;
    
    if(self.selectedTournament.gameName.length > 0)
    {
        self.gameNameLabel.text = tour.gameName;
    }
    else
    {
        self.gameNameLabel.text = @"Unspecified game";
    }
}

@end
