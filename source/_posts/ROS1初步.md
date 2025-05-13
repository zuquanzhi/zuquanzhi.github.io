---
title: ROS1初步
tags: ROS
categories: 718
abbrlink: 51251
date: 2024-03-11 20:12:21
cover: https://www.loliapi.com/acg?6
---

<a name="J4y9t"></a>
# Topic与Message
<!--more-->
基础概念：<br />1.话题Topic是节点间进行持续通讯的一种形式<br />2.话题通讯的两个节点通过话题的名称建立起话题通讯连接。<br />3.话题中通讯的数据，叫做消息Message<br />4.消息Message通常会按照一定的频率持续不断的发送，以保证消息数据的实时性。<br />5.消息的发送方叫做话题的发布者Publisher<br />6.消息的接收方叫做话题的订阅者Subsciber<br />更多有：<br />1.一个ROS节点网络中，可以同时存在多个话题<br />2.一个话题可以有多个发布者，也可以有多个订阅者<br />3.一个节点可以对多个话题进行订阅，也可以发布多个话题<br />4.不痛得传感器消息通常会拥有各自独立话题名称，每个话题只有一个发布者<br />5.机器人速度指令话题通常会有多个发布者，但是同一时间只能有一个发言人。
<a name="v1QhS"></a>
## Topic的C++实现
发布者的具体步骤：<br />1.确定话题名称和消息类型<br />2.在代码文件中include消息类型对应的头文件<br />3.在main函数中通过NodeHandler大管家发布一个话题并得到消息发送对象<br />4.生成要发送的消息包并进行发送数据的赋值。<br />5.调用消息发送对象的publish()函数将消息包发送到话题当中。<br />为了查看有关的Topic我们可以使用以下的常用工具：<br />rostopic list<br />列出当前系统汇总所有活跃着的话题<br />rostopic echo 主体名称<br />显示指定话题中发送的消息包内容<br />rostopic hz 主体名称<br />统计指定话题中消息包的发送频率<br />而话题的订阅需要满足以下的步骤：<br />1.确定话题名称和消息类型<br />2.在代码文件中include<ros.h>和消息类型对应的头文件<br />3.在main函数中通过NodeHandler大管家订阅一个话题并设置消息接收回调函数<br />4.定义一个回调函数，对接收到的消息包进行处理。<br />5.main函数中需要执行ros::spinOnce()，让回调函数能够响应接受到的消息包
<a name="JxKTI"></a>
### 代码实现
```cpp
#include <ros/ros.h>
#include <std_msgs/String.h>
using namespace ros;
int main(int argc, char *argv[])
{
  init(argc, argv, "chao_node");
  printf("node_chao is running\n");

  NodeHandle nh;
  Publisher pub = nh.advertise<std_msgs::String>("node_chao", 10);
    //这里第二个参数表示缓存空间
  Rate loop_rate(10);
  while (ok())
  {
    printf("chao is sending\n");
    std_msgs::String msg;
    msg.data = "chao is sending message";
    pub.publish(msg);
    loop_rate.sleep();
  }
  return 0;
}
```

