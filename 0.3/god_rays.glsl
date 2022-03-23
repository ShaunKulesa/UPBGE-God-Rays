uniform sampler2D bgl_RenderedTexture;
uniform sampler2D bgl_DepthTexture;

in vec4 bgl_TexCoord;
out vec4 fragColor;

//uniform float avgL;

const float dens = 0.6; // Density
const float dec = 0.95; // Decay
const float weight = 0.2;
float exp = 0.25; // Exposure

// Light Screen (Origin if effect is not working Play with X & Y)

uniform float xPos = 0.5; // 0.0 - 1.0
uniform float yPos = 0.8; // 0.0 - 1.0

uniform vec2 lightScreenPos;

// Number of Ray Samples (Quality 1 - 128)

const int raySamples = 64;
vec4 origin;
vec4 sample1;
vec4 mask;

void main()
{
    origin = vec4(0,0,0,0);
    sample1 = vec4(0,0,0,0);
    mask   = vec4(0,0,0,0);
    
    vec2 lightScreenPos = vec2(xPos,yPos);

    vec2 deltaTexCoord = vec2(bgl_TexCoord) - lightScreenPos;
	vec2 texCoo = bgl_TexCoord.st;
	deltaTexCoord *= 1.0 / float(raySamples) * dens;
	float illumDecay = 1.0;

   for(int i=0; i < raySamples ; i++)
   {
       texCoo -= deltaTexCoord;

        if (texture2D(bgl_DepthTexture, texCoo).r > 0.9989)
        {
            sample1 += texture2D(bgl_RenderedTexture, texCoo);
        }
        
        sample1 *= illumDecay * weight;
    
        origin += sample1;
        illumDecay *= dec;
    }
    
    vec2 texcoord = bgl_TexCoord.xy;
 
    fragColor = texture2D(bgl_RenderedTexture, texcoord) + (origin*exp);

}
