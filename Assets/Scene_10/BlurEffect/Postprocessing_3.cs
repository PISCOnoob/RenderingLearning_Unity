using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Postprocessing_3 : MonoBehaviour
{
    [SerializeField]
    public Material postprocessingMaterial;
 
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // draws the pixels from source texture to the destination texture
        var temporaryTexture = RenderTexture.GetTemporary(source.width, source.height);
        // use first pass to blur y axis
        Graphics.Blit(source, temporaryTexture, postprocessingMaterial, 0);
        // use second pass to blur xaxis
        Graphics.Blit(temporaryTexture, destination, postprocessingMaterial,1);

        RenderTexture.ReleaseTemporary(temporaryTexture);
    }
}
