Shader "Custom/SpeechBubble"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {

        Tags { 
            "Queue" = "Transparent+1" 
            "RenderType" = "Transparent"
        }
        ZTest Always
        //ZWrite Off
        Cull Off
        LOD 100
        AlphaToMask On
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define PI 3.1415926
            #include "UnityCG.cginc"

            struct appdata
            {  
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                //float4 vertex : SV_POSITION;
                //float4 pos : TEXCOORD0;
                float4 pos : SV_POSITION;
                float4 screenpos : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _view;
            
            v2f vert (appdata v)
            {
                v2f o;
                /*
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenpos = ComputeScreenPos(o.pos);
                o.uv = v.uv;
                */
                //v.vertex.x += 8;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.screenpos = ComputeScreenPos(o.pos);
                o.uv = v.uv;
                
                // billboard mesh towards camera  
                float3 vpos = mul((float3x3)unity_ObjectToWorld, v.vertex.xyz);
                float4 worldCoord = float4(unity_ObjectToWorld._m03, unity_ObjectToWorld._m13, unity_ObjectToWorld._m23,
                                           1);
                float4 viewPos = mul(UNITY_MATRIX_V, worldCoord) + float4(vpos, 0);
                viewPos.y += 0.3;
                float4 outPos = mul(UNITY_MATRIX_P, viewPos);

                o.pos = outPos;
                //o.pos.x += 0.2;
                    
               // UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                //return tex2Dproj(_view, i.screenpos);
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * col.a;
            }
            ENDCG
        }
    }
}