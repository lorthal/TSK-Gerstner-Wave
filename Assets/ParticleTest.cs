using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ParticleTest : MonoBehaviour
{
    float time;

    void Start()
    {
        time = Time.deltaTime;
    }
    void Update()
    {
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("time", time);
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("PI", Mathf.PI);
        gameObject.GetComponent<Renderer>().sharedMaterial.SetFloat("G", -Physics.gravity.y);

        time += Time.deltaTime;
    }
}
