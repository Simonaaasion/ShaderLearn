using UnityEngine;

public class RotateAroundObject : MonoBehaviour
{
    public Transform targetObject; // 目标物体B的Transform组件
    public float rotationRadius = 2.0f; // 旋转半径
    public float rotationSpeed = 30.0f; // 旋转速率

    private Vector3 rotationCenter; // 物体B的位置

    private void Start()
    {
        if (targetObject != null)
        {
            rotationCenter = targetObject.position;
        }
        else
        {
            Debug.LogError("目标物体未设置！");
        }
    }

    private void Update()
    {
        if (targetObject != null)
        {
            // 计算物体A应该围绕物体B旋转的位置
            float angle = Time.time * rotationSpeed;
            float x = rotationCenter.x + Mathf.Cos(angle) * rotationRadius;
            float y = rotationCenter.y + Mathf.Sin(angle) * rotationRadius;
            Vector3 newPosition = new Vector3(x, y, transform.position.z);

            // 将物体A移动到新位置
            transform.position = newPosition;
        }
    }
}
