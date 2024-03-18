using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FlutterUnityIntegration;
using UnityEngine.SceneManagement;
using System.Globalization;
using System;

public class FloorController : MonoBehaviour
{
    int keyboardRotateSpeed = 5;
    public Mesh meshtest;
    //int gyroRotateSpeed = 10;
    void Start()
    {
        //RotateAmount = new Vector3(0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.UpArrow))
        {
            //RotateAmount = new Vector3(RotateAmount.x+rotateSpeed, RotateAmount.y, RotateAmount.z);
            gameObject.transform.Rotate(new Vector3(keyboardRotateSpeed* -1, 0, 0));
        }
        if (Input.GetKeyDown(KeyCode.DownArrow))
        {
            //RotateAmount = new Vector3(RotateAmount.x - rotateSpeed, RotateAmount.y, RotateAmount.z);
            gameObject.transform.Rotate(new Vector3(keyboardRotateSpeed, 0, 0));
        }
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            //RotateAmount = new Vector3(RotateAmount.x, RotateAmount.y, RotateAmount.z+rotateSpeed);
            gameObject.transform.Rotate(new Vector3(0, keyboardRotateSpeed, 0));
        }
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            //RotateAmount = new Vector3(RotateAmount.x, RotateAmount.y, RotateAmount.z-rotateSpeed);
            gameObject.transform.Rotate(new Vector3(0, keyboardRotateSpeed*-1,0));
        }

        for (int i = 0; i < Input.touchCount; ++i)
        {
            if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
            {
                var hit = new RaycastHit();

                Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

                if (Physics.Raycast(ray, out hit))
                {
                    Reset("");
                }
            }
        }
    }

    void newMap()
    {
        //Mesh mesh = new Mesh(); // ezt valahonnan be kell szerezni
        GetComponent<MeshFilter>().sharedMesh = meshtest;
        GetComponent<MeshCollider>().sharedMesh = meshtest;
    }
    // This method is called from Flutter
    public void Reset(String message)
    {
        transform.rotation = Quaternion.identity;
        gameObject.transform.Rotate(new Vector3(-90, 90, 90));
    }
    public void SetX(String message)
    {
        float value = float.Parse(message, CultureInfo.InvariantCulture.NumberFormat);
        gameObject.transform.Rotate(new Vector3(value, 0, 0));
    }
    //public void SetY(String message)
    //{
    //    float value = float.Parse(message, CultureInfo.InvariantCulture.NumberFormat);
    //    gameObject.transform.Rotate(new Vector3(0, value*gyroRotateSpeed, 0));
    //    string position = "floor rotate position: " + transform.rotation.eulerAngles.ToString();
    //    UnityMessageManager.Instance.SendMessageToFlutter(position);
    //}
    public void SetZ(String message)
    {
        float value = float.Parse(message, CultureInfo.InvariantCulture.NumberFormat);
        gameObject.transform.Rotate(new Vector3(0,value*-1,0));   
    }
}
