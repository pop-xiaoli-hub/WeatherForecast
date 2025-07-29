//
//  MainVC.m
//  Weather Forecast
//
//  Created by xiaoli pop on 2025/7/17.
//

#import "MainVC.h"
#import "WeatherCell.h"
#import "OtherVC.h"
#import "DataOfAddedCity.h"
#import "MasterPageVC.h"
@interface MainVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UIImageView* imageView;
@property (nonatomic, strong)UIButton* button;
@property (nonatomic, strong)UITableView* tableView;
@property (nonatomic, strong)DataOfAddedCity* singleton;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singleton = [DataOfAddedCity sharedInstance];
    for(NSString *familyname in [UIFont familyNames]){
              NSLog(@"family: %@",familyname);
              for(NSString *fontName in [UIFont fontNamesForFamilyName:familyname]){
                  NSLog(@"----font: %@",fontName);
              }
              NSLog(@"--------------");
        }
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    [self createLogo];
    [self createAdd];
    [self createtableView];
    [self.tableView registerClass:[WeatherCell class] forCellReuseIdentifier:@"cell01"];
    //[self creatArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCity:) name:@"notice" object:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.singleton.mutableArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)addCity:(NSNotification* )notification {
    NSDictionary* dict = notification.userInfo;
    [self.singleton.mutableArray addObject:dict];
    [self.tableView reloadData];
    NSLog(@"%@", self.singleton.mutableArray[0]);
}

