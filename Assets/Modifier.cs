using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Modifier : MonoBehaviour {

    public Material mat;
    public GameObject speedSlider;
    public Text txt;
	// Update is called once per frame
	void Update () {
        mat.SetFloat("_Speed", speedSlider.GetComponent<Slider>().value);
        txt.text = speedSlider.GetComponent<Slider>().value.ToString() + " m/s";

    }
}
