using UnityEngine;

[ExecuteInEditMode]
//屏幕后处理效果主要是针对摄像机进行操作，需要绑定摄像机
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

    //用于检查并创建临时材质
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