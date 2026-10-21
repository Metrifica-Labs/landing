// Isometric 2D renderer for the Town. Logical canvas space is fixed
// (VIEW_W × VIEW_H); the component scales it to fit its container.

import {
  COFFEE_MACHINE,
  FRIDGE,
  GH,
  GW,
  ROOMS,
  type Agent,
  type World,
} from './scene';

const TW = 32;
const TH = 16;
const WALL = 46;
const OX = (GH * TW) / 2;
const OY = WALL + 34;

export const VIEW_W = ((GW + GH) * TW) / 2;
export const VIEW_H = OY + ((GW + GH) * TH) / 2 + 12;

const PIXEL_FONT = '"Pixelify Sans", ui-monospace, monospace';

export type HitKind = 'agent' | 'fridge' | 'coffee' | 'gate' | 'owner';

export interface Hit {
  kind: HitKind;
  id?: string;
  x: number;
  y: number;
  w: number;
  h: number;
}

type V = [number, number];

function p(x: number, y: number, z = 0): V {
  return [(x - y) * (TW / 2) + OX, (x + y) * (TH / 2) + OY - z];
}

function poly(ctx: CanvasRenderingContext2D, pts: V[], fill: string) {
  ctx.beginPath();
  ctx.moveTo(pts[0][0], pts[0][1]);
  for (let i = 1; i < pts.length; i++) ctx.lineTo(pts[i][0], pts[i][1]);
  ctx.closePath();
  ctx.fillStyle = fill;
  ctx.fill();
}

function shade(hex: string, k: number): string {
  const n = parseInt(hex.slice(1), 16);
  const f = (c: number) => Math.max(0, Math.min(255, Math.round(c * k)));
  const r = f((n >> 16) & 255);
  const g = f((n >> 8) & 255);
  const b = f(n & 255);
  return `rgb(${r},${g},${b})`;
}

function box(
  ctx: CanvasRenderingContext2D,
  x: number,
  y: number,
  w: number,
  d: number,
  h: number,
  color: string,
  z0 = 0,
) {
  const z1 = z0 + h;
  poly(ctx, [p(x + w, y, z0), p(x + w, y + d, z0), p(x + w, y + d, z1), p(x + w, y, z1)], shade(color, 0.72));
  poly(ctx, [p(x, y + d, z0), p(x + w, y + d, z0), p(x + w, y + d, z1), p(x, y + d, z1)], shade(color, 0.86));
  poly(ctx, [p(x, y, z1), p(x + w, y, z1), p(x + w, y + d, z1), p(x, y + d, z1)], color);
}

// ---------------------------------------------------------------------------

function drawWalls(ctx: CanvasRenderingContext2D, world: World) {
  const wallR = '#1a2342';
  const wallL = '#141c36';
  poly(ctx, [p(0, 0), p(GW, 0), p(GW, 0, WALL), p(0, 0, WALL)], wallR);
  poly(ctx, [p(0, 0), p(0, GH), p(0, GH, WALL), p(0, 0, WALL)], wallL);

  // Windows: night outside, faint light inside.
  for (let i = 0; i < GW - 4; i += 3) {
    poly(ctx, [p(i + 0.6, 0, 14), p(i + 2.2, 0, 14), p(i + 2.2, 0, 36), p(i + 0.6, 0, 36)], '#0b1124');
    poly(ctx, [p(i + 0.6, 0, 33), p(i + 2.2, 0, 33), p(i + 2.2, 0, 36), p(i + 0.6, 0, 36)], '#2a3a6a');
  }
  for (let j = 0; j < GH; j += 3) {
    poly(ctx, [p(0, j + 0.6, 14), p(0, j + 2.2, 14), p(0, j + 2.2, 36), p(0, j + 0.6, 36)], '#0a1020');
  }

  // Demand board on the Gestão wall: cards drift between columns.
  const bx = 18.3;
  poly(ctx, [p(bx, 0, 10), p(bx + 3.4, 0, 10), p(bx + 3.4, 0, 38), p(bx, 0, 38)], '#e9eefb');
  const cols = ['#3d7bff', '#ffb547', '#8b7bff', '#3fd39a'];
  for (let c = 0; c < 4; c++) {
    const n = 1 + ((Math.floor(world.time / 3) + c * 2) % 3);
    for (let k = 0; k < n; k++) {
      const x0 = bx + 0.2 + c * 0.8;
      const z = 33 - k * 6;
      poly(ctx, [p(x0, 0, z - 4), p(x0 + 0.6, 0, z - 4), p(x0 + 0.6, 0, z), p(x0, 0, z)], cols[c]);
    }
  }

  // Wall caps.
  ctx.strokeStyle = '#2c3a66';
  ctx.lineWidth = 1;
  ctx.beginPath();
  const a = p(0, GH, WALL);
  const b = p(0, 0, WALL);
  const c2 = p(GW, 0, WALL);
  ctx.moveTo(a[0], a[1]);
  ctx.lineTo(b[0], b[1]);
  ctx.lineTo(c2[0], c2[1]);
  ctx.stroke();
}