```cpp
#include <ros/ros.h>
#include <std_msgs/String.h>
#include <bits/stdc++.h>

using namespace std;
using namespace ros;

void chao_callback(std_msgs::String msg)
{
  ROS_INFO(msg.data.c_str());
}

void yao_callback(std_msgs::String msg)
{
  ROS_WARN(msg.data.c_str());
}
int main(int argc, char *argv[])
{
  init(argc, argv, "ma_node");

  NodeHandle nh;

  Subscriber sub = nh.subscribe("node_chao", 10, chao_callback);
	//这里第三个参数类似于单片机里的中断函数
  Subscriber sub_yao = nh.subscribe("node_yao", 10, yao_callback);
  while (ok())
  {
    spinOnce();
  }
  return 0;
}
```
<a name="L26MD"></a>
### 图形化界面rqt_graph
运行三个节点和roscore，然后在一个新的终端中输入rqt_graph可以得到一个用来观察当前消息链路的图形化界面<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705307614453-48eb5146-7ae3-40e1-b12c-6cc0a99ed5cb.png#averageHue=%23817243&clientId=ued9d9fb6-a67b-4&from=paste&height=586&id=u8f7c53f5&originHeight=1172&originWidth=2532&originalType=binary&ratio=2&rotation=0&showTitle=false&size=466221&status=done&style=none&taskId=u54a4f49e-81fd-4e78-bf60-cd6d364613b&title=&width=1266)
<a name="DLwhc"></a>
### launch文件同时启动多个节点
launch文件是一种遵循XML语法的描述文件，这里启动多个节点只是launch文件的功能之一。 <br />对应到启动节点，我们可以使用这个流程：<br />1.使用launch文件，可以通过roslaunch指令一次启动多个节点。<br />2.在launch文件中，为节点添加output="screen"属性，可以容纳个节点信息输出在终端中。（ROS_WARN不受该属性控制）<br />3.在launch文件中，为节点添加launch-prefix="gnome-terminal -e"属性，可以让节点单独运行在一个独立终端中。<br />具体的，我们使用这个代码：
```xml
<launch>
  <node pkg="ssr_pkg" type="yao_node" name="yao_node" />
  <node pkg="ssr_pkg" type="chao_node" name="chao_node" launch-prefix="gnome-terminal -e" />
  <node pkg="atr_pkg" type="ma_node" name="ma_node" output="screen" />
</launch>
```
而我们使用时只需要在终端中使用
```cpp
roslaunch 包名 launch文件名
```
就可以运行了
<a name="Xp45g"></a>
## Topic的python实现
python实现基本上和c++实现差不多，无非就是c++中的NodeHandler变成了python中的rospy<br />看看代码
```python
#!/usr/bin/python3
# coding=utf-8
#说明解释器和编码
import rospy
from std_msgs.msg import String

if __name__ == "__main__": #主函数
    rospy.init_node("chao_node")#申明节点
    rospy.logwarn("node chao is running")#启动标签，打个warn让你吓一跳（
    pub = rospy.Publisher("node_chao", String, queue_size=10)
    rate = rospy.Rate(10)#控制频率
    while not rospy.is_shutdown():
        rospy.loginfo("node chao is sending message")
        msg = String()
        msg.data = "this is node chao's message"
        pub.publish(msg)
        rate.sleep()

```
接收端：
```python
#!/usr/bin/python3
# coding=utf-8

import rospy
from std_msgs.msg import String


def chao_callback(msg):
    rospy.loginfo(msg.data)


def yao_callback(msg):
    rospy.logwarn(msg.data)


if __name__ == "__main__":
    rospy.init_node("ma_node")

    sub = rospy.Subscriber("node_chao", String, chao_callback, queue_size=10)
    sub1 = rospy.Subscriber("node_yao", String, yao_callback, queue_size=10)
    rospy.spin()
```
```python
#!/usr/bin/python3
# coding=utf-8

import rospy
from std_msgs.msg import String


def chao_callback(msg):
    rospy.loginfo(msg.data)


def yao_callback(msg):
    rospy.logwarn(msg.data)


if __name__ == "__main__":
    rospy.init_node("ma_node")

    sub = rospy.Subscriber("node_chao", String, chao_callback, queue_size=10)
    sub1 = rospy.Subscriber("node_yao", String, yao_callback, queue_size=10)
    rospy.spin()
```
和c++的程序实现十分相似<br />值得说明的是，在launch中c++直接是一个可执行文件，而python则是要加入后缀py
```xml
<launch>
  <node pkg="ssr_py_pkg" type="yao_node.py" name="yao_node" />
  <node pkg="ssr_py_pkg" type="chao_node.py" name="chao_node" />
  <node pkg="atr_py_pkg" type="ma_node.py" name="ma_node" launch-prefix="gnome-terminal -e" />
</launch>
```
<a name="Wz45W"></a>
# service
service是ros中另一种通讯方式，类似于服务器和终端之间请求式的关系。<br />主要操作步骤分为：<br />1.服务端Server注册<br />2.客户端Client注册<br />3.节点管理器进行话题匹配<br />4.服务端请求服务<br />5.服务端提供服务
<a name="OQdRg"></a>
## 终端指令的实现
我们使用ros自带的小乌龟来手动模拟一下一个service实现的过程<br />首先启动ros核心并召唤出小乌龟<br />然后使用
```python
rosrun rqt_service_caller rqt_service_caller
```
召唤出图形化的service界面<br />按照<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705388668505-d518fb03-f941-4f5c-b0f6-7f08d92ac516.png#averageHue=%23ede7e5&clientId=u36e31b96-9ee5-4&from=paste&height=435&id=uc21508a1&originHeight=956&originWidth=940&originalType=binary&ratio=2.200000047683716&rotation=0&showTitle=false&size=271004&status=done&style=none&taskId=uda7225e4-f750-48cd-b154-967e9ec5ca3&title=&width=427.27271801184054)<br />来配置<br />就能看到图上出现了一只新的小乌龟<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705388704513-fa622c00-39a1-498e-85e3-d908b340bc3e.png#averageHue=%234556fe&clientId=u36e31b96-9ee5-4&from=paste&height=255&id=u07d8973e&originHeight=562&originWidth=504&originalType=binary&ratio=2.200000047683716&rotation=0&showTitle=false&size=20276&status=done&style=none&taskId=u4f0b890d-9656-4f8d-9ad6-8a5d36bee53&title=&width=229.09090412549747)

