---
title: ROS2初步
tags: ROS
categories: 机器人/计算机视觉
abbrlink: 51200
date: 2024-03-11 20:16:00
cover: https://www.loliapi.com/acg?5
---
<a name="w3PS4"></a>
# 安装ROS2 
下面给出一套在 Ubuntu 上可复现的安装方式（以 FishROS 脚本为例）。
```bash
wget http://fishros.com/install -O fishros && bash fishros
```
如果需要卸载 ROS 发行版，可执行：
```bash
sudo apt remove ros-foxy-* && sudo apt autoremove
```
<a name="hoy3W"></a>
<!--more-->
# 基础概念：
与 ROS1 类似，ROS2 也由节点、工作空间、功能包等核心概念构成。
<a name="ALm4g"></a>
## 节点
<a name="RgFga"></a>
### 每一个节点都负责一个单独的模块。
可以把系统想成一条流水线：每个节点只负责一件事，然后通过标准通信机制协作。<br />
例如：一个节点采集激光雷达数据，一个节点做定位，一个节点做路径规划，一个节点控制底盘执行。

> <a name="sQg5i"></a>
### 节点通信（详见）

ROS2 中主要有以下四种通信方式：

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
列举几个常用的：<br />运行节点：
```bash
ros2 run <package_name> <executable_name>
```
查看节点列表(常用)：
```bash
ros2 node list
```
查看节点信息(常用)：
```bash
ros2 node info <node_name>
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

- 手动编译：通常在你需要修改源码或调试依赖时使用。
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
ros2 pkg create <package-name> --build-type {cmake,ament_cmake,ament_python} --dependencies <依赖名字>
```
**2.列出可执行文件**<br />列出所有
```bash
ros2 pkg executables
```
列出某个功能包的
```bash
ros2 pkg executables turtlesim
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709952853767-34253709-40e1-445a-9df0-99407cbf16e4.png#averageHue=%23262321&clientId=uc1f625e0-63bc-4&from=paste&id=u29043447&originHeight=82&originWidth=430&originalType=url&ratio=1.25&rotation=0&showTitle=false&status=done&style=none&taskId=u5ab1ac60-bfbc-4ace-97a5-3a014d2af0f&title=)<br />**3.列出所有的包**
```bash
ros2 pkg list
```
**4.输出某个包所在路径的前缀**
```bash
ros2 pkg prefix <package-name>
```
比如小乌龟
```bash
ros2 pkg prefix turtlesim
```
**5.列出包的清单描述文件**<br />**每一个功能包都有一个标配的manifest.xml文件，用于记录这个包的名字，构建工具，编译信息，拥有者，干啥用的等信息。**<br />**通过这个信息，就可以自动为该功能包安装依赖，构建时确定编译顺序等**<br />查看小乌龟模拟器功能包的信息。
```bash
ros2 pkg xml turtlesim
```
<a name="WrcLt"></a>
## colcon:
colcon 是 ROS2 常用的构建工具。若系统未安装，可先执行：
```bash
sudo apt-get install python3-colcon-common-extensions
```
<a name="BzyYh"></a>
### 相关指令
<a name="moZ8W"></a>
### [5.1 只编译一个包](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_51-%e5%8f%aa%e7%bc%96%e8%af%91%e4%b8%80%e4%b8%aa%e5%8c%85)
```bash
colcon build --packages-select YOUR_PKG_NAME
```
<a name="Mb0AY"></a>
### [5.2 不编译测试单元](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_52-%e4%b8%8d%e7%bc%96%e8%af%91%e6%b5%8b%e8%af%95%e5%8d%95%e5%85%83)
```bash
colcon build --packages-select YOUR_PKG_NAME --cmake-args -DBUILD_TESTING=0
```
<a name="Dt5J5"></a>
### [5.3 运行编译的包的测试](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_53-%e8%bf%90%e8%a1%8c%e7%bc%96%e8%af%91%e7%9a%84%e5%8c%85%e7%9a%84%e6%b5%8b%e8%af%95)
```bash
colcon test
```
<a name="Gacar"></a>
### [5.4 允许通过更改src下的部分文件来改变install（重要）](https://fishros.com/d2lros2foxy/#/chapt3/3.3ROS2%E7%9A%84%E7%BC%96%E8%AF%91%E5%99%A8Colcon?id=_54-%e5%85%81%e8%ae%b8%e9%80%9a%e8%bf%87%e6%9b%b4%e6%94%b9src%e4%b8%8b%e7%9a%84%e9%83%a8%e5%88%86%e6%96%87%e4%bb%b6%e6%9d%a5%e6%94%b9%e5%8f%98install%ef%bc%88%e9%87%8d%e8%a6%81%ef%bc%89)
（每次调整 python 脚本时都不必重新build了）
```
colcon build --symlink-install
```
<a name="DEwTp"></a>
## 手写节点测试（C++）
这一节用 C++ 做一个最小可运行节点，重点是熟悉 ROS2 的节点编写、编译与安装流程。
<a name="b6gfN"></a>
### 创建工作空间与功能包
```bash
mkdir -p town_ws/src
cd town_ws/src
ros2 pkg create village_wang --build-type ament_cmake --dependencies rclcpp
```
创建完成的目录结构如下：<br />![image-20210727193256467.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709953867147-9f288dcf-5e47-4151-9465-e4418685f654.png#averageHue=%23300a24&clientId=u7f35f781-53fd-4&from=drop&id=ua3e86124&originHeight=118&originWidth=212&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=7896&status=done&style=none&taskId=u4fdf03cc-db2e-4232-9a0f-487eae2ca95&title=)
<a name="XZHy1"></a>
### POP 方式编写节点
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
    RCLCPP_INFO(node->get_logger(), "大家好，我是节点 wang2.");
    /* 运行节点，并检测退出信号*/
    rclcpp::spin(node);
    rclcpp::shutdown();
    return 0;
}

```
主函数中首先初始化rclcpp，然后新建了一个Node节点的对象，命名为wang2，接着使用rclcpp让这个节点暴露在外面，并检测退出信号（Ctrl+C），检测到退出信号后，就会执行rcl.shutdown()关闭节点。
<a name="FGd6F"></a>
#### 添加到cmakelists
在 CMakeLists.txt 中加入下面几行代码，让 `wang2.cpp` 被正常编译并安装：
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
这一步的作用是把编译产物安装到 ROS2 约定的目录中，否则 `ros2 run` 找不到对应节点。
<a name="WfmFe"></a>
#### 编译运行：
打开终端，进入 `town_ws` 后按下面顺序执行：
<a name="Z1Ujk"></a>
### 1. 编译节点
```bash
colcon build
```
<a name="FFV99"></a>
### 2. 加载环境
```bash
source install/setup.bash
```
<a name="xqzlR"></a>
### 3. 运行节点
```bash
ros2 run village_wang wang2_node
```
如果运行成功，你会看到节点打印自我介绍。此时再执行 `ros2 node list`，可以确认节点已经注册到系统中。<br />![a85481a9b56ae5cf6bee46a440140235.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709954465823-94f63561-dbe0-4ac6-90a6-3e3720ef2823.png#averageHue=%231f1d1c&clientId=u7f35f781-53fd-4&from=drop&id=ucbef2116&originHeight=317&originWidth=644&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=105682&status=done&style=none&taskId=u3d85a105-b651-4405-8a1d-378ebd2cea7&title=)<br />![972b7669eb967a31c2a0d959b7301ad9.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709954606260-0bd6726b-4a2b-4717-bf95-eba0cac67750.png#averageHue=%23363534&clientId=u7f35f781-53fd-4&from=drop&id=u21cafeca&originHeight=68&originWidth=437&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=14564&status=done&style=none&taskId=ubda76a82-e9ab-43e9-943a-dd83f8acea4&title=)
<a name="MJsrM"></a>
## OOP 方式编写节点

如果你希望把节点封装成类，便于后续扩展订阅器、定时器和服务端，可以改成下面这种写法。

还是在 `wang2.cpp` 中输入代码：
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
    RCLCPP_INFO(this->get_logger(), "大家好，我是节点 %s.", name.c_str());
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
这部分与上一节相同：更新 CMakeLists.txt、重新编译、重新 source，然后运行节点即可。<br />![8014891cb75b9e90255db630b7115fad.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709965221810-a121ef27-b3a9-42f7-a674-f23eee0c3e3b.png#averageHue=%231d1d1c&clientId=u488a9513-274b-4&from=drop&id=u35b36f1c&originHeight=1344&originWidth=1108&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=230404&status=done&style=none&taskId=u6451a532-fc8b-4701-8e02-2a8ab5680a6&title=)<br />运行成功后，说明类封装节点的方式已经走通。
<a name="zvknJ"></a>
## 通信
这一节开始进入 ROS2 的核心能力：节点之间通过标准通信接口交换数据。

这里用一个最小示例说明“发布者-订阅者”模型：

1. 发布者节点负责发送消息。
2. 订阅者节点负责接收消息。
3. 消息内容用字符串类型表示。

这是一个一对一示例，但在 ROS2 中，话题通信同样支持 1 对多、多对 1、多对多。
<a name="HgXzG"></a>
### 话题通讯
<a name="jWcs8"></a>
##### 死锁
这个例子的核心问题，不是“服务不好用”，而是**阻塞式等待和单线程执行器撞在了一起**。

假设服务回调里需要等待队列里攒够足够多的章节，才能把结果返回给客户端；但新章节又恰好依赖另一个订阅回调持续写入队列。如果节点仍然运行在默认的单线程执行器中，那么服务回调一旦阻塞，订阅回调就没有机会执行，队列也就永远补不满，这就是典型的死锁场景。

更直接地说：

- 服务回调在等队列变大。
- 订阅回调负责把数据写进队列。
- 单线程执行器一次只能跑一个回调。

结果就是两边互相等待，系统卡住。

解决办法有两种思路：

- 不在回调里做长时间阻塞等待，改成异步状态机或定时器驱动。
- 如果示例就是要保留阻塞式逻辑，那么至少把相关回调拆到合适的回调组里，并使用多线程执行器。
- 话题名字是关键,发布订阅接口类型要相同，发布的是字符串，接受也要用字符串来接收;
- 同一个人(节点)可以订阅多个话题，同时也可以发布多个话题，就像一本书的作者也可以是另外一本书的读者;
- 同一个小说不能有多个作者（版权问题），但跟小说不一样，同一个话题可以有多个发布者。
ROS2 里常见的做法是结合多线程执行器和回调组，把可能互相影响的回调拆开调度。先在 `SingleDogNode` 中声明一个服务回调组成员变量：

```cpp
<a name="FnJns"></a>
##### rqt_graph:
`rqt_graph` 可以直观看到节点和话题之间的连接关系，是排查通信问题时非常实用的工具。![image-20210803113450234.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1709972464260-688eb5ba-8779-4843-ad42-7a00609803f8.png#averageHue=%23e9e9e8&clientId=ud645a189-b8aa-4&from=drop&id=ud5918dcf&originHeight=591&originWidth=761&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=53857&status=done&style=none&taskId=u304193b0-36aa-4ccc-9cbe-cdec436b6b7&title=)

此时类的大致结构如下：

```cpp
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
### 订阅者示例

- 将wang2.cpp代码修改如下：
```cpp
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
        RCLCPP_INFO(this->get_logger(), "大家好，我是节点 %s.", name.c_str());
         // 创建一个订阅者，订阅名为 sexy_girl 的话题
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
使用 C++ 订阅话题，需要先引入对应的消息类型头文件：
```
#include "std_msgs/msg/string.hpp"
#include "std_msgs/msg/u_int32.hpp"
```
创建订阅者和发布者时，依然使用 `this->create_subscription` 和 `this->create_publisher`。<br />
在 C++ 中，类成员函数不能直接作为普通回调函数传入，因此这里使用 `std::bind` 把成员函数和当前对象实例绑定起来。你可以先把它理解成“把 `this` 和回调函数打包后交给 ROS2”。

- 编译运行
```
colcon build --packages-select village_wang
```

- source运行
<a name="KES9k"></a>
### 发布者示例

下面补一个最小发布者节点，用来把“发布-订阅”链路完整跑通。
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
```bash
ros2 interface show std_msgs/msg/String
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811860-73d814e9-0ad4-4f3c-8b03-cc84d50b8e00.png#averageHue=%23292929&clientId=ud3f5d7d5-6e8f-4&from=paste&id=uff812660&originHeight=114&originWidth=764&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=ufbd1877f-055c-45bb-b469-d1c4c124258&title=)
<a name="YVXNq"></a>
##### [输出某一个接口所有属性](https://fishros.com/d2lros2foxy/#/chapt4/4.5ROS2%E9%80%9A%E4%BF%A1%E6%8E%A5%E5%8F%A3%E4%BB%8B%E7%BB%8D?id=_45-%e8%be%93%e5%87%ba%e6%9f%90%e4%b8%80%e4%b8%aa%e6%8e%a5%e5%8f%a3%e6%89%80%e6%9c%89%e5%b1%9e%e6%80%a7)
```bash
ros2 interface proto sensor_msgs/msg/Image
```
![](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710036811870-5f07a163-7673-4f56-a3c5-337c13939d9a.png#averageHue=%23212121&clientId=ud3f5d7d5-6e8f-4&from=paste&id=u9b08528d&originHeight=208&originWidth=611&originalType=url&ratio=1.5625&rotation=0&showTitle=false&status=done&style=none&taskId=uf0315698-41a2-4e5e-b260-a5dff7aa66e&title=)

<a name="PJTRk"></a>
#### 服务与话题的区别

话题更适合连续数据流，通常没有即时返回结果；服务则是典型的请求-响应模型，客户端发起请求，服务端处理后返回结果。
<a name="JJ4MV"></a>
### 自定义话题接口

- 新建工作空间

在town_ws的src文件夹下，运行下面的指令，即可完成village_interfaces功能包的创建。    <br /> 	**注意，这里包的编译类型我们使用ament_cmake方式。**
```bash
ros2 pkg create village_interfaces --build-type ament_cmake 
```
![image-20210809151545012.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710037304935-3b720491-175f-421f-b8b8-cd410932ca33.png#averageHue=%23212121&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u0e50a9c7&originHeight=179&originWidth=503&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=15650&status=done&style=none&taskId=u951c0305-6102-4c35-885a-e55d3f3c93b&title=)


- 新建msg文件和Novel.msg（小说消息）

**注意：消息文件名首字母通常使用大写，便于和生成后的类型名保持一致。**
```bash
cd village_interfaces
mkdir msg
touch Novel.msg 

```


- 编写Novel.msg内容

这里的目标是定义一个复合消息：既包含文本内容，也包含图像数据。文本部分可以用 `string` 或 `std_msgs/String` 表示，图像部分则使用 `sensor_msgs/Image`。在 `msg` 文件中可以使用 `#` 添加注释。
```
# 标准消息接口std_msgs下的String类型
std_msgs/String content
# 图像消息，调用sensor_msgs下的Image类型
sensor_msgs/Image image
```
可以把这类自定义消息理解成三层组合：最上层是你定义的消息，中间层是 ROS2 的标准消息类型，最底层是 `string`、`uint32` 这类基础数据类型。ROS2 的所有接口本质上都是这样逐层组合出来的。
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


### 另一种写法

我们不使用std_msgs/String 而是直接使用最下面一层的string。
```
# 直接使用ROS2原始的数据类型
string content
# 图像消息，调用sensor_msgs下的Image类型
sensor_msgs/Image image
```

### 为什么可以直接使用 string

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
```cmake
#添加对sensor_msgs的
find_package(sensor_msgs REQUIRED)
find_package(rosidl_default_generators REQUIRED)
#添加消息文件和依赖
rosidl_generate_interfaces(${PROJECT_NAME}
"msg/Novel.msg"
    DEPENDENCIES sensor_msgs
    )
```
`find_package` 用于查找依赖，`rosidl_generate_interfaces` 用于声明接口文件和依赖。这里有两个常见坑：

1. `DEPENDENCIES` 里的依赖要写全，否则有些问题会在运行时才暴露。
2. `rosidl_generate_interfaces()` 必须写在 `ament_package()` 之前。

代码大概是这样的<br />![e3877412c40448c0995ba2884a1ae7c1.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710038380883-6becece5-b4cd-4c3d-bc11-cdcffa9dcf1d.png#averageHue=%23201f1f&clientId=ud3f5d7d5-6e8f-4&from=drop&id=ua4ec7301&originHeight=843&originWidth=1469&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=471267&status=done&style=none&taskId=u795fc122-a6a1-4427-9f9d-d20f8507983&title=)

- 修改package.xml

修改 `village_interfaces` 目录下的 `package.xml`，显式添加依赖更稳妥，能减少环境差异带来的问题。
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
先运行一个服务节点：
```bash
ros2 run examples_rclpy_minimal_service service
```

这个服务的作用很简单：输入两个整数，返回它们的和。
<a name="OhYmw"></a>
##### 查看服务列表
```bash
ros2 service list
```
<a name="ZNyUa"></a>
##### 手动调用服务

注意请求体里的 YAML 格式要写对：

```bash
ros2 service call /add_two_ints example_interfaces/srv/AddTwoInts "{a: 5,b: 10}"
```

这条命令建议在另一个终端里执行。
<a name="RHF6C"></a>
##### 查看服务接口类型
```bash
ros2 service type /add_two_ints

```
<a name="AIADv"></a>
##### 查找使用某一接口的服务
```bash
ros2 service find example_interfaces/srv/AddTwoInts

```
<a name="X9wyU"></a>
#### 自定义服务接口
先看一下服务接口的基本格式。一个 `.srv` 文件分成请求和响应两部分：
```
int64 a
int64 b
---
int64 sum
```
与话题不同，`srv` 文件中间多出的 `---` 就是分界线：上面定义请求结构，下面定义响应结构。可以按下面顺序创建自定义服务：

- 新建srv文件夹，并在文件夹下新建xxx.srv
- 在xxx.srv下编写服务接口内容并保存
- 在CmakeLists.txt添加依赖和srv文件目录
- 在package.xml中添加xxx.srv所需的依赖
- 编译功能包即可生成python与c++头文件

在动手写 `.srv` 文件之前，先根据业务需求确定请求和返回的数据结构。这里依然在 `village_interfaces` 下创建服务接口。

假设需求如下：

1. 请求方必须携带借条信息，服务端收到后才继续处理。
2. 单次放款金额不能超过当前可用资金的 10%，并且金额必须是整数。

总结一下，借钱请求至少要包含两条信息：

- 借钱者名字，字符串类型、可以用string表示
- 金额，整形，可以用uint32表示

确定了请求结构后，再设计返回结构。既然服务端可能同意，也可能拒绝，那么返回值至少需要两项：

- 是否出借：只有成功和失败两种情况，布尔类型（bool）可表示
- 出借金额：无符号整形，可以用uint32表示，借钱失败时为0。
<a name="SOi0x"></a>
##### 创建srv文件夹及BorrowMoney.srv消息文件
在village_interfaces下新建srv文件夹<br />![image-20210811162010736.png](https://cdn.nlark.com/yuque/0/2024/png/39221021/1710038764606-c8035912-d3b5-4a18-8758-978165a7a504.png#averageHue=%23222222&clientId=ud3f5d7d5-6e8f-4&from=drop&id=u87e80afd&originHeight=160&originWidth=471&originalType=binary&ratio=1.5625&rotation=0&showTitle=false&size=14984&status=done&style=none&taskId=u6fcc9d9a-d569-433f-86c9-0a6ed8b969f&title=)
<a name="yxyCD"></a>
##### 编写文件内容
```srv
string name
uint32 money
---
bool success
uint32 money
```
<a name="efh5K"></a>
##### 修改CMakeLists.txt
我们已经添加过 `msg` 文件和依赖，所以这里直接再加入一个 `srv` 文件即可。
```cmake
find_package(rosidl_default_generators REQUIRED)
rosidl_generate_interfaces(${PROJECT_NAME}
  #---msg---
  "msg/Novel.msg"
  #---srv---
  "srv/BorrowMoney.srv"
  DEPENDENCIES sensor_msgs
 )
```
需要关注的是 `"srv/BorrowMoney.srv"` 这一行，它告诉构建系统要生成对应的服务接口代码。

- 踩坑：在rosidl_generate_interfaces()函数中传递了一个依赖项sensor_msgs，但是在使用find_package()函数之前没有找到它。需要在CMakeLists.txt 文件中添加find_package(sensor_msgs REQUIRED)，以确保 **sensor_msgs** 包被正确地找到和链接。
<a name="io4wO"></a>
##### 修改 package.xml
```xml
  <build_depend>sensor_msgs</build_depend>
  <build_depend>rosidl_default_generators</build_depend>
  <exec_depend>rosidl_default_runtime</exec_depend>
  <member_of_group>rosidl_interface_packages</member_of_group>

```
<a name="Ink82"></a>
##### 编译
```bash
colcon build --packages-select village_interfaces
```
<a name="lVN2C"></a>
##### 测试
这次测试我们依然使用ros2 interface指令进行测试。
```bash
source install/setup.bash 
ros2 interface package village_interfaces
ros2 interface show village_interfaces/srv/BorrowMoney
ros2 interface proto village_interfaces/srv/BorrowMoney 
```
<a name="uONPm"></a>
#### 服务的c++实现
**一句话：客户端发起请求，服务端按约定规则处理后返回结果，可按下面步骤实现。**

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
这个例子的关键问题，是阻塞式等待放在了单线程执行器里。

如果服务回调需要等待队列中积累足够多的数据才能返回，而补充队列的数据又依赖另一个订阅回调，那么单线程执行器就会出现典型的互相等待：服务回调占住线程时，订阅回调得不到执行机会，队列也就永远补不满。

可以把这个问题理解成三句话：

- 服务回调在等待库存变多。
- 订阅回调负责补库存。
- 单线程执行器一次只能处理一个回调。

这就是死锁产生的根源。

工程上更稳妥的方案，是避免在回调里做长时间阻塞；如果教程里暂时保留这种写法，那么就应该配合回调组和多线程执行器，让订阅回调仍然有机会继续运行。
<a name="aZhlq"></a>
##### 回调函数组
ROS2 中通常通过“回调组 + 多线程执行器”的组合来解决这类问题。先在 `SingleDogNode` 中声明一个服务回调组成员变量：
```cpp
// 声明一个服务回调组
rclcpp::CallbackGroup::SharedPtr callback_group_service_;
```
完整结构大致如下：
```cpp
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
回调组本身也是对象，可以在构造函数中通过 `create_callback_group` 创建：

```cpp
callback_group_service_ = this->create_callback_group(rclcpp::CallbackGroupType::MutuallyExclusive);
```

因为这里使用成员函数作为服务回调，所以还要准备好两个占位符，对应请求和响应两个参数：

```cpp
using std::placeholders::_1;
using std::placeholders::_2;
```

然后在 `private:` 区域声明服务端：

```cpp
// 声明一个服务端
rclcpp::Service<village_interfaces::srv::SellNovel>::SharedPtr server_;
```

最后在构造函数中实例化服务端：

```cpp
// 实例化卖二手书的服务
server_ = this->create_service<village_interfaces::srv::SellNovel>("sell_novel",
                            std::bind(&SingleDogNode::sell_book_callback,this,_1,_2),
                            rmw_qos_profile_services_default,
                            callback_group_service_);
```
这段代码的四个参数分别表示：

- `sell_novel`：服务名。
- `std::bind(&SingleDogNode::sell_book_callback, this, _1, _2)`：服务请求到来时执行的回调。
- `rmw_qos_profile_services_default`：服务通信使用默认 QoS。
- `callback_group_service_`：把这个服务回调放进前面创建的回调组里，便于后续由多线程执行器调度。
<a name="q5mnn"></a>
##### 编写回调函数
下面是一个直接可运行的服务回调示例：

```cpp
// 声明一个回调函数，当收到买书请求时调用该函数，用于处理数据
    void sell_book_callback(const village_interfaces::srv::SellNovel::Request::SharedPtr request,
        const village_interfaces::srv::SellNovel::Response::SharedPtr response)
    {
        RCLCPP_INFO(this->get_logger(), "收到一个买书请求，一共给了%d钱",request->money);
        unsigned int novelsNum = request->money*1;  //应给小说数量，一块钱一章

        // 判断当前库存是否满足需求，不够则进入等待
        if(novels_queue.size()<novelsNum)
        {
            RCLCPP_INFO(this->get_logger(), "当前章节库存为%d，暂时不能满足请求，开始等待",novels_queue.size());

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
                // 打印一下当前库存和缺口
                RCLCPP_INFO(this->get_logger(), "等待中，目前已有%d章，还差%d章",novels_queue.size(),novelsNum-novels_queue.size());

                //rate.sleep()让整个循环1s运行一次
                loop_rate.sleep();
            }
        }
        // 章节数量满足需求了
        RCLCPP_INFO(this->get_logger(), "当前章节库存为%d，已经满足请求",novels_queue.size());

        //一本本把书取出来，放进请求响应对象response中
        for(unsigned int i =0 ;i<novelsNum;i++)
        {
            response->novels.push_back(novels_queue.front());
            novels_queue.pop();
        }
    }
```

这段逻辑可以按下面的顺序理解：

- 先根据请求参数计算本次需要返回多少章节。
- 如果库存不足，就暂时等待队列补充。
- 一旦队列数量满足条件，就把内容逐个写入响应对象。

与此同时，订阅回调也要负责把收到的新章节写入队列：

```cpp
// 收到话题数据的回调函数
 void topic_callback(const std_msgs::msg::String::SharedPtr msg){
     // 新建一张人民币
     std_msgs::msg::UInt32 money;
     money.data = 10;

    // 发送稿费消息
    pub_->publish(money);
    RCLCPP_INFO(this->get_logger(), "收到新章节：'%s'，并支付稿费：%d 元", msg->data.c_str(),money.data);

    // 将章节放入缓存队列
    novels_queue.push(msg->data);
};
```
<a name="S7CCg"></a>
##### 修改main函数
因为这个例子依赖服务回调和订阅回调并行推进，所以 `main` 函数里也要把默认执行器换成多线程执行器：

```cpp
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

如果你只是想验证“多线程执行器是否生效”，可以先保留示例逻辑不动，观察服务等待期间订阅回调是否还能继续写入队列；这比单纯记概念更容易理解为什么这里一定要切到 `MultiThreadedExecutor`。

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
