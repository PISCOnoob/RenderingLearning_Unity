#ifndef WHITE_NOISE
#define WHITE_NOISE

// 1d output

float Rand_3dTo1d(float3 vec, float3 dotDir = float3(12.9898, 78.233, 37.719)) 
{
    float random = dot(vec, dotDir);
    random = sin(random);
    random = frac(random * 163758.3153);
    return random;
}

float Rand_2dTo1d(float2 vec, float2 dotDir = float2(12.9898, 78.233)) 
{
    float random = dot(vec, dotDir);
    random = sin(random);
    random = frac(random * 163758.3153);
    return random;
}

float Rand_1dTo1d(float value, float mutator = 37.719) 
{
    float random = frac(sin(value + mutator) * 163758.3153);  
    return random;
}

// 2d output

float2 Rand_3dTo2d(float3 vec) 
{
    
    return float2(
    Rand_3dTo1d(vec, float3(12.989, 78.233, 37.719)),
    Rand_3dTo1d(vec, float3(89.138, 21.982, 67.739))
    );
}

float2 Rand_2dTo2d(float2 vec)
{
    return float2(
    Rand_2dTo1d(vec, float2(65.324, 13.446)),
    Rand_2dTo1d(vec, float2(14.965, 78.346))
    );
}

float2 Rand_1dTo2d(float value) 
{
    return float2(
    Rand_2dTo1d(value, 99.81),
    Rand_2dTo1d(value, 77.49)
    );
}



// 3d output

float3 Rand_3dTo3d(float3 vec) 
{
    return float3(
    Rand_3dTo1d(vec,float3(12.169, 78.233, 17.219)),
    Rand_3dTo1d(vec,float3(99.346, 22.135, 83.155)),
    Rand_3dTo1d(vec,float3(21.196, 52.235, 03.191))
    );
}

float3 Rand_2dTo3d(float2 vec) 
{
    return float3(
    Rand_2dTo1d(vec,float2(22.165, 98.532)),
    Rand_2dTo1d(vec,float2(99.346, 22.135)),
    Rand_2dTo1d(vec,float2(21.196, 52.235))
    );
}

float3 Rand_1dTo3d(float value) 
{
    return float3(
    Rand_1dTo1d(value, 52.235),
    Rand_1dTo1d(value, 98.125),
    Rand_1dTo1d(value, 11.235)
    );
}


#endif