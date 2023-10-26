using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode] 
[RequireComponent(typeof(Camera))]
public class TestRenderImage : MonoBehaviour {
    #region Variables
    public Shader curShader;
    public float grayScaleAmount = 1.0f;
    private Material curMaterial;
    #endregion

    #region Properties
    Material material {
        get{
        if (curMaterial==null) {
            curMaterial = new Material(curShader);
            curMaterial.hideFlags = HideFlags.HideAndDontSave;
        }
        return curMaterial;
    }
    }
    #endregion

    void Start (){
        if (!curShader)
            enabled = false;
    }

    void OnRenderImage(Texture srcTex, RenderTexture dstTex)  {
        if (curShader != null){
            material.SetFloat("_LuminosityAmount", grayScaleAmount);
            Graphics.Blit(srcTex, dstTex, material);
        } 
        else Graphics.Blit(srcTex, dstTex);
    }

    void Update () {
        grayScaleAmount = Mathf.Clamp(grayScaleAmount, 0.0f, 1.0f);
    }

    private void OnDisable() {
        if (curMaterial) DestroyImmediate(curMaterial);
    }
}
