using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SphereMovements : MonoBehaviour
{
    private float initialTransformY;
    private float direction;
    public float offset = .5f;

    // Start is called before the first frame update
    void Start()
    {
        initialTransformY = transform.position.y;
        direction = 1;
    }

    // Update is called once per frame
    void Update()
    {
        transform.position += new Vector3(0, Time.deltaTime * direction, 0);

        if (Mathf.Abs(transform.position.y - initialTransformY) > offset)
        {
            direction *= -1;
            Debug.Log(direction);
        }
        Debug.Log(transform.position.y);
    }
}
