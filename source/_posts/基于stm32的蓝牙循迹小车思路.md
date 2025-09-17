---
title: 基于stm32的蓝牙循迹小车思路
tags: stm32
categories: 机器人/计算机视觉
abbrlink: 43791
date: 2023-11-05 15:10:23
cover: https://www.loliapi.com/acg?13
---

## 一. 概况：

1. 基本思路。

2. 最初代码实现。

3. 最终代码实现。

   <!-- more -->

## 二. 思路实现&&理解：

### 1. 循迹：

* 整体思路：ADC采样—>对ADC采样数据的数学处理—>对得到的数据进行PID算法运算—>赋值给ccr调整pwm波输出占空比驱动电机。循环此过程则可实现速度闭环实现直角弯道除外的赛道。

* 方案：两灯&三灯及以上。

​       **归根结底，重点在于数学算法处理。**







* 实操理解：

  **针对采样：**

​      *重要参数*：单个采样范围及变化趋势&&单个采样值。

​              单个采样范围及变化趋势：非常有限，几乎不触及黑线采样值变化很小，但一接近黑线立即成指数增长。

​              单个采样值：几百（个体差异）~约2300的原始值。但转化为电压值之后仅为0~3.3，大量数据被压缩，损失了很多精度，最终决定采用原始                                        值进行操作。

​      		误差来源*包括但不限*：环境红外线影响  红外对管个体差异  红外对管彼此距离  红外对管对地距离。

​              环境红外线影响：

​					非常影响红外对管采集数据。最终解决办法有两种：

​				（1）在每个红外对管四周缠上黑胶布，用以反射环境红外线并聚合红外对管发出的红外线；

​				（2）在代码中初始化过程中消除环境误差并不需要测得，但随着小车运动导 致的位置改变，环境误差在变化，而我们只消除了开始的误差，但我们放弃使用动态消除误差，可能会影响正常循迹和路口识别。

​               红外对管个体差异：

​					不同红外对管的峰值大致相同，但最低值各有千秋。有的一两百，有的却五六百。考虑到对ADC采样数据进行处理时，个体误差的存在会影响很多计算结果造成两个灯调节作用差别很大。故必须消除。最终我们采用个体采样值域大的红外对管，以输出更加灵敏的值，并在代码中在初始化过程中，连同环境误差一起消除。

​               红外对管彼此距离：

​					主要影响两点，一是识别范围，二是数学处理时产生漏洞。对于第一点，两灯距离太小时，识别范围就太小，小车遇到稍抖一点的弯路时极易偏线，但两灯距离过大时，就相当于允许小车有一定程度的偏线，造成循迹不流畅。对于第二点，若两灯距离过小，此时可以忽略个体误差，但同时ADC数学处理获得值值域很小，调节精度或说范围很小，若两灯距离过大，两灯之间会留出一个处理值为0的空白区允许小车一定程度偏线，这是我们不希望看到的。

​               红外对管对地距离：

​					主要影响红外对管的采样值域。对地距离过低时红外对管接收不到反射光，采样值很低，对地距离过高时很受环境光干扰，接收红外线很多，采样值很高，通过打印波形图来观察何对地距离红外对管的检测距离最大，以及采样值域最大。



​		**针对数学处理：**

​       处理参数：识别范围，输出值。

​                  识别范围：即小车的“视野”，能够允许偏线程度最大的情况下依然可以回归正轨。

​                   输出值：作为偏差，进行PID运算后，改变ccr来改变电机占空比。

​       处理方法与消除误差：

​                   两灯： 缺少能够作为条件的判断，所以只有让两灯采样值相减，同时让两灯在同一环境下初始化，记录两灯差值，然后代入程序中来消除个体误差和环境误差，然后调用ADC数据处理函数，得到曲线。

​      



​	**针对PID：**

​        本次任务中采用位置式PID，且用到P与D参与运算。

​        采用PD系统调节原因：通过P进行主导线形控制，通过D来计算未来趋势抑制系统震荡，即通过PD系统获得更快的反应速度。符合循迹需求。

​        输入值：实时计算ADC数学处理获得值与目标值0的差值

​        输出值：除了初始占空比以外的用于控制电机的pwm

