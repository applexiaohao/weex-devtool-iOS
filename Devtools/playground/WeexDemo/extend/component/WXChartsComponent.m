/**
 * Created by Weex.
 * Copyright (c) 2016, Alibaba, Inc. All rights reserved.
 *
 * This source code is licensed under the Apache Licence 2.0.
 * For the full copyright and license information,please view the LICENSE file in the root directory of this source tree.
 */
#import "WXChartsComponent.h"
#import "WeexDemo-Swift.h"

@interface WXChartsComponent() <ChartViewDelegate>

@property (nonatomic, strong) BarChartView *chartView;

@end

@implementation WXChartsComponent

- (void)drawBarWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    
}

- (void)setStyleWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    [self drawBarStyles:dataSource];
}

- (void)renderWithDataSource:(NSDictionary *)dataSource chartsModule:(WXChartsModule *)chartsModule
{
    [self setData:dataSource];
}

- (instancetype)initWithRef:(NSString *)ref
                       type:(NSString *)type
                     styles:(NSDictionary *)styles
                 attributes:(NSDictionary *)attributes
                     events:(NSArray *)events
               weexInstance:(WXSDKInstance *)weexInstance
{
    if (self = [super initWithRef:ref type:type styles:styles attributes:attributes events:events weexInstance:weexInstance]) {
        
    }
    return self;
}

- (UIView *)loadView
{
    _chartView = [[BarChartView alloc] init];
    return _chartView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBarLineChartView:_chartView];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - event
- (void)addEvent:(NSString *)eventName
{
    
}

- (void)removeEvent:(NSString *)eventName
{
    
}

#pragma mark - private method
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView
{
    chartView.descriptionText = @"";
    chartView.noDataTextDescription = @"You need to provide data for the chart.";
    
    chartView.drawGridBackgroundEnabled = NO;
    
    chartView.dragEnabled = YES;
    [chartView setScaleEnabled:YES];
    chartView.pinchZoomEnabled = NO;
    
    // ChartYAxis *leftAxis = chartView.leftAxis;
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    
    chartView.rightAxis.enabled = NO;
}

- (void)drawBarStyles:(NSDictionary *)dic
{
    _chartView.delegate = self;
    
    if ([dic[@"drawBarShadowEnabled"] boolValue]) {
        _chartView.drawBarShadowEnabled = YES;
    }
    _chartView.drawValueAboveBarEnabled = YES;
    
    _chartView.maxVisibleValueCount = 60;
    
    ChartXAxis *xAxis = _chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.labelFont = [UIFont systemFontOfSize:10.f];
    xAxis.drawGridLinesEnabled = NO;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    leftAxis.labelFont = [UIFont systemFontOfSize:10.f];
    leftAxis.labelCount = 8;
    leftAxis.valueFormatter = [[NSNumberFormatter alloc] init];
    leftAxis.valueFormatter.maximumFractionDigits = 1;
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.spaceTop = 0.15;
    leftAxis.axisMinValue = 0.0;
    
    ChartYAxis *rightAxis = _chartView.rightAxis;
    rightAxis.enabled = YES;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.labelFont = [UIFont systemFontOfSize:10.f];
    rightAxis.labelCount = 8;
    rightAxis.valueFormatter = leftAxis.valueFormatter;
    rightAxis.spaceTop = 0.15;
    rightAxis.axisMinValue = 0.0; // this replaces startAtZero = YES
    
    ChartLegend *l = _chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentLeft;
    l.verticalAlignment = ChartLegendVerticalAlignmentBottom;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.form = ChartLegendFormSquare;
    l.formSize = 9.0;
    l.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f];
    l.xEntrySpace = 4.0;
}

- (void)setData:(NSDictionary *)datas{
    double start = 0.0;
    
    NSArray *values = (NSArray *)datas[@"data"];
    NSMutableArray *xVals = [NSMutableArray array];
    
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    
    for (int i = start; i < values.count; i++)
    {
        NSDictionary *barDatas = values[i];
        [xVals addObject:barDatas[@"x"]];
        [yVals addObject:[[BarChartDataEntry alloc] initWithValue:[barDatas[@"y"] doubleValue] xIndex:(double)i]];
    }
    
    BarChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (BarChartDataSet *)_chartView.data.dataSets[0];
        set1.yVals = yVals;
        _chartView.data.xValsObjc = xVals;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[BarChartDataSet alloc] initWithYVals:yVals label:@"The year 2017"];
        [set1 setColors:ChartColorTemplates.material];
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        BarChartData *data = [[BarChartData alloc] initWithXVals:xVals dataSets:dataSets];
        [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];
        
        _chartView.data = data;
    }
}



@end
