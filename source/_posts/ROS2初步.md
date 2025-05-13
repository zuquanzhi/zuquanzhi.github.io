---
title: ROS2初步
tags: ROS
categories: 718
abbrlink: 51200
date: 2024-03-11 20:16:00
cover: https://www.loliapi.com/acg?5
---
<a name="w3PS4"></a>
# 安装ROS2 
鱼香yyds
```bash
wget http://fishros.com/install -O fishros && bash fishros
```
卸载ROS
```bash
sudo apt remove ros-foxy-* && sudo apt autoremove
```
<a name="hoy3W"></a>
<!--more-->
# 基础概念：
与ROS1类似，ROS中同样具有节点，工作空间，功能包等概念
<a name="ALm4g"></a>
## 节点
<a name="RgFga"></a>
### 每一个节点都负责一个单独的模块。
举个不太恰当的例子：外卖员小哥外卖给主播小姐姐吃，送累了就刷小姐姐直播跳舞，这里外卖小哥和小姐姐都是一个节点，大家共同构成了一个整体，营造出lianghao社会（bushi）<br />ROS2中的节点也是如此，每一个节点也是只负责一个单独的模块化的功能（比如一个节点负责控制车轮转动，一个节点负责从激光雷达获取数据、一个节点负责处理激光雷达的数据、一个节点负责定位等等）

> <a name="sQg5i"></a>
### 节点通信（详见）

ROS2中主要有以下四种通信方式：

- 话题-topics
- 服务-services
- 动作-Action
- 参数-parameters

