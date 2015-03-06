//
//  UIView+ScatterPlot.h
//  kiloton
//
//  Created by Ariel Robles on 3/4/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GraphWeightModel.h"
@interface UIView (ScatterPlot)<CPTPlotDataSource>
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) GraphWeightModel *graphModel;
-(void)initPlot:(GraphWeightModel *)graphModel;
@end
