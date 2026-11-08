"""Generate the editable SVG artwork for the board and plant atlas."""
import random
from pathlib import Path

ASSETS = Path(__file__).resolve().parents[1] / "assets"
PALETTES = [
    ("#f2ffc0", "#a2db40", "#39832d", 5),
    ("#ffe8ec", "#ff7eb6", "#ad2670", 6),
    ("#e4fcff", "#62c6ff", "#3652c0", 7),
    ("#fff7b1", "#ffba41", "#d16a21", 8),
]


def gradient(name, colors, radial=False):
    tag = "radialGradient" if radial else "linearGradient"
    coords = 'cx="35%" cy="25%" r="74%"' if radial else 'x2="0" y2="100%"'
    stops = "".join(f'<stop offset="{i / (len(colors) - 1):.3f}" stop-color="{color}"/>'
                    for i, color in enumerate(colors))
    return f'<{tag} id="{name}" {coords}>{stops}</{tag}>'


def write(name, width, height, defs, body):
    svg = (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}"><defs>{defs}</defs>{body}</svg>\n'
    )
    (ASSETS / name).write_text(svg.replace("><", ">\n<"))


def flower(color, stage, petals, openness=1.0):
    leaf = '<path d="M64 99 Q51 72 22 77 Q28 106 64 103 Q88 101 104 75 Q79 72 64 99Z" fill="url(#leaf)" stroke="#23552a" stroke-width="1.5"/>'
    veins = '<path d="M37 85 Q57 96 64 101 Q78 92 91 82" fill="none" stroke="#d9f47a" opacity=".7" stroke-width="1.7"/>'
    body = '<ellipse cx="65" cy="109" rx="44" ry="13" fill="#160b09" opacity=".28"/><ellipse cx="65" cy="108" rx="29" ry="8" fill="#21110a" opacity=".4"/>'
    body += f'<ellipse cx="65" cy="106" rx="21" ry="8" fill="url(#{color})" stroke="#352112" stroke-width="2"/>'
    markings = [
        '<circle cx="65" cy="106" r="4.5"/>',
        '<path d="M65 101 70 106 65 111 60 106Z"/>',
        '<path d="M65 101 70 110 60 110Z"/>',
        '<rect x="61" y="102" width="8" height="8" rx="1"/>',
    ]
    body += '<path d="M64 105 Q56 79 64 57" fill="none" stroke="#2b662a" stroke-width="8" stroke-linecap="round"/>'
    body += leaf + veins
    if stage == 0:
        body += '<path d="M64 87 Q42 76 45 58 Q64 61 65 78 Q66 58 83 55 Q88 77 64 87Z" fill="url(#leaf)" stroke="#285a2d" stroke-width="2"/>'
    elif stage == 1:
        body += f'<path d="M64 82 C43 76 37 57 46 40 C52 42 54 41 58 35 C64 27 66 24 69 29 C78 40 94 42 89 60 C85 73 76 81 64 82Z" fill="url(#{color})" stroke="#50324b" stroke-width="1.8"/>'
        body += '<path d="M54 65 Q47 57 54 47 M68 39 Q77 49 75 56" fill="none" stroke="#fff" stroke-width="4" stroke-linecap="round" opacity=".45"/><path d="M65 83 Q45 84 43 66 Q55 66 65 78 Q74 68 87 68 Q84 83 65 83" fill="url(#leaf)"/>'
    else:
        body += '<ellipse cx="64" cy="58" rx="43" ry="37" fill="#331526" opacity=".28"/>'
        for ring, scale in ((0, 1), (1, .70)):
            for i in range(petals):
                angle = (i + .5 * ring) * 360 / petals
                transform = f'rotate({angle:.3f}) scale({scale} {scale})'
                if openness < 1:
                    angle = ((angle + 180) % 360 - 180) * openness
                    width = scale * (.64 + .36 * openness)
                    length = scale * (.57 + .43 * openness)
                    transform = f'rotate({angle:.3f}) scale({width:.3f} {length:.3f})'
                body += f'<g transform="translate(64 52) {transform}"><path d="M0 8 C-13 -1 -25 -23 -17 -36 C-10 -49 12 -51 19 -37 C28 -21 10 1 0 8Z" fill="url(#{color})" stroke="#6e3652" stroke-opacity=".35" stroke-width="1.4"/><path d="M-12 -32 Q-6 -42 6 -41" fill="none" stroke="#fff" stroke-width="3" stroke-linecap="round" opacity=".52"/></g>'
        body += '<circle cx="64" cy="52" r="16" fill="url(#pollen)" stroke="#ad6425" stroke-width="2"/><path d="M55 48 Q58 42 66 43" fill="none" stroke="#fff7c6" stroke-width="3" stroke-linecap="round"/>'
        for x, y in [(59, 54), (67, 52), (71, 57), (63, 61), (74, 48)]:
            body += f'<circle cx="{x}" cy="{y}" r="1.8" fill="#b77928"/>'
    if stage < 2:
        marker = markings[int(color[-1]) if color.startswith("petal") else 3]
        body += f'<g fill="#fff6d1">{marker}</g>'
    return body