![Nodes-TopicandService.gif](https://cdn.nlark.com/yuque/0/2024/gif/39221021/1709952196063-33689e90-6391-444f-b3f8-054f02b98e34.gif#averageHue=%23faf7fb&clientId=uc1f625e0-63bc-4&from=drop&id=u42629f68&originHeight=480&originWidth=854&originalType=binary&ratio=1.25&rotation=0&showTitle=false&size=2993370&status=done&style=none&taskId=u5f22b082-1278-4c51-a0b8-8d390e71c3e&title=)

<a name="SasOs"></a>
### 启动节点
需要使用指令：
```bash
ros2 run <package_name> <executable_name>
```
<a name="qUDBx"></a>
### 命令行查看节点信息
这里涉及以下两个概念：

- GUI（Graphical User Interface）就是平常我们说的图形用户界面，大家用的Windows是就是可视化的，我们可以通过鼠标点击按钮等图形化交互完成任务。
- CLI（Command-Line Interface）就是命令行界面了，我们所用的终端，黑框框就是命令行界面，没有图形化。
<a name="JdGKJ"></a>
### 节点相关CLI：
列举几个常用的：<br />运行节点(
```bash
ros2 run <package_name> <executable_name>Copy to clipboardErrorCopied
```
查看节点列表(常用)：
```bash
ros2 node listCopy to clipboardErrorCopied
```
查看节点信息(常用)：
```bash
ros2 node listCopy to clipboardErrorCopied
```
重映射节点名称
```bash
ros2 run turtlesim turtlesim_node --ros-args --remap __node:=my_turtle
```
<a name="qg3CI"></a>
## 工作空间&&功能包：
想要找到一个可执行文件（节点）必须依赖于一个功能包，这些包可以统一放在某个工作空间里。<br />创建工作空间：
```bash
mkdir -p turtle_ws/src
cd turtle_ws/src
```
功能包：<br />可以理解为存放节点的容器。<br />ROS2中功能包根据编译方式的不同分为三种类型。

- ament_python，适用于python程序
- cmake，适用于C++
- ament_cmake，适用于C++程序,是cmake的增强版
<a name="YUrMN"></a>
### 功能包获取

- 安装一般使用
```bash
sudo apt install ros-<version>-package_name
```

- 手动编译：有点麻烦，一般都是需要对包进行修改的时候shiytong
<a name="mddWh"></a>
### 相关指令——ros2pkg
```bash
create       Create a new ROS2 package
executables  Output a list of package specific executables
list         Output a list of available packages
prefix       Output the prefix path of a package
xml          Output the XML of the package manifest or a specific tag

```
   **1.创建功能包**
```bash
ros2 pkg create <package-name>  --build-type  {cmake,ament_cmake,ament_python}  --dependencies <依赖名字>Copy to clipboardErrorCopied
```
**2.列出可执行文件**<br />列出所有
```bash
ros2 pkg executablesCopy to clipboardErrorCopied
```
列出某个功能包的
```bash
ros2 pkg executables turtlesimCopy to clipboardErrorCopied
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709952853767-34253709-40e1-445a-9df0-99407cbf16e4.png#averageHue=%23262321&clientId=uc1f625e0-63bc-4&from=paste&id=u29043447&originHeight=82&originWidth=430&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u5ab1ac60-bfbc-4ace-97a5-3a014d2af0f&title=)<br />**3.列出所有的包**
```bash
ros2 pkg listCopy to clipboardErrorCopied
```
**4.输出某个包所在路径的前缀**
```bash
ros2 pkg prefix  <package-name>Copy to clipboardErrorCopied
```
比如小乌龟
```bash
ros2 pkg prefix turtlesimCopy to clipboardErrorCopied
```
**5.列出包的清单描述文件**<br />**每一个功能包都有一个标配的manifest.xml文件，用于记录这个包的名字，构建工具，编译信息，拥有者，干啥用的等信息。**<br />**通过这个信息，就可以自动为该功能包安装依赖，构建时确定编译顺序等**<br />查看小乌龟模拟器功能包的信息。
```bash
ros2 pkg xml turtlesim
```
<a name="WrcLt"></a>
## colcon:
colcon其是就是个功能包的构建工具，说白了就是编译器。<br />ros2默认死没有colcon的，所以需要安装
```bash
sudo apt-get install python3-colcon-common-extensions
```
<a name="BzyYh"></a>
### 相关指令
<a name="moZ8W"></a>
### [5.1 只编译一个包](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_51-%e5%8f%aa%e7%bc%96%e8%af%91%e4%b8%80%e4%b8%aa%e5%8c%85)
```bash
colcon build --packages-select YOUR_PKG_NAME Copy to clipboardErrorCopied
```
<a name="Mb0AY"></a>
### [5.2 不编译测试单元](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_52-%e4%b8%8d%e7%bc%96%e8%af%91%e6%b5%8b%e8%af%95%e5%8d%95%e5%85%83)
```bash
colcon build --packages-select YOUR_PKG_NAME  --cmake-args -DBUILD_TESTING=0Copy to clipboardErrorCopied
```
<a name="Dt5J5"></a>
### [5.3 运行编译的包的测试](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_53-%e8%bf%90%e8%a1%8c%e7%bc%96%e8%af%91%e7%9a%84%e5%8c%85%e7%9a%84%e6%b5%8b%e8%af%95)
```bash
colcon testCopy to clipboardErrorCopied
```
<a name="Gacar"></a>
### [5.4 允许通过更改src下的部分文件来改变install（重要）](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_54-%e5%85%81%e8%ae%b8%e9%80%9a%e8%bf%87%e6%9b%b4%e6%94%b9src%e4%b8%8b%e7%9a%84%e9%83%a8%e5%88%86%e6%96%87%e4%bb%b6%e6%9d%a5%e6%94%b9%e5%8f%98install%ef%bc%88%e9%87%8d%e8%a6%81%ef%bc%89)
（每次调整 python 脚本时都不必重新build了）
```
colcon build --symlink-install
```
<a name="DEwTp"></a>
## 手撸节点test（c++）
由于python的运行效率实在是一言难尽，我们只学习C++_的版本
<a name="b6gfN"></a>
### 创建工作空间&& 功能包
```bash
mkdir -p town_ws/src
cd town_ws/src
ros2 pkg create village_wang --build-type ament_cmake --dependencies rclcpp
```
创建完成的目录结构如下：<br />![image-20210727193256467.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709953867147-9f288dcf-5e47-4151-9465-e4418685f654.png#averageHue=%23300a24&clientId=u7f35f781-53fd-4&from=drop&id=ua3e86124&originHeight=118&originWidth=212&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=7896&status=done&style=none&taskId=u4fdf03cc-db2e-4232-9a0f-487eae2ca95&title=)
<a name="XZHy1"></a>
### POP方式编写节点
在village_wang/src中创建wang2.cpp
```bash
#include "rclcpp/rclcpp.hpp"


int main(int argc, char **argv)
{
    /*初始化rclcpp
    rclcpp::init(argc, argv);
    /*产生一个Wang2的节点*/
    auto node = std::make_shared<rclcpp::Node>("wang2");
    // 打印一句自我介绍
    RCLCPP_INFO(node->get_logger(), "大家好，我是单身狗wang2.");
    /* 运行节点，并检测退出信号*/
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

```
主函数中首先初始化rclcpp，然后新建了一个Node节点的对象，命名为wang2，接着使用rclcpp让这个节点暴露在外面，并检测退出信号（Ctrl+C），检测到退出信号后，就会执行rcl.shutdown()关闭节点。
<a name="FGd6F"></a>
#### 添加到cmakelists
在CmakeLists.txt最后一行加入下面两行代码。
```
add_executable(wang2_node src/wang2.cpp)
ament_target_dependencies(wang2_node rclcpp)
```
添加这两行代码的目的是让编译器编译wang2.cpp这个文件，不然不会主动编译。接着在上面两行代码下面添加下面的代码。
```
install(TARGETS
  wang2_node
  DESTINATION lib/${PROJECT_NAME}
)
```
这个是C++比Python要麻烦的地方，需要手动将编译好的文件安装到install/village_wang/lib/village_wang下.
<a name="WfmFe"></a>
#### 编译运行：
打开vscode终端，进入town_ws
<a name="Z1Ujk"></a>
### [编译节点](https://fishros.com/d2lros2foxy/#/chapt3/3.6.2POP%E6%96%B9%E6%B3%95%E7%BC%96%E5%86%99C++%E8%8A%82%E7%82%B9%E5%B9%B6%E6%B5%8B%E8%AF%95?id=%e7%bc%96%e8%af%91%e8%8a%82%e7%82%b9)
```bash
colcon build
```
<a name="FFV99"></a>
### [source环境](https://fishros.com/d2lros2foxy/#/chapt3/3.6.2POP%E6%96%B9%E6%B3%95%E7%BC%96%E5%86%99C++%E8%8A%82%E7%82%B9%E5%B9%B6%E6%B5%8B%E8%AF%95?id=source%e7%8e%af%e5%a2%83)
```bash
source install/setup.bash
```
<a name="xqzlR"></a>
### [运行节点](https://fishros.com/d2lros2foxy/#/chapt3/3.6.2POP%E6%96%B9%E6%B3%95%E7%BC%96%E5%86%99C++%E8%8A%82%E7%82%B9%E5%B9%B6%E6%B5%8B%E8%AF%95?id=%e8%bf%90%e8%a1%8c%e8%8a%82%e7%82%b9)
```bash
ros2 run village_wang wang2_node
```
不出意外，你可以看到王二的自我介绍。<br />![a85481a9b56ae5cf6bee46a440140235.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709954465823-94f63561-dbe0-4ac6-90a6-3e3720ef2823.png#averageHue=%231f1d1c&clientId=u7f35f781-53fd-4&from=drop&id=ucbef2116&originHeight=317&originWidth=644&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=105682&status=done&style=none&taskId=u3d85a105-b651-4405-8a1d-378ebd2cea7&title=)<br />当节点运行起来后，使用ros2 node list 指令来查看现有的节点。![972b7669eb967a31c2a0d959b7301ad9.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709954606260-0bd6726b-4a2b-4717-bf95-eba0cac67750.png#averageHue=%23363534&clientId=u7f35f781-53fd-4&from=drop&id=u21cafeca&originHeight=68&originWidth=437&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=14564&status=done&style=none&taskId=ubda76a82-e9ab-43e9-943a-dd83f8acea4&title=)
<a name="MJsrM"></a>
## OPP方式编写节点
还是在wang2.cpp输入代码：
```cpp

#include "rclcpp/rclcpp.hpp"

/*
    创建一个类节点，名字叫做SingleDogNode,继承自Node.
*/
class SingleDogNode : public rclcpp::Node
{

public:
// 构造函数,有一个参数为节点名称
SingleDogNode(std::string name) : Node(name)
{
    // 打印一句自我介绍
    RCLCPP_INFO(this->get_logger(), "大家好，我是单身狗%s.",name.c_str());
}

private:

};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    /*产生一个Wang2的节点*/
    auto node = std::make_shared<SingleDogNode>("wang2");
    /* 运行节点，并检测退出信号*/
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

```
<a name="mRwWY"></a>
### 修改cmakelists&&运行
同上，不多赘述<br />![8014891cb75b9e90255db630b7115fad.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709965221810-a121ef27-b3a9-42f7-a674-f23eee0c3e3b.png#averageHue=%231d1d1c&clientId=u488a9513-274b-4&from=drop&id=u35b36f1c&originHeight=1344&originWidth=1108&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=230404&status=done&style=none&taskId=u6451a532-fc8b-4701-8e02-2a8ab5680a6&title=)<br />运行成功。
<a name="zvknJ"></a>
## 通信
鱼香教程里的举例实在是难以忘却，这里我cv过来
```bash
这里的王二和李四两个节点，通过话题来互相通信（传递数据）。

李四节点会创建一个发布者（Publisher）来发布一个话题（艳娘传奇,小鱼取个英文名叫sexy_girl）。单身汉王二节点，他创建了一个订阅者（Subscriber）来订阅李四发布的话题sexy_girl。

那艳娘传奇的内容是什么呢？我们暂且规定为由文字组成的字符串（连插图都没的那种）。

[object Promise]
李四王二通信模型是一个一对一（一个发布者，一个订阅者）的模型，除此之外ROS2中话题通信其实还可以是1对n,n对1,n对n的。
```
<a name="HgXzG"></a>
### 话题通讯
<a name="jWcs8"></a>
#### 规则：

- 话题名字是关键,发布订阅接口类型要相同，发布的是字符串，接受也要用字符串来接收;
- 同一个人(节点)可以订阅多个话题，同时也可以发布多个话题，就像一本书的作者也可以是另外一本书的读者;
- 同一个小说不能有多个作者（版权问题），但跟小说不一样，同一个话题可以有多个发布者。
<a name="YaREO"></a>
#### 相关工具：
<a name="FnJns"></a>
##### rqt_graph:
ROS2作为一个强大的工具，在运行过程中，我们是可以通过命令来看到节点和节点之间的数据关系的。![image-20210803113450234.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709972464260-688eb5ba-8779-4843-ad42-7a00609803f8.png#averageHue=%23e9e9e8&clientId=ud645a189-b8aa-4&from=drop&id=ud5918dcf&originHeight=591&originWidth=761&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=53857&status=done&style=none&taskId=u304193b0-36aa-4ccc-9cbe-cdec436b6b7&title=)

<a name="Cm70r"></a>
##### 命令行界面——CLI
返回系统活动所有主题列表
```bash
ros2 topic list
```
增加消息类型
```bash
ros2 topic list -t
```
打印实时话题内容
```bash
ros2 topic echo /chatter

```
查看主题信息
```bash
ros2 topic info  /chatter
```
查看消息类型
```bash
ros2 interface show std_msgs/msg/String
```
手动发布命令
```bash
ros2 topic pub /chatter std_msgs/msg/String 'data: "123"'
```
<a name="B7agU"></a>
### c++实现
创建话题订阅者的一般流程：

1. 导入订阅的话题接口类型
2. 创建订阅回调函数
3. 声明并创建订阅者
4. 编写订阅回调处理逻辑
<a name="vIZWC"></a>
### 王三

- 将wang2.cpp代码修改如下：
```bash
#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"
#include "std_msgs/msg/u_int32.hpp"


using std::placeholders::_1;
using std::placeholders::_2;

/*
    创建一个类节点，名字叫做SingleDogNode,继承自Node.
*/
class SingleDogNode : public rclcpp::Node
{

public:
    // 构造函数,有一个参数为节点名称
    SingleDogNode(std::string name) : Node(name)
    {
        // 打印一句自我介绍
        RCLCPP_INFO(this->get_logger(), "大家好，我是单身狗%s.", name.c_str());
         // 创建一个订阅者来订阅李四写的小说，通过名字sexy_girl
        sub_novel = this->create_subscription<std_msgs::msg::String>("sexy_girl", 10, std::bind(&SingleDogNode::topic_callback, this, _1));
    }

private:
    // 声明一个订阅者（成员变量）,用于订阅小说
    rclcpp::Subscription<std_msgs::msg::String>::SharedPtr sub_novel;

    // 收到话题数据的回调函数
    void topic_callback(const std_msgs::msg::String::SharedPtr msg)
    {
        RCLCPP_INFO(this->get_logger(), "朕已阅：'%s'", msg->data.c_str());
    };

};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    /*产生一个Wang2的节点*/
    auto node = std::make_shared<SingleDogNode>("wang2");
    /* 运行节点，并检测退出信号*/
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

```
使用C++订阅话题，需要添加对应的消息类型头文件：
```
#include "std_msgs/msg/string.hpp"
#include "std_msgs/msg/u_int32.hpp"
```
创建订阅者和发布者时依然使用this->create_subscription和this->create_publisher方法。<br />C++中创建一个订阅者，需要传入话题类型、话题名称、所要绑定的回调函数，以及通信Qos.<br />**std::bind()**<br />**C++的类成员函数不能像普通函数那样用于回调，因为每个成员函数都需要有一个对象实例去调用它。 通常情况下，要实现成员函数作为回调函数：一种过去常用的方法就是把该成员函数设计为静态成员函数（因为类的成员函数需要隐含的this指针 而回调函数没有办法提供），但这样做有一个缺点，就是会破坏类的结构性，因为静态成员函数只能访问该类的静态成员变量和静态成员函数，不能访问非静态的，要解决这个问题，可以把对象实例的指针或引用做为参数传给它。 后面就可以靠这个对象实例的指针或引用访问非静态成员函数。另一种办法就是使用std::bind和std::function结合实现回调技术。(目前还看不太懂)**

- 编译运行
```
colcon build --packages-select village_wang
```

- source运行
<a name="KES9k"></a>
### 李四
突然发现李四的源码在教程里没有，自己搓了个试试。
```cpp
#include "rclcpp/rclcpp.hpp"
#include "std_msgs/msg/string.hpp"


using std::placeholders::_1;

// 定义一个小说内容的数组
std::string novel[] = {
"第一回：潋滟湖 1 次偶遇胡艳娘",
"第二回：潋滟湖 2 次偶遇胡艳娘",
"第三回：潋滟湖 3 次偶遇胡艳娘",
"第四回：潋滟湖 4 次偶遇胡艳娘",
"第五回：潋滟湖 5 次偶遇胡艳娘"
};

// 定义一个小说内容的索引
int nb = 0;

/*
    创建一个类节点，名字叫做WriterNode,继承自Node.
*/
class WriterNode : public rclcpp::Node
{

public:
// 构造函数,有一个参数为节点名称
WriterNode(std::string name) : Node(name)
{
    // 打印一句自我介绍
    RCLCPP_INFO(this->get_logger(), "大家好，我是%s,我是一名作家！", name.c_str());
    // 创建一个发布者来发布小说内容，通过名字sexy_girl
    pub_novel = this->create_publisher<std_msgs::msg::String>("sexy_girl", 10);
    // 创建一个定时器，每隔五秒发布一章小说内容
    timer = this->create_wall_timer(std::chrono::seconds(5), std::bind(&WriterNode::timer_callback, this));
}

private:
// 声明一个发布者（成员变量）,用于发布小说内容
rclcpp::Publisher<std_msgs::msg::String>::SharedPtr pub_novel;

// 声明一个定时器（成员变量）,用于定时发布小说内容
rclcpp::TimerBase::SharedPtr timer;

// 定时器触发的回调函数
void timer_callback()
{
    // 新建一个小说内容的消息
    std_msgs::msg::String novel_msg;
    // 判断小说内容的索引是否超出数组范围
    if (nb < sizeof(novel) / sizeof(novel[0]))
    {
        // 获取小说内容
        novel_msg.data = novel[nb];
        // 发布小说内容
        pub_novel->publish(novel_msg);
        // 打印发布的小说内容
        RCLCPP_INFO(this->get_logger(), "发布小说内容：%s", novel_msg.data.c_str());
        // 小说内容的索引加一
        nb++;
    }
    else
    {
        // 小说内容已经发布完毕，取消定时器
        timer->cancel();
        // 打印结束语
        RCLCPP_INFO(this->get_logger(), "小说已经完结，感谢大家的支持！");
    }
};
};

int main(int argc, char **argv)
{
    rclcpp::init(argc, argv); // 初始化rclcpp
    auto node = std::make_shared<WriterNode>("li4"); // 新建一个节点
    rclcpp::spin(node); // 保持节点运行，检测是否收到退出指令（Ctrl+C）
    rclcpp::shutdown(); // 关闭rclcpp
    return 0;
}

```
使用Ctrl+Shift+5切分一个终端出来，输入下面命令：
```
source install/setup.bash 
ros2 run  village_li  li4_node
```
![image-20210804074600329.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709973381445-1adfa01f-8fab-4b2e-862b-37be052c45b0.png#averageHue=%232e2e2e&clientId=ud645a189-b8aa-4&from=drop&id=u0011d78d&originHeight=243&originWidth=1362&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=120502&status=done&style=none&taskId=u430b4fc9-7dae-41d0-813a-b956f4cda2a&title=)
<a name="ffgNa"></a>
### 发布
C++中创建一个发布者也比较简单，使用this->create_publisher即可创建一个发布者。
```
pub_ = this->create_publisher<std_msgs::msg::UInt32>("sexy_girl_money",10);
```
这里提供了三个参数，分别是该发布者要发布的话题名称（sexy_girl_money）、发布者要发布的话题类型（std_msgs::msg::UInt32）、Qos（10）
<a name="hnt3J"></a>
### 服务和接口
<a name="RpsO0"></a>
### 接口：接口其实是一种规范
当接口类型统一的时候，适配显然就不是问题了，大家的服务和响应都是一致的规范格式
<a name="MYwEG"></a>
#### 常用命令
<a name="eTGJG"></a>
##### [查看接口列表（当前环境下）](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_41%e6%9f%a5%e7%9c%8b%e6%8e%a5%e5%8f%a3%e5%88%97%e8%a1%a8%ef%bc%88%e5%bd%93%e5%89%8d%e7%8e%af%e5%a2%83%e4%b8%8b%ef%bc%89)
```cpp
ros2 interface list
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811318-9c2e1b9d-119d-4c2d-80ee-8b9effa311de.png#averageHue=%23282828&clientId=ud3f5d7d5-6e8f-4&from=paste&id=u6b0684ac&originHeight=366&originWidth=700&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=ueea0a066-269f-4a44-908b-66eff688a8a&title=)
<a name="gfepk"></a>
##### [查看所有接口包](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_42%e6%9f%a5%e7%9c%8b%e6%89%80%e6%9c%89%e6%8e%a5%e5%8f%a3%e5%8c%85)
```cpp
ros2 interface packages
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811026-b7326182-2b56-499b-bf97-5580abcd8c68.png#averageHue=%23252525&clientId=ud3f5d7d5-6e8f-4&from=paste&id=uc9cacca0&originHeight=500&originWidth=444&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=uba98428e-3d16-4193-926e-7b18b031853&title=)
<a name="EDlMf"></a>
##### [查看某一个包下的所有接口](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_43%e6%9f%a5%e7%9c%8b%e6%9f%90%e4%b8%80%e4%b8%aa%e5%8c%85%e4%b8%8b%e7%9a%84%e6%89%80%e6%9c%89%e6%8e%a5%e5%8f%a3)
```cpp
ros2 interface package std_msgs
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811203-ae44eadd-e3cf-41ce-8f6e-17452d028e89.png#averageHue=%23262626&clientId=ud3f5d7d5-6e8f-4&from=paste&id=u11110c34&originHeight=246&originWidth=669&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=ue6b53307-54e5-482e-9233-ae6dfa80bfa&title=)
<a name="kgaGi"></a>
##### [查看某一个接口详细的内容](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_44%e6%9f%a5%e7%9c%8b%e6%9f%90%e4%b8%80%e4%b8%aa%e6%8e%a5%e5%8f%a3%e8%af%a6%e7%bb%86%e7%9a%84%e5%86%85%e5%ae%b9)
```cpp
ros2 interface show std_msgs/msg/String
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811860-73d814e9-0ad4-4f3c-8b03-cc84d50b8e00.png#averageHue=%23292929&clientId=ud3f5d7d5-6e8f-4&from=paste&id=uff812660&originHeight=114&originWidth=764&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=ufbd1877f-055c-45bb-b469-d1c4c124258&title=)
<a name="YVXNq"></a>
##### [输出某一个接口所有属性](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_45-%e8%be%93%e5%87%ba%e6%9f%90%e4%b8%80%e4%b8%aa%e6%8e%a5%e5%8f%a3%e6%89%80%e6%9c%89%e5%b1%9e%e6%80%a7)
```cpp
ros2 interface proto sensor_msgs/msg/Image
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811870-5f07a163-7673-4f56-a3c5-337c13939d9a.png#averageHue=%23212121&clientId=ud3f5d7d5-6e8f-4&from=paste&id=u9b08528d&originHeight=208&originWidth=611&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=uf0315698-41a2-4e5e-b260-a5dff7aa66e&title=)

<a name="PJTRk"></a>
#### 
显然，服务和话题的区别在于话题是没有返回的，只是单向的数据传递。而服务是双向的客户端发送，服务端响应。
<a name="JJ4MV"></a>
### 自定义话题接口

- 新建工作空间

在town_ws的src文件夹下，运行下面的指令，即可完成village_interfaces功能包的创建。    <br /> 	**注意，这里包的编译类型我们使用ament_cmake方式。**
```cpp
ros2 pkg create village_interfaces --build-type ament_cmake 
```
![image-20210809151545012.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710037304935-3b720491-175f-421f-b8b8-cd410932ca33.png#averageHue=%23212121&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u0e50a9c7&originHeight=179&originWidth=503&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=15650&status=done&style=none&taskId=u951c0305-6102-4c35-885a-e55d3f3c93b&title=)


- 新建msg文件和Novel.msg（小说消息）

**注意:msg文件开头首字母一定要大写，ROS2强制要求，盲猜应该是为了和类名保持一致**
```cpp
cd village_interfaces
mkdir msg
touch Novel.msg 

```


- 编写Novel.msg内容

我们的目的是给李四的小说每一章增加一张图片，原来李四写小说是对外发布一个std_msgs/msg/String字符串类型的数据。<br />而发布图片的格式，我们需要采用ros自带的传感器消息接口中的图片sensor_msgs/msg/Image数据类型，所以我们新的消息文件的内容就是将两者合并，在ROS2中可以写做这样：<br />**在msg文件中可以使用#号添加注释。**
```
# 标准消息接口std_msgs下的String类型
std_msgs/String content
# 图像消息，调用sensor_msgs下的Image类型
sensor_msgs/Image image
```
这种组合结构图如下：<br />[object Promise]<br />这个图一共三层，第一层是消息定义层，第二层是ROS2已有的std_msgs,sensor_msgs，其组成关系是由下一层组合成上一层。<br />最下面一层string、uint8、uint32是ROS2中的原始数据类型，原始数据类型有下面几种，ROS2中所有的接口都是由这些原始数据类型组成。
```
bool
byte
char
float32,float64
int8,uint8
int16,uint16
int32,uint32
int64,uint64
string
```


- Another way

我们不使用std_msgs/String 而是直接使用最下面一层的string。
```
# 直接使用ROS2原始的数据类型
string content
# 图像消息，调用sensor_msgs下的Image类型
sensor_msgs/Image image
```

- 说明

如何知道，std_msgs/String是由基础数据类型string组成的，其实可以通过下面的指令来查看
```
ros2 interface show std_msgs/msg/String
```
结果如下：
```
string data

```
原来std_msgs的String就是包含一个叫变量名为data的string类型变量，这也是在4.2和4.3章节中代码要用.data才能拿到真正的数据的原因：
```
from std_msgs.msg import String
msg = String()
msg.data = '第%d回：潋滟湖 %d 次偶遇胡艳娘' % (self.i,self.i)
# msg 是 std_msgs.msg.String() 的对象
# msg.data data是string类型的对象，其定义是string data
```
最终Novel.msg
```
# 直接使用ROS2原始的数据类型
string content
# 图像消息，调用sensor_msgs下的Image类型
sensor_msgs/Image image
```

- 修改Cmakelists.txt

完成了代码的编写还不够，我们还需要在CMakeLists.txt中告诉编译器，你要给我把Novel.msg转换成Python库和C++的头文件。<br />直接添加下面的代码到CMakeLists.txt即可。
```cpp
#添加对sensor_msgs的
find_package(sensor_msgs REQUIRED)
find_package(rosidl_default_generators REQUIRED)
#添加消息文件和依赖
rosidl_generate_interfaces(${PROJECT_NAME}
"msg/Novel.msg"
    DEPENDENCIES sensor_msgs
    )
```
find_package用于查找rosidl_default_generators位置，下面rosidl_generate_interfaces就是声明msg文件所属的工程名字、文件位置以及依赖DEPENDENCIES。<br />**踩坑报告：**

- **重点强调一下依赖部分DEPENDENCIES，我们消息中用到的依赖这里必须写上，即使不写编译器也不会报错，直到运行的时候才会出错。**
- **而且rosidl_generate_interfaces()** 函数必须在 **ament_package()** 函数之前调用。

代码大概是这样的<br />![e3877412c40448c0995ba2884a1ae7c1.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710038380883-6becece5-b4cd-4c3d-bc11-cdcffa9dcf1d.png#averageHue=%23201f1f&clientId=ud3f5d7d5-6e8f-4&from=drop&id=ua4ec7301&originHeight=843&originWidth=1469&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=471267&status=done&style=none&taskId=u795fc122-a6a1-4427-9f9d-d20f8507983&title=)

- 修改package.xml

修改village_interfaces目录下的package.xml，添加下面三行代码，为工程添加一下所需的依赖。<br />**这里其实不添加也可以**
```
  <depend>sensor_msgs</depend>
  <build_depend>rosidl_default_generators</build_depend>
  <exec_depend>rosidl_default_runtime</exec_depend>
  <member_of_group>rosidl_interface_packages</member_of_group>
```
代码位置：<br />![image-20210816145202732.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710037769727-982ef5d8-77a3-446a-9035-8861ead0bf4e.png#averageHue=%23201f1f&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u06f1f241&originHeight=492&originWidth=1099&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=105921&status=done&style=none&taskId=u1930cd93-9480-4455-b99b-a9971abac6c&title=)

- 编译

回到town_ws
```
colcon build --packages-select village_interfaces
```

- 验证

过上节课说过的ros2 interface常用的命令来测试。
```
source install/setup.bash 
ros2 interface package village_interfaces  #查看包下所有接口
ros2 interface show village_interfaces/msg/Novel #查看内容
ros2 interface proto village_interfaces/msg/Novel #显示属性

```
<a name="zucuy"></a>
### ![image-20210816145503946.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710037813556-ec2ce503-73b2-4496-ad09-0d176cf48bdb.png#averageHue=%23242424&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u580048f1&originHeight=367&originWidth=751&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=58470&status=done&style=none&taskId=u39622192-29e6-41b5-9414-a9b8c7ed920&title=)
我们可以在运行结果中看到，Novel的消息内容是由content数据和传感器数据image共同组成的了。

<a name="vtOSp"></a>
### 服务：

- 服务：客户端发送请求给服务端，服务端可以根据客户端的请求做一些处理，然后返回结果给客户端。

![Service-SingleServiceClient.gif](https://cdn.nlark.com/yuque/0/2024/gif/39221021/1710035790713-136e7676-715a-48d2-92ad-41e569c869f1.gif#averageHue=%23fcf9fd&clientId=ud3f5d7d5-6e8f-4&from=drop&id=PMpbD&originHeight=480&originWidth=854&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=380270&status=done&style=none&taskId=u365753d7-dbb5-4e03-9548-c451b5f740a&title=)<br />![Service-MultipleServiceClient.gif](https://cdn.nlark.com/yuque/0/2024/gif/39221021/1710035797325-0dfe07bb-99eb-4afc-9625-737c1827a667.gif#averageHue=%2394a2cc&clientId=ud3f5d7d5-6e8f-4&from=drop&id=mTDBy&originHeight=480&originWidth=854&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=898464&status=done&style=none&taskId=u4ef526f9-0e06-43be-ab48-beff9eb1ad0&title=)

下面操作一下ros2自带的样例服务：
<a name="ZLIvy"></a>
#### 启动服务端
运行一个服务节点
```cpp
ros2 run examples_rclpy_minimal_service service
//服务的功能是将两个数字相加，给定a，b两个数，返回sum也就是ab之和
```
<a name="OhYmw"></a>
##### 查看服务列表
```cpp
ros2 service list
```
<a name="ZNyUa"></a>
##### 手动调用服务（一定要注意a：  b: 的空格）
```cpp
ros2 service call /add_two_ints example_interfaces/srv/AddTwoInts "{a: 5,b: 10}"
//需要再启动一个终端
```
<a name="RHF6C"></a>
##### 查看服务接口类型
```cpp
ros2 service type /add_two_ints

```
<a name="AIADv"></a>
##### 查找使用某一接口的服务
```cpp
ros2 service find example_interfaces/srv/AddTwoInts

```
<a name="X9wyU"></a>
#### 自定义服务接口
我们来看一下服务的消息接口长什么样子？<br />服务接口格式：xxx.srv
```
int64 a
int64 b
---
int64 sum
```
与话题不同的是，srv文件比msg文件中间多出了三个---这三个杠杠就是分界线，上方的是客户端发送请求的数据结构定义，下方的是服务端响应结果的数据结构定义。<br />参考下面的步骤：

- 新建srv文件夹，并在文件夹下新建xxx.srv
- 在xxx.srv下编写服务接口内容并保存
- 在CmakeLists.txt添加依赖和srv文件目录
- 在package.xml中添加xxx.srv所需的依赖
- 编译功能包即可生成python与c++头文件

当然在做上面的步骤之前，我们还需要做一件很重要的事情。就是根据业务需求，确定好请求的数据结构和返回的数据结构。我们依然是在village_interfaces下创建服务接口。<br />开始之前，我们先根据李四的需求来确定数据结构。<br />上一节中李四对借钱的要求如下：

1. 借钱一定要打欠条，收到欠条才能给钱
2. 每次借钱不能超过自己全部资金的10%且一定是整数，也就是说李四假如现在有100块钱，那么最多借出去100x10%=10块钱

总结一下就是，李三发送借钱请求的时候一定要有欠条，我们想一下，欠条中应该至少包含两条信息

- 借钱者名字，字符串类型、可以用string表示
- 金额，整形，可以用uint32表示

那请求的数据结构我们就可以确定下来了，接着确定返回的数据的格式。<br />既然是借钱，那李四就有可能拒绝，会有借钱失败的情况，所以返回数据应该有这两条信息：

- 是否出借：只有成功和失败两种情况，布尔类型（bool）可表示
- 出借金额：无符号整形，可以用uint32表示，借钱失败时为0。
<a name="SOi0x"></a>
##### 创建srv文件夹及BorrowMoney.srv消息文件
在village_interfaces下新建srv文件夹<br />![image-20210811162010736.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710038764606-c8035912-d3b5-4a18-8758-978165a7a504.png#averageHue=%23222222&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u87e80afd&originHeight=160&originWidth=471&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=14984&status=done&style=none&taskId=u6fcc9d9a-d569-433f-86c9-0a6ed8b969f&title=)
<a name="yxyCD"></a>
##### 编写文件内容
```cpp
string name
uint32 money
---
bool success
uint32 money
```
<a name="efh5K"></a>
##### 修改Cmakelists.txt
我们已经添加过依赖DEPENDENCIES和msg文件了，所以这里我们直接添加一个srv即可。
```cpp
find_package(rosidl_default_generators REQUIRED)
rosidl_generate_interfaces(${PROJECT_NAME}
  #---msg---
  "msg/Novel.msg"
  #---srv---
  "srv/BorrowMoney.srv"
  DEPENDENCIES sensor_msgs
 )
```
需要关注的是这一行"srv/BorrowMoney.srv",添加了对应的文件位置。

- 踩坑：在rosidl_generate_interfaces()函数中传递了一个依赖项sensor_msgs，但是在使用find_package()函数之前没有找到它。需要在CMakeLists.txt 文件中添加find_package(sensor_msgs REQUIRED)，以确保 **sensor_msgs** 包被正确地找到和链接。
<a name="io4wO"></a>
##### 修改package.xml
```cpp
  <build_depend>sensor_msgs</build_depend>
  <build_depend>rosidl_default_generators</build_depend>
  <exec_depend>rosidl_default_runtime</exec_depend>
  <member_of_group>rosidl_interface_packages</member_of_group>

```
<a name="Ink82"></a>
##### 编译
```cpp
colcon build --packages-select village_interfaces
```
<a name="lVN2C"></a>
##### 测试
这次测试我们依然使用ros2 interface指令进行测试。
```cpp
source install/setup.bash 
ros2 interface package village_interfaces
ros2 interface show village_interfaces/srv/BorrowMoney
ros2 interface proto village_interfaces/srv/BorrowMoney 
```
<a name="uONPm"></a>
#### 服务的c++实现
**一句话：张三拿多少钱钱给王二，王二凑够多少个章节的艳娘传奇给他，可参考以下步骤**

1. 导入服务接口
2. 创建服务端回调函数
3. 声明并创建服务端
4. 编写回调函数逻辑处理请求
<a name="c7FPU"></a>
##### 添加接口&&依赖
因为village_wang的包类型是ament_cmake，故需要进行以下两步操作：<br />**第一步修改package.xml**<br />加入下面的代码（告诉colcon，编译之前要确保有village_interfaces存在）
```cpp
  <depend>village_interfaces</depend>
```
![image-20210816153438400.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710039585985-a81f2aa8-b41e-461b-bc89-2642cab063a3.png#averageHue=%23222120&clientId=ud3f5d7d5-6e8f-4&from=drop&id=ud2b27244&originHeight=109&originWidth=542&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=18085&status=done&style=none&taskId=u0cad5214-f47f-4485-a806-092b7a4e5d0&title=)<br />**第二步修改和CMakeLists.txt**<br />在CMakeLists.txt中加入下面一行代码
```cpp
find_package(village_interfaces REQUIRED)
```
**find_package是cmake的语法，用于查找库。找到后，还需要将其和可执行文件链接起来**<br />所以还需要修改ament_target_dependencies，在其中添加village_interfaces。
```cpp
ament_target_dependencies(wang2_node 
  rclcpp 
  village_interfaces
)
```
对于C++来说，添加服务接口只需在程序中引入对应的头文件即可。<br />**这个头文件就是我们SellNovel.srv生成的头文件**
```cpp
#include "village_interfaces/srv/sell_novel.hpp"
```
<a name="Fhg7q"></a>
##### 声明回调函数
添加完服务接口接着就可以声明一个**卖书请求回调函数**。
```cpp
// 声明一个回调函数，当收到买书请求时调用该函数，用于处理数据
void sell_book_callback(const village_interfaces::srv::SellNovel::Request::SharedPtr request,
        const village_interfaces::srv::SellNovel::Response::SharedPtr response)
{
}
```

再创建一个队列，用于存放自己看过的二手书，创建队列需要用到queue容器，所以我们先用#include <queue>在程序开头引入该容器，再在代码中添加下面这句话。
```cpp
//创建一个小说章节队列
std::queue<std::string>  novels_queue;
```
<a name="LaIsk"></a>
##### 死锁
当张三请求王二买二手书的时候，假如王二手里书的数量不足，王二就等攒够了对应数量的书再返回给张三。<br />等待攒够章节的操作需要在卖书服务函数中阻塞当前线程，阻塞后王二就收不到李四写的小说了，这样一来就会造成一个很尴尬的情景：<br />**在卖书服务回调函数中等着书库（队列）里小说章节数量满足张三需求，接收小说的程序等着这边的卖书回调函数结束，好把书放进书库（队列）里。**<br />这种互相等待的情况，我们称之为死锁<br />ROS2默认是单线程的，同时只有一个线程在跑，大家都是顺序执行，你干完我干，一条线下去。<br />所以为了解决这个问题，我们可以使用多线程，即每次收到服务请求后，单独开一个线程来处理，不影响其他部分。
<a name="aZhlq"></a>
##### 回调函数组
ROS2中要使用多线程执行器和回调组来实现多线程，我们先在SingleDogNode中声明一个回调组成员变量。
```cpp
// 声明一个服务回调组
rclcpp::CallbackGroup::SharedPtr callback_group_service_;
```
最终结果
```
class SingleDogNode : public rclcpp::Node 
{

public:
    // 构造函数
    SingleDogNode(std::string name) : Node(name)
    {
    }
    
private:
    // 声明一个服务回调组
    rclcpp::CallbackGroup::SharedPtr callback_group_service_;
    //创建一个小说章节队列
    std::queue<std::string>  novels_queue;
    // 声明一个服务端
    rclcpp::Service<village_interfaces::srv::SellNovel>::SharedPtr server_;
    // 声明一个回调函数，当收到买书请求时调用该函数，用于处理数据
    void sell_book_callback(const village_interfaces::srv::SellNovel::Request::SharedPtr request,
        const village_interfaces::srv::SellNovel::Response::SharedPtr response)
    {
        //对请求数据进行处理
    }
};
```
<a name="rAhK4"></a>
##### 实例化服务端&&编写回调函数处理请求
在ROS2中，回调函数组也是一个对象，通过实例化create_callback_group类即可创建一个callback_group_service的对象。<br />在SingleDogNode的构造函数中添加下面这行代码，即可完成实例化 
```
callback_group_service_ = this->create_callback_group(rclcpp::CallbackGroupType::MutuallyExclusive);
```
<br />我们使用成员函数作为回调函数，这里要根据回调函数中参数个数，设置占位符，即告诉编译器，这个函数需要传入的参数个数。<br />**在之前订阅话题的回调函数中，我们已经用到过一次了，因为话题回调只有一个参数，所以只需要一个占位符，这里服务的回调是两个参数，所以要设置两个**
```
using std::placeholders::_1;
using std::placeholders::_2;
```
在private:下**声明服务端**
```
// 声明一个服务端
rclcpp::Service<village_interfaces::srv::SellNovel>::SharedPtr server_;
```
在构造函数中**实例化服务端**
```
// 实例化卖二手书的服务
server_ = this->create_service<village_interfaces::srv::SellNovel>("sell_novel",
                            std::bind(&SingleDogNode::sell_book_callback,this,_1,_2),
                            rmw_qos_profile_services_default,
                            callback_group_service_);
```
实例化服务端可以直接使用create_service函数，该函数是一个模版函数，需要输入要创建的服务类型，这里我们使用的是<village_interfaces::srv::SellNovel>，这个函数有四个参数需要输入,小鱼接下来进行一一介绍

- "sell_novel"服务名称，没啥好说的，要唯一哦，因为服务只能有一个
- std::bind(&SingleDogNode::sell_book_callback,this,_1,_2)回调函数，这里指向了我们2.3.1中我们声明的sell_book_callback
- rmw_qos_profile_services_default 通信质量，这里使用服务默认的通信质量
- callback_group_service_，回调组，我们前面创建回调组就是在这里使用的，告诉ROS2，当你要调用回调函数处理请求时，请把它放到单独线程的回调组中
<a name="q5mnn"></a>
##### 编写回调函数
```
// 声明一个回调函数，当收到买书请求时调用该函数，用于处理数据
    void sell_book_callback(const village_interfaces::srv::SellNovel::Request::SharedPtr request,
        const village_interfaces::srv::SellNovel::Response::SharedPtr response)
    {
        RCLCPP_INFO(this->get_logger(), "收到一个买书请求，一共给了%d钱",request->money);
        unsigned int novelsNum = request->money*1;  //应给小说数量，一块钱一章

        //判断当前书库里书的数量是否满足张三要买的数量，不够则进入等待函数
        if(novels_queue.size()<novelsNum)
        {
            RCLCPP_INFO(this->get_logger(), "当前艳娘传奇章节存量为%d：不能满足需求,开始等待",novels_queue.size());

            // 设置rate周期为1s，代表1s检查一次
            rclcpp::Rate loop_rate(1);

            //当书库里小说数量小于请求数量时一直循环
            while (novels_queue.size()<novelsNum)
            {
                //判断系统是否还在运行
                if(!rclcpp::ok())
                {
                    RCLCPP_ERROR(this->get_logger(), "程序被终止了");
                    return ;
                }
                //打印一下当前的章节数量和缺少的数量
                RCLCPP_INFO(this->get_logger(), "等待中，目前已有%d章，还差%d章",novels_queue.size(),novelsNum-novels_queue.size());

                //rate.sleep()让整个循环1s运行一次
                loop_rate.sleep();
            }
        }
        // 章节数量满足需求了
        RCLCPP_INFO(this->get_logger(), "当前艳娘传奇章节存量为%d：已经满足需求",novels_queue.size());

        //一本本把书取出来，放进请求响应对象response中
        for(unsigned int i =0 ;i<novelsNum;i++)
        {
            response->novels.push_back(novels_queue.front());
            novels_queue.pop();
        }
    }
```
<br />当收到请求时，先计算一下应该给张三多少书novelsNum，然后判断书库里书的数量够不够，不够则进入攒书程序。如果够或者攒够了就把书放到服务响应对象里，返回给张三。这里我们还需要修改一下话题回调函数，增加了一行代码，将小说放到书库里novels_queue.push(msg->data);
```
// 收到话题数据的回调函数
 void topic_callback(const std_msgs::msg::String::SharedPtr msg){
     // 新建一张人民币
     std_msgs::msg::UInt32 money;
     money.data = 10;

    // 发送人民币给李四
    pub_->publish(money);
    RCLCPP_INFO(this->get_logger(), "王二：我收到了：'%s' ，并给了李四：%d 元的稿费", msg->data.c_str(),money.data);

    //将小说放入novels_queue中
    novels_queue.push(msg->data);
};
```
<a name="S7CCg"></a>
##### 修改main函数
因为我们要让整个程序变成多线程的，所以我们要把节点的执行器变成多线程执行器。<br />修改一下main函数，新建一个多线程执行器，添加王二节点并spin,完整代码如下：
```
int main(int argc, char **argv)
{
    rclcpp::init(argc, argv);
    /*产生一个Wang2的节点*/
    auto node = std::make_shared<SingleDogNode>("wang2");
    /* 运行节点，并检测退出信号*/
    rclcpp::executors::MultiThreadedExecutor exector;
    exector.add_node(node);
    exector.spin();
    rclcpp::shutdown();
    return 0;
}
```
 [wang2.cpp](https://raw.githubusercontent.com/fishros/ros2_town/af8b29f7b23153d35348ebfcd3b1bc5760c6c5a6/village_wang/src/wang2.cpp)
<a name="NmoFR"></a>
##### 编译：
```
colcon build --packages-select village_wang
```
<a name="YjbW2"></a>
##### 测试
```shell
source install/setup.bash
ros2 run village_wang wang2_node
source install/setup.bash
ros2@ubuntu:~/code/town_ws$ ros2 service list -t
/sell_book [village_interfaces/srv/SellNovel]
ros2 service call /sell_book  village_interfaces/srv/SellNovel "{money: 5}"
source install/setup.bash
ros2 run village_li li4_node

```
<br />![image-20210831124712850.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710040232046-33fa90eb-16d0-4459-8907-ec1d53912d34.png#averageHue=%232f2f2f&clientId=ud3f5d7d5-6e8f-4&from=drop&id=bKVka&originHeight=251&originWidth=1424&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=135885&status=done&style=none&taskId=ud6755017-b9b4-40d3-a3d5-08f505ffa75&title=)

[客户端实现](https://fishros.com/d2lros2foxy/#/chapt4/4.10%E6%9C%8D%E5%8A%A1%E5%AE%9E%E7%8E%B0(C++)?id=_3%e5%ae%a2%e6%88%b7%e7%ab%af%ef%bc%88%e5%bc%a0%e4%b8%89%ef%bc%89%e5%ae%9e%e7%8e%b0)![28bff3501425d8b0e5a018fb3f7cfb1b.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710040911063-ab181be4-89fa-4a05-8da4-a2b5d58c0444.png#averageHue=%23eeebe9&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u4725bfe1&originHeight=430&originWidth=380&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=62757&status=done&style=none&taskId=u2b8126d0-3aa8-4cae-b16e-308b2b4d88f&title=)
