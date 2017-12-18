using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Modifier : MonoBehaviour
{

    public Material mat;

    public GameObject arrow;

    public GameObject speedSlider;
    public Text txt;

    public Vector3 dir;

    private Vector2 pass;
    // Update is called once per frame
    void Update()
    {
        dir = Vector3.Normalize(arrow.transform.rotation * Vector3.right);

        pass = new Vector2(dir.x, dir.z);

        mat.SetFloat("_Speed", speedSlider.GetComponent<Slider>().value);
        mat.SetVector("_Direction", pass);
        txt.text = speedSlider.GetComponent<Slider>().value.ToString() + " m/s";
    }
}
