//
//  TCustomTableViewController.m
//  Tournament
//
//  Created by Eugene Heckert on 5/8/15.
//  Copyright (c) 2015 Eugene Heckert. All rights reserved.
//

#import "TCustomTableAnimationVC.h"

@interface TCustomTableAnimationVC ()

@end

@implementation TCustomTableAnimationVC

- (id) init
{
    self = [super init];
    if(self)
    {
        self.reloadIdx = RELOAD_INDEX_RESET;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reloadIdx = RELOAD_INDEX_RESET;
    
    //    self.tableView.delegate = self;
    //    self.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView.panGestureRecognizer translationInView:tableView].y >= 0)
    {
        return;
    }
    
    NSArray* temp = [tableView visibleCells];
    
    NSIndexPath* index = [tableView indexPathForCell:[temp lastObject]];
    
    if(indexPath.row <= index.row)
    {
        return;
    }
    
    //    DLog(@"[tableView.panGestureRecognizer translationInView:tableView].y: %f", [tableView.panGestureRecognizer translationInView:tableView].y);
    
    //    DLog(@"self.reloadIdx: %li",(long)self.reloadIdx);
    //    DLog(@"indexPath.row: %li",(long)indexPath.row);
    //    DLog(@"(self.reloadIdx - indexPath.row): %li",(long)(self.reloadIdx - indexPath.row));
    if (indexPath.row < self.reloadIdx && !(self.reloadIdx - indexPath.row > 5))
    {
        //        DLog(@"return");
        return;
    }
    else
    {
        //        DLog(@"reset reload");
        self.reloadIdx = RELOAD_INDEX_RESET;
    }
    
    static float delay = 0.0f;
    
    switch(self.tableAnimationStyle)
    {
        case SLIDE_IN_RIGHT:
        {
            [cell setFrame:CGRectMake(tableView.frame.size.width * 0.25, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:0.0];
            
            [UIView beginAnimations:NULL context:nil];
            [UIView setAnimationDuration:0.35];
            
            
            if(!tableView.isDragging && !tableView.isDecelerating)
            {
                
                if(cell.frame.origin.y <= tableView.contentOffset.y)
                {
                    delay = 0;
                }
                else
                    if(cell.frame.origin.y > tableView.contentOffset.y)
                    {
                        delay += 0.1f;
                    }
                
                if(delay < 1)
                {
                    [UIView setAnimationDelay:delay];
                }
                else
                {
                    
                    [UIView setAnimationDelay:0.99f];
                }
            }
            else
            {
                delay = 0;
            }
            
            [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:1.0f];
            
            //DLog(@"cell: %@",cell);
            
            [UIView commitAnimations];
            break;
        }
        case FADE_IN:
        {
            [cell setAlpha:0.0];
            
            [UIView beginAnimations:NULL context:nil];
            [UIView setAnimationDuration:0.35];
            
            if(!tableView.isDragging && !tableView.isDecelerating)
            {
                
                if(cell.frame.origin.y <= tableView.contentOffset.y)
                {
                    delay = 0.0f;
                }
                else
                    if(cell.frame.origin.y > tableView.contentOffset.y)
                    {
                        delay += 0.1f;
                    }
                
                if(delay < 1)
                {
                    [UIView setAnimationDelay:delay];
                }
                else
                {
                    
                    [UIView setAnimationDelay:0.99f];
                }
            }
            else
            {
                delay = 0;
            }
                
            [cell setAlpha:1.0f];
            
            [UIView commitAnimations];
            break;
        }
        case SLIDE_IN_BOTTOM:
        {
            
            float cellYPos = cell.frame.origin.y;
            
            [cell setFrame:CGRectMake(cell.frame.origin.x, (cell.frame.origin.y + cell.frame.size.height), cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:0.0];
            
            [UIView beginAnimations:NULL context:nil];
            [UIView setAnimationDuration:0.35];
            
            
            if(!tableView.isDragging && !tableView.isDecelerating)
            {
                
                if(cell.frame.origin.y <= tableView.contentOffset.y)
                {
                    delay = 0;
                }
                else
                    if(cell.frame.origin.y > tableView.contentOffset.y)
                    {
                        delay += 0.1f;
                    }
                
                if(delay < 1)
                {
                    [UIView setAnimationDelay:delay];
                }
                else
                {
                    
                    [UIView setAnimationDelay:0.99f];
                }
            }
            
            [cell setFrame:CGRectMake(cell.frame.origin.x, cellYPos, cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:1.0f];
            
            [UIView commitAnimations];
            break;
        }
        case SCALE_IN:
        {
            
            cell.transform = CGAffineTransformMakeScale(1.05, 1.05);
            
            [cell setAlpha:0.0];
            
            [UIView beginAnimations:NULL context:nil];
            [UIView setAnimationDuration:0.35];
            
            if(!tableView.isDragging && !tableView.isDecelerating)
            {
                
                if(cell.frame.origin.y <= tableView.contentOffset.y)
                {
                    delay = 0;
                }
                else
                    if(cell.frame.origin.y > tableView.contentOffset.y)
                    {
                        delay += 1;
                    }
                
                if(delay < 10)
                {
                    
                    [UIView setAnimationDelay:[[NSString stringWithFormat:@"0.%li",(long)delay] floatValue]];
                }
                else
                {
                    
                    [UIView setAnimationDelay:0.99f];
                }
            }
            else
            {
                delay = 0;
            }
            
            [cell setAlpha:1.0f];
            
            //    [cell setFrame:startingFrame];
            
            cell.transform = CGAffineTransformMakeScale(1, 1);
            
            [UIView commitAnimations];
            break;
        }
        case NO_ANIMATION:
        {
            break;
        }
        default:
        {
            [cell setFrame:CGRectMake(tableView.frame.size.width * 0.25, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:0.0];
            
            [UIView beginAnimations:NULL context:nil];
            [UIView setAnimationDuration:0.35];
            
            
            if(!tableView.isDragging && !tableView.isDecelerating)
            {
                
                if(cell.frame.origin.y <= tableView.contentOffset.y)
                {
                    delay = 0;
                }
                else
                if(cell.frame.origin.y > tableView.contentOffset.y)
                {
                    delay += 0.1f;
                }
                
                if(delay < 1)
                {
                    [UIView setAnimationDelay:delay];
                }
                else
                {
                    
                    [UIView setAnimationDelay:0.99f];
                }
            }
            else
            {
                delay = 0;
            }
            
            [cell setFrame:CGRectMake(0, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
            
            [cell setAlpha:1.0f];
            
            //DLog(@"cell: %@",cell);
            
            [UIView commitAnimations];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    double delayInSeconds = 0.2f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // To "clear" the footer view
    return [[UIView alloc] initWithFrame:CGRectZero];
}

@end
