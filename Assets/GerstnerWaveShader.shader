Shader "Custom/GerstnerWaveShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_HeightMap("Height Map", 2D) = "white" {}
		_HeightMapScale("Height map scale", float) = 1.0
		_Color("Color", color) = (1,1,1,1)
		_Amplitude("Wave _Amplitude", float) = 1.0
		_Length("Wave Length", float) = 10.0
		_Direction("Wind Direction", vector) = (1,0,0)
		_Speed("Wind Speed", float) = 5
	}

	SubShader
	{
			CGPROGRAM
			#pragma surface surf BlinnPhong alpha vertex:vert
			#pragma target 3.0

			float PI;
			float G;

			float Q1, Q2;
			float _Amplitude, A;
			float _Length, L;
			float2 _Direction, Dir;
			float _Speed, S, CrestVelocity;

			sampler2D _HeightMap, _MainTex;

			float4 _Color;

			float _HeightMapScale;

			float3 northVertex, southVertex, eastVertex, westVertex;
			float F1, F2;
			float phaseConst1, phaseConst2;

			float2 directionalWave1, directionalWave2;

			float time, _DeltaTime;

			struct Input
			{
				float2 uv_HeightMap;
				float2 uv_MainTex;
			};

			void CalculateGhostVertices(float2 direction)
			{
				northVertex.x += (Q1 * _Amplitude) * direction.x * cos((F1 * dot(float2(direction.x, direction.y), northVertex.xz)) + (phaseConst1 * time));
				northVertex.y += _Amplitude * sin((F1 * dot(float2(_Direction.x, direction.y), northVertex.xz)) + (phaseConst1 * time));
				northVertex.z += (Q1 * _Amplitude) * direction.y * cos((F1 * dot(float2(direction.x, direction.y), northVertex.xz)) + (phaseConst1 * time));

				southVertex.x += (Q1 * _Amplitude) * direction.x * cos((F1 * dot(float2(direction.x, direction.y), southVertex.xz)) + (phaseConst1 * time));
				southVertex.y += _Amplitude * sin((F1 * dot(float2(_Direction.x, direction.y), southVertex.xz)) + (phaseConst1 * time));
				southVertex.z += (Q1 * _Amplitude) * direction.y * cos((F1 * dot(float2(direction.x, direction.y), southVertex.xz)) + (phaseConst1 * time));

				eastVertex.x += (Q1 * _Amplitude) * direction.x * cos((F1 * dot(float2(direction.x, direction.y), eastVertex.xz)) + (phaseConst1 * time));
				eastVertex.y += _Amplitude * sin((F1 * dot(float2(_Direction.x, direction.y), eastVertex.xz)) + (phaseConst1 * time));
				eastVertex.z += (Q1 * _Amplitude) * direction.y * cos((F1 * dot(float2(direction.x, _Direction.y), eastVertex.xz)) + (phaseConst1 * time));

				westVertex.x += (Q1 * _Amplitude) * direction.x * cos((F1 * dot(float2(direction.x, direction.y), westVertex.xz)) + (phaseConst1 * time));
				westVertex.y += _Amplitude * sin((F1 * dot(float2(_Direction.x, direction.y), westVertex.xz)) + (phaseConst1 * time));
				westVertex.z += (Q1 * _Amplitude) * direction.y * cos((F1 * dot(float2(direction.x, direction.y), westVertex.xz)) + (phaseConst1 * time));
			}

			void vert(inout appdata_full v)
			{

				float4 heightMap = tex2Dlod(_HeightMap, float4( v.texcoord.xy, 0, 0 ));

				v.vertex.y += heightMap.b * _HeightMapScale;
				// S = 5;
				// A = ((0.27 * S * S) / G) / 2;
				// L = ((S * S) * 2 * PI) / G;
				// Dir = float2(1, 0); 

				_Length = _Speed * _DeltaTime * 150;

				CrestVelocity = sqrt((G * _Length) / (2 * PI));

				_Amplitude = ((0.27 * _Speed * _Speed) / G) / 2;

				_Direction = normalize(_Direction);

				if (_Length <= 0.1)
				{
					_Length = L;
				}

				F1 = (2 * PI) / _Length;
				// F2 = (2 * PI) / L;

				phaseConst1 = CrestVelocity * (2 * PI) / _Length;
				// phaseConst2 = S * (2 * PI) / L;

				Q1 = sqrt(G * ((2 * PI) / _Length));
				// Q2 = sqrt(G * ((2 * PI) / L));

				northVertex = v.vertex + float3(0, 0, 1);
				southVertex = v.vertex + float3(0, 0, -1);
				eastVertex = v.vertex + float3(1, 0, 0);
				westVertex = v.vertex + float3(-1, 0, 0);

				
				directionalWave1 = float2(_Direction.x, _Direction.y);

				//wave 1
				v.vertex.x += (Q1 * _Amplitude) * directionalWave1.x * cos((F1 * dot(directionalWave1, v.vertex.xz)) + (phaseConst1 * time));
				v.vertex.y += _Amplitude * sin((F1 * dot(directionalWave1, v.vertex.xz)) + (phaseConst1 * time));
				v.vertex.z += (Q1 * _Amplitude) * directionalWave1.y * cos((F1 * dot(directionalWave1, v.vertex.xz)) + (phaseConst1 * time));

				CalculateGhostVertices(directionalWave1);

				// directionalWave2 = float2(Dir.x, Dir.y);

				//wave 2
				// v.vertex.x += (Q2 * A) * directionalWave2.x * cos((F2 * dot(directionalWave2, v.vertex.xz)) + (phaseConst2 * time));
				// v.vertex.y += A * sin((F2 * dot(directionalWave2, v.vertex.xz)) + (phaseConst2 * time));
				// v.vertex.z += (Q2 * A) * directionalWave2.y * cos((F2 * dot(directionalWave2, v.vertex.xz)) + (phaseConst2 * time));

				// CalculateGhostVertices(directionalWave2);

				//Get a vector from one neighbour vertex to another, this gives us a base from which to calculate the normal
				float3 northSouth = northVertex - southVertex;
				float3 eastWest = eastVertex - westVertex;

				//Lets get the cross product of these to get the perpindicular normal
				float3 normals = cross(northSouth, eastWest) ;
				v.normal = normalize(normals);
			}

			void surf(Input i, inout SurfaceOutput o)
			{
				float2 uvs = i.uv_MainTex;
				// float disp = time * CrestVelocity / 250.0;
				// uvs += _Direction.xy * disp;

				fixed4 tex = tex2D(_MainTex, uvs);

				o.Albedo = tex.rgb * _Color.rgb;
				o.Gloss = tex.a * _Color.a;
				o.Alpha = _Color.a;
				o.Specular = 0.07;
			}

			ENDCG
	}
}
