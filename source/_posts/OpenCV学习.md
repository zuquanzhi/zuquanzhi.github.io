---
title: OpenCV学习
tags: OpenCV
categories: OpenCV
abbrlink: 48272
date: 2024-01-12 23:57:55
cover: https://imgapi.jinghuashang.cn/random?9
---

经过长达一天的重装和环境配置，正式开始OpenCV的学习。

<!--more-->

##### 参考资料：

[OpenCV入门【C++版】_opencv c++入门-CSDN博客](https://blog.csdn.net/Star_ID/article/details/122656593)

[利用VScode和cmake编译构建C++工程代码 - Oldpan的个人博客](https://oldpan.me/archives/use-vscode-cmake-tools-build-project)

[OpenCV - C++实战（05） — 颜色检测_c++图像色素带识别-CSDN博客](https://blog.csdn.net/qq_41921826/article/details/129145473)

## 基本 （图片&视频）操作

首先在opencv中创建一个文件夹mytest，用于存放后续的测试程序,并创建程序test1（后续同理）

```cpp
mkdir mytest
cd mytest
gedit test1.cpp
```

找一张图片（好友丑照）命名为1.jpg存放于这个目录中用于后续测试（蹂躏）。

### 1 图片腐蚀

#### 示例代码:

```cpp
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(){
    Mat srcImage =imread("1.jpg");
    imshow("[原始图]",srcImage);
    Mat element =getStructuringElement(MORPH_RECT,Size(15,15));
    Mat dstImage;
    erode(srcImage,dstImage,element);
    imshow("[效果图]腐蚀操作",dstImage);
    waitKey(0);
}
```

功能很简单，就是一个腐蚀操作。

在终端输入

```cpp
g++ test1.cpp -o test1 `pkg-config --cflags --libs opencv`
./test1
```

显示原图和腐蚀操作图。

效果展示：

![1](1.png)

完美运行。



### 2.图像模糊

#### 示例代码

```cpp
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(){
    Mat srcImage =imread("1.jpg");
    imshow("[原始图]",srcImage);
    Mat dstImage;
    blur(srcImage,dstImage,Size(7,7));
    imshow("[效果图]",dstImage);
    waitKey(0);
}
```

非常好理解，载入原图之后调用一次blur函数，最后显示效果图。

效果如下：

![2](2.png)

### 3  Canny边缘检测

#### 示例代码:

```cpp
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>

using namespace cv;

int main(){
    Mat srcImage =imread("1.jpg");
    imshow("[原始图]",srcImage);
    Mat dstImage,edge,grayImage;//参数定义
    dstImage.create(srcImage.size(),srcImage.type());
    //创建与src同类型大小的矩阵（dest）
    cvtColor(srcImage,grayImage,COLOR_BGR2GRAY);
    //将原图像转换为灰度图像

    blur(grayImage,edge,Size(3,3));//3x3内核降噪
    Canny(edge,edge,3,9,3);//运行Canny算子
    dstImage = edge; //将Canny算子的结果赋值给dstImage
    imshow("[效果图]",dstImage);
    waitKey(0);
    destroyAllWindows(); //释放所有窗口
    return 0;
}
```

效果如下：

![3](3.png)

### 4.读取视频

#### 示例代码:

```cpp
#include <opencv2/opencv.hpp>
using namespace cv;

int main(){
    VideoCapture capture("1.avi");
    while(1){
        Mat frame;//定义Mat变量储存每一帧
        capture>>frame;//读取当前帧
        imshow("读取视频",frame);
        waitKey(30);//延迟30ms
    }
    return 0;
}
```

### 5.调取摄像头采集视频

#### 示例代码:

```cpp
#include <opencv2/opencv.hpp>
using namespace cv;

int main(){
    VideoCapture capture(0);
    Mat edges;
    while(1){
        Mat frame;
        capture>>frame;//读取当前帧
        cvtColor(frame,edges,COLOR_BGR2GRAY);//灰度转换
        blur(edges,edges,Size(7,7));
        Canny(edges,edges,1,31,3);
        imshow("读取视频",frame);
        waitKey(30);
    }
    return 0;
}
```

（其实就是把Videocapture中的视频源改为参数0）

### 6.灰度转化

图片有多种色彩模式，主要就是包括位图模式，灰度模式，RGB模式，CMYK模式和HSB模式。这里就不详细展开了。值得注意的有两个概念，就是图片的深度和通道，深度表示一个图片的一个像素有几位，通道则表示一个图像由几层颜色表示，一般由单通道（灰度），三通道（RGB）以及四通道（RGB+透明度）表示。

在opencv中我们一般采用cvtColor这个函数来转换图像的灰度。

![4](4.png)

```cpp
 C++: void cvtColor(InputArray src, OutputArray dst, int code, int dstCn=0 );
```

这里给出函数的定义和常用的几个转换标识

## 图像裁剪和缩放

可以参考

[https://blog.csdn.net/ZBC010/article/details/120584785?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522170480359916800185832024%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=170480359916800185832024&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-120584785-null-null.142^v99^pc_search_result_base6&utm_term=opencv%E5%9B%BE%E5%83%8F%E8%A3%81%E5%89%AA%E5%92%8C%E7%BC%A9%E6%94%BE&spm=1018.2226.3001.4187](https://blog.csdn.net/ZBC010/article/details/120584785?ops_request_misc=%7B%22request%5Fid%22%3A%22170480359916800185832024%22%2C%22scm%22%3A%2220140713.130102334..%22%7D&request_id=170480359916800185832024&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~sobaiduend~default-1-120584785-null-null.142^v99^pc_search_result_base6&utm_term=opencv图像裁剪和缩放&spm=1018.2226.3001.4187)

### 图像尺寸缩放：

#### 示例代码：

```cpp
void resize( InputArray src, //输入图像
			 OutputArray dst,//输出图像
             Size dsize, //调整成的大小
             double fx = 0, 
             double fy = 0,
             int interpolation = INTER_LINEAR 
             );
```

#### 参数解释：

- src：输入的图像，Mat类
- dst：输出的图像，当参数dsize不为0时，dst的大小由dsize决定；否则，它的大小由参数fx和fy决定
- dsize：输出图像的大小，写成Size(宽，高)（单位：像素）
- fx和fy：水平/竖直方向上的缩放比例
- interpolation：插值方法。取值如下：
  INTER_NEAREST---------最近邻插值
  INTER_LINEAR---------双线性插值（默认设置）
  INTER_AREA---------使用像素区域关系进行重采样
  INTER_CUBIC---------4x4像素邻域的双三次插值
  INTER_LANCZOS4---------8x8像素邻域的Lanczos插值
- 注意：参数dsize和参数(fx, fy)不能够同时为0

```cpp
#include <iostream>
#include <opencv2/opencv.hpp>
using namespace cv;
#ifdef _DEBUG
#pragma comment(lib,"opencv_world453d.lib")
#else
#pragma comment(lib,"opencv_world453.lib")
#endif // _DEBUG

int main()
{
    Mat img = imread("D:\\My Bags\\图片\\Test.jpg");
    Mat outImg;
    resize(img, outImg, Size(0,0), 0.8, 0.8);//宽和高都变为原来的0.8倍
    imshow("原图", img);
    imshow("改变尺寸后", outImg);
    waitKey(0);
    return 0;
}
```

### 图像裁剪

#### 示例代码：

```cpp
#include <iostream>
#include <opencv2/opencv.hpp>
using namespace cv;
#ifdef _DEBUG
#pragma comment(lib,"opencv_world453d.lib")
#else
#pragma comment(lib,"opencv_world453.lib")
#endif // _DEBUG

int main()
{
    Mat img = imread("D:\\My Bags\\图片\\Test.jpg");
    Rect cropArea(0, 0, 150, 200);
    Mat outImg = img(cropArea);
    imshow("原图", img);
    imshow("裁剪后", outImg);
    waitKey(0);
    return 0;
}
```

## 图像绘制和文字输出

参考资料：[Opencv图形绘制与文字输出_opencv mat 显示文字-CSDN博客](https://blog.csdn.net/k673656/article/details/129227483?ops_request_misc=%7B%22request%5Fid%22%3A%22170480417316800213038610%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=170480417316800213038610&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-129227483-null-null.142^v99^pc_search_result_base6&utm_term=opencv图形绘制和文字绘制&spm=1018.2226.3001.4187)

### 绘制圆形

```cpp
void circle(InputOutputArray img, Point center, int radius, const Scalar& color, 
            int thickness = 1, int lineType = LINE_8, int shift = 0);
```

其中center表示中心位置，radius表示半径，thikness可以表示厚度，-1表示填充，与可以表示位FILLED

### 绘制矩形

```cpp
void rectangle(InputOutputArray img, Point pt1, Point pt2, const Scalar& color, 
               int thickness = 1, int lineType = LINE_8, int shift = 0);
```

 值得注意的是，还可以使用RECT来绘制，函数如下

```cpp
void rectangle(InputOutputArray img, Rect(x,y,width,height), const Scalar& color, 
               int thickness = 1, int lineType = LINE_8, int shift = 0);
```

### 绘制直线

```cpp
 void line(InputOutputArray img, Point pt1, Point pt2, const Scalar& color,
           int thickness = 1, int lineType = LINE_8, int shift = 0);
```

### 输入文字

```cpp
void putText( InputOutputArray img, const String& text, Point org, int fontFace, 
              double fontScale, Scalar color, int thickness = 1, int lineType = LINE_8,
              bool bottomLeftOrigin = false );
```

img表示初始的文字，text表示文字内容，org表示文字的左下角坐标，fontface表示字体类型，fontscale表示字体大小，最后以为表示图像数据的原点是左下角还是左上角。

## 几何变换

首先，对几何变换做个简单了解。打开任意一个图像编辑器，一般可以有对图像进行放大、缩小、旋转等操作，这类操作改变了原图中各区域的空间关系。对于这类操作，通常称为图像的**几何变换**。

一般而言，完成一张图像的几何变换需要**两个独立的算法**：**首先**，需要一个算法实现空间坐标变换，用它描述每个像素如何从初始位置移动到终止位置；**其次**，还需要一个**插值算法**完成输出图像的每个像素的灰度值。

### 仿射变换

#### 仿射矩阵

对于空间变换的仿射矩阵有两种计算方式，分别是**方程组法**和**矩阵相乘法**。

**(1) 方程组法**

仿射变换矩阵有六个未知数，所以需要三组对应位置坐标，构造出由六个方程组成的方程组即可解六个未知数。
举例：如果(0,0) 、(200,0) 、(0,200)这三个坐标通过某仿射变换矩阵A分别转换为(0,0) 、(100,0) 、(0,100)，则可利用这三组对应坐标构造出六个方程，求解出A。

对于C++的API函数getAffineTransform()输入参数有两种方式，第一种方式是将原位置坐标和对应的变换后的坐标分别保存在Point2f数组中，代码如下：

```cpp
#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;
int main() {

	Point2f src[] = { Point2f(0,0),Point2f(200,0), Point2f(0,200) };
	Point2f dst[] = { Point2f(0,0),Point2f(100,0), Point2f(0,100) };

	Mat A = getAffineTransform(src,dst);

	cout << A<<endl;
	
	return 0;
}
```

返回值A仍然是2行3列的矩阵，指的是**仿射变换矩阵的前两行**。需要注意的是，数据类型是CV_64F而**不是**CV_32F。


第二种方式是**将原位置坐标和对应的变换后的坐标保存在**Mat中，**每一行代表一个坐标，数据类型必须是**CV_32F，否则会报错，代码如下：

```cpp
#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;
int main() {

	Mat src = (Mat_<float>(3, 2) << 0, 0, 200, 0, 0, 200);
	Mat dst = (Mat_<float>(3, 2) << 0, 0, 100, 0, 0, 100);


	Mat A = getAffineTransform(src, dst);
	cout << A << endl;

	return 0;
}
```

使用矩阵相乘法计算仿射矩阵，**前提是需要知道基本仿射变换步骤**.

**需要注意的是**，虽然先缩放再平移，但是仿射变换矩阵是**平移仿射矩阵乘以缩放仿射矩阵，而不是缩放仿射矩阵乘以平移仿射矩阵**，即等式右边的运算是从右向左进行的。

在[OpenCV](https://so.csdn.net/so/search?q=OpenCV&spm=1001.2101.3001.7020)中是通过“*”运算符或者gemm函数来实现矩阵的乘法的，代码如下：



```cpp
#include <iostream>
#include <opencv2/opencv.hpp>
#include <opencv2/core/core.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;
int main() {
	Mat src = (Mat_<float>(3, 3) << 0.5, 0, 0, 0, 0.5, 0, 0, 0, 1);//缩放矩阵
	Mat dst = (Mat_<float>(3, 3) << 1, 0, 100, 0,1, 200, 0, 0, 1);//平移矩阵

	Mat A;

	gemm(src,dst,1.0,Mat(),0,A,0);

	cout << A << endl;

	return 0;
}
```

### 透射变换

仿射变换是在平面上的线性变换加平移，根据其性质可知变换后平行四边形依然是平行四边形，不改变直线的平行关系。透射变换即中心投影变换，利用透视中心、像点、目标点三点共线的条件,按透视旋转定律使承影面（透视面）绕迹线（透视轴）旋转某一角度，破坏原有的投影光线束，仍能保持承影面上投影几何图形不变的变换。

 透视变换是将二维的图片投影到一个三维视平面上，然后再转换到二维坐标下，所以也称为投影映射。

移动投影中心和承影面，可得到各种形状的变换。（有点像《三体》里的二向箔）



```cpp
Mat cv::getPerspectiveTransform (const Point2f src[], const Point2f dst[])
```



**返回相应 4 个点对的 3x3 透视变换**。

```cpp
void cv::warpPerspective (InputArray src, OutputArray dst, InputArray M, Size dsize, int flags=INTER_LINEAR, int borderMode=BORDER_CONSTANT, const Scalar &borderValue=Scalar())
```



**对图像应用透视变换**。

```cpp
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

float w = 250, h = 350;
Mat matrix, imgWarp;

int main()
{
	string path = "Resources/cards.jpg";
	Mat img = imread(path);

	Point2f src[4] = { {529, 142}, {771, 190}, {405, 395}, {674, 457} };
	Point2f dst[4] = { {0.0f, 0.0f}, {w, 0.0f}, {0.0f, h}, {w, h} };

	matrix = getPerspectiveTransform(src, dst);
	warpPerspective(img, imgWarp, matrix, Point(w, h));

	for (int i = 0; i < 4; i++) {
		circle(img, src[i], 10, Scalar(0, 0, 255), FILLED);
	}

	imshow("Image", img);
	imshow("ImageWarp", imgWarp);
	waitKey(0);

	return 0;
}
```

PS：文档扫描应该就是这种变换。



## 颜色检测：

```cpp
void cv::inRange (InputArray src, InputArray lowerb, InputArray upperb, OutputArray dst)
```

检查数组元素是否位于其他两个数组的元素之间。



```cpp
void cv::namedWindow (const String &winname, int flags = WINDOW_AUTOSIZE)
```

**创建一个窗口**。函数namedWindow创建一个可用作图像和轨迹栏占位符的窗口。创建的窗口由它们的名称引用。如果同名的窗口已经存在，则该函数不执行任何操作。



```cpp
int cv::createTrackbar (const String &trackbarname, const String &winname, int *value, int count, TrackbarCallback onChange = 0, void *userdata = 0)
```

**创建一个**trackbar**并将其附加到指定窗口**。函数createTrackbar创建一个具有指定名称和范围的trackbar（滑块或范围控件），分配一个变量值作为与trackbar同步的位置，并指定回调函数onChange为 在跟踪栏位置变化时被调用。创建的轨迹栏显示在指定的窗口winname中。

```cpp
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <iostream>

using namespace cv;
using namespace std;

Mat imgHSV, mask;
int hmin = 0, smin = 110, vmin = 153;
int hmax = 19, smax = 240, vmax = 255;


int main()
{
    string path = "resources/lambo.png";
    Mat img = imread(path);
    cvtColor(img, imgHSV, COLOR_BGR2HSV);

    namedWindow("Trackbars", (640, 200));
    createTrackbar("Hue Min", "Trackbars", &hmin, 179);
    createTrackbar("Hue Max", "Trackbars", &hmax, 179);
    createTrackbar("Sat Min", "Trackbars", &smin, 255);
    createTrackbar("Sat Max", "Trackbars", &smax, 255);
    createTrackbar("Val Min", "Trackbars", &vmin, 255);
    createTrackbar("Val Max", "Trackbars", &vmax, 2555);


    while (true) {

        Scalar lower(hmin, smin, vmin);
        Scalar upper(hmax, smax, vmax);
        inRange(imgHSV, lower, upper, mask);

        imshow("Image", img);
        imshow("Image HSV", imgHSV);
        imshow("Image Mask", mask);
        waitKey(1);

    }

    return 0;
}
```

## 项目实操

#### 参考资料：

[@23沈晨阳](https://hitwhlc.yuque.com/tosania)

此处为语雀内容卡片，点击链接查看：https://hitwhlc.yuque.com/smartcar/daily/zg04pi54zig4rqbt

[https://blog.csdn.net/qq_40344790/article/details/127653557?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522170481303716800188516338%2522%252C%2522scm%2522%253A%252220140713.130102334.pc%255Fall.%2522%257D&request_id=170481303716800188516338&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-127653557-null-null.142^v99^pc_search_result_base6&utm_term=opencv%E7%BA%A2%E7%BB%BF%E7%81%AF%E8%AF%86%E5%88%AB%E6%A3%80%E6%B5%8Bc%2B%2B&spm=1018.2226.3001.4187](https://blog.csdn.net/qq_40344790/article/details/127653557?ops_request_misc=%7B%22request%5Fid%22%3A%22170481303716800188516338%22%2C%22scm%22%3A%2220140713.130102334.pc%5Fall.%22%7D&request_id=170481303716800188516338&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~first_rank_ecpm_v1~rank_v31_ecpm-1-127653557-null-null.142^v99^pc_search_result_base6&utm_term=opencv红绿灯识别检测c%2B%2B&spm=1018.2226.3001.4187)

#### 任务内容：

##### OpenCV红绿灯检测

- 使用**c++**版本的opencv对视频进行处理
- 读取TrafficLight.mp4
- 检测交通信号灯颜色，并在图像中标出红绿灯位置（中间数字无需检测）
- 将信号灯颜色以字符串输出到图像左上角
- 将处理后的视频输出为result.avi，示例为压缩包内“输出示例.avi”
- 可以进行创新，给大家的视频只是一个示例

- 在语雀中创建文档，完整记录自己的实现方式
- 将代码、result.avi放入同一压缩包内上传到语雀中
- 将result.avi直接传入语雀中，其他人可以直接查看的那种
- 提交截止时间：下周一例会前(2.14)

#### 完成思路：

1.将视频的每一帧处理，（高斯模糊，边缘检测，膨胀....），增强特征点的提取。

```cpp
// 对二值化后的图像进行高斯模糊
    GaussianBlur(imgDil, imgDil, Size(7, 7), 6, 0);

    // 对图像进行Canny边缘检测
    Canny(imgDil, imgDil, 25, 75);

    // 定义膨胀操作的内核
    Mat kernel = getStructuringElement(MORPH_RECT, Size(3, 3));

    // 对Canny边缘检测后的图像进行膨胀
    dilate(imgDil, imgDil, kernel);
```

2.由于红绿灯是由许多小像素点组成的，可能会造成误判，故需要检测一下轮廓过滤出最大的画出矩形。

```cpp
    // 查找图像中的轮廓
    vector<vector<Point>> contours;
    vector<Vec4i> hierarchy;
    findContours(imgDil, contours, hierarchy, RETR_EXTERNAL, CHAIN_APPROX_SIMPLE);

    // 存储轮廓的多边形逼近和轮廓的矩形边界
    vector<vector<Point>> conPoly(contours.size());
    vector<Rect> boundRect(contours.size());

    // 存储最大轮廓的相关信息
    double maxx = 0;
    int choose = 0, ok = 0;

    // 遍历所有轮廓，找到最大的符合条件的轮廓
    for (int i = 0; i < contours.size(); i++)
    {
        if (contourArea(contours[i]) / arcLength(contours[i], true) > maxx)
        {
            maxx = contourArea(contours[i]) / arcLength(contours[i], true);
            choose = i;
            if (maxx > 20 && contourArea(contours[i]) > 2000)
                ok = 1;
        }
    }

    // 遍历所有轮廓，绘制最大的轮廓及相关信息
    for (int i = 0; i < contours.size(); i++)
    {
        if (choose == i && ok == 1)
        {
            // 计算轮廓的多边形逼近
            double peri = arcLength(contours[i], true);
            approxPolyDP(contours[i], conPoly[i], 0.02 * peri, true);

            // 计算轮廓的矩形边界
            boundRect[i] = boundingRect(conPoly[i]);

            // 绘制矩形边界
            rectangle(img, boundRect[i], Scalar(0, 225, 0), 2);

            // 在矩形边界的左上角绘制文本
            putText(img, c, boundRect[i].tl(), FONT_HERSHEY_DUPLEX, 1.5, Scalar(0, 255, 100), 2);
        }
    }
```

- 关于颜色的识别：

由于inrange函数的局限性，最好将图像转换成HSV颜色空间，相比于RGB颜色空间，HSV颜色空间更适合处理颜色分割和阈值操作。在HSV中，颜色范围可以更容易地通过阈值进行调整，因为色调和明度是分开的。

使用HSV颜色空间是为了更容易地确定图像中红色和绿色的区域。对于交通灯的颜色检测，通常更关注颜色的种类而不是其亮度或深浅，因此使用HSV更为合适。



主函数代码如下：

```cpp
int main()
{
    // 视频文件路径
    string path = "1.avi";
    VideoCapture cap(path);
    Mat img;
    
    // 获取视频帧数
    int cnt = cap.get(CAP_PROP_FRAME_COUNT);
    
    // 获取视频帧的大小
    Size sizeReturn = Size(cap.get(CAP_PROP_FRAME_WIDTH), cap.get(CAP_PROP_FRAME_HEIGHT));
    
    // 创建输出视频的写入对象，设置输出视频文件名、编码方式、帧率和大小
    VideoWriter writer("out.mp4", cv::VideoWriter::fourcc('m', 'p', '4', 'v'), cap.get(CAP_PROP_FPS), sizeReturn);
    
    // 遍历视频的每一帧
    for (int i = 1; i <= cnt; i++)
    {
        // 读取当前帧
        cap >> img;
        
        // 转换当前帧为HSV颜色空间
        Mat imgHSV;
        cvtColor(img, imgHSV, COLOR_BGR2HSV);
        
        // 定义绿色和红色的HSV阈值范围
        Scalar g_lower(h_gmin, s_gmin, v_gmin);
        Scalar g_upper(h_gmax, s_gmax, v_gmax);
        Scalar r_lower(h_rmin, s_rmin, v_rmin);
        Scalar r_upper(h_rmax, s_rmax, v_rmax);
        
        // 通过HSV阈值得到绿色和红色的掩码
        Mat g_mask, r_mask;
        inRange(imgHSV, g_lower, g_upper, g_mask);
        inRange(imgHSV, r_lower, r_upper, r_mask);
        
        // 对绿色掩码进行目标识别和标记
        workg(g_mask, img, "green");
        
        // 对红色掩码进行目标识别和标记
        workr(r_mask, img, "red");
        
        // 将处理后的帧写入输出视频文件
        writer.write(img);
    }
    imshow("img", img);
    // 释放视频捕捉对象和写入对象
    cap.release();
    writer.release();

    return 0;
}
```



本来是不用学人脸识别的，感觉好玩所以写了个基于摄像头输入源的人脸识别：

```cpp
#include <bits/stdc++.h>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/objdetect.hpp>
using namespace cv;
using namespace std;
int main()
{
	CascadeClassifier faceCascade;
	faceCascade.load("/usr/share/opencv4/haarcascades/haarcascade_frontalface_default.xml");
	if (faceCascade.empty()) { cout << "Load Error" << endl; }
	VideoCapture cap(0);
	Mat img;
	while (true)
	{
		cap.read(img);
		
		waitKey(1);
		vector<Rect> face;
		faceCascade.detectMultiScale(img, face);
		for (int i = 0; i < face.size(); i++)
		{
			rectangle(img, face[i], Scalar(0, 255, 0), 2);
			putText(img, "a people", face[i].tl(), FONT_HERSHEY_DUPLEX, 0.75,Scalar(0, 69, 255), 2);
		}
		imshow("Image", img);
		waitKey(100);
		}
}

```

后来感觉不够，完全可以基于主屏幕输入画面进行人脸识别，方便帮舍友识别出藏在床底下的老王（bushi）

```cpp
#include <bits/stdc++.h>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include <opencv2/objdetect.hpp>
#include <X11/Xlib.h>
#include <X11/Xutil.h>

using namespace cv;
using namespace std;
int main()

{
    Display* display = XOpenDisplay(NULL); // 打开X11显示
    Screen* screen = DefaultScreenOfDisplay(display); // 获取默认屏幕
    int width = screen->width; // 获取屏幕的宽度
    int height = screen->height; // 获取屏幕的高度

    // 加载人脸检测分类器
    CascadeClassifier faceCascade;
    faceCascade.load("/usr/share/opencv4/haarcascades/haarcascade_frontalface_default.xml");
    if (faceCascade.empty()) { cout << "Load Error" << endl; }

    // 创建VideoWriter对象，用于将每一帧屏幕图像写入视频文件
    VideoWriter writer("out.mp4", cv::VideoWriter::fourcc('m', 'p', '4', 'v'), 30, Size(width, height));

    while (true)
    {
        // 获取屏幕的XImage对象
        XImage* ximage = XGetImage(display, DefaultRootWindow(display), 0, 0, width, height, AllPlanes, ZPixmap);

        // 转换为OpenCV的Mat对象
        cv::Mat image(height, width, CV_8UC4, ximage->data); // 创建Mat对象
        cv::cvtColor(image, image, cv::COLOR_BGRA2BGR); // 转换为BGR格式

        // 在屏幕图像上进行人脸检测和标注
        vector<Rect> face;
        faceCascade.detectMultiScale(image, face);
        for (int i = 0; i < face.size(); i++)
        {
            rectangle(image, face[i], Scalar(0, 255, 0), 2);
            putText(image, "a people", face[i].tl(), FONT_HERSHEY_DUPLEX, 0.75,Scalar(0, 69, 255), 2);
        }

        // 显示屏幕图像
        cv::imshow("Screen", image);
        cv::waitKey(100);

        // 将修改后的图像写入视频文件
        writer.write(image);

        // 释放资源
        XDestroyImage(ximage);
    }

    // 关闭X11显示
    XCloseDisplay(display);

    // 释放VideoCapture对象和VideoWriter对象的资源
    writer.release();
}
```

