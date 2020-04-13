using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class game_root : MonoBehaviour
{
    // Start is called before the first frame update

    public Transform cube_trans;
    void Start()
    {
      // TODO:1   获取对象
      
      // transform.gameobject == this.gameobject == gameobect
      print(this.gameObject.transform == this.transform);  // True
      
      print(this.gameObject.tag);  
      print(this.gameObject.activeSelf);  // 自己是否可见
      print(this.gameObject.activeInHierarchy);  // 自己在这个体系中是否可见  比如自己还是勾选了可见的，但是父级被隐藏了
      print(this.transform.up.x);
      
      
      //****** 获取下面的内容 （Find 和 FindChild） *******
      
      // 通过 find 方法，里面的参数是你下面的名字
      Transform button = this.transform.Find("Button");

      cube_trans = button;
      // find 的高级用法，可以直接用/获取下一级，而 FindChild 就不行
      Transform buttonText = this.transform.Find("Button/Text"); 

      // 通过 gameObject 获得自己的信息
      print(button.gameObject.name);
      print(buttonText.gameObject.name);

      
      // 通过 findChild 方法
      Transform img = this.transform.Find("Image");
      // 通过 gameObject 获得自己的信息
      print(img.gameObject.name);
      
      
      /***基于 GameObject 的全局查找****/
      
      // *******FindTag 挂载在全局 GameObject 下的，如果有多个是同一个 Tag，他会返回第一个找到的
      GameObject button2 = GameObject.FindWithTag("Player");
      print(button2.name);
      
      // 返回所有 tag 的，可以使用GameObject.FindGameObjectsWithTag()
      
      // GetSiblingIndex //返回当前节点在其父节点下的index
      
      GameObject[] players = GameObject.FindGameObjectsWithTag("Player");
      print(players.Length);  // 2
      

      // TODO:2   坐标系
      
      // position 获取的是绝对坐标  localPosition 获取的是相对坐标 所有 local 开头的都是相对的
      print(img.position); // (295.0, 484.0, 0.0)
      
      print(img.localPosition); //(0.0, 39.0, 0.0)

      // 将相对坐标转换成世界坐标
      print(this.transform.TransformPoint(new Vector3(0,0,0))); // (295.0, 445.0, 0.0)
     
      // 将世界坐标转换成相对坐标
      print(this.transform.InverseTransformPoint(new Vector3(295,445,0))); // (0,0,0)



      
      // todo:3  时间
      
      // Time.deltaTime  距离上一次刷新的时间
      // Time.fixedDeltaTime  // 物理引擎固定更新的时间  

      
      //todo:4  forward  right  up
      
      // xyz 三个轴的向量，从-1到 1  
      // forward 表示物体的前方向 //相对于该物体本身而言，不同于世界坐标系
      // up 表示物体的上方向
      // right 表示物体的左方向 
      
      
      // todo:5 旋转
      
      /*
       *
       *常用的控制旋转的方法有：矩阵旋转和欧拉旋转，还有本篇要介绍的重点四元数，它也是实现旋转的方式之一。下面简单介绍一下前面的两种实现方式：

        1.矩阵旋转：使用一个4*4的矩阵来表示绕任意轴旋转时的变换矩阵，这个矩阵具有的特点：乘以一个向量的时候只改变向量的方向而不会改变向量的大小；

        优点：旋转轴可以是任意向量；

        缺点：进行旋转其实我们只需要知道一个向量和一个角度，4个值的信息，而旋转变换矩阵使用了4*4=16个元素；

                    变换过程增加乘法运算量，耗时；

        2.欧拉旋转：在旋转时，按照一定的顺序（例如：x、y、z，Unity中的顺序是z、x、y）每个轴旋转一定的角度，来变换坐标或者是向量，实际上欧拉旋转也可以理解为：一系列坐标旋转的组合；

        优点：只需使用3个值，即三个坐标轴的旋转角度；

        缺点：必须严格按照顺序进行旋转（顺序不同结果就不同）；

                   容易造成“万向节锁”现象，造成这个现象的原因是因为欧拉旋转是按顺序先后旋转坐标轴的，并非同时旋转，所以当旋转中某些坐标重合就会发生万向节锁，这时就会丢失一个方向上的选择能力，除非打破原来的旋转顺序或者三个坐标轴同时旋转；

                   由于万向节锁的存在，欧拉旋转无法实现球面平滑插值；
        ————————————————
        版权声明：本文为CSDN博主「河乐不为」的原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接及本声明。
        原文链接：https://blog.csdn.net/linshuhe1/article/details/51206377
       * 
       */
      
      print("cube_trans.rotation:"+this.cube_trans.rotation);  // cube_trans.rotation:(0.0, 0.0, 0.1, 1.0)
      // 上面打印出来的是四元数！！
      // 下面的才是欧拉角！！！
      print(this.cube_trans.rotation.eulerAngles);  // 这个打印出来的就是我们在 unity 里面看到的那个旋转值

      // 在实际应用中我们只需通过Quaternion.Euler和Quaternion.Slerp来完成Rotation的赋值操作。
      // 如果想按照 Z 轴旋转 90 度，应该是这样子，要把欧拉角转成四元数
      this.cube_trans.rotation = Quaternion.Euler(new Vector3(0,0,90));
      
      // 一直转。。四元数乘积
      //this.cube_trans.rotation *= Quaternion.Euler(new Vector3(0,0,90));

      
      // 也可以直接调用 Rotate 方法，更加直观 （！！！！测试发现，他是在上面的基础上再旋转！！！！）
      this.cube_trans.Rotate(new Vector3(0,0,30));
    }

    // Update is called once per frame
    void Update()
    {


      // 不能在 update 里面去获取this.cube_trans，不然的每次获取到的都是同一个值。。。
      
      // 得到标量
      float s = 30 * Time.deltaTime;
      
      // 单位向量 * 标量 --->  这个标量在这个单位向量 X,Y,Z轴上的分解
      this.cube_trans.position += this.cube_trans.right * s;
      
      
      // Translate第二个参数比较特殊，默认是参考自己的 X,Y,X，如果用 World 的话就是用世界坐标的 XYZ，要 3D 下才能看出来效果
      
     //  this.cube_trans.Translate(new Vector3(0,0,s),Space.Self);
     // this.cube_trans.Translate(new Vector3(0,0,s),Space.Self);
      // 还可以参考任何物体的坐标系
      this.cube_trans.Translate(new Vector3(0,0,s),this.transform);

    }
}
