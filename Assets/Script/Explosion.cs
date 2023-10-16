using UnityEngine;

public class ExplosionController : MonoBehaviour
{
    public Material explosionMaterial; // 爆炸效果所使用的材质
    public float explosionForce = 10f; // 爆炸力度
    public float explosionRadius = 5f; // 爆炸半径

    private bool exploded = false; // 检查是否已经发生过爆炸

    private void OnCollisionEnter(Collision collision)
    {
        if (!exploded && collision.relativeVelocity.magnitude > 0.5f)
        {
            Explode();
            exploded = true;
        }
    }

    private void Explode()
    {
        // 获取模型的位置
        Vector3 explosionPosition = transform.position;

        // 在模型位置创建一个爆炸力场
        Collider[] colliders = Physics.OverlapSphere(explosionPosition, explosionRadius);
        foreach (Collider collider in colliders)
        {
            Rigidbody rb = collider.GetComponent<Rigidbody>();
            if (rb != null)
            {
                // 给附近的刚体施加爆炸力
                rb.AddExplosionForce(explosionForce, explosionPosition, explosionRadius);
            }
        }

        // 应用爆炸效果的材质
        Renderer renderer = GetComponent<Renderer>();
        if (renderer != null && explosionMaterial != null)
        {
            renderer.material = explosionMaterial;
        }
    }
}