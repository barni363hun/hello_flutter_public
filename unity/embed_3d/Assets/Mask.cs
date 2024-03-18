using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Mask : MonoBehaviour
{
    [SerializeField] int renderQueue = 3000;
    void Start()
    {
        Material[] mats = GetComponent<Renderer>().materials;
        for (int i = 0; i < mats.Length; i++)
        {
            mats[i].renderQueue = renderQueue;
        }
    }


}
