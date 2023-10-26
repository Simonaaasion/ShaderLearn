using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ScreenBroken : MonoBehaviour
{

    public Material mat;

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture src0 = RenderTexture.GetTemporary(source.width, source.height);
        mat.SetTexture("_MainTex", source);
        Graphics.Blit(source, src0, mat, 0);
        Graphics.Blit(src0, destination);

        RenderTexture.ReleaseTemporary(src0);
    }
}