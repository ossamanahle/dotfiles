// Fade the cursor when the terminal is not focused.
// Ghostty draws a hollow box for the unfocused cursor; this blends that cell
// toward the background so it becomes a subtle hint instead of a bright box.

const float FADE = 0.75; // 0.0 = no fade, 1.0 = invisible

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 color = texture(iChannel0, uv);

    if (iFocus == 0 && iCursorVisible.x > 0.0) {
        // iCurrentCursor.xy = top-left corner (y grows upward), .zw = size
        vec4 c = iCurrentCursor;
        bool inside =
            fragCoord.x >= c.x && fragCoord.x < c.x + c.z &&
            fragCoord.y <= c.y && fragCoord.y > c.y - c.w;
        if (inside) {
            // Real background = the empty cell just right of the cursor
            vec2 bgPos = vec2(c.x + c.z * 1.5, c.y - c.w * 0.5);
            vec4 bg = texture(iChannel0, bgPos / iResolution.xy);
            color = mix(color, bg, FADE);
        }
    }

    fragColor = color;
}
