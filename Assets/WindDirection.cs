using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WindDirection : MonoBehaviour {

    public GameObject Modifier;
    public Modifier mod;

    Vector3 currentMouse, previousMouse;
	// Use this for initialization
	void Start () {
        mod = Modifier.GetComponent<Modifier>();
	}
	
	// Update is called once per frame
	void Update () {
        //this.transform.rotation;
        //currentMouse = Mouse

	}
}
