using UnityEngine;

public class RotateAroundObject : MonoBehaviour
{
    public Transform targetObject; // Ŀ������B��Transform���
    public float rotationRadius = 2.0f; // ��ת�뾶
    public float rotationSpeed = 30.0f; // ��ת����

    private Vector3 rotationCenter; // ����B��λ��

    private void Start()
    {
        if (targetObject != null)
        {
            rotationCenter = targetObject.position;
        }
        else
        {
            Debug.LogError("Ŀ������δ���ã�");
        }
    }

    private void Update()
    {
        if (targetObject != null)
        {
            // ��������AӦ��Χ������B��ת��λ��
            float angle = Time.time * rotationSpeed;
            float x = rotationCenter.x + Mathf.Cos(angle) * rotationRadius;
            float y = rotationCenter.y + Mathf.Sin(angle) * rotationRadius;
            Vector3 newPosition = new Vector3(x, y, transform.position.z);

            // ������A�ƶ�����λ��
            transform.position = newPosition;
        }
    }
}
