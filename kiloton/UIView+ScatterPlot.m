//
//  UIView+ScatterPlot.m
//  kiloton
//
//  Created by Ariel Robles on 3/4/15.
//  Copyright (c) 2015 nearsoft. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIView+ScatterPlot.h"
#import "CorePlot-CocoaTouch.h"
#import <objc/runtime.h>
#import "GraphWeightModel.h"

static void * hostViewPropertyKey = &hostViewPropertyKey;
static void * graphModelPropertyKey = &graphModelPropertyKey;
static NSString * expectedPlotName = @"expected";
static NSString * resultPlotName = @"result";

@implementation UIView (ScatterPlot)
#pragma mark - Chart behavior

- (CPTGraphHostingView *)hostView {
    return objc_getAssociatedObject(self, hostViewPropertyKey);
}

- (void)setHostView:(CPTGraphHostingView *)unicorn {
    objc_setAssociatedObject(self, hostViewPropertyKey, unicorn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CPTGraphHostingView *)graphModel {
    return objc_getAssociatedObject(self, graphModelPropertyKey);
}

- (void)setGraphModel:(CPTGraphHostingView *)unicorn {
    objc_setAssociatedObject(self, graphModelPropertyKey, unicorn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)initPlot:(GraphWeightModel *)graphModel {
    self.graphModel = graphModel;
    [self configureHost];
    [self configureGraph];
    [self configurePlots];
    [self configureAxes];
}

-(void)configureHost {
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:self.bounds];
    self.hostView.allowPinchScaling = YES;
    [self addSubview:self.hostView];
}

-(void)configureGraph {
    // 1 - Create the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    [graph applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
    self.hostView.hostedGraph = graph;
    // 2 - Set graph title
    NSString *title = @"History graph";
    graph.title = title;
    // 3 - Create and set text style
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 16.0f;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, 15.0f);
    // 4 - Set padding for plot area
    [graph.plotAreaFrame setPaddingLeft:1.0f];
    [graph.plotAreaFrame setPaddingBottom:1.0f];
    // 5 - Enable user interactions for plot space
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.allowsUserInteraction = YES;
}

-(void)configurePlots {
    // 1 - Get graph and plot space
    CPTGraph *graph = self.hostView.hostedGraph;
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    // 2 - Create the three plots
    CPTScatterPlot *expPlot = [[CPTScatterPlot alloc] init];
    expPlot.dataSource = self;
    expPlot.identifier = expectedPlotName;
    CPTColor *expColor = [CPTColor greenColor];
    [graph addPlot:expPlot toPlotSpace:plotSpace];
    CPTScatterPlot *resultPlot = [[CPTScatterPlot alloc] init];
    resultPlot.dataSource = self;
    resultPlot.identifier = resultPlotName;
    CPTColor *resultlColor = [CPTColor redColor];
    [graph addPlot:resultPlot toPlotSpace:plotSpace];
    // 3 - Set up plot space
    [plotSpace scaleToFitPlots:[NSArray arrayWithObjects:expPlot, nil]];
    CPTMutablePlotRange *xRange = [plotSpace.xRange mutableCopy];
    [xRange expandRangeByFactor:CPTDecimalFromCGFloat(1.15f)];
    plotSpace.xRange = xRange;//zoom for each axis
    CPTMutablePlotRange *yRange = [plotSpace.yRange mutableCopy];
    [yRange expandRangeByFactor:CPTDecimalFromCGFloat(10.0f)];
    plotSpace.yRange = yRange;
    // 4 - Create styles and symbols
    CPTMutableLineStyle *expLineStyle = [expPlot.dataLineStyle mutableCopy];
    expLineStyle.lineWidth = 1;
    expLineStyle.lineColor = expColor;
    expPlot.dataLineStyle = expLineStyle;
    CPTMutableLineStyle *expSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    expSymbolLineStyle.lineColor = expColor;
    CPTPlotSymbol *expSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    expSymbol.fill = [CPTFill fillWithColor:expColor];
    expSymbol.lineStyle = expSymbolLineStyle;
    expSymbol.size = CGSizeMake(5.0f, 5.0f);
    expPlot.plotSymbol = expSymbol;
    CPTMutableLineStyle *resultLineStyle = [resultPlot.dataLineStyle mutableCopy];
    resultLineStyle.lineWidth = 1.5;
    resultLineStyle.lineColor = resultlColor;
    resultPlot.dataLineStyle = resultLineStyle;
    CPTMutableLineStyle *resultSymbolLineStyle = [CPTMutableLineStyle lineStyle];
    resultSymbolLineStyle.lineColor = resultlColor;
    CPTPlotSymbol *resultSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    resultSymbol.fill = [CPTFill fillWithColor:resultlColor];
    resultSymbol.lineStyle = resultSymbolLineStyle;
    resultSymbol.size = CGSizeMake(5.0f, 5.0f);
    resultPlot.plotSymbol = resultSymbol;
}

