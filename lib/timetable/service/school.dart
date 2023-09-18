import 'package:mimir/network/session.dart';
import 'package:mimir/school/entity/school.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';

class TimetableService {
  static const _timetableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  final ISession session;

  TimetableService(this.session);

  /// 获取课表
  Future<SitTimetable> getTimetable(SchoolYear schoolYear, Semester semester) async {
    final response = await session.request(
      _timetableUrl,
      ReqMethod.post,
      para: {'gnmkdm': 'N253508'},
      data: {
        // 学年名
        'xnm': schoolYear.toString(),
        // 学期名
        'xqm': semesterToFormField(semester)
      },
    );
    final json = response.data;
    final List<dynamic> courseList = json['kbList'];
    // final List<dynamic> courseList = jsonDecode(
    //     """[{"kcmc":"大学物理C2","xqjmc":"星期一","jcs":"1-2","zcd":"1-14周","cdmc":"二教F206","xm":"余冠良","xqmc":"奉贤校区","xf":"3.5","zxs":"56","jxbmc":"2301649","kch":"B122014"},{"kcmc":"面向对象程序设计课程设计","xqjmc":"星期一","jcs":"1-8","zcd":"19周","cdmc":"奉贤实践基地","xm":"张蕊","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301337","kch":"B704210"},{"kcmc":"数据结构","xqjmc":"星期一","jcs":"3-4","zcd":"1-7周,16周","cdmc":"一教D401（录播）","xm":"荣祺","xqmc":"奉贤校区","xf":"3.5","zxs":"48","jxbmc":"2300329","kch":"B2042305"},{"kcmc":"数据结构","xqjmc":"星期一","jcs":"3-4","zcd":"8-15周","cdmc":"七科A518","xm":"荣祺","xqmc":"奉贤校区","xf":"3.5","zxs":"16","jxbmc":"2300329A","kch":"B2042305"},{"kcmc":"面向对象程序设计","xqjmc":"星期一","jcs":"5-6","zcd":"1-14周","cdmc":"一教D401（录播）","xm":"宋智礼","xqmc":"奉贤校区","xf":"3","zxs":"40","jxbmc":"2301130","kch":"B2042211"},{"kcmc":"计算机组成原理","xqjmc":"星期一","jcs":"7-8","zcd":"1-8周","cdmc":"一教C302","xm":"孙怀英","xqmc":"奉贤校区","xf":"2.0","zxs":"32","jxbmc":"2300846","kch":"B2042343"},{"kcmc":"创业方法","xqjmc":"星期一","jcs":"9-11","zcd":"4-13周","cdmc":"二教E101","xm":"李永胜","xqmc":"奉贤校区","xf":"2.0","zxs":"30","jxbmc":"2301822","kch":"G5010017"},{"kcmc":"数据结构课程设计","xqjmc":"星期一","jcs":"9-11","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"},{"kcmc":"体育3篮球（男）","xqjmc":"星期二","jcs":"1-2","zcd":"1-16周","cdmc":"馆A119(篮球馆)","xm":"曹伟","xqmc":"奉贤校区","xf":"0.5","zxs":"32","jxbmc":"2303612","kch":"S1230123"},{"kcmc":"面向对象程序设计课程设计","xqjmc":"星期二","jcs":"1-8","zcd":"19周","cdmc":"奉贤实践基地","xm":"张蕊","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301337","kch":"B704210"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"1周","cdmc":"四科205（大物实验）","xm":"蔡金华","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"3周","cdmc":"四科208（大物实验） ","xm":"王向欣","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"5周","cdmc":"四科106（大物实验）","xm":"张成功","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"7周","cdmc":"四科206（大物实验）","xm":"胡健","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"9周","cdmc":"四科207（大物实验） ","xm":"潘瑞芹","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"11周","cdmc":"四科201（大物实验）","xm":"李琳","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"13周","cdmc":"四科301（大物实验） ","xm":"蔡金华","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"大学物理实验2","xqjmc":"星期二","jcs":"5-7","zcd":"15周","cdmc":"四科403（大物实验）","xm":"王向欣","xqmc":"奉贤校区","xf":"1","zxs":"无","jxbmc":"2303691","kch":"B1221026"},{"kcmc":"形势与政策（3）","xqjmc":"星期二","jcs":"7-8","zcd":"4-10周(双)","cdmc":"二教I104","xm":"袁桂娟","xqmc":"奉贤校区","xf":"0.5","zxs":"8","jxbmc":"2301679","kch":"B1280003"},{"kcmc":"ChatGPT、元宇宙与人工智能","xqjmc":"星期二","jcs":"9-11","zcd":"4-8周","cdmc":"二教G202","xm":"李晓斌","xqmc":"奉贤校区","xf":"2.0","zxs":"15","jxbmc":"2303549","kch":"G5030026Y"},{"kcmc":"数据结构课程设计","xqjmc":"星期二","jcs":"9-11","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"},{"kcmc":"面向对象程序设计课程设计","xqjmc":"星期三","jcs":"1-8","zcd":"19周","cdmc":"奉贤实践基地","xm":"张蕊","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301337","kch":"B704210"},{"kcmc":"面向对象程序设计","xqjmc":"星期三","jcs":"3-4","zcd":"1-2周,5-11周(单)","cdmc":"一教D105","xm":"宋智礼","xqmc":"奉贤校区","xf":"3","zxs":"40","jxbmc":"2301130","kch":"B2042211"},{"kcmc":"面向对象程序设计","xqjmc":"星期三","jcs":"3-4","zcd":"3-4周,6-12周(双),13-14周","cdmc":"奉计13（三教411）","xm":"宋智礼","xqmc":"奉贤校区","xf":"3","zxs":"16","jxbmc":"2301130A","kch":"B2042211"},{"kcmc":"数据结构","xqjmc":"星期三","jcs":"5-6","zcd":"1-16周","cdmc":"一教D401（录播）","xm":"荣祺","xqmc":"奉贤校区","xf":"3.5","zxs":"48","jxbmc":"2300329","kch":"B2042305"},{"kcmc":"大学物理C2","xqjmc":"星期三","jcs":"7-8","zcd":"1-14周","cdmc":"二教F206","xm":"余冠良","xqmc":"奉贤校区","xf":"3.5","zxs":"56","jxbmc":"2301649","kch":"B122014"},{"kcmc":"数据结构课程设计","xqjmc":"星期三","jcs":"9-11","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"},{"kcmc":"计算机组成原理","xqjmc":"星期四","jcs":"1-2","zcd":"1-8周","cdmc":"一教C302","xm":"孙怀英","xqmc":"奉贤校区","xf":"2.0","zxs":"32","jxbmc":"2300846","kch":"B2042343"},{"kcmc":"面向对象程序设计课程设计","xqjmc":"星期四","jcs":"1-4","zcd":"19周","cdmc":"奉贤实践基地","xm":"张蕊","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301337","kch":"B704210"},{"kcmc":"线性代数A","xqjmc":"星期四","jcs":"5-6","zcd":"1-16周","cdmc":"二教G201","xm":"罗纯","xqmc":"奉贤校区","xf":"2","zxs":"32","jxbmc":"2301037","kch":"B2220034"},{"kcmc":"数据结构课程设计","xqjmc":"星期四","jcs":"5-11","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"},{"kcmc":"面向对象程序设计课程设计","xqjmc":"星期五","jcs":"1-4","zcd":"19周","cdmc":"奉贤实践基地","xm":"张蕊","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301337","kch":"B704210"},{"kcmc":"数据结构课程设计","xqjmc":"星期六","jcs":"1-8","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"},{"kcmc":"数据结构课程设计","xqjmc":"星期日","jcs":"1-8","zcd":"18周","cdmc":"奉贤实践基地","xm":"孙怀英","xqmc":"奉贤校区","xf":"1","zxs":"32","jxbmc":"2301106","kch":"B704208"}]""");
    final rawCourses = courseList.map((e) => CourseRaw.fromJson(e)).toList();
    final timetableEntity = SitTimetable.parse(rawCourses);
    return timetableEntity;
  }
}