- (void)createtableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 110, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 160);
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)pressAdd{
    OtherVC* vc = [[OtherVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSDictionary* dict = self.singleton.mutableArray[indexPath.row];
    NSArray* alldata = self.singleton.mutableArray;
    MasterPageVC* vc = [[MasterPageVC alloc] initWithData:alldata initialIndex:indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.singleton.mutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WeatherCell* cell  = [self.tableView dequeueReusableCellWithIdentifier:@"cell01" forIndexPath:indexPath];
    NSDictionary* dict = [self.singleton.mutableArray objectAtIndex:indexPath.row];
    NSArray* forecastArray = dict[@"forecast"][@"forecastday"];
    NSDictionary* todayInfo = forecastArray[0];  // 只取第一个元素
    NSDictionary* today = todayInfo[@"day"];
        NSInteger code = [today[@"condition"][@"code"] integerValue];
        NSString* imageName;
        if (code == 1000) {
            imageName = @"p5.jpg";
        } else if (code == 1003 || code == 1006 || code == 1009) {
            imageName = @"p2.jpg";
        } else if ((code == 1063) || (code >= 1150 && code <= 1207) || (code >= 1240 && code <= 1246)) {
            imageName = @"p1.jpg";
        } else if ((code == 1066 || code == 1069 || code == 1072 || code == 1114 || code == 1117) || (code >= 1210 && code <= 1237) || (code >= 1255 && code <= 1264)) {
            imageName = @"p4.jpg";
        }
        else if (code == 1087 || (code >= 1273 && code <= 1282)) {
            imageName = @"p3.jpg";
        } else {
            imageName = @"p2.jpg";
        }
    UIImage* image = [UIImage imageNamed:imageName];
    cell.iView.image = image;
    cell.CityName.text = dict[@"location"][@"name"];
    cell.temperature.text = [NSString stringWithFormat:@"%@ ℃", dict[@"current"][@"temp_c"]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)createAdd {
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(pressAdd) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(340, 50, 40 , 40);
    [self.view addSubview:self.button];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)createLogo {
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = [UIImage imageNamed:@"logo.png"];
    self.imageView.frame = CGRectMake(20, 50, 60, 60);
    [self.view addSubview:self.imageView];
}

//- (void)creatArray {
//    self.array = @[
//        @"北京市 北京市",
//        @"天津市 天津市",
//        @"石家庄市 河北省",
//        @"唐山市 河北省",
//        @"秦皇岛市 河北省",
//        @"邯郸市 河北省",
//        @"邢台市 河北省",
//        @"保定市 河北省",
//        @"张家口市 河北省",
//        @"承德市 河北省",
//        @"沧州市 河北省",
//        @"廊坊市 河北省",
//        @"衡水市 河北省",
//        @"太原市 山西省",
//        @"大同市 山西省",
//        @"阳泉市 山西省",
//        @"长治市 山西省",
//        @"晋城市 山西省",
//        @"朔州市 山西省",
//        @"晋中市 山西省",
//        @"运城市 山西省",
//        @"忻州市 山西省",
//        @"临汾市 山西省",
//        @"吕梁市 山西省",
//        @"呼和浩特市 内蒙古自治区",
//        @"包头市 内蒙古自治区",
//        @"乌海市 内蒙古自治区",
//        @"赤峰市 内蒙古自治区",
//        @"通辽市 内蒙古自治区",
//        @"鄂尔多斯市 内蒙古自治区",
//        @"呼伦贝尔市 内蒙古自治区",
//        @"巴彦淖尔市 内蒙古自治区",
//        @"乌兰察布市 内蒙古自治区",
//        @"兴安盟 内蒙古自治区",
//        @"锡林郭勒盟 内蒙古自治区",
//        @"阿拉善盟 内蒙古自治区",
//        @"沈阳市 辽宁省",
//        @"大连市 辽宁省",
//        @"鞍山市 辽宁省",
//        @"抚顺市 辽宁省",
//        @"本溪市 辽宁省",
//        @"丹东市 辽宁省",
//        @"锦州市 辽宁省",
//        @"营口市 辽宁省",
//        @"阜新市 辽宁省",
//        @"辽阳市 辽宁省",
//        @"盘锦市 辽宁省",
//        @"铁岭市 辽宁省",
//        @"朝阳市 辽宁省",
//        @"葫芦岛市 辽宁省",
//        @"长春市 吉林省",
//        @"吉林市 吉林省",
//        @"四平市 吉林省",
//        @"辽源市 吉林省",
//        @"通化市 吉林省",
//        @"白山市 吉林省",
//        @"松原市 吉林省",
//        @"白城市 吉林省",
//        @"延边朝鲜族自治州 吉林省",
//        @"哈尔滨市 黑龙江省",
//        @"齐齐哈尔市 黑龙江省",
//        @"鸡西市 黑龙江省",
//        @"鹤岗市 黑龙江省",
//        @"双鸭山市 黑龙江省",
//        @"大庆市 黑龙江省",
//        @"伊春市 黑龙江省",
//        @"佳木斯市 黑龙江省",
//        @"七台河市 黑龙江省",
//        @"牡丹江市 黑龙江省",
//        @"黑河市 黑龙江省",
//        @"绥化市 黑龙江省",
//        @"大兴安岭地区 黑龙江省",
//        @"上海市 上海市",
//        @"南京市 江苏省",
//        @"无锡市 江苏省",
//        @"徐州市 江苏省",
//        @"常州市 江苏省",
//        @"苏州市 江苏省",
//        @"南通市 江苏省",
//        @"连云港市 江苏省",
//        @"淮安市 江苏省",
//        @"盐城市 江苏省",
//        @"扬州市 江苏省",
//        @"镇江市 江苏省",
//        @"泰州市 江苏省",
//        @"宿迁市 江苏省",
//        @"杭州市 浙江省",
//        @"宁波市 浙江省",
//        @"温州市 浙江省",
//        @"嘉兴市 浙江省",
//        @"湖州市 浙江省",
//        @"绍兴市 浙江省",
//        @"金华市 浙江省",
//        @"衢州市 浙江省",
//        @"舟山市 浙江省",
//        @"台州市 浙江省",
//        @"丽水市 浙江省",
//        @"合肥市 安徽省",
//        @"芜湖市 安徽省",
//        @"蚌埠市 安徽省",
//        @"淮南市 安徽省",
//        @"马鞍山市 安徽省",
//        @"淮北市 安徽省",
//        @"铜陵市 安徽省",
//        @"安庆市 安徽省",
//        @"黄山市 安徽省",
//        @"滁州市 安徽省",
//        @"阜阳市 安徽省",
//        @"宿州市 安徽省",
//        @"六安市 安徽省",
//        @"亳州市 安徽省",
//        @"池州市 安徽省",
//        @"宣城市 安徽省",
//        @"福州市 福建省",
//        @"厦门市 福建省",
//        @"莆田市 福建省",
//        @"三明市 福建省",
//        @"泉州市 福建省",
//        @"漳州市 福建省",
//        @"南平市 福建省",
//        @"龙岩市 福建省",
//        @"宁德市 福建省",
//        @"南昌市 江西省",
//        @"景德镇市 江西省",
//        @"萍乡市 江西省",
//        @"九江市 江西省",
//        @"新余市 江西省",
//        @"鹰潭市 江西省",
//        @"赣州市 江西省",
//        @"吉安市 江西省",
//        @"宜春市 江西省",
//        @"抚州市 江西省",
//        @"上饶市 江西省",
//        @"济南市 山东省",
//        @"青岛市 山东省",
//        @"淄博市 山东省",
//        @"枣庄市 山东省",
//        @"东营市 山东省",
//        @"烟台市 山东省",
//        @"潍坊市 山东省",
//        @"济宁市 山东省",
//        @"泰安市 山东省",
//        @"威海市 山东省",
//        @"日照市 山东省",
//        @"莱芜市 山东省",
//        @"临沂市 山东省",
//        @"德州市 山东省",
//        @"聊城市 山东省",
//        @"滨州市 山东省",
//        @"菏泽市 山东省",
//        @"郑州市 河南省",
//        @"开封市 河南省",
//        @"洛阳市 河南省",
//        @"平顶山市 河南省",
//        @"安阳市 河南省",
//        @"鹤壁市 河南省",
//        @"新乡市 河南省",
//        @"焦作市 河南省",
//        @"濮阳市 河南省",
//        @"许昌市 河南省",
//        @"漯河市 河南省",
//        @"三门峡市 河南省",
//        @"南阳市 河南省",
//        @"商丘市 河南省",
//        @"信阳市 河南省",
//        @"周口市 河南省",
//        @"驻马店市 河南省",
//        @"济源市 河南省",
//        @"武汉市 湖北省",
//        @"黄石市 湖北省",
//        @"十堰市 湖北省",
//        @"宜昌市 湖北省",
//        @"襄阳市 湖北省",
//        @"鄂州市 湖北省",
//        @"荆门市 湖北省",
//        @"孝感市 湖北省",
//        @"荆州市 湖北省",
//        @"黄冈市 湖北省",
//        @"咸宁市 湖北省",
//        @"随州市 湖北省",
//        @"恩施土家族苗族自治州 湖北省",
//        @"长沙市 湖南省",
//        @"株洲市 湖南省",
//        @"湘潭市 湖南省",
//        @"衡阳市 湖南省",
//        @"邵阳市 湖南省",
//        @"岳阳市 湖南省",
//        @"常德市 湖南省",
//        @"张家界市 湖南省",
//        @"益阳市 湖南省",
//        @"郴州市 湖南省",
//        @"永州市 湖南省",
//        @"怀化市 湖南省",
//        @"娄底市 湖南省",
//        @"湘西土家族苗族自治州 湖南省",
//        @"广州市 广东省",
//        @"韶关市 广东省",
//        @"深圳市 广东省",
//        @"珠海市 广东省",
//        @"汕头市 广东省",
//        @"佛山市 广东省",
//        @"江门市 广东省",
//        @"湛江市 广东省",
//        @"茂名市 广东省",
//        @"肇庆市 广东省",
//        @"惠州市 广东省",
//        @"梅州市 广东省",
//        @"汕尾市 广东省",
//        @"河源市 广东省",
//        @"阳江市 广东省",
//        @"清远市 广东省",
//        @"东莞市 广东省",
//        @"中山市 广东省",
//        @"潮州市 广东省",
//        @"揭阳市 广东省",
//        @"云浮市 广东省",
//        @"南宁市 广西壮族自治区",
//        @"柳州市 广西壮族自治区",
//        @"桂林市 广西壮族自治区",
//        @"梧州市 广西壮族自治区",
//        @"北海市 广西壮族自治区",
//        @"防城港市 广西壮族自治区",
//        @"钦州市 广西壮族自治区",
//        @"贵港市 广西壮族自治区",
//        @"玉林市 广西壮族自治区",
//        @"百色市 广西壮族自治区",
//        @"贺州市 广西壮族自治区",
//        @"河池市 广西壮族自治区",
//        @"来宾市 广西壮族自治区",
//        @"崇左市 广西壮族自治区",
//        @"海口市 海南省",
//        @"三亚市 海南省",
//        @"三沙市 海南省",
//        @"儋州市 海南省",
//        @"成都市 四川省",
//        @"重庆市 重庆市",
//        @"贵阳市 贵州省",
//        @"昆明市 云南省",
//        @"西安市 陕西省",
//        @"兰州市 甘肃省",
//        @"西宁市 青海省",
//        @"银川市 宁夏回族自治区",
//        @"乌鲁木齐市 新疆维吾尔自治区",
//        @"拉萨市 西藏自治区",
//        @"香港特别行政区 香港特别行政区",
//        @"澳门特别行政区 澳门特别行政区",
//        @"台北市 台湾省"
//    ];
//
//
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
