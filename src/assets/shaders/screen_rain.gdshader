shader_type canvas_item;
render_mode unshaded;

uniform float rain_amount : hint_range(0.0, 1.0) = 0.25;
uniform float blue_amount : hint_range(0.0, 1.0) = 0.0;
uniform float speed : hint_range(0.0, 2.0) = 0.2;
uniform float trail_strength : hint_range(0.0, 1.0) = 1.0;
uniform float trail_length : hint_range(0.0, 1.0) = 1.0;
uniform float drop_size : hint_range(0.1, 2.0) = 1.5;
uniform float wind_strength : hint_range(-1.0, 1.0) = 0.0;
uniform float blur_strength : hint_range(0.0, 8.0) = 2.0;
uniform float highlight_intensity : hint_range(0.0, 2.0) = 0.5;
uniform float density : hint_range(0.5, 4.0) = 1.0;
uniform float chromatic_aberration : hint_range(0.0, 0.01) = 0.002;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

vec3 N13(float p) {
    vec3 p3 = fract(vec3(p) * vec3(.1031, .11369, .13787));
    p3 += dot(p3, p3.yzx + 19.19);
    return fract(vec3((p3.x + p3.y) * p3.z, (p3.x + p3.z) * p3.y, (p3.y + p3.z) * p3.x));
}

float N(float t) {
    return fract(sin(t * 12345.564) * 7658.76);
}

float Saw(float b, float t) {
    return smoothstep(0.0, b, t) * (1.0 - smoothstep(b, 1.0, t));
}

float sdEgg(vec2 p, float ra, float rb) {
    const float k = sqrt(3.0);
    p.x = abs(p.x);
    float r = ra - rb;
    return ((p.y < 0.0) ? length(vec2(p.x, p.y)) - r
                       : (k * (p.x + r) < p.y) ? length(vec2(p.x, p.y - k * r))
                                               : length(vec2(p.x + r, p.y)) - 2.0 * r) - rb;
}

// Улучшенный слой капель с ветром, бликами и следом
vec2 DropLayer2(vec2 uv, float t, vec2 densityScale) {
    vec2 a = vec2(6.0, 1.0) * densityScale * density;
    vec2 grid = a * 2.0;
    vec2 id = floor(uv * grid);
    float gridFall = N(id.x) / 3.0 + 0.5;

    uv.y -= t * gridFall / a.y;

    id = floor(uv * grid);
    uv.y += N(id.x);
    id = floor(uv * grid);
    vec2 st = fract(uv * grid) - vec2(0.5, 0.0);
    vec3 n = N13(id.x * 35.2 + id.y * 2376.1);
    float x = n.x - 0.7;

    // Горизонтальное покачивание
    x += sin(uv.y * 20.0 + sin(uv.y * 20.0)) * (0.5 - abs(x)) * (n.z - 0.5) * 0.3;
    x *= 0.6;

    float ti = fract(t * (gridFall + 0.1) + n.z);
    float y = 1.0 - ti;

    // Добавляем влияние ветра (сдвиг по горизонтали, зависящий от высоты)
    x += wind_strength * (1.0 - ti) * 0.3;

    float dropShape = mix(0.0, -0.2, ti);
    float diameter = (N(id.x + id.y) / 7.0 + 0.2) * drop_size;

    // Основная капля
    float d = sdEgg((st - vec2(x, y)) * a.yx, 0.0, dropShape);
    float mainDrop = smoothstep(diameter / 1.5, 0.0, d);

    // Блик на капле
    float highlight = smoothstep(diameter * 0.2, 0.0, length((st - vec2(x, y)) - vec2(-0.02, -0.05) * diameter));
    mainDrop += highlight * highlight_intensity;

    // Шлейф под каплей
    float trail = 0.0;
    if (st.y < y) {
        float width = diameter * 0.75;
        float hFade = smoothstep(width, 0.0, abs(st.x - x));
        float dist = y - st.y;
        float maxDist = 0.3 * trail_length;
        float vFade = smoothstep(0.0, maxDist, dist);
        trail = hFade * vFade * 0.5 * trail_strength;
    }

    // Слабый след над каплей (мокрый след)
    if (st.y > y) {
        float width = diameter * 0.9;
        float hFade = smoothstep(width, 0.0, abs(st.x - x));
        float dist = st.y - y;
        float maxDist = 0.1 * trail_length;
        float vFade = smoothstep(0.0, maxDist, dist);
        trail += hFade * vFade * 0.2 * trail_strength;
    }

    return vec2(mainDrop, trail);
}

// Статические капли
float StaticDrops(vec2 uv, float t) {
    uv *= 40.0;
    vec2 id = floor(uv);
    vec3 n = N13(id.x * 106.45 + id.y * 3543.654);
    vec2 center = (n.xy - 0.5) * 0.6;
    uv = fract(uv) - 0.5;
    float d = length(uv - center.xy);
    float drop = smoothstep(0.3, 0.0, d);
    float fade = Saw(0.10, fract(t + n.y));
    return drop * fade * fract(n.z * 27.0);
}

// Комбинирование слоёв
vec2 Drops(vec2 uv, float t, float l0, float l1, float l2) {
    float s = StaticDrops(uv, t) * l0;
    vec2 m1 = DropLayer2(uv, t, vec2(1.0)) * l1;
    vec2 m2 = DropLayer2(uv * 1.85, t, vec2(1.0)) * l2;
    float c = smoothstep(0.3, 1.0, s + m1.x + m2.x);
    return vec2(c, m1.y + m2.y);
}

void fragment() {
    vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 aspect_uv = (FRAGCOORD.xy - 0.5 * resolution.xy) / resolution.y;
    float t = TIME * speed;

    // Исправленные веса слоёв: при rain_amount = 0 эффект исчезает
    float staticDrops = smoothstep(0.0, 0.1, rain_amount);
    float layer1 = smoothstep(0.25, 0.75, rain_amount);
    float layer2 = smoothstep(0.0, 0.5, rain_amount);

    vec2 c = Drops(aspect_uv, t, staticDrops, layer1, layer2);

    // Преломление фона
    vec2 grad = vec2(dFdx(c.x), dFdy(c.x));
    vec2 scale = 0.5 * vec2(resolution.y / resolution.x, 1.0);
    vec2 n = grad * scale;

    float maxBlur = mix(3.0, 6.0, rain_amount) * blur_strength;
    float minBlur = 1.0 * blur_strength;
    float focus = mix(maxBlur - c.y, minBlur, smoothstep(0.1, 0.2, c.x));

    // Выборка цвета с возможной хроматической аберрацией
    vec3 col;
    if (chromatic_aberration > 0.0) {
        float ca = chromatic_aberration;
        col.r = textureLod(SCREEN_TEXTURE, SCREEN_UV + n * (1.0 + ca), focus).r;
        col.g = textureLod(SCREEN_TEXTURE, SCREEN_UV + n, focus).g;
        col.b = textureLod(SCREEN_TEXTURE, SCREEN_UV + n * (1.0 - ca), focus).b;
    } else {
        col = textureLod(SCREEN_TEXTURE, SCREEN_UV + n, focus).rgb;
    }

    // Цветовая тонировка
    vec3 target_color = mix(vec3(1.0), vec3(0.8, 0.9, 1.3), blue_amount);
    float colFade = sin(t * 0.2) * 0.5 + 0.5;
    col *= mix(vec3(1.0), target_color, colFade);

    // Виньетка
    vec2 vignette_uv = SCREEN_UV - 0.5;
    col *= 1.0 - dot(vignette_uv, vignette_uv);

    COLOR = vec4(col, 1.0);
}