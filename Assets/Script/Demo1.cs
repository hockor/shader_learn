using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Demo1 : MonoBehaviour
{

  public float speed = 1;

  public GameObject canvas;

  public Text font;
    // Start is called before the first frame update
    void Start()
    {
      print("start");
      
      //  修改 Text 组件的文字
      canvas = GameObject.Find("Text");
     font = canvas.GetComponent<Text>();
      font.text = "good";
    }

    // Update is called once per frame
    void Update()
    {

      // 控制物体移动
      transform.Translate(Vector3.right * speed * Time.deltaTime);

      if (Input.GetKeyDown(KeyCode.A))
      {
        font.text = "你按下了 A";
      }
      else if (Input.GetKeyDown(KeyCode.Space))
      {
        font.text = "你按下了空格键";
      }
      
    }

  
}
