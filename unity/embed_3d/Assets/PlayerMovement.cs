using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using FlutterUnityIntegration;
using UnityEngine.SceneManagement;
using System.Globalization;
using System;
using UnityEngine.UIElements;

public class PlayerMovement : MonoBehaviour
{
    //[SerializeField]
    //Vector3 RotateAmount;
    //int keyboardRotateSpeed = 5;
    [SerializeField] GameObject floor;
    //int gyroRotateSpeed = 2;

    // Start is called before the first frame update
    void Start()
    {
        //RotateAmount = new Vector3(0, 0, 0);
    }

    // Update is called once per frame
    void Update()
    {
        //if (Input.GetKeyDown(KeyCode.UpArrow))
        //{
        //    //RotateAmount = new Vector3(RotateAmount.x+rotateSpeed, RotateAmount.y, RotateAmount.z);
        //    gameObject.transform.Rotate(new Vector3(keyboardRotateSpeed, 0, 0));
        //}
        //if (Input.GetKeyDown(KeyCode.DownArrow))
        //{
        //    //RotateAmount = new Vector3(RotateAmount.x - rotateSpeed, RotateAmount.y, RotateAmount.z);
        //    gameObject.transform.Rotate(new Vector3(keyboardRotateSpeed * -1, 0, 0));
        //}
        //if (Input.GetKeyDown(KeyCode.LeftArrow))
        //{
        //    //RotateAmount = new Vector3(RotateAmount.x, RotateAmount.y, RotateAmount.z+rotateSpeed);
        //    gameObject.transform.Rotate(new Vector3(0, 0, keyboardRotateSpeed));
        //}
        //if (Input.GetKeyDown(KeyCode.RightArrow))
        //{
        //    //RotateAmount = new Vector3(RotateAmount.x, RotateAmount.y, RotateAmount.z-rotateSpeed);
        //    gameObject.transform.Rotate(new Vector3(0, 0, keyboardRotateSpeed * -1));
        //}

        //gameObject.transform.Rotate(RotateAmount * Time.deltaTime * 120);

        for (int i = 0; i < Input.touchCount; ++i)
        {
            if (Input.GetTouch(i).phase.Equals(TouchPhase.Began))
            {
                var hit = new RaycastHit();

                Ray ray = Camera.main.ScreenPointToRay(Input.GetTouch(i).position);

                if (Physics.Raycast(ray, out hit))
                {
                    // This method is used to send data to Flutter
                    //Debug.Log("asdf");
                    //UnityMessageManager.Instance.SendMessageToFlutter("The player feels touched.");
                    //string position = "player rotate position: " + transform.rotation.eulerAngles.ToString();
                    //UnityMessageManager.Instance.SendMessageToFlutter(position);
                    //Debug.Log(position);
                    UnityMessageManager.Instance.SendMessageToFlutter("reset");
                    transform.position = new Vector3(0, 0, 0);
                    GetComponent<Rigidbody>().velocity = Vector3.zero;
                    GetComponent<Rigidbody>().angularVelocity = Vector3.zero;
                }
            }
        }

        if (transform.position.y < -5)
        {
            transform.position = new Vector3(0,0,0);
            floor.GetComponent<Collider>().enabled = true;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("target"))
        {
            Debug.Log("cel elerve");
            floor.GetComponent<Collider>().enabled = false;
            if (SceneManager.GetActiveScene().name == "Level1")
            {
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex + 1);
            }
            else
            {
                //Application.Quit();
                UnityMessageManager.Instance.SendMessageToFlutter("done");
                SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex-1);
            }
        }
    }
    public void Reset(String message)
    {
        transform.position = new Vector3(0, 0, 0);
        GetComponent<Rigidbody>().velocity = Vector3.zero;
        GetComponent<Rigidbody>().angularVelocity = Vector3.zero;
        if (SceneManager.GetActiveScene().name == "Level2")
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex - 1);
        }
    }

    public void SwitchNative()
    {
        UnityMessageManager.Instance.ShowHostMainWindow();
    }

    public void UnloadNative()
    {
        UnityMessageManager.Instance.UnloadMainWindow();
    }

    public void QuitNative()
    {
        UnityMessageManager.Instance.QuitUnityWindow();
    }
}
