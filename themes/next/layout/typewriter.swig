<script type="text/javascript" src="jquery.min.js"></script>
<script type="text/javascript" src="typed.js"></script>
<script>
   var typed = new Typed('.typewriter-content',{
      // 注意：输出的可以是标签,将标签当节点运行.比如下面的h1
	  // 这是一个字符串数组,可以填充多个值,使用引号修饰,使用逗号分割
      strings: ['<h1>{{ subtitle }}<h1>'],
	  // 速度值越小打字速度越快
      typeSpeed:80,
	  // 用于在在输出字符结尾闪烁的符号
	  cursorChar: '_'
   });
   // 设置页面加载完成时再开始打字
   typed.stop();
    $(document).ready(function () {
      typed.start();
    });
</script>