function drawFloor(ctx: CanvasRenderingContext2D, build: number) {
  for (const r of ROOMS) {
    for (let x = r.x; x < r.x + r.w; x++) {
      for (let y = r.y; y < r.y + r.h; y++) {
        const k = (x + y) / (GW + GH);
        if (k > build) continue;
        const drop = Math.max(0, (build - k) * 8) < 1 ? (1 - (build - k) * 8) * 10 : 0;
        const fill = (x + y) % 2 === 0 ? r.floor[0] : r.floor[1];
        poly(ctx, [p(x, y, -drop), p(x + 1, y, -drop), p(x + 1, y + 1, -drop), p(x, y + 1, -drop)], fill);
      }
    }
  }
  if (build < 1) return;

  // Room seams.
  ctx.strokeStyle = 'rgba(6,10,24,0.85)';
  ctx.lineWidth = 1.4;
  for (const r of ROOMS) {
    ctx.beginPath();
    const c = [p(r.x, r.y), p(r.x + r.w, r.y), p(r.x + r.w, r.y + r.h), p(r.x, r.y + r.h)];
    ctx.moveTo(c[0][0], c[0][1]);
    for (let i = 1; i < 4; i++) ctx.lineTo(c[i][0], c[i][1]);
    ctx.closePath();
    ctx.stroke();
  }

  // Sector plaques painted on the floor (iso-skewed text).
  ctx.save();
  ctx.font = `600 9px ${PIXEL_FONT}`;
  ctx.fillStyle = 'rgba(205,218,255,0.5)';
  for (const r of ROOMS) {
    const [sx, sy] = p(r.x + 0.35, r.y + r.h - 0.3);
    ctx.save();
    ctx.translate(sx, sy);
    ctx.transform(1, 0.5, -1, 0.5, 0, 0);
    ctx.fillText(r.label, 0, 0);
    ctx.restore();
  }
  ctx.restore();

  // Front edges of the building.
  ctx.strokeStyle = '#34457a';
  ctx.lineWidth = 1.2;
  ctx.beginPath();
  const e1 = p(GW, 0);
  const e2 = p(GW, GH);
  const e3 = p(0, GH);
  ctx.moveTo(e1[0], e1[1]);
  ctx.lineTo(e2[0], e2[1]);
  ctx.lineTo(e3[0], e3[1]);
  ctx.stroke();
}

// ---------------------------------------------------------------------------

interface Drawable {
  depth: number;
  draw: () => void;
}

function deskDrawable(ctx: CanvasRenderingContext2D, world: World, desk: World['desks'][number]): Drawable {
  return {
    depth: desk.x + desk.y + desk.w / 2 + 0.5,
    draw: () => {
      const owner = world.agents.find((a) => a.id === desk.ownerId);
      const on = !!owner && owner.state === 'working';
      box(ctx, desk.x + 0.08, desk.y + 0.12, desk.w - 0.16, 0.72, 9, desk.chief ? '#7a6248' : '#5f5368');
      const screens = desk.chief ? 2 : 1;
      for (let i = 0; i < screens; i++) {
        const mx = desk.x + 0.22 + i * 0.9;
        box(ctx, mx, desk.y + 0.22, 0.6, 0.08, 10, '#20283f', 9);
        const flick = on ? 0.85 + 0.15 * Math.sin(world.time * 7 + mx * 3) : 0;
        const face = on ? `rgba(91,157,255,${flick})` : '#141a2c';
        poly(ctx, [p(mx + 0.05, desk.y + 0.3, 10.5), p(mx + 0.55, desk.y + 0.3, 10.5), p(mx + 0.55, desk.y + 0.3, 18), p(mx + 0.05, desk.y + 0.3, 18)], face);
        if (on) {
          for (let l = 0; l < 3; l++) {
            const len = 0.15 + ((Math.floor(world.time * 2) + l + i) % 3) * 0.1;
            const z = 16.5 - l * 2;
            poly(ctx, [p(mx + 0.1, desk.y + 0.31, z), p(mx + 0.1 + len, desk.y + 0.31, z), p(mx + 0.1 + len, desk.y + 0.31, z + 0.9), p(mx + 0.1, desk.y + 0.31, z + 0.9)], 'rgba(230,240,255,0.8)');
          }
        }
      }
    },
  };
}

