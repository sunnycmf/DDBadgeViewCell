//
//  DDBadgeViewCell.m
//
//  Created by digdog on 1/23/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG and digdog software. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//   
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//   
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "DDBadgeViewCell.h"

#pragma mark -
#pragma mark DDBadgeView declaration

@interface DDBadgeView : UIView {
	
@private
	DDBadgeViewCell *cell_;
}

@property (nonatomic, assign) DDBadgeViewCell *cell;

- (id)initWithFrame:(CGRect)frame cell:(DDBadgeViewCell *)newCell;
@end

#pragma mark -
#pragma mark DDBadgeView implementation

@implementation DDBadgeView 

@synthesize cell = cell_;

#pragma mark -
#pragma mark init

- (id)initWithFrame:(CGRect)frame cell:(DDBadgeViewCell *)newCell {
	
	if ((self = [super initWithFrame:frame])) {
		cell_ = newCell;
		
		self.backgroundColor = [UIColor clearColor];
		self.layer.masksToBounds = YES;
	}
	return self;
}

#pragma mark -
#pragma mark redraw

- (void)drawRect:(CGRect)rect {	

	CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *currentSummaryColor = [UIColor blackColor];
    UIColor *currentDetailColor = [UIColor grayColor];
    UIColor *currentBadgeColor = self.cell.badgeColor;
    if (!currentBadgeColor) {
        currentBadgeColor = [UIColor colorWithRed:0.53 green:0.6 blue:0.738 alpha:1.];
    }
    
	if (self.cell.isHighlighted || self.cell.isSelected) {
        currentSummaryColor = [UIColor whiteColor];
        currentDetailColor = [UIColor whiteColor];
		currentBadgeColor = self.cell.badgeHighlightedColor;
		if (!currentBadgeColor) {
			currentBadgeColor = [UIColor whiteColor];
		}
	} 

    CGSize badgeTextSize = [self.cell.badgeText sizeWithFont:[UIFont boldSystemFontOfSize:13.]];
    CGRect badgeViewFrame = CGRectInset(CGRectIntegral(CGRectMake(rect.size.width - badgeTextSize.width - 20, (rect.size.height - badgeTextSize.height) / 2, badgeTextSize.width, badgeTextSize.height)), -7, -2);
    
	CGContextSaveGState(context);	
	CGContextSetFillColorWithColor(context, currentBadgeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.width - badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI / 2, M_PI * 3 / 2, YES);
    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.height / 2, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2, badgeViewFrame.size.height / 2, M_PI * 3 / 2, M_PI / 2, YES);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);
	CFRelease(path);
	CGContextRestoreGState(context);
	
	CGContextSaveGState(context);	
	CGContextSetBlendMode(context, kCGBlendModeClear);
	[self.cell.badgeText drawInRect:CGRectInset(badgeViewFrame, 7, 2) withFont:[UIFont boldSystemFontOfSize:13.]];
	CGContextRestoreGState(context);

    [currentSummaryColor set];
    [self.cell.summary drawInRect:CGRectMake(10., 10., badgeViewFrame.origin.x - 15., 22.) withFont:[UIFont boldSystemFontOfSize:18.] lineBreakMode:UILineBreakModeTailTruncation];
    
    [currentDetailColor set];
    [self.cell.detail drawInRect:CGRectMake(10., 32., badgeViewFrame.origin.x - 15., 18.) withFont:[UIFont systemFontOfSize:14.] lineBreakMode:UILineBreakModeTailTruncation];    
}

@end

#pragma mark -
#pragma mark DDBadgeViewCell private

@interface DDBadgeViewCell ()
@property (nonatomic, retain) DDBadgeView *	badgeView;
@end

#pragma mark -
#pragma mark DDBadgeViewCell implementation

@implementation DDBadgeViewCell

@synthesize summary = summary_;
@synthesize detail = detail_;
@synthesize badgeView = badgeView_;
@synthesize badgeText = badgeText_;
@synthesize badgeColor = badgeColor_;
@synthesize badgeHighlightedColor = badgeHighlightedColor_;

#pragma mark -
#pragma mark init & dealloc

- (void)dealloc {
	
	[badgeView_ release], badgeView_ = nil;
	
    [summary_ release], summary_ = nil;
    [detail_ release], detail_ = nil;
	[badgeText_ release], badgeText_ = nil;
	[badgeColor_ release], badgeColor_ = nil;
	[badgeHighlightedColor_ release], badgeHighlightedColor_ = nil;
	
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		badgeView_ = [[DDBadgeView alloc] initWithFrame:self.contentView.bounds cell:self];
        badgeView_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        badgeView_.contentMode = UIViewContentModeRedraw;
        [self.contentView addSubview:badgeView_];
    }
    return self;
}

#pragma mark -
#pragma mark accessors

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];
		
	[self.badgeView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

	[super setHighlighted:highlighted animated:animated];
		
	[self.badgeView setNeedsDisplay];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	
	[super setEditing:editing animated:animated];
	
	[UIView beginAnimations:@"hiddenAnimation" context:NULL];
	self.badgeView.hidden = editing;
	[UIView commitAnimations];
}

@end
