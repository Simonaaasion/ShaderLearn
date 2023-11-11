using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(GrassGroup))]
public class GrassGroup_Inspector : Editor
{
    private GrassGroup grassGroup = null;
    private float m_Theta = 0.1f; // 值越低圆环越平滑  
    private Color m_Color = Color.blue; // 线框颜色  
    private HeGizmosCircle heGizmosCircle = null;
    void OnEnable()
    {
        grassGroup = target as GrassGroup;
        if (heGizmosCircle == null)
            heGizmosCircle = GameObject.FindWithTag("HeGizmosCircle").GetComponent<HeGizmosCircle>();
    }
    void OnDisable()
    {
        if (heGizmosCircle != null)
        {
            heGizmosCircle.SetEnable(grassGroup.editorMode);
        }
    }
    public override void OnInspectorGUI()
    {

        base.OnInspectorGUI();
        GUILayout.BeginHorizontal();
        GUILayout.Label("radius(半径)：" + grassGroup.radius.ToString());
        grassGroup.radius = GUILayout.HorizontalSlider(grassGroup.radius, 0, 10, null);
        if (heGizmosCircle != null)
            heGizmosCircle.m_Radius = grassGroup.radius;
        GUILayout.EndHorizontal();
        GUILayout.BeginHorizontal();
        GUILayout.Label("count(数量)：" + grassGroup.count.ToString());
        grassGroup.count = System.Convert.ToInt32(GUILayout.HorizontalSlider(grassGroup.count, 1, 100, null));
        GUILayout.EndHorizontal();
    }

    [MenuItem("地图编辑/创建GrassGroup")]
    static void CreateGrassGroup()
    {
        GameObject go = new GameObject("GrassGroup");
        GrassGroup group = go.AddComponent<GrassGroup>();
        go.transform.position = Vector3.zero;
    }

    public void OnSceneGUI()
    {
        if (grassGroup == null || !grassGroup.editorMode)
            return;

        if (grassGroup.editorMode)
        {
            Ray ray = HandleUtility.GUIPointToWorldRay(Event.current.mousePosition);
            RaycastHit hitInfo;
            if (Physics.Raycast(ray, out hitInfo, 1 << 8))
            {
                heGizmosCircle.transform.position = hitInfo.point + new Vector3(0, 0.2f, 0);
                if (Event.current.type == EventType.MouseDown)
                {
                    grassGroup.AddGrassNode(hitInfo.point);
                }
            }
        }
    }
}