function agentDrawable(
  ctx: CanvasRenderingContext2D,
  world: World,
  a: Agent,
  hovered: boolean,
  hits: Hit[],
  owner = false,
): Drawable {
  return {
    depth: a.pos.x + a.pos.y + 0.6,
    draw: () => {
      const [sx0, sy0] = p(a.pos.x, a.pos.y);
      const sx = Math.round(sx0);
      const sy = Math.round(sy0);
      const walking = a.state === 'walking';
      const t = world.time * 10 + a.phase;
      const bob = walking ? Math.round(Math.abs(Math.sin(t)) * 1.5) : 0;

      ctx.save();
      if (a.helper) ctx.globalAlpha = 0.82;

      ctx.fillStyle = 'rgba(0,0,0,0.35)';
      ctx.beginPath();
      ctx.ellipse(sx, sy, 7, 3.2, 0, 0, Math.PI * 2);
      ctx.fill();

      if (hovered) {
        ctx.strokeStyle = owner ? '#ffc35c' : '#8fb6ff';
        ctx.lineWidth = 1.5;
        ctx.beginPath();
        ctx.ellipse(sx, sy, 10, 4.6, 0, 0, Math.PI * 2);
        ctx.stroke();
      }

      // Legs.
      const step = walking ? Math.round(Math.sin(t) * 2) : 0;
      ctx.fillStyle = '#1b2236';
      ctx.fillRect(sx - 4, sy - 7 + Math.max(0, step), 3, 7 - Math.max(0, step));
      ctx.fillRect(sx + 1, sy - 7 + Math.max(0, -step), 3, 7 - Math.max(0, -step));

      // Body.
      const by = sy - 17 - bob;
      ctx.fillStyle = a.shirt;
      ctx.fillRect(sx - 6, by, 12, 11);
      ctx.fillStyle = shade(a.shirt, 0.78);
      ctx.fillRect(sx + 3, by, 3, 11);
      if (a.chief && !owner) {
        ctx.fillStyle = '#f4f6ff';
        ctx.fillRect(sx - 2, by, 4, 2);
        ctx.fillStyle = '#10162a';
        ctx.fillRect(sx - 1, by + 2, 2, 5);
      }
      // Arms: typing while working.
      const typing = a.state === 'working' && !a.helper ? Math.round(Math.sin(t * 1.6)) : 0;
      ctx.fillStyle = shade(a.shirt, 0.9);
      ctx.fillRect(sx - 8, by + 2 + typing, 2, 6);
      ctx.fillRect(sx + 6, by + 2 - typing, 2, 6);

      // Head + hair.
      const hy = by - 9;
      ctx.fillStyle = a.skin;
      ctx.fillRect(sx - 4, hy, 9, 9);
      ctx.fillStyle = a.hair;
      ctx.fillRect(sx - 5, hy - 2, 11, 4);
      ctx.fillRect(sx - 5, hy, 2, 5);
      ctx.fillStyle = '#10162a';
      ctx.fillRect(sx - 2, hy + 4, 1, 2);
      ctx.fillRect(sx + 2, hy + 4, 1, 2);

      if (a.helper) {
        ctx.fillStyle = '#5b9dff';
        ctx.fillRect(sx + 4, hy - 6, 7, 7);
        ctx.fillStyle = '#0b1020';
        ctx.fillRect(sx + 7, hy - 5, 1, 5);
        ctx.fillRect(sx + 5, hy - 3, 5, 1);
      }

      if (owner) {
        ctx.font = `600 9px ${PIXEL_FONT}`;
        ctx.textAlign = 'center';
        ctx.fillStyle = '#ffc35c';
        ctx.fillText('VOCÊ', sx, hy - 6);
        ctx.textAlign = 'left';
      }
      ctx.restore();

      hits.push({ kind: owner ? 'owner' : 'agent', id: a.id, x: sx - 9, y: hy - 4, w: 18, h: sy - hy + 6 });
    },
  };
}

