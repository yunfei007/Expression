//
//  QSCExpressionView.m
//  qingsongchou
//
//  Created by yf on 2018/11/12.
//  Copyright © 2018年 Chai. All rights reserved.
//

#import "QSCExpressionView.h"
#import "QSCExpressionCell.h"
#import "QSCExpressionGroupModel.h"
#import "FlyHorizontalFlowLauyout.h"

#define kOneEmoticonHeight 30
#define kOnePageCount 24

@interface QSCExpressionView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView * collectionView;

@property (nonatomic,strong) NSMutableArray * dataArr;

@property (nonatomic,assign) NSInteger emoticonGroupTotalPageCount;

@property (nonatomic,strong) UIView * pgControlView;

@property (nonatomic,strong) UIPageControl * pageControlBottom;

@end


@implementation QSCExpressionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.backgroundColor = [UIColor whiteColor];
        [self initDataArr];
        [self stepSubView];
    }
    return self;
}

- (void)initDataArr
{
    NSString *path = [NSBundle.mainBundle pathForResource:@"expression" ofType:@"plist"];
    if (!path) {
        return;
    }
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    for (int i=0; i<array.count; i++) {
        NSDictionary * groupDict = array[i];
        QSCExpressionGroupModel * groupModel = [QSCExpressionGroupModel objectWithKeyValues:groupDict];
        
        for (int j=0; j<groupModel.emoticons.count; j++) {
            if ((j+1)%kOnePageCount == 0) {
                QSCExpressionModel * deleteModel = [[QSCExpressionModel alloc] init];
                deleteModel.desc = @"删除";
                deleteModel.image = @"expression_delete";
                
                [groupModel.emoticons insertObject:deleteModel atIndex:j];
            }
            [self.dataArr addObject:groupModel.emoticons[j]];
        }
        
        //还差多少个item没满一页
        int count = kOnePageCount - self.dataArr.count%kOnePageCount;
        for (int k = 0; k<count; k++) {
            
            if (k == (count -1)) {
                QSCExpressionModel * deleteModel = [[QSCExpressionModel alloc] init];
                deleteModel.desc = @"删除";
                deleteModel.image = @"expression_delete";
                
                [self.dataArr addObject:deleteModel];
            }else{
                [self.dataArr addObject:@""];
            }
        }
 
    }
    _emoticonGroupTotalPageCount = (_dataArr.count%kOnePageCount == 0)?(_dataArr.count/kOnePageCount):(_dataArr.count/kOnePageCount+1);
}

-(void)stepSubView
{
    _pgControlView = [[UIView alloc] init];
    [self addSubview:_pgControlView];
    
    [_pgControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(30);
    }];
    
    //分页控制器
    _pageControlBottom = [[UIPageControl alloc] initWithFrame:CGRectZero];
    _pageControlBottom.numberOfPages = _emoticonGroupTotalPageCount;
    _pageControlBottom.currentPage = 0;
    _pageControlBottom.pageIndicatorTintColor = [UIColor colorWithGivenHexColorString:@"#f2f2f2"];// 设置非选中页的圆点颜色
    _pageControlBottom.currentPageIndicatorTintColor = [UIColor colorWithGivenHexColorString:@"#999999"]; // 设置选中页的圆点颜色
    [_pgControlView addSubview:_pageControlBottom];
    

    [_pageControlBottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pgControlView.mas_top).offset(0);
        make.left.equalTo(self.mas_left).offset(30);
        make.right.equalTo(self.mas_right).offset(-30);
        make.height.mas_equalTo(10);
    }];
    
    
    //collectionview
    FlyHorizontalFlowLauyout * layout = [[FlyHorizontalFlowLauyout alloc] init];
    //水平布局
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    //设置每个表情按钮的大小为30*30
    layout.itemSize=CGSizeMake(kOneEmoticonHeight, kOneEmoticonHeight);
    //设置行列间距
    layout.minimumLineSpacing=20;
    layout.minimumInteritemSpacing=(kDeviceWidth-30*2-30*6)/5;
    //设置分区的内容偏移
    layout.sectionInset=UIEdgeInsetsMake(25, 30, 25, 30);
    
    UICollectionView * collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor whiteColor];
    //打开分页效果
    collectionView.pagingEnabled = YES;
    collectionView.delegate=self;
    collectionView.dataSource=self;
    self.collectionView = collectionView;
    [self addSubview:self.collectionView];
    
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.bottom.equalTo(_pgControlView.mas_top).offset(0);
    }];
    
    //注册cell
    [collectionView registerClass:[QSCExpressionCell class] forCellWithReuseIdentifier:@"expressionCell"];
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _emoticonGroupTotalPageCount;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kOnePageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.section * 24 + indexPath.row;
    id obj = _dataArr[index];
    QSCExpressionModel * model;
    if ([obj isKindOfClass:[QSCExpressionModel class]]) {
        model = _dataArr[index];
    }else{
        model = nil;
    }
    
    QSCExpressionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"expressionCell" forIndexPath:indexPath];
    cell.expressionModel = model;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.section * 24 + indexPath.row;
    id obj = _dataArr[index];
    QSCExpressionModel * model;
    if ([obj isKindOfClass:[QSCExpressionModel class]]) {
        model = _dataArr[index];
        if ([model.desc isEqualToString:@"删除"]) {
            NSLog(@"删除表情");
            if (self.delegate && [self.delegate respondsToSelector:@selector(expressionViewItemClickWith:andEmojiTag:)]) {
                [self.delegate expressionViewItemClickWith:@"" andEmojiTag:@""];
            }
        }else{
            NSLog(@"%@",model.desc);
            if (self.delegate && [self.delegate respondsToSelector:@selector(expressionViewItemClickWith:andEmojiTag:)]) {
                [self.delegate expressionViewItemClickWith:model.image andEmojiTag:model.emojiTag];
            }
        }
    }
}


//pagecontroll的委托方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置页码
    _pageControlBottom.currentPage = page;
}

@end
