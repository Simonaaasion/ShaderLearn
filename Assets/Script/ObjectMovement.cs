using UnityEngine;

public class ObjectMovement : MonoBehaviour
{
    public float moveSpeed = 5f; // 移动速度

    private void Update()
    {
        // 获取输入轴的值
        float horizontalInput = Input.GetAxis("Horizontal");
        float verticalInput = Input.GetAxis("Vertical");

        // 根据输入轴的值计算移动方向
        Vector3 movement = new Vector3(horizontalInput, 0f, verticalInput);

        // 根据移动方向和速度进行移动
        transform.Translate(movement * moveSpeed * Time.deltaTime);
    }
}