​        偏差：ADC数学处理获得值与目标值0的差值，用于P计算

​        二次偏差：前后两次偏差的差值，用于D计算

​        调参注意：P过小调节作用小，P过大造成过冲系统震荡。D过小调节作用小，D过大会放大系统趋势的影响，使系统震荡。

​        调参顺序：先设D=0，调P，从0逐渐增大，直到系统震荡。再调D使其逐渐增大，直到系统震荡。之后进行微调，直到系统稳定。



​	  **针对电机控制：**

​          调节方式：对两边电机同时附PID运算值，以达到使两测车轮具有相同效果的调节作用。

​          调节精度及限制：

​          考虑到可供调节的ccr范围为0~500( 有点小，占空比的相对调节精度小），但考虑到对循迹小车来讲500的调节范围够用，所以没改，但后来调车发现问题，发现有些曲率较大的弯转不过去，起初认为是P设的过小，但经过数学运算后发现问题是数值溢出，即能转过这个弯路的PID处理值没发挥出它的作用，因为溢出下限即占空比为0，溢出上限即占空比为100，所以最终采用【循迹电机反转函数】的使用，使溢出值得到充分利用。事实上增大ccr的可操作区间亦可。

​           初始值设置：一开始设置为50%占空比，因为考虑到想使PID调节具有对称性。事实效果很好，循迹很丝滑，但后来考虑到走直线速度较慢，故逐渐增大初始占空比，再具体进行调参。

​           置“0”操作：每次赋值给电机后，电机会保持这个数值运动，但在赋新的值之前，若不将之前赋过值的电机置0，两者会发生冲突比如相互抵消。



### 2. 机械结构：

* 机械臂：

​          	负责能量块夹放及将普通矿放入盒子内。

* 机械铲：

​			  负责为机械臂工作铺路。（可根据具体需要调整）

## 三. 最初代码实现：

## 1. 循迹：

* 两灯：



```c
void ADC_caiyang(void)    
{
	int wucha=0;             //定义两灯远离黑线的个体误差
	
	static int LeftMax=0;     //定义左灯峰值 
	static int RightMax=0;    //定义右灯峰值

	Right_AD=ADC_ConvertedValue[4]; 	//定义左右灯实时采样数据
	Left_AD=ADC_ConvertedValue[7];		
		
	if(Left_AD>LeftMax)	       //确定左灯峰值
	{
		LeftMax=Left_AD;
		
	}
	if(Right_AD>RightMax)       //确定右灯峰值
	{
		RightMax=Right_AD;
	}		
	
	wucha=Right_AD-Left_AD;    //确定两灯远离黑线的个体误差
	
	printf("Right_AD:%d Left_AD:%d\r\n",Right_AD,Left_AD);    //用rawdate实时打印方便记录
	printf("wucha:%d LeftMax:%d RightMax:%d \r\n",wucha,LeftMax,RightMax);
}
union FloatToByte                             //联合体函数
{
	float ADC_ConvertedValueLocal[NOFCHANEL];   //用于保存转换计算后的电压值
	char byte[NOFCHANEL*4+4];                   //联合体    将1个浮点数为4个字节
};
union FloatToByte a;

extern int Data_Out;            //ADC数学处理获得值
extern int Left_AD,Right_AD;    //左右灯实时采样数据

void Test_ADC_PRINTF(void)
{
	  a.byte[NOFCHANEL*4+0]=0x00;
	  a.byte[NOFCHANEL*4+1]=0x00;
	  a.byte[NOFCHANEL*4+2]=0x80;
    a.byte[NOFCHANEL*4+3]=0x7f;
    while (1)
    {
        a.ADC_ConvertedValueLocal[0] = (float)ADC_ConvertedValue[0] ;
        a.ADC_ConvertedValueLocal[1] = (float)ADC_ConvertedValue[1] ;
        a.ADC_ConvertedValueLocal[2] = (float)ADC_ConvertedValue[2] ;
        a.ADC_ConvertedValueLocal[3] = (float)ADC_ConvertedValue[3] ;
        a.ADC_ConvertedValueLocal[4] = (float)ADC_ConvertedValue[4] ;
        a.ADC_ConvertedValueLocal[5] = (float)ADC_ConvertedValue[5] ;
        a.ADC_ConvertedValueLocal[6] = (float)ADC_ConvertedValue[6] ;
        a.ADC_ConvertedValueLocal[7] = (float)ADC_ConvertedValue[7] ;
        a.ADC_ConvertedValueLocal[8] = (float)Right_AD ;
        a.ADC_ConvertedValueLocal[9] = (float)Left_AD ;
        a.ADC_ConvertedValueLocal[10] = (float)ADC_ConvertedValue[10];
        a.ADC_ConvertedValueLocal[11] = (float)Data_Out ;

			for(int i=0;i<NOFCHANEL*4+4;i++)      //NOFCHANEL*4+4为数值12*4+4=52
			{
				printf("%c",a.byte[i]);
			}
       
        Delay_MS(5);        //5ms一采样
				
    }
}
#define WUCHA -400 		
#define LEFT_MAX 2927   
#define RIGHT_MAX 2868  	
void ADC_chuli()
{	
	Left_AD=ADC_ConvertedValue[4];
	Right_AD=ADC_ConvertedValue[7];
	
	Data_Out=(Left_AD-Right_AD+WUCHA);   //只有两个灯，故只能作差处理
}
typedef struct
{
	 uint16_t kp;
	 uint16_t ki;
	 uint16_t kd;

}PID;

PID pid;

int PositionPID(float dev)         //此为位置式pid（需要两次），可以考虑增量式pid（需要三次）
{
	
	float Position_kp=(float)pid.kp,Position_ki=(float)pid.ki,Position_kd=(float)pid.kd;
  static float Bias,Pwm,Integral_Bias,Last_Bias;
	Bias=Data_Out;
	Integral_Bias+=Bias;
	
	Pwm=Position_kp*Bias+Position_ki*Integral_Bias+Position_kd*(Bias-Last_Bias);
	
	Last_Bias=Bias;
	return Pwm;
}
void motor_xunji(void)
{
	Motor_Run(motor_1, 200-PositionPID(Data_Out));
  Motor_Run(motor_2, 0);
  Motor_Run(motor_3, 200-PositionPID(Data_Out));
  Motor_Run(motor_4, 0);
  Motor_Run(motor_5, 200+PositionPID(Data_Out));
  Motor_Run(motor_6, 0);
  Motor_Run(motor_7, 200+PositionPID(Data_Out));
	Motor_Run(motor_8, 0);
}
extern void ADC_chuli(void);
extern void ADC_caiyang(void);
extern void motor_xunji(void);
// 将 ADC1 转换的电压值通过 DMA 方式传到 SRAM
extern __IO uint16_t ADC_ConvertedValue[NOFCHANEL];

// 局部变量，用于保存转换计算后的电压值
float ADC_ConvertedValueLocal[NOFCHANEL];

int Data_Out;            
int Left_AD,Right_AD;


int main()
{
	pid.kp=0;
	pid.kp=0;
	pid.kp=0;
	
	USART_Config();
	ADCx_Init();
	Delay_Init();
	
	while(1)
	{
//	ADC_caiyang();     //获得adc采样数据
    ADC_chuli();    //只进行adc采样数据处理

		Delay_MS(5);
//	Test_ADC_PRINTF(); //打印ADC波形
		
//		void motor_xunji();    //循迹启动
		
	};
}
```

### 2.机械臂：

```c
		if (66 == i)                         //上升
		{
			for (; rise > 500; rise--)
			{
				Servo_Run(servo_1, rise);
				Delay_MS(2);
				if (54 == i)
					break;
			}
		}
		
		if (65 == i)                          //下降
		{
			for (; rise < 2500; rise++)
			{
				Servo_Run(servo_1, rise);
				Delay_MS(2);
				if (54 == i)
					break;
			}
		}
	
		
		if (67 == i)                        //夹取
		{
			Servo_Run(servo_2, 1000);
			Servo_Run(servo_3, 1400);
		}
		if (68 == i)                        //松开
		{ 
			Servo_Run(servo_2, 1200);
			Servo_Run(servo_3, 1200);
		}
```

由于本次赛制并不是单纯实现循迹功能，而是走迷宫，需要在十字路口，T字路口，环形岛等情况时进行特殊判断，故舍弃原先两灯方案。

