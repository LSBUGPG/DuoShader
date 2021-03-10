using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(Camera))]
public class SetDepthTextureMode : MonoBehaviour
{
    [SerializeField]
    DepthTextureMode mode = DepthTextureMode.DepthNormals;
    public DepthTextureMode Mode
    {
        get
        {
            return mode;
        }

        set
        {
            mode = value;
            UpdateMode();
        }
    }
    new Camera camera;

    void Initialise()
    {
        camera = GetComponent<Camera>();
        UpdateMode();
    }

    void Reset()
    {
        Initialise();
    }

    void OnEnable()
    {
        Initialise();
    }

    void OnValidate()
    {
        Initialise();
    }

    void UpdateMode()
    {
        camera.depthTextureMode = mode;
    }
}
