using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Postprocessing_2 : MonoBehaviour
{
    [SerializeField]
    private Material postprocessingMaterial;

    private Camera cam;
    void Start()
    {
        cam = GetComponent<Camera>();

        cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Matrix4x4 viewToWorld = cam.cameraToWorldMatrix;
        postprocessingMaterial.SetMatrix("_ViewToWorldMatrix", viewToWorld);
        Graphics.Blit(source, destination, postprocessingMaterial);
    }
}
