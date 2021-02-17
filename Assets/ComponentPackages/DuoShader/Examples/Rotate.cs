using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public float speed = 1.0f;
    void Update()
    {
        transform.Rotate(0.0f, speed * Time.deltaTime, 0.0f);
    }
}
