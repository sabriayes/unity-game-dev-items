Shader "Custom/SpriteBlackBGTransparent"
{
    Properties {
        [PerRendererData] _MainTex("Sprite Texture", 2D) = "white" {}
        _Threshold ("Cutout Shreshold", Range(0,1)) = 0.1
        _Softness ("Cutout Softness", Range(0,0.5)) = 0.0
        _Lightness ("Lightness", Range(0,1.0)) = 0.5
        [MaterialToggle] PixelSnap("Pixel Snap", Float) = 0
        _StencilComp("Stencil Comparison", Float) = 8
        _Stencil("Stencil ID", Float) = 0
        _StencilOp("Stencil Operation", Float) = 0
        _StencilWriteMask("Stencil Write Mask", Float) = 255
        _StencilReadMask("Stencil Read Mask", Float) = 255
        _ColorMask("Color Mask", Float) = 15
    }

    SubShader {

        Tags {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "IgnoreProjector" = "True"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        LOD 100

        Stencil {
            Ref[_Stencil]
            Comp[_StencilComp]
            Pass[_StencilOp]
            ReadMask[_StencilReadMask]
            WriteMask[_StencilWriteMask]
        }
        ColorMask[_ColorMask]

        Cull Off
        Lighting Off
        ZWrite Off
        Fog{ Mode Off }

        CGPROGRAM
        #pragma surface surf Lambert alpha

        sampler2D _MainTex;
        float _Threshold;
        float _Softness;
        float _Lightness;

        struct Input {
            float2 uv_MainTex;
        };

        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            o.Albedo = c.rgb * _Lightness;
            o.Alpha = smoothstep(_Threshold, _Threshold + _Softness,
               0.333 * (c.r + c.g + c.b));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
