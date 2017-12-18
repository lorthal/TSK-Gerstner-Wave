using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindDirection : MonoBehaviour
{

    float speed = 80.0f;
    Transform target;

    // Use this for initialization
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetMouseButton(0))
        {
            transform.Rotate(new Vector3(Input.GetAxis("Mouse X"), 0, 0) * Time.deltaTime * speed);
        }
    }
}
