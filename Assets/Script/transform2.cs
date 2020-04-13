using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class transform2 : MonoBehaviour
{
    // Start is called before the first frame update
    public Transform cube;
    void Start()
    {
      this.cube = this.transform.Find("Cube");
      this.cube.Rotate(new Vector3(0,0,14));
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
