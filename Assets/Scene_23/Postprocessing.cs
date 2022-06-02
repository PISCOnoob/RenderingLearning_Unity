using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Secene_23
{
    public class Postprocessing : MonoBehaviour
    {
        [SerializeField]
        private Material postprocessMaterial;

        private Camera cam;
        void Start()
        {
            cam = GetComponent<Camera>();
            cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.DepthNormals;
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            Graphics.Blit(source, destination,postprocessMaterial);
        }
    }
}


