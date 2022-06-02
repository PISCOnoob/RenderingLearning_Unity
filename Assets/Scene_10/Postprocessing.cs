using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Scene_10
{
    public class Postprocessing : MonoBehaviour
    {
        [SerializeField]
        private Material postprocessingMaterial;

        [SerializeField]
        private float waveSpeed;

        [SerializeField]
        private bool waveActive;

        private float waveDistance;

        private void Start()
        {
            Camera cam = GetComponent<Camera>();
            cam.depthTextureMode = cam.depthTextureMode | DepthTextureMode.Depth;

        }

        private void Update()
        {
            if (waveActive)
            {
                waveDistance = waveDistance + waveSpeed * Mathf.Sin(Time.deltaTime);

            }
            else
            {
                waveDistance = 0;
            }
        }

        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            postprocessingMaterial.SetFloat("_WaveDistance", waveDistance);

            Graphics.Blit(source, destination, postprocessingMaterial);
        }
    }
}

