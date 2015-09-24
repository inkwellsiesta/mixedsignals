// Fragment Shader
// Leslie Watkins

#ifdef GL_ES
precision highp float;
precision highp int;
#endif

uniform sampler2D ppixels;
uniform sampler2D texture;
uniform vec2 resolution;

uniform vec2 mouse;
uniform float rColor, gColor, bColor;

void main() {
  vec2 position = gl_FragCoord.xy/resolution.xy;

  if (length(position-mouse) < 0.01) { 
     gl_FragColor = vec4(rColor,gColor,bColor,1);
   } else { 
     gl_FragColor = (texture2D(ppixels, position) + 
     		     texture2D(ppixels, position-vec2(0,1)/resolution.xy) + 
		     texture2D(ppixels, position+vec2(0,1)/resolution.xy) +
		     texture2D(ppixels, position-vec2(1,0)/resolution.xy) + 
		     texture2D(ppixels, position+vec2(1,0)/resolution.xy))/(1. + 4.);
   }

   if (position.y <= 1./resolution.y) {
     gl_FragColor = vec4(0,0,0,1);
   }
	
}