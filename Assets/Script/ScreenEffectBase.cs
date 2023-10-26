using UnityEngine;

[ExecuteInEditMode]
//��Ļ����Ч����Ҫ�������������в�������Ҫ�������
[RequireComponent(typeof(Camera))]
public class ScreenEffectBase : MonoBehaviour
{
    public Shader shader;
    private Material material;
    protected Material Material
    {
        get
        {
            material = CheckShaderAndCreatMat(shader, material);
            return material;
        }
    }

    //���ڼ�鲢������ʱ����
    private Material CheckShaderAndCreatMat(Shader shader, Material material)
    {
        Material nullMat = null;
        if (shader != null)
        {
            if (shader.isSupported)
            {
                if (material && material.shader == shader) { }
                else
                {
                    material = new Material(shader) { hideFlags = HideFlags.DontSave };
                }
                return material;
            }
        }
        return nullMat;
    }
}