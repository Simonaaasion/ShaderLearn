using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMove : MonoBehaviour
{

    public GameObject cube;

    void Update()
    {
        if (Input.GetKey(KeyCode.W))
        {
            cube.transform.Translate(Vector3.forward * Time.deltaTime*5);
        }
        if (Input.GetKey(KeyCode.S))
        {
            cube.transform.Translate(Vector3.back * Time.deltaTime * 5);
        }
        if (Input.GetKey(KeyCode.A))
        {
            cube.transform.Translate(Vector3.left * Time.deltaTime * 5);
        }
        if (Input.GetKey(KeyCode.D))
        {
            cube.transform.Translate(Vector3.right * Time.deltaTime * 5);
        }
    }
}