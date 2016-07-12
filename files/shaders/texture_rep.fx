texture Tex;

technique tec0
{
    pass P0
    {
        MaterialAmbient = Tex;
        MaterialDiffuse = Tex;
        MaterialEmissive = Tex;
        MaterialSpecular = Tex;

        AmbientMaterialSource = Material;
        DiffuseMaterialSource = Material;
        EmissiveMaterialSource = Material;
        SpecularMaterialSource = Material;

        ColorOp[0] = SELECTARG1;
        ColorArg1[0] = Diffuse;

        AlphaOp[0] = SELECTARG1;
        AlphaArg1[0] = Diffuse;

        Lighting = true;
    }
}
