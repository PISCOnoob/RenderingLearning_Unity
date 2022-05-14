using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Renderer))]
public class PolygonController : MonoBehaviour
{
    [SerializeField]
    private Vector2[] m_points;
    private Material m_mat;

    void Start()
    {
        UpdateMaterial();
    }

    void OnValidate()
    {
        UpdateMaterial();
    }
    void UpdateMaterial()
    {
        if(m_mat == null)
        {
            m_mat = GetComponent<Renderer>().sharedMaterial;
        }

        Vector4[] vec4Points = new Vector4[1000];
        for(int i=0;i<m_points.Length;i++)
        {
            vec4Points[i] = m_points[i];
        }

        m_mat.SetVectorArray("_PointsArray", vec4Points);
        m_mat.SetInt("_PointCount", m_points.Length);
    }
}