def main():
    defs = gradient("leaf", ["#e0fa91", "#78bd4e", "#23734b"], True)
    defs += gradient("pollen", ["#ffffb0", "#ffce58", "#d67b21"], True)
    body = ""
    opening = ""
    for species, (*colors, petals) in enumerate(PALETTES):
        name = f"petal{species}"
        defs += gradient(name, colors, True)
        for stage in range(3):
            body += f'<g transform="translate({128 * stage} {128 * species})">{flower(name, stage, petals)}</g>'
        for frame in range(6):
            openness = .24 + .76 * frame / 5
            opening += f'<g transform="translate({128 * frame} {128 * species})">{flower(name, 2, petals, openness)}</g>'
    write("plants.svg", 384, 512, defs, body)
    write("bloom_opening.svg", 768, 512, defs, opening)
    petals = flower("gold", 2, 7)
    logo_defs = defs + gradient("gold", ["#fff8a4", "#ffc34b", "#f37d39"], True)
    write("icon.svg", 128, 128, logo_defs,
          '<rect width="128" height="128" rx="30" fill="#164a3a"/><circle cx="64" cy="64" r="52" fill="#2d7052" stroke="#e9b650" stroke-width="3"/>' + petals)
    write("launcher_flower.svg", 128, 128, logo_defs,
          '<g transform="translate(22 22) scale(.66)">' + petals + '</g>')
    rng = random.Random(81)
    defs = gradient("earth", ["#563026", "#60382b", "#3b211c"])
    soil = '<rect x="1" y="3" width="126" height="123" rx="18" fill="#391f17"/><rect x="3" y="2" width="122" height="120" rx="17" fill="url(#earth)" stroke="#b57844" stroke-width="2"/><path d="M12 30 V21 Q12 10 24 10 H105" fill="none" stroke="#241710" opacity=".4" stroke-width="3"/>'
    for _ in range(76):
        x, y = rng.randint(11, 117), rng.randint(12, 114)
        soil += f'<ellipse cx="{x}" cy="{y}" rx="{rng.uniform(.5, 2.7):.1f}" ry="{rng.uniform(.5, 1.4):.1f}" fill="{rng.choice(["#f1ba81", "#23100a"])}" opacity=".18"/>'
    write("soil.svg", 128, 128, defs, soil)
    defs = gradient("wood", ["#ffe1a3", "#d88c41", "#99511e", "#60331d"])
    wood = '<rect x="3" y="5" width="634" height="632" rx="42" fill="#3e2419"/><rect x="3" y="2" width="634" height="628" rx="41" fill="url(#wood)" stroke="#7c481e" stroke-width="5"/><rect x="13" y="12" width="614" height="606" rx="33" fill="none" stroke="#ffdda0" stroke-opacity=".73" stroke-width="3"/>'
    for i in range(33, 620, 13):
        x = rng.randint(17, 120)
        wood += f'<path d="M{x} {i} Q210 {i+9} 347 {i-2} T622 {i+2}" fill="none" stroke="#522510" stroke-width="2" opacity=".18"/>'
    write("wood.svg", 640, 640, defs, wood)


if __name__ == "__main__":
    main()
