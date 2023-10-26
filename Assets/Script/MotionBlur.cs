using UnityEngine;

[RequireComponent(typeof(Camera))] // ��Ҫ������
public class MotionBlur : MonoBehaviour
{
    [Range(0.0f, 0.9f)]
    public float blurAmount = 0.5f; // ģ��ֵ, ֵԽ����βЧ��Խ����
    private RenderTexture historyTexture; // ��ʷ��Ļ����
    private Material material = null; // ����

    private void Start()
    {
        material = new Material(Shader.Find("MyShader/MotionBlur"));
        material.hideFlags = HideFlags.DontSave;
    }

    void OnDisable()
    { // �ű�������ʱ��������, �´ο�ʼӦ���˶�ģ��ʱ, ���»��ͼ��
        DestroyImmediate(historyTexture);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            // ��ʼ��ʱ�򴰿ڳߴ�仯ʱ, ������������
            if (historyTexture == null || historyTexture.width != src.width || historyTexture.height != src.height)
            {
                DestroyImmediate(historyTexture);
                historyTexture = new RenderTexture(src.width, src.height, 0);
                historyTexture.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(src, historyTexture);
            }
            material.SetFloat("_BlurAmount", 1.0f - blurAmount); // ����ģ��ֵ, ͨ��alphaͨ�����Ƶ�ǰ��Ļ��������ʷ��Ļ������л��
            Graphics.Blit(src, historyTexture, material);
            Graphics.Blit(historyTexture, dest);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}