Shader "Custom/Gerstner Wave" 
{
	/* Euan Watt
	* Purpose of this shader:
	*	This shader utilises the Gerstner Wave algorithm which can be found here: http://http.developer.nvidia.com/GPUGems/gpugems_ch01.html
	*	The algorithm takes an ordinary sin wave, or in this case 4, and manipulates the peak to make it pointed like a real wave.
	*	The user, with the help of the GerstnerWaveScript.cs can pass in up to four unique waves, directional or circular.
	*	As well as manipulate the vertices of the mesh this shader is applied to, it also calculates the new normals in real time.
	*	The fragment shader found here is a partially edited version of the one by Mark Woulfe, December 5th, 2011. Found here: http://doc.gold.ac.uk/~ma901mw/Woulfepress/gerstner-waves-unity3d/ [accessed 15th March, 2015].
	*/
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,0.5)
	}
	
	SubShader 
	{ 
		CGPROGRAM
		#pragma surface surf BlinnPhong alpha vertex:vert
        #pragma target 3.0 //this sets the rendering target to Shader model 2.0 in DirectX 9 (this is the default hence commented out)

		//float4 values below now allow for 4 waves to be passed through mesh, .x .y .z .w all represent a wave individually
		sampler2D _MainTex;
		float4 steepness;
		float4 amplitude;
		float4 direction1;
		float4 direction2;
		float4 centre1;
		float4 centre2;
		float4 circular;
		float4 wavelength;
		float4 speed;
		float deltaTime;
		float PI;
		float4 frequency = 0;
		float4 phaseConstant = 0;
		fixed4 _Color;
		float3 northVertex, southVertex, eastVertex, westVertex;
		float2 directionalWave1, directionalWave2, directionalWave3, directionalWave4;
		
		struct Input 
		{
			float2 uv_MainTex;
		};
		
		void CalculateGhostVertices(float2 direction)
		{
			//This applies the wave algorithm to the neighbour vertices, adding at each wave in order to get the normal at the current vertex
			northVertex.x += (steepness.x * amplitude.x) * direction.x * cos((frequency.x * dot(float2(direction.x, direction.y), northVertex.xz)) + (phaseConstant.x * deltaTime));
	    	northVertex.y += amplitude.x * sin((frequency.x * dot(float2(direction1.x, direction.y), northVertex.xz)) + (phaseConstant.x * deltaTime));
	    	northVertex.z += (steepness.x * amplitude.x) * direction.y * cos((frequency.x * dot(float2(direction.x, direction.y), northVertex.xz)) + (phaseConstant.x * deltaTime));
	    	
	    	southVertex.x += (steepness.x * amplitude.x) * direction.x * cos((frequency.x * dot(float2(direction.x, direction.y), southVertex.xz)) + (phaseConstant.x * deltaTime));
	    	southVertex.y += amplitude.x * sin((frequency.x * dot(float2(direction1.x, direction.y), southVertex.xz)) + (phaseConstant.x * deltaTime));
	    	southVertex.z += (steepness.x * amplitude.x) * direction.y * cos((frequency.x * dot(float2(direction.x, direction.y), southVertex.xz)) + (phaseConstant.x * deltaTime));
	    	
	    	eastVertex.x += (steepness.x * amplitude.x) * direction.x * cos((frequency.x * dot(float2(direction.x, direction.y), eastVertex.xz)) + (phaseConstant.x * deltaTime));
	    	eastVertex.y += amplitude.x * sin((frequency.x * dot(float2(direction1.x, direction.y), eastVertex.xz)) + (phaseConstant.x * deltaTime));
	    	eastVertex.z += (steepness.x * amplitude.x) * direction.y * cos((frequency.x * dot(float2(direction.x, direction1.y), eastVertex.xz)) + (phaseConstant.x * deltaTime));
	    	
	    	westVertex.x += (steepness.x * amplitude.x) * direction.x * cos((frequency.x * dot(float2(direction.x, direction.y), westVertex.xz)) + (phaseConstant.x * deltaTime));
	    	westVertex.y += amplitude.x * sin((frequency.x * dot(float2(direction1.x, direction.y), westVertex.xz)) + (phaseConstant.x * deltaTime));
	    	westVertex.z += (steepness.x * amplitude.x) * direction.y * cos((frequency.x * dot(float2(direction.x, direction.y), westVertex.xz)) + (phaseConstant.x * deltaTime));
		}

	    void vert(inout appdata_full v) 
	    {
	    	//wave 1
	    	frequency.x = (2 * PI) / wavelength.x;
	   		phaseConstant.x = speed.x * (2 * PI) / wavelength.x;
	   		northVertex = v.vertex + float3(0, 0, 1);
	   		southVertex = v.vertex + float3(0, 0, -1);
	   		eastVertex = v.vertex + float3(1, 0, 0);
	   		westVertex = v.vertex + float3(-1, 0, 0);
	   		
	   		directionalWave1 = float2(direction1.x, direction1.y);
	   		
	   		if(circular.x == 1)
	   		{		   			
				//If the user has set the wave to be circular, calculate the current direction based on the origin of the circle and the current vertex position
	   			directionalWave1.x = (v.vertex.x - centre1.x)/sqrt((v.vertex.x * v.vertex.x) + (centre1.x * centre1.x));
	   			directionalWave1.y = (v.vertex.z - centre1.y)/sqrt((v.vertex.z * v.vertex.z) + (centre1.y * centre1.y));
	   		}
	    	
			//Apply the Gerstner Algorithm with the input values
	    	v.vertex.x += (steepness.x * amplitude.x) * directionalWave1.x * cos((frequency.x * dot(directionalWave1, v.vertex.xz)) + (phaseConstant.x * deltaTime));
	    	v.vertex.y += amplitude.x * sin((frequency.x * dot(directionalWave1, v.vertex.xz)) + (phaseConstant.x * deltaTime));
	    	v.vertex.z += (steepness.x * amplitude.x) * directionalWave1.y * cos((frequency.x * dot(directionalWave1, v.vertex.xz)) + (phaseConstant.x * deltaTime));
	    	
			//Calculate the vertex positions of the neighbours for calculating normals
	    	CalculateGhostVertices(directionalWave1);
	    	
			//Repeat if there is more than one wave
	    	if(amplitude.y != 0)
	    	{
		    	//wave 2
		    	frequency.y = (2 * PI) / wavelength.y;
		   		phaseConstant.y = speed.y * (2 * PI) / wavelength.y;
		   		
		   		directionalWave2 = float2(direction1.z, direction1.w);
		   		
		   		if(circular.y == 1)
		   		{		   			
		   			directionalWave2.x = (v.vertex.x - centre1.z)/sqrt((v.vertex.x * v.vertex.x) + (centre1.z * centre1.z));
		   			directionalWave2.y = (v.vertex.z - centre1.w)/sqrt((v.vertex.z * v.vertex.z) + (centre1.w * centre1.w));
		   		}
		    	
		    	v.vertex.x += (steepness.y * amplitude.y) * directionalWave2.x * cos((frequency.y * dot(directionalWave2, v.vertex.xz)) + (phaseConstant.y * deltaTime));
		    	v.vertex.y += amplitude.y * sin((frequency.y * dot(directionalWave2, v.vertex.xz)) + (phaseConstant.y * deltaTime));
		    	v.vertex.z += (steepness.y * amplitude.y) * directionalWave2.y * cos((frequency.y * dot(directionalWave2, v.vertex.xz)) + (phaseConstant.y * deltaTime));
		    	
		    	CalculateGhostVertices(directionalWave2);
		    }
	    	
	    	if(amplitude.z != 0)
	    	{
		    	//wave 3
		    	frequency.z = (2 * PI) / wavelength.z;
		   		phaseConstant.z = speed.z * (2 * PI) / wavelength.z;
		   		
		   		directionalWave3 = float2(direction2.x, direction2.y);
		   		
		   		if(circular.z == 1)
		   		{		   			
		   			directionalWave3.x = (v.vertex.x - centre2.x)/sqrt((v.vertex.x * v.vertex.x) + (centre2.x * centre2.x));
		   			directionalWave3.y = (v.vertex.z - centre2.y)/sqrt((v.vertex.z * v.vertex.z) + (centre2.y * centre2.y));
		   		}
		    	
		    	v.vertex.x += (steepness.z * amplitude.z) * directionalWave3.x * cos((frequency.z * dot(directionalWave3, v.vertex.xz)) + (phaseConstant.z * deltaTime));
		    	v.vertex.y += amplitude.z * sin((frequency.z * dot(directionalWave3, v.vertex.xz)) + (phaseConstant.z * deltaTime));
		    	v.vertex.z += (steepness.z * amplitude.z) * directionalWave3.y * cos((frequency.z * dot(directionalWave3, v.vertex.xz)) + (phaseConstant.z * deltaTime));
		    	
		    	CalculateGhostVertices(directionalWave3);
		    }
	    	
	    	if(amplitude.w != 0)
	    	{
		    	//wave 4
		    	frequency.w = (2 * PI) / wavelength.w;
		   		phaseConstant.w = speed.w * (2 * PI) / wavelength.w;
		   		
		   		directionalWave4 = float2(direction2.z, direction2.w);
		   		
		   		if(circular.w == 1)
		   		{		   			
		   			directionalWave4.x = (v.vertex.x - centre2.z)/sqrt((v.vertex.x * v.vertex.x) + (centre2.z * centre2.z));
		   			directionalWave4.y = (v.vertex.z - centre2.w)/sqrt((v.vertex.z * v.vertex.z) + (centre2.w * centre2.w));
		   		}
		   		
		   		v.vertex.x += (steepness.w * amplitude.w) * directionalWave4.x * cos((frequency.w * dot(directionalWave4, v.vertex.xz)) + (phaseConstant.w * deltaTime));
		    	v.vertex.y += amplitude.w * sin((frequency.w * dot(directionalWave4, v.vertex.xz)) + (phaseConstant.w * deltaTime));
		    	v.vertex.z += (steepness.w * amplitude.w) * directionalWave4.y * cos((frequency.w * dot(directionalWave4, v.vertex.xz)) + (phaseConstant.w * deltaTime));
		    	
		    	CalculateGhostVertices(directionalWave4);
		    }
			
			//Get a vector from one neighbour vertex to another, this gives us a base from which to calculate the normal
			float3 northSouth = northVertex - southVertex;
			float3 eastWest = eastVertex - westVertex;

			//Lets get the cross product of these to get the perpindicular normal
			float3 normals = cross(northSouth, eastWest);
			v.normal = normalize(normals);	
	    }

	    void surf (Input IN, inout SurfaceOutput o)
	    {
			//Taken and slightly edited from here: http://doc.gold.ac.uk/~ma901mw/Woulfepress/gerstner-waves-unity3d/ 
		    //this code takes the position of the texture and moves it based on the direction vector
		    float2 uvs = IN.uv_MainTex;
		    float disp = deltaTime*speed.x/250.0f;
		    uvs += direction1.xy*disp;
			fixed4 tex = tex2D(_MainTex, uvs);
			//multiply the colour value by the texture so you can change its appearance
			o.Albedo = tex.rgb;
			//set the gloss to the alpha value (not entirely sure why)
			o.Gloss = tex.a;
			//get the alpha value from the colour and times it by the texture
			o.Alpha = 1.0f;//tex.a * _Color.a;
			//the specularity is equal to the variable defined above
			o.Specular = 0.07;
		}
	    
		ENDCG
	} 
}