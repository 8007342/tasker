// One-off: draws the app icons (a white check on a green field) with no image library.
import { writeFileSync } from "node:fs";
import { deflateSync, crc32 } from "node:zlib";

function png(size, pixel) {
  const raw = Buffer.alloc((size * 4 + 1) * size);
  let o = 0;
  for (let y = 0; y < size; y++) {
    raw[o++] = 0;
    for (let x = 0; x < size; x++) for (const v of pixel((x + 0.5) / size, (y + 0.5) / size)) raw[o++] = v;
  }
  const chunk = (type, data) => {
    const len = Buffer.alloc(4); len.writeUInt32BE(data.length);
    const t = Buffer.from(type);
    const crc = Buffer.alloc(4); crc.writeUInt32BE(crc32(Buffer.concat([t, data])));
    return Buffer.concat([len, t, data, crc]);
  };
  const ihdr = Buffer.alloc(13);
  ihdr.writeUInt32BE(size, 0); ihdr.writeUInt32BE(size, 4); ihdr[8] = 8; ihdr[9] = 6;
  return Buffer.concat([Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]), chunk("IHDR", ihdr), chunk("IDAT", deflateSync(raw)), chunk("IEND", Buffer.alloc(0))]);
}
function seg(px, py, ax, ay, bx, by) {
  const dx = bx - ax, dy = by - ay;
  const t = Math.max(0, Math.min(1, ((px - ax) * dx + (py - ay) * dy) / (dx * dx + dy * dy)));
  return Math.hypot(px - ax - t * dx, py - ay - t * dy);
}
const icon = (scale, round) => (x, y) => {
  if (round) {
    const r = 0.2, qx = Math.abs(x - 0.5) - (0.5 - r), qy = Math.abs(y - 0.5) - (0.5 - r);
    if (Math.hypot(Math.max(qx, 0), Math.max(qy, 0)) > r) return [0, 0, 0, 0];
  }
  const u = (x - 0.5) / scale + 0.5, v = (y - 0.5) / scale + 0.5;
  const d = Math.min(seg(u, v, 0.24, 0.52, 0.43, 0.71), seg(u, v, 0.43, 0.71, 0.78, 0.31));
  if (d < 0.07) return [255, 255, 255, 255];
  return v > 0.84 ? [201, 138, 47, 255] : [46, 107, 58, 255];
};
for (const [name, size, scale, round] of [
  ["web/icons/Icon-192.png", 192, 1, true], ["web/icons/Icon-512.png", 512, 1, true],
  ["web/icons/Icon-maskable-192.png", 192, 0.72, false], ["web/icons/Icon-maskable-512.png", 512, 0.72, false],
  ["web/favicon.png", 48, 1, true],
]) writeFileSync(name, png(size, icon(scale, round)));
