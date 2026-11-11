"""Pack existing Blender PNGs for Flutter; leave all exports unchanged.

Run with Python + Pillow: python tool/build_focus_atlas.py
The manifest retains each original 600px canvas rect and part name. Runtime
draw order, transforms, sockets and baked occlusion still come from the JSONs.
"""
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
EXPORT = ROOT / 'preview' / 'sit_down'
OUTPUT = ROOT / 'assets' / 'animations' / 'focus'
CLIPS = ('sit_down', 'focus_breathe', 'idle_breathe', 'think', 'fix_leaf',
         'fidget', 'stretch', 'rebalance', 'focus_complete')
SIDE = 2048
PADDING = 2


def main():
    paths_by_clip = []
    for name in CLIPS:
        data = json.loads((EXPORT / f'{name}.json').read_text(encoding='utf-8'))
        paths_by_clip.append({
            frame['parts'][part].get('bakedPng', data['parts'][part]['png'])
            for frame in data['frames'] for part in frame['drawOrder']
        })
    sit = paths_by_clip[0]
    focus = sit | paths_by_clip[1]
    sprites = []
    for path in sorted(set.union(*paths_by_clip)):
        # Match the previous runtime decode sizes before trimming. This keeps
        # shared rigid art at 360px, focus art at 256px and waiting art at 224px.
        width = 360 if path in sit else 256 if path in focus else 224
        with Image.open(EXPORT / path) as source:
            original_width, original_height = source.size
            image = source.convert('RGBA')
        width = min(width, original_width)
        height = round(original_height * width / original_width)
        image = image.resize((width, height), Image.Resampling.LANCZOS)
        box = image.getbbox() or (0, 0, 1, 1)
        cropped = image.crop(box)
        destination = [box[0] * original_width / width,
                       box[1] * original_height / height,
                       (box[2] - box[0]) * original_width / width,
                       (box[3] - box[1]) * original_height / height]
        sprites.append((path, cropped, destination))
    sprites.sort(key=lambda s: (-s[1].height, -s[1].width, s[0]))
    pages = []
    regions = {}
    for path, image, destination in sprites:
        w, h = image.width + PADDING * 2, image.height + PADDING * 2
        assert w <= SIDE and h <= SIDE
        selected = None
        for index, page in enumerate(pages):
            x, y, row = page['x'], page['y'], page['row']
            if x + w > SIDE:
                x, y, row = 0, y + row, 0
            if y + h <= SIDE:
                selected = index, x, y, row
                break
        if selected is None:
            pages.append({'image': Image.new('RGBA', (SIDE, SIDE)),
                          'x': 0, 'y': 0, 'row': 0, 'used': 0})
            selected = len(pages) - 1, 0, 0, 0
        index, x, y, row = selected
        page = pages[index]
        page['image'].paste(image, (x + PADDING, y + PADDING))
        page.update(x=x + w, y=y, row=max(row, h), used=max(page['used'], y + h))
        regions[path] = {'page': index,
                         'source': [x + PADDING, y + PADDING, image.width, image.height],
                         'destination': destination}
    OUTPUT.mkdir(parents=True, exist_ok=True)
    files = []
    pixels = 0
    for index, page in enumerate(pages):
        height = min(SIDE, 1 << (page['used'] - 1).bit_length())
        filename = f'page_{index}.png'
        page['image'].crop((0, 0, SIDE, height)).save(OUTPUT / filename, optimize=True)
        files.append(filename)
        pixels += SIDE * height
    manifest = {'schemaVersion': 1, 'clips': list(CLIPS), 'pages': files,
                'sprites': dict(sorted(regions.items()))}
    (OUTPUT / 'atlas.json').write_text(json.dumps(manifest, separators=(',', ':')) + '\n', encoding='utf-8')
    print(f'{len(regions)} sprites, {len(pages)} pages, {pixels * 4 / 1024**2:.1f} MiB decoded RGBA')


if __name__ == '__main__':
    main()
