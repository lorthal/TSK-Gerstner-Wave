using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Modifier : MonoBehaviour {

    public Material mat;
    public GameObject speedSlider;

    public float speed = 10;
    public Vector3 dir = new Vector3(0,1,0);
	// Update is called once per frame
	void Update () {
        mat.SetFloat("_Speed", speedSlider.GetComponent<Slider>().value);
        mat.SetVector("_Direction", dir);
        //if (Input.GetKey(KeyCode.D))
        //{
        //    dir = new Vector3(dir.x, dir.y, dir.z);
        //}
        //if (Input.GetKey(KeyCode.A))
        //{
        //    dir = new Vector3(dir.x, dir.y, dir.z);
        //}
        //if (Input.GetKey(KeyCode.W))
        //{
        //    speed += 0.1f;
        //}
        //if (Input.GetKey(KeyCode.S))
        //{
        //    speed -= 0.1f;
        //}

    }
}
