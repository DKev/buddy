// Renders animated GIF for each species — one GIF per species showing all frames
import puppeteer from 'puppeteer';
import { createWriteStream, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import GIFEncoder from 'gif-encoder-2';
import { PNG } from 'pngjs';
import { SPRITE_BODIES } from '../dist/lib/species.js';

const __dirname = dirname(fileURLToPath(import.meta.url));
const OUTPUT_DIR = join(__dirname, '..', '..', 'buddyReborn', 'sprites');
mkdirSync(OUTPUT_DIR, { recursive: true });

const W = 200, H = 140;
const DEFAULT_EYE = '°';
const FRAME_DELAY = 500;

const STYLE = `
  body { margin:0; background:#1e1e2e; display:flex; align-items:center; justify-content:center; height:${H}px; }
  pre { font-family:'Courier New',monospace; font-size:14px; line-height:1.5; color:#f5c2e7; margin:0; white-space:pre; }
`;

async function main() {
  console.log('Generating species GIFs...\n');
  const browser = await puppeteer.launch({ headless: true });
  const page = await browser.newPage();
  await page.setViewport({ width: W, height: H });

  for (const [species, frames] of Object.entries(SPRITE_BODIES)) {
    const encoder = new GIFEncoder(W, H);
    encoder.setDelay(FRAME_DELAY);
    encoder.setRepeat(0);
    encoder.setQuality(10);

    const slug = species.toLowerCase().replace(/ /g, '-');
    const outputPath = join(OUTPUT_DIR, `${slug}.gif`);
    const stream = createWriteStream(outputPath);
    encoder.createReadStream().pipe(stream);
    encoder.start();

    for (const frame of frames) {
      const rendered = frame.map(l =>
        l.replace(/\{E\}/g, DEFAULT_EYE)
         .replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;')
      ).join('\n');

      await page.setContent(`<html><head><style>${STYLE}</style></head><body><pre>${rendered}</pre></body></html>`);
      const screenshot = await page.screenshot({ type: 'png' });
      const png = PNG.sync.read(screenshot);
      encoder.addFrame(png.data);
    }

    encoder.finish();
    await new Promise(resolve => stream.on('finish', resolve));
    console.log(`  ✓ ${species} (${frames.length} frames)`);
  }

  await browser.close();
  console.log(`\nDone! ${Object.keys(SPRITE_BODIES).length} GIFs in ${OUTPUT_DIR}`);
}

main().catch(console.error);
