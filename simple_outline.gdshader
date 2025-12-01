shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform bool enable = false;
varying flat vec4 modulate;

void vertex() {
	modulate = COLOR;
	//if enalbe and UV of the vertex is at or outside the edge,
	//move vertex position by a single pixel outwards.
	if (enable && (UV.x <= 0.0 || UV.x >= 1.0) && (UV.y <= 0.0 || UV.y >= 1.0))
		VERTEX += UV * 2.0 - 1.0;
	}
bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D _texture) {
	for (int i = 0; i < 4; i++){
		//bit-wise operation to cheeply obtain desired coordinates
		//x and y value as results of i are :
		//(-1,0), (1,0), (0,-1), (0,1)
		int x = int(i < 2) * ((i & 1)*2-1);
		int y = int(i > 1) * ((i & 1)*2-1);
		//near_uv are the neighboring pixels of given uv.
		vec2 near_uv = uv + texture_pixel_size * vec2(float(x), float(y));
		//if near_uv is within (0,0)-(1,1) and texture at near_uv is not empty(a<=0.0) return true
		if (near_uv == clamp(near_uv, vec2(0.0), vec2(1.0)) && texture(_texture, near_uv).a > 0.0)
			return true;
		}
	return false;
	}
void fragment() {
	if (enable) {
		vec2 uv = UV;
		vec2 texture_pixel_size = 1.0 / (1.0 / TEXTURE_PIXEL_SIZE + 2.0);
		//remap uv from (0,0)-(1,1) to (0-TEXTURE_PIXEL_SIZE)-(1+TEXTURE_PIXEL_SIZE)
		uv = (uv - texture_pixel_size) * TEXTURE_PIXEL_SIZE / texture_pixel_size;
		//if remapped uv is outside (0,0)-(1,1), modulate a = 0
		if (uv != clamp(uv, vec2(0.0), vec2(1.0)))
			COLOR.a = 0.0;
		//if remapped uv is inside (0,0)-(1,1), modulate = origianl modulate
		else
			COLOR = texture(TEXTURE, uv) * modulate;
		//if current texture is empty(a<=0) and this pixel has contrary neighbor,
		//set color modulation as set uniform var color
		if (COLOR.a <= 0.0 && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
			COLOR.rgb = color.rgb * modulate.rgb;
			COLOR.a += (1.0 - COLOR.a) * color.a * modulate.a;
			}
	}
}