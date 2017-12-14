/* Euan Watt
* Purpose of this class:
*	The standard unity plane is not detailed enough for what we need.
*	This class generates a custom mesh of quads each of a unit size.
*	Unity sets a vertex limit for any mesh at 65000, so the largest this plane can be is 254x254.
*/

using UnityEngine;
using System.Collections;
#if UNITY_EDITOR
using UnityEditor;
#endif

public class GeneratePlane : MonoBehaviour
{
    Vector3[] vertices;
    Vector2[] UV;
    int[] triangles;
    Vector3[] normals;
    public Mesh plane;
    public Material material;
    public int meshHeight = 100;
    public int meshWidth = 100;
    int index = 0;
    int triangleIndex = 0;

    // Use this for initialization
    void Start()
    {
        //Set up the relevant arrays for mesh generation
        Mesh planeMesh = new Mesh();
        vertices = new Vector3[meshWidth * meshHeight];
        UV = new Vector2[meshWidth * meshHeight];
        triangles = new int[(meshWidth - 1) * (meshHeight - 1) * 6]; //this is multiplied by 6 as this is an index array, meaning there are 6 points for every quad (since each quad is made of triangles)
        normals = new Vector3[meshWidth * meshHeight];

        //calculate vertices for plane
        for (int i = 0; i < meshWidth; i++)
        {
            for (int j = 0; j < meshHeight; j++)
            {
                //get index for array
                index = (meshHeight * j) + i;
                vertices[index] = new Vector3(i, 0, j); //Generate a list of vertices
                normals[index] = new Vector3(0, 1, 0); //just have all normals point up to begin with, since mesh sits in x, z plane
            }
        }

        int test = 0;
        while (test < UV.Length)
        {
            UV[test] = new Vector2(vertices[test].x / meshHeight, vertices[test].z / meshHeight); //Set up the texture coordinates
            test++;
        }

        for (int j = 0; j < (meshHeight - 1); j++)
        {
            for (int i = 0; i < (meshWidth - 1); i++)
            {
                //Get the index for each vertex, this tells Unity the build order for the mesh.
                int index1 = (j * meshHeight) + i;
                int index2 = (j * meshHeight) + (i + 1);
                int index3 = ((j + 1) * meshHeight) + i;
                int index4 = ((j + 1) * meshHeight) + (i + 1);

                // Get three vertices from the face.
                triangles[triangleIndex] = index1;
                triangleIndex++;

                triangles[triangleIndex] = index3;
                triangleIndex++;

                triangles[triangleIndex] = index2;
                triangleIndex++;

                triangles[triangleIndex] = index2;
                triangleIndex++;

                triangles[triangleIndex] = index3;
                triangleIndex++;

                triangles[triangleIndex] = index4;
                triangleIndex++;
            }
        }

        //This sends all the information above to the mesh renderer
        planeMesh.vertices = vertices;
        planeMesh.uv = UV;
        planeMesh.triangles = triangles;
        planeMesh.normals = normals;

        //Render the mesh
        gameObject.GetComponent<Renderer>().sharedMaterial = material;
        gameObject.GetComponent<MeshFilter>().mesh = planeMesh;
#if UNITY_EDITOR
        AssetDatabase.CreateAsset(planeMesh, "Assets/generated_plane.asset");
        AssetDatabase.SaveAssets();
#endif
    }

    // Update is called once per frame
    void Update()
    {
    }
}