<a name="zoD2G"></a>
## c++实现
<a name="T27RX"></a>
### 客户端
```cpp
#include "ros/ros.h"
#include "service_test/service_test.h"
using namespace std;
class service_client
{
private:
  /* data */
  ros::NodeHandle nh;
  int a, b;

public:
  service_client();
  ~service_client();
  ros::ServiceClient client;
  void request();
};

service_client::service_client()
{
  a = 0;
  b = 0;
  client = nh.serviceClient<service_test::service_test::Request>("a_b");
}
void service_client::request()
{
  cout << "request" << endl;
  service_test::service_test req;
  req.request.numb1 = a;
  req.request.numb2 = b;
  if (client.call(req))
  {
    cout << a << "+" << b << "=" << req.response.sum << endl;
  }
  else
  {
    cout << "request falied" << endl;
  }
  a++;
  b += 2;
}
service_client::~service_client()
{
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "service_client");
  ROS_INFO("service_client is started");
  service_client service_client;
  ros::Rate rate(10);
  while (ros::ok())
  {
    service_client.request();
    rate.sleep();
  }
  return 0;
}

```
这里用一个类写了一下这个东西，实现了一个a+b的不断请求<br />注意一下里面的核心语句：
```xml
serviceClient<service_test::service_test::Request>("a+b");
```
这里定义了最重要的服务名
```xml
req.request.numb1 = a;
  req.request.numb2 = b;
  if (client.call(req))
  {
    cout << a << "+" << b << "=" << req.response.sum << endl;
  }
```
这里以req为媒介去询问并获得数据
<a name="rS9TQ"></a>
### 服务端
```cpp
#include "ros/ros.h"
#include "service_test/service_test.h"
using namespace std;
class service_server
{
private:
  /* data */
  ros::NodeHandle nh;

public:
  service_server(/* args */);
  ~service_server();
  ros::ServiceServer server;
  bool requestCallback(service_test::service_test::Request &request, service_test::service_test::Response &response);
};

service_server::service_server(/* args */)
{
  server = nh.advertiseService("a_b", &service_server::requestCallback, this);
}
bool service_server::requestCallback(service_test::service_test::Request &request, service_test::service_test::Response &response)
{
  cout << "a request is handled" << endl;
  response.sum = request.numb1 + request.numb2;
  return true;
}

service_server::~service_server()
{
}

int main(int argc, char **argv)
{
  ros::init(argc, argv, "service_server");
  ROS_INFO("service_server is started");
  service_server server;
  ros::Rate rate(10);
  ros::spin();
  return 0;
}

```
这里核心为：
```cpp
advertiseService("a_b", &service_server::requestCallback, this);
```
这里前面是名字，后面有返回参数，不过这个this我看了半天也没明白是什么，我看如果没有写类的话这里好像只有两个参数，所以我大胆猜测这个是用来指向类的一个东西？
<a name="RRsNw"></a>
### 具体实现
再cmakelists中加入
```cpp
add_executable(service_client src/service_client.cpp)  
target_link_libraries(service_client
    ${catkin_LIBRARIES}) 
add_dependencies(service_client ${catkin_EXPORTED_TARGETS})

add_executable(service_server src/service_server.cpp)  
target_link_libraries(service_server
    ${catkin_LIBRARIES}) 
add_dependencies(service_server ${catkin_EXPORTED_TARGETS})
```
然后编译运行<br />效果：![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705392274716-e9b41739-0415-4df2-964b-0a2a2bb01b27.png#averageHue=%231e1a1a&clientId=ue763d424-91f3-4&from=paste&height=440&id=u37dec1cb&originHeight=968&originWidth=1456&originalType=binary&ratio=2.200000047683716&rotation=0&showTitle=false&size=257893&status=done&style=none&taskId=uf53eabec-6008-468b-a83f-f7a4cd72232&title=&width=661.8181674736594)
<a name="OpNbK"></a>
## python实现
<a name="sOxSw"></a>
### 服务端：
```python
#!/usr/bin/python3
# encoding: utf-8

import rospy
from service_test.srv import service_test, service_testResponse

def addCallback(req):
    sum = req.numb1 + req.numb2
    rospy.loginfo("a request is being handled")
    return service_testResponse(sum)

if __name__ == "__main__":
    rospy.init_node("add_server")
    # 创建一个名为add_server的server，注册回调函数addCallback,返回类型为service_test
    server = rospy.Service("add_server", service_test, addCallback)

    rospy.loginfo("server is Ready.")
    rospy.spin()

```
其实具体思路和c++很相似，就有个坑，第五行那两个，我本来以为只要自定义两个当作输入输出就行了，后来发现好像不大行，必须严格按照他这个格式。
<a name="Mphok"></a>
### 客户端
```python
#!/usr/bin/python3
# encoding: utf-8

import rospy
from service_test.srv import *


def add_two_ints_client(x, y):
    rospy.wait_for_service("add_server")
    add_two_ints = rospy.ServiceProxy("add_server", service_test)
    resp = add_two_ints(x, y)
    rospy.loginfo("sum:%lf", resp.sum)


if __name__ == "__main__":
    rospy.init_node("add_client")
    x = 0.1585
    y = 15.21
    add_two_ints_client(x, y)

```
这位更是十分简洁，没啥问题。记得和srv里文件一定就行了。<br />说起来为啥C语言要搞成.h而python只要srv呢（
<a name="DPKCw"></a>
### 效果![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705478826907-6a743179-d0cd-490d-be0c-760eb509f9b5.png#averageHue=%231e1b1a&clientId=ubbf6ae85-b225-4&from=paste&height=492&id=u874c5b1f&originHeight=984&originWidth=1476&originalType=binary&ratio=2.200000047683716&rotation=0&showTitle=false&size=191244&status=done&style=none&taskId=ufb54405b-e108-494f-a287-1060d7db19b&title=&width=738)
<a name="gMt1l"></a>
# param
<a name="QUW9p"></a>
## 原理
举个栗子，我现在手里有一组数据，现在很多个节点都在想要得到我这个数据，如果使用前面的两种通讯方式，我开个topic在里面公麦喊数据显然不太合理，或者再开一个服务器呢？看起来好像不错，但是我们要维持这个端口一方面得一直开着这个节点，另一方面要不断的对外输出数据还得自己手写，而且各种数据类型还都不好处理。这个时候就需要我们的参数服务器登场了。<br />![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705485702889-26424fa6-e2ba-4130-ae19-545ad789e272.png#averageHue=%23f5f5f5&clientId=u670af268-3edf-4&from=paste&height=280&id=u95f2ebc6&originHeight=559&originWidth=1024&originalType=binary&ratio=2&rotation=0&showTitle=false&size=43576&status=done&style=none&taskId=ufb874013-3788-41b9-8c63-bc7cf6c85c4&title=&width=512)<br />在这里总计有三个角色，但是实际操作起来的时候，我们并不需要向之前一样像master注册身份，而是只要连接到master之后就可以进行全部的操作。<br />当然了为了书写的方便我们在实现中依旧将get和set分开写。值得注意的是，参数服务器不随着set的关闭而关闭，而是随着roscore的启动一直存在。
<a name="aKczn"></a>
## c++的实现
<a name="UUER6"></a>
### set
```cpp
#include <ros/ros.h>

using namespace std;
using namespace ros;

int main(int argc, char **argv)
{
  setlocale(LC_ALL, "");
  init(argc, argv, "param_set");
  NodeHandle nh;

  {
    string name = "vbot";
    string geometry = "rectangle";
    double wheel_radius = 0.1;
    int wheel_num = 4;
    bool vision = true;
    vector<double> base_size = {0.7, 0.6, 0.3};
    map<string, int> sensor_id = {{"camera", 0}, {"laser", 2}};
    // 设置参数
    nh.setParam("name", 'vbot');               // 字符串, 机器人的名字，char*
    nh.setParam("geometry", geometry);         // 字符串, 形状，string
    nh.setParam("wheel_radius", wheel_radius); // 车轮半径double
    param::set("wheel_num", wheel_num);        // 车轮数量int
    param::set("vision", vision);              // 是否具有视觉bool
    param::set("base_size", base_size);        // 三维体积vector
    param::set("sensor_id", sensor_id);        // 传感器的id，map
    // 验证是否设置成功
    system("rosparam get name");
    system("rosparam get geometry");
    system("rosparam get wheel_radius");
    system("rosparam get wheel_num");
    system("rosparam get vision");
    system("rosparam get base_size");
    system("rosparam get sensor_id");
  }
  return 0;
}
```
这里我们描述了一个机器人，将这个机器人的各个参数传入了参数服务器<br />值得说明的是，这里用了两种写法来写入数据，一种是用NodeHandle，一种直接调用了param里的函数<br />另外system这里不知道为什么会给个warning，无视就行了
<a name="OjksJ"></a>
### get
```cpp
#include <ros/ros.h>

using namespace std;
using namespace ros;

int main(int argc, char **argv)
{
  setlocale(LC_ALL, "");
  init(argc, argv, "param_get");
  NodeHandle nh;
  // 修改参数
  nh.setParam("name", "mybot"); // 字符串, char*

  vector<double> base_size = {0.2, 0.04};
  nh.setParam("base_size", base_size); // vector
  map<string, int> sensor_id = {{"camera", 0}, {"laser", 2}};
  sensor_id.insert({"ultrasonic", 5});
  param::set("sensor_id", sensor_id); // map

  // 获取参数

  string name;
  string geometry;
  double wheel_radius;
  int wheel_num;
  bool vision;
  nh.getParam("name", name);
  nh.getParam("geometry", geometry);
  nh.getParam("wheel_radius", wheel_radius);
  nh.getParam("wheel_num", wheel_num);
  nh.getParam("vision", vision);
  nh.getParam("base_size", base_size);
  nh.getParam("sensor_id", sensor_id);
  ROS_INFO("ros::NodeHandle getParam, name: %s, geometry: %s, wheel_radius: %lf, wheel: %d, vision: %s, base_size: (%lf, %lf)",
           name.c_str(), geometry.c_str(), wheel_radius, wheel_num, vision ? "true" : "false",
           base_size[0], base_size[1]);
  for (auto sensor : sensor_id)
  {
    ROS_INFO("ros::NodeHandle getParam, %s_id: %d", sensor.first.c_str(), sensor.second);
  }

  // 删除参数

  nh.deleteParam("vision");
  system("rosparam get vision");
  return 0;
}
```
这里好像也没有什么要说明的了，大家看看就行了
<a name="PVfKq"></a>
### cmake
```cmake
add_executable(param_set src/param_set.cpp)
add_executable(param_get src/param_get.cpp)
target_link_libraries(param_set
  ${catkin_LIBRARIES}
)

target_link_libraries(param_get
  ${catkin_LIBRARIES}
)
```
<a name="X1725"></a>
### 其他功能
param函数直接返回值，不存在则返回default_val，getparamcached函数好象是getparam的进阶版，加了个记搜？getparamnames返回所有值，以vector形式给出。
<a name="EWhdA"></a>
### 效果
![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705486990088-41376b0a-9140-4996-8f12-a6679c204d01.png#averageHue=%231f1b1b&clientId=u670af268-3edf-4&from=paste&height=506&id=uf0ed96e3&originHeight=1012&originWidth=1508&originalType=binary&ratio=2&rotation=0&showTitle=false&size=247069&status=done&style=none&taskId=u607c6b38-a903-4ac5-ab4b-8f6db920f4c&title=&width=754)
<a name="dsWxB"></a>
## python实现
<a name="mnReF"></a>
### set
```python
#!/usr/bin/python3
# coding=utf-8

import rospy
import os


if __name__ == "__main__":
    rospy.init_node("param_hello_world_set")

    # 设置参数
    rospy.set_param("name", "vbot")  # 字符串, string
    rospy.set_param("geometry", "rectangle")  # 字符串, string
    rospy.set_param("wheel_radius", 0.1)  # double
    rospy.set_param("wheel_num", 4)  # int
    rospy.set_param("vision", True)  # bool
    rospy.set_param("base_size", [0.7, 0.6, 0.3])  # list
    rospy.set_param("sensor_id", {"camera": 0, "laser": 2})  # dictionary

    # 验证是否设置成功
    os.system("rosparam get name")
    os.system("rosparam get geometry")
    os.system("rosparam get wheel_radius")
    os.system("rosparam get wheel_num")
    os.system("rosparam get vision")
    os.system("rosparam get base_size")
    os.system("rosparam get sensor_id")
```
<a name="pLckx"></a>
### get
```python
#!/usr/bin/python3
# coding=utf-8

import rospy
import os


if __name__ == "__main__":
    rospy.init_node("param_hello_world_set")

    # 设置参数
    rospy.set_param("name", "vbot")  # 字符串, string
    rospy.set_param("geometry", "rectangle")  # 字符串, string
    rospy.set_param("wheel_radius", 0.1)  # double
    rospy.set_param("wheel_num", 4)  # int
    rospy.set_param("vision", True)  # bool
    rospy.set_param("base_size", [0.7, 0.6, 0.3])  # list
    rospy.set_param("sensor_id", {"camera": 0, "laser": 2})  # dictionary

    # 验证是否设置成功
    os.system("rosparam get name")
    os.system("rosparam get geometry")
    os.system("rosparam get wheel_radius")
    os.system("rosparam get wheel_num")
    os.system("rosparam get vision")
    os.system("rosparam get base_size")
    os.system("rosparam get sensor_id")
```
这个实在是没啥好讲的，看代码就行了（
<a name="OTwIA"></a>
# Action
<a name="JC3y8"></a>
## 用途：
在实际中，有的时候通讯的时间是非常长的，而在通讯过程中，我们需要掌握中间值，比如我们要下载一个东西，我们可能时不时就要看一看下载进度，这个时候进度就是所需要的反馈feedback值<br />Action在结构上几乎和服务service相似，所以我暂时将其理解为service with feedback(?)
<a name="yurY8"></a>
## 实现：
说实话这个实现有点阴间，我也只是把教程里的那个东西实现了一下，要自己纯手搓感觉不好实现（
<a name="fAysR"></a>
### 文件分层：
![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705559399543-95ef64ac-bbf9-47a2-a75d-de38c50c3d9c.png#averageHue=%23060504&clientId=ucf2197ff-0c36-4&from=paste&height=74&id=ub74f1fe7&originHeight=370&originWidth=468&originalType=binary&ratio=2&rotation=0&showTitle=false&size=41409&status=done&style=none&taskId=u7efe1ed1-fea5-401f-9729-b13df614435&title=&width=93.6)
<a name="CiRbu"></a>
### laundry.action
```
# goal，洗衣类型 1:开始快洗;2:开始高温洗;3:开始浸泡洗
uint8 wash_type
---
# result，洗涤结果
string wash_result
---
# feedback，洗涤的进度
uint8 wash_percent
```
<a name="YMVMz"></a>
### cmake
```cmake
cmake_minimum_required(VERSION 3.0.2)
project(action_test)
# catkin构建时依赖的组件包
find_package(catkin REQUIRED COMPONENTS
  roscpp
  rospy
  std_msgs
  actionlib
  actionlib_msgs
)
include_directories(
# include
  ${catkin_INCLUDE_DIRS}
)
# 配置action源文件，FILES将引用当前功能包目录的action目录中的*.action文件，自动生成一个头文件（*.h）
add_action_files(
  FILES
  Laundry.action
)

# 生成消息时依赖于std_msgs、actionlib_msgs
generate_messages(
  DEPENDENCIES
  std_msgs
  actionlib_msgs
)

# 运行时依赖，描述了库、catkin构建依赖项和系统依赖的功能包
catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES action_test
 CATKIN_DEPENDS roscpp rospy std_msgs actionlib actionlib_msgs 
#  DEPENDS system_lib
)

# 节点构建选项，配置可执行文件
add_executable(action_client src/action_client.cpp)
add_executable(action_server src/action_server.cpp)

# 构建库和可执行文件之前，预先生成依赖消息
add_dependencies(action_client ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})
add_dependencies(action_server ${${PROJECT_NAME}_EXPORTED_TARGETS} ${catkin_EXPORTED_TARGETS})

# 节点构建选项，配置目标链接库
target_link_libraries(action_client
  ${catkin_LIBRARIES}
)
target_link_libraries(action_server
  ${catkin_LIBRARIES}
)
```
<a name="mf7uX"></a>
### client
```cpp
#include <ros/ros.h>
#include "actionlib/client/simple_action_client.h"
#include "action_test/LaundryAction.h"

typedef actionlib::SimpleActionClient<action_test::LaundryAction> ActionClient;

void doneCb(const actionlib::SimpleClientGoalState &state, const action_test::LaundryResultConstPtr &result)
{
  if (state.state_ == state.SUCCEEDED)
  {
    ROS_INFO("反馈结果:%s", result->wash_result.c_str());
  }
  else
  {
    ROS_INFO("任务失败！");
  }
}

void activeCb()
{
  ROS_INFO("动作已经被激活....");
}

void feedbackCb(const action_test::LaundryFeedbackConstPtr &feedback)
{ 
  ROS_INFO("洗涤进度为:%d%s", feedback->wash_percent, "%");
}

int main(int argc, char **argv)
{
  // 设置编码
  setlocale(LC_ALL, "");

  // 1.初始化ROS节点
  ros::init(argc, argv, "action_client");

  // 2.实例化ROS句柄
  ros::NodeHandle nh;

  // 3.实例化action客户端对象
  // 参数2为动作的名称，参数3默认为true，无需再调用ros::spin()，设置为false时需手动调用
  ActionClient client(nh, "laundry", true);
  // 等待服务端启动
  client.waitForServer();

  // 4.定义动作目标数据
  action_test::LaundryGoal goal;
  goal.wash_type = 2;

  // 5.发送目标，同时注册回调，处理反馈以及最终结果
  // 参数1是转换为Done时处理的回调函数，参数2为转换为Active时处理的回调函数，参数3为每当收到此目标的反馈时就调用的回调函数
  client.sendGoal(goal, &doneCb, &activeCb, &feedbackCb);

  ros::spin();

  return 0;
}
```
<a name="s4uDJ"></a>
### server
```cpp
#include <ros/ros.h>
#include "actionlib/server/simple_action_server.h"
#include "action_test/LaundryAction.h"
#include <iostream>

typedef actionlib::SimpleActionServer<action_test::LaundryAction> ActionServer;

// 4.收到action的goal后调用的回调函数
void executeCb(const action_test::LaundryGoalConstPtr &goal, ActionServer *server)
{
  // 获取目标值
  uint8_t wash_type = goal->wash_type;
  std::string wash_mode;
  switch (wash_type)
  {
  case 1:
    wash_mode = "快洗";
    break;
  case 2:
    wash_mode = "高温洗";
    break;
  case 3:
    wash_mode = "浸泡洗";
    break;
  default:
    break;
  }
  ROS_INFO("目标值为%d，开始%s！", wash_type, wash_mode.c_str());

  // 响应连续反馈
  action_test::LaundryFeedback feedback;
  for (int i = 0; i <= 100; i++)
  {
    feedback.wash_percent = i;
    server->publishFeedback(feedback);
    ros::Duration(0.5).sleep();
  }

  // 反馈结果
  action_test::LaundryResult result;
  result.wash_result = wash_mode + "完成！";
  server->setSucceeded(result);
}

int main(int argc, char **argv)
{
  // 设置编码
  setlocale(LC_ALL, "");
  // 1.初始化ROS节点
  ros::init(argc, argv, "action_server");
  // 2.实例化ROS句柄
  ros::NodeHandle nh;
  // 3.实例化action服务端对象
  // 参数2为动作服务器名称，参数3为当一个新目标被接收时在一个单独的线程中被调用，参数4为告诉ActionServer是否在它出现时立即开始发布
  ActionServer server(nh, "laundry", boost::bind(&executeCb, _1, &server), false);
  server.start();

  ros::spin();

  return 0;
}
```
<a name="Vpuri"></a>
### 效果：
![image.png](https://cdn.nlark.com/yuque/0/2024/png/39228163/1705559548910-bc235096-7d99-4292-b382-b91268dfc171.png#averageHue=%231f1b1b&clientId=ucf2197ff-0c36-4&from=paste&height=506&id=ub6200bb0&originHeight=1012&originWidth=1508&originalType=binary&ratio=2&rotation=0&showTitle=false&size=286203&status=done&style=none&taskId=u5d1e22a4-1937-479d-8cce-5e1ec8d2b05&title=&width=754)