-(void)configureAxes {
    // 1 - Create styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 2.0f;
    axisLineStyle.lineColor = [CPTColor whiteColor];
    CPTMutableTextStyle *axisTextStyle = [[CPTMutableTextStyle alloc] init];
    axisTextStyle.color = [CPTColor whiteColor];
    axisTextStyle.fontName = @"Helvetica-Bold";
    axisTextStyle.fontSize = 11.0f;
    CPTMutableLineStyle *tickLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor whiteColor];
    tickLineStyle.lineWidth = 2.0f;
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    tickLineStyle.lineColor = [CPTColor blackColor];
    tickLineStyle.lineWidth = 0.1f;
    // 2 - Get axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.hostView.hostedGraph.axisSet;
    // 3 - Configure x-axis
    CPTAxis *x = axisSet.xAxis;
    x.title = @"Day";
    x.titleTextStyle = axisTitleStyle;
    x.titleOffset = 15.0f;
    x.axisLineStyle = axisLineStyle;
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    x.labelTextStyle = axisTextStyle;
    x.majorTickLineStyle = axisLineStyle;
    x.majorTickLength = 4.0f;
    x.tickDirection = CPTSignNegative;
    CGFloat dateCount = [self.graphModel.numberOfDays floatValue];
    NSMutableSet *xLabels = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *majorTickLocations = [NSMutableSet setWithCapacity:dateCount];
    NSMutableSet *minorTickLocations = [NSMutableSet setWithCapacity:dateCount];
    NSInteger namberOfDays = [self.graphModel.numberOfDays integerValue];
    NSInteger chunksForLabel = [self calculeteNumberOfLabelsToSet:(long)15 totalOfLocations: namberOfDays];
    for(NSInteger i = 1; i < namberOfDays; i++) {
        NSUInteger mod = i % chunksForLabel;
        if(mod == 0) {
            CGFloat location = i++;
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText: [NSString stringWithFormat:@"%li", (long)i]  textStyle:x.labelTextStyle];
            label.tickLocation = CPTDecimalFromCGFloat(location);
            label.offset = x.majorTickLength;
            if (label) {
                [xLabels addObject:label];
                [majorTickLocations addObject:[NSNumber numberWithFloat:location]];
            }
        } else {
            [minorTickLocations addObject:[NSNumber numberWithFloat:i]];
        }
    }
    x.axisLabels = xLabels;
    x.majorTickLocations = majorTickLocations;
    x.minorTickLocations = minorTickLocations;
    // 4 - Configure y-axis
    CPTAxis *y = axisSet.yAxis;
    y.title = @"Weight";
    y.titleTextStyle = axisTitleStyle;
    y.titleOffset = -40.0f;
    y.axisLineStyle = axisLineStyle;
    y.majorGridLineStyle = gridLineStyle;
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.labelTextStyle = axisTextStyle;
    y.labelOffset = 16.0f;
    y.majorTickLineStyle = axisLineStyle;
    y.majorTickLength = 5.0f;
    y.minorTickLength = 10.0f;
    y.tickDirection = CPTSignPositive;
    NSInteger majorIncrement = 30;
    NSInteger minorIncrement = 10;
    CGFloat yMax = 300.0f;  // should determine dynamically based on max price
    NSMutableSet *yLabels = [NSMutableSet set];
    NSMutableSet *yMajorLocations = [NSMutableSet set];
    NSMutableSet *yMinorLocations = [NSMutableSet set];
    for (NSInteger j = minorIncrement; j <= yMax; j += minorIncrement) {
        NSUInteger mod = j % majorIncrement;
        if (mod == 0) {
            CPTAxisLabel *label = [[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%li", (long)j] textStyle:y.labelTextStyle];
            NSDecimal location = CPTDecimalFromInteger(j);
            label.tickLocation = location ;
            label.offset = -y.majorTickLength - y.labelOffset;
            if (label) {
                [yLabels addObject:label];
            }
            [yMajorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:location]];
        } else {
            [yMinorLocations addObject:[NSDecimalNumber decimalNumberWithDecimal:CPTDecimalFromInteger(j)]];
        }
    }
    y.axisLabels = yLabels;
    y.majorTickLocations = yMajorLocations;
    y.minorTickLocations = yMinorLocations;
}

#pragma mark - Rotation
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

#pragma mark - CPTPlotDataSource methods

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot {
    NSInteger numberOfRecords;
    NSArray *recordKeys = [self.graphModel.resultSpots allKeys];
    if(plot.identifier == resultPlotName) {
        numberOfRecords = recordKeys.count + 1;
    } else if(plot.identifier == expectedPlotName) {
        numberOfRecords = 2;
    }
    return numberOfRecords;
}

-(NSArray *) getSortedResultlocations  {
    return [[self.graphModel.resultSpots allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue]==[obj2 intValue]) {
            return NSOrderedSame;
        } else if ([obj1 intValue]<[obj2 intValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index {
    if(plot.identifier == resultPlotName) {
        NSArray *sortedKey = [self getSortedResultlocations];;
        if(fieldEnum == CPTScatterPlotFieldX) {
            if(index == 0) {
                return @1;
            }
            return sortedKey[index - 1];
        } else if(fieldEnum == CPTScatterPlotFieldY) {
            if(index == 0) {
                return self.graphModel.initialRange;
            }
            return [self.graphModel.resultSpots objectForKey: sortedKey[index - 1]];
        }
    } else if(plot.identifier == expectedPlotName) {
        if(fieldEnum == CPTScatterPlotFieldX) {
            if(index == 0) {
                return @1;
            }
            return self.graphModel.numberOfDays;
        } else if(fieldEnum == CPTScatterPlotFieldY) {
            if(index == 0) {
                return self.graphModel.initialRange;
            }
            return self.graphModel.objectiveRange;
        }
    }
    return [NSDecimalNumber zero];
}

-(NSInteger)calculeteNumberOfLabelsToSet:(NSInteger)number totalOfLocations:(NSInteger)numberOfLocations {
    NSInteger j;
    for(j = 5; j <= 50; j += 5 ) {
        if((j * number) >= numberOfLocations) {
            break;
        }
    }
    return j;
}


@end