function furnitureDrawables(ctx: CanvasRenderingContext2D, world: World, hits: Hit[]): Drawable[] {
  const f = world.furniture;
  const out: Drawable[] = [];

  // Copa counter + coffee machine.
  out.push({
    depth: 18.2 + 5.05 + 1.2,
    draw: () => {
      box(ctx, 18.2, 5.05, 2.4, 0.62, 11, '#5b6478');
      const m = COFFEE_MACHINE;
      box(ctx, m.x, m.y + 0.1, 0.5, 0.42, 10, '#1d2133', 11);
      const lit = world.time < f.coffeeUntil;
      poly(ctx, [p(m.x + 0.12, m.y + 0.52, 15), p(m.x + 0.28, m.y + 0.52, 15), p(m.x + 0.28, m.y + 0.52, 18), p(m.x + 0.12, m.y + 0.52, 18)], lit ? '#ff6b4a' : '#5a2a2a');
      if (lit) {
        for (let i = 0; i < 4; i++) {
          const k = (world.time * 0.9 + i * 0.25) % 1;
          const [sx, sy] = p(m.x + 0.25, m.y + 0.3, 22 + k * 18);
          ctx.fillStyle = `rgba(230,236,255,${0.45 * (1 - k)})`;
          ctx.beginPath();
          ctx.arc(sx + Math.sin(k * 6 + i) * 2, sy, 2 + k * 2, 0, Math.PI * 2);
          ctx.fill();
        }
      }
      const [ax, ay] = p(m.x, m.y + 0.5, 22);
      hits.push({ kind: 'coffee', x: ax - 4, y: ay - 6, w: 24, h: 26 });
    },
  });

  // Fridge.
  out.push({
    depth: FRIDGE.x + FRIDGE.y + 1.4,
    draw: () => {
      const { x, y } = FRIDGE;
      const w = 0.82;
      const d = 0.78;
      if (f.fridgeOpen) {
        box(ctx, x, y, w, d, 32, '#d4dcec');
        poly(ctx, [p(x + 0.06, y + d, 2), p(x + w - 0.06, y + d, 2), p(x + w - 0.06, y + d, 30), p(x + 0.06, y + d, 30)], '#fff3c4');
        for (const z of [10, 18, 24]) {
          poly(ctx, [p(x + 0.06, y + d, z), p(x + w - 0.06, y + d, z), p(x + w - 0.06, y + d, z + 1), p(x + 0.06, y + d, z + 1)], '#c9b98a');
        }
        poly(ctx, [p(x + 0.12, y + d, 19), p(x + 0.3, y + d, 19), p(x + 0.3, y + d, 23), p(x + 0.12, y + d, 23)], '#3fd39a');
        poly(ctx, [p(x + 0.45, y + d, 11), p(x + 0.6, y + d, 11), p(x + 0.6, y + d, 17), p(x + 0.45, y + d, 17)], '#ff6b6b');
        poly(ctx, [p(x, y + d, 0), p(x, y + d + 0.72, 0), p(x, y + d + 0.72, 32), p(x, y + d, 32)], '#e7edf8');
        const glow = p(x + w / 2, y + d + 0.6);
        ctx.fillStyle = 'rgba(255,236,170,0.12)';
        ctx.beginPath();
        ctx.ellipse(glow[0], glow[1], 26, 10, 0, 0, Math.PI * 2);
        ctx.fill();
      } else {
        box(ctx, x, y, w, d, 32, '#dfe6f2');
        poly(ctx, [p(x + 0.1, y + d, 20), p(x + 0.14, y + d, 20), p(x + 0.14, y + d, 27), p(x + 0.1, y + d, 27)], '#7d879e');
      }
      const [hx, hy] = p(x, y + d, 34);
      hits.push({ kind: 'fridge', x: hx - 2, y: hy - 2, w: 30, h: 46 });
    },
  });

  // Copa table.
  out.push({
    depth: 19.6 + 7.6 + 0.8,
    draw: () => {
      box(ctx, 19.55, 7.7, 0.18, 0.18, 9, '#3a3f52');
      const [tx, ty] = p(19.64, 7.79, 10);
      ctx.fillStyle = '#8a6e52';
      ctx.beginPath();
      ctx.ellipse(tx, ty, 17, 8.5, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.fillStyle = '#ffffff';
      ctx.fillRect(tx - 6, ty - 4, 3, 3);
      ctx.fillRect(tx + 4, ty - 1, 3, 3);
    },
  });

  // Recepção sofa + plants.
  out.push({ depth: 21.4 + 11.2 + 1.2, draw: () => box(ctx, 21.1, 10.3, 0.7, 1.8, 8, '#3d4f8a') });
  for (const [px, py] of [
    [5.3, 0.3],
    [11.3, 5.3],
    [17.3, 0.3],
    [5.4, 10.3],
    [21.2, 9.2],
  ] as V[]) {
    out.push({
      depth: px + py + 0.5,
      draw: () => {
        box(ctx, px, py, 0.42, 0.42, 7, '#7a4a33');
        const [cx, cy] = p(px + 0.21, py + 0.21, 14);
        ctx.fillStyle = '#2f9e6a';
        ctx.beginPath();
        ctx.arc(cx, cy, 7, 0, Math.PI * 2);
        ctx.arc(cx - 4, cy + 3, 5, 0, Math.PI * 2);
        ctx.arc(cx + 4, cy + 3, 5, 0, Math.PI * 2);
        ctx.fill();
      },
    });
  }

  // Gate on the front edge of Recepção.
  out.push({
    depth: 19 + 14 + 2,
    draw: () => {
      const y = GH;
      box(ctx, 18.85, y - 0.15, 0.2, 0.2, 30, '#8a93ad');
      box(ctx, 21.0, y - 0.15, 0.2, 0.2, 30, '#8a93ad');
      const open = f.gateOpen;
      const bars = 7;
      for (let i = 0; i < bars; i++) {
        const x = open ? 20.6 + i * 0.05 : 19.15 + i * 0.27;
        poly(ctx, [p(x, y, 2), p(x + 0.07, y, 2), p(x + 0.07, y, 26), p(x, y, 26)], open ? '#5d6680' : '#c6cde0');
      }
      poly(ctx, [p(open ? 20.55 : 19.05, y, 25), p(21, y, 25), p(21, y, 27), p(open ? 20.55 : 19.05, y, 27)], '#c6cde0');
      const [gx, gy] = p(19, y, 30);
      hits.push({ kind: 'gate', x: gx - 4, y: gy - 4, w: 64, h: 50 });
    },
  });

  return out;
}

function drawBubble(ctx: CanvasRenderingContext2D, a: Agent) {
  if (!a.bubble) return;
  const [sx0, sy0] = p(a.pos.x, a.pos.y);
  const sx = Math.round(sx0);
  const sy = Math.round(sy0) - 34;
  ctx.font = `500 9px ${PIXEL_FONT}`;
  const w = Math.ceil(ctx.measureText(a.bubble.text).width) + 10;
  const alpha = Math.min(1, a.bubble.t * 3);
  ctx.save();
  ctx.globalAlpha = alpha;
  ctx.fillStyle = '#f3f6ff';
  ctx.fillRect(sx - w / 2, sy - 13, w, 14);
  ctx.beginPath();
  ctx.moveTo(sx - 3, sy + 1);
  ctx.lineTo(sx + 3, sy + 1);
  ctx.lineTo(sx, sy + 5);
  ctx.fill();
  ctx.fillStyle = '#0e1424';
  ctx.fillText(a.bubble.text, sx - w / 2 + 5, sy - 3);
  ctx.restore();
}

// ---------------------------------------------------------------------------

export interface RenderOpts {
  build: number;
  hoverId: string | null;
}

export function render(ctx: CanvasRenderingContext2D, world: World, opts: RenderOpts): Hit[] {
  const hits: Hit[] = [];
  ctx.clearRect(0, 0, VIEW_W, VIEW_H);

  drawWalls(ctx, world);
  drawFloor(ctx, opts.build);
  if (opts.build < 1) return hits;

  const items: Drawable[] = [];
  for (const d of world.desks) items.push(deskDrawable(ctx, world, d));
  items.push(...furnitureDrawables(ctx, world, hits));
  for (const a of world.agents) items.push(agentDrawable(ctx, world, a, opts.hoverId === a.id, hits));

  const you: Agent = {
    id: 'owner',
    name: 'Você',
    role: 'Dono',
    sector: 'recepcao',
    chief: false,
    helper: false,
    shirt: '#ffb547',
    hair: '#2b1d16',
    skin: '#e8b98f',
    seat: world.owner,
    pos: world.owner,
    path: [],
    state: 'break',
    next: 'break',
    timer: 0,
    bubble: null,
    phase: 0,
    gone: false,
  };
  items.push(agentDrawable(ctx, world, you, opts.hoverId === 'owner', hits, true));

  items.sort((a, b) => a.depth - b.depth);
  for (const it of items) it.draw();
  for (const a of world.agents) drawBubble(ctx, a);

  return hits;
}
