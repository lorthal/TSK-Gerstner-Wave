using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MaterialTimer : MonoBehaviour
{
    public Material mat;

    private float time;

	void Update ()
	{
        mat.SetFloat("time", time);
        time += Time.deltaTime;
	}
}
