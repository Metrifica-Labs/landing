import * as THREE from "https://esm.sh/three@0.164.1";
import { RoundedBoxGeometry } from "https://esm.sh/three@0.164.1/examples/jsm/geometries/RoundedBoxGeometry.js";
import { OrbitControls } from "https://esm.sh/three@0.164.1/examples/jsm/controls/OrbitControls.js";

function createGradientTexture() {
  const c = document.createElement("canvas");
  c.width = 512; c.height = 512;
  const ctx = c.getContext("2d");
  const lin = ctx.createLinearGradient(0, 0, 512, 512);
  lin.addColorStop(0.0,  "#f8fbff");
  lin.addColorStop(0.34, "#ffdcdc");
  lin.addColorStop(1.0,  "#1a6aff");
  ctx.fillStyle = lin; ctx.fillRect(0, 0, 512, 512);
  const rad = ctx.createRadialGradient(128, 102, 0, 128, 102, 170);
  rad.addColorStop(0, "rgba(255,255,255,0.9)");
  rad.addColorStop(1, "rgba(255,255,255,0)");
  ctx.fillStyle = rad; ctx.fillRect(0, 0, 512, 512);
  return new THREE.CanvasTexture(c);
}

const scene = new THREE.Scene();
scene.background = new THREE.Color(0xdceaff);

scene.add(new THREE.Mesh(
  new THREE.SphereGeometry(50, 32, 16),
  new THREE.MeshBasicMaterial({ map: createGradientTexture(), side: THREE.BackSide })
));

const camera = new THREE.PerspectiveCamera(65, innerWidth / innerHeight, 0.1, 1000);
camera.position.set(3.2, 2.7, 4.4);
camera.lookAt(0.2, 0.2, 0.2);

const renderer = new THREE.WebGLRenderer({ antialias: true });
renderer.setSize(innerWidth, innerHeight);
renderer.setPixelRatio(Math.min(devicePixelRatio, 2));
renderer.outputColorSpace = THREE.SRGBColorSpace;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1.35;
renderer.shadowMap.enabled = false;
document.body.appendChild(renderer.domElement);

const dpr = Math.min(devicePixelRatio, 2);

// MSAA samples=4 elimina serrilhado na pass de refração (requer WebGL2)
const glassRT = new THREE.WebGLRenderTarget(innerWidth * dpr, innerHeight * dpr, {
  samples: renderer.capabilities.isWebGL2 ? 4 : 0,
});

const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(18, 18),
  new THREE.MeshStandardMaterial({
    color: 0xc8deff, roughness: 0.85,
    transparent: true, opacity: 0.28, depthWrite: false,
  })
);
floor.rotation.x = -Math.PI / 2;
floor.position.y = -1.2;
scene.add(floor);

const geometry     = new RoundedBoxGeometry(1.6, 1.6, 1.6, 6, 0.01);
const geometryTall = new RoundedBoxGeometry(1.6, 2.4, 1.6, 6, 0.02);

// ── CUBO AZUL — refração screen-space ─────────────────────────────────────
const blueMaterial = new THREE.ShaderMaterial({
  uniforms: {
    tDiffuse:    { value: glassRT.texture },
    uResolution: { value: new THREE.Vector2(innerWidth * dpr, innerHeight * dpr) },
    uStrength:   { value: 0.02 },
    uColor:      { value: new THREE.Color(0x1133ff) },
    uDensity:    { value: 0.70 },
  },
  vertexShader: `
    varying vec3  vNormal;
    varying float vLocalY;
    void main() {
      vNormal     = normalize(normalMatrix * normal);
      vLocalY     = position.y;
      gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
    }
  `,
  fragmentShader: `
    precision highp float;
    uniform sampler2D tDiffuse;
    uniform vec2  uResolution;
    uniform float uStrength;
    uniform vec3  uColor;
    uniform float uDensity;
    varying vec3  vNormal;
    varying float vLocalY;

    void main() {
      vec2 uv      = gl_FragCoord.xy / uResolution;
      vec2 offset  = vNormal.xy * uStrength;
      vec3 bg      = texture2D(tDiffuse, uv + offset).rgb;

      float t      = clamp((vLocalY + 0.8) / 1.6, 0.0, 1.0);
      vec3 botCol  = vec3(0.18, 0.44, 1.00);
      vec3 topCol  = vec3(0.00, 0.05, 0.42);
      vec3 faceCol = mix(topCol, botCol, t);

      vec3 col     = mix(bg, faceCol, uDensity * 0.55);

      float nDotV  = abs(dot(normalize(vNormal), vec3(0.0, 0.0, 1.0)));
      float rim    = 1.0 - nDotV;

      col += faceCol             * pow(rim, 5.0) * 0.55;
      col += vec3(0.75, 0.88, 1.0) * pow(rim, 7.0) * 2.8;
      col += vec3(0.9,  0.95, 1.0) * pow(max(0.0, vNormal.y), 5.0) * 0.35;

      gl_FragColor = vec4(col, 1.0);
    }
  `,
});

const blueCube = new THREE.Mesh(geometry, blueMaterial);
blueCube.position.set(1.1, 0.5, 2.0);
blueCube.scale.setScalar(0.99);
scene.add(blueCube);

// ── GAIOLA METÁLICA ───────────────────────────────────────────────────────
const cageMaterial = new THREE.MeshStandardMaterial({
  color: 0xededed,
  metalness: 1.0,
  roughness: 0.3,
  emissive: 0x223355,
  emissiveIntensity: 0.82,
});

function createMetalCage(size, t) {
  const group = new THREE.Group();
  const h = size / 2 - t / 2;
  const r = t * 0.45;
  const segs = 4;

  // geometrias reutilizadas para as 3 orientações
  const gX = new RoundedBoxGeometry(size, t, t, segs, r);
  const gY = new RoundedBoxGeometry(t, size, t, segs, r);
  const gZ = new RoundedBoxGeometry(t, t, size, segs, r);
[[ h, h], [ h,-h], [-h, h], [-h,-h]].forEach(([a, b]) => {
    const mx = new THREE.Mesh(gX, cageMaterial); mx.position.set(0, a, b); group.add(mx);
    const my = new THREE.Mesh(gY, cageMaterial); my.position.set(a, 0, b); group.add(my);
    const mz = new THREE.Mesh(gZ, cageMaterial); mz.position.set(a, b, 0); group.add(mz);
  });

  return group;
}

const blueCage = createMetalCage(1.6, 0.02);
blueCage.position.copy(blueCube.position);
scene.add(blueCage);

// ── CUBO BRANCO ───────────────────────────────────────────────────────────
const whiteCube = new THREE.Mesh(geometryTall, new THREE.MeshPhysicalMaterial({
  color: 0xf0f7ff,
  roughness: 0.12,
  clearcoat: 0.7,
  clearcoatRoughness: 0.12,
  specularIntensity: 1.2,
  envMapIntensity: 0,
}));
whiteCube.position.set(0.68, 0.82, -0.38);
scene.add(whiteCube);

// ── ILUMINAÇÃO ────────────────────────────────────────────────────────────
function addDir(color, intensity, x, y, z) {
  const l = new THREE.DirectionalLight(color, intensity);
  l.position.set(x, y, z);
  scene.add(l);
}

addDir(0xffffff, 5.5, -3,  9,  4);
addDir(0xffffff, 3.2,  1, 10,  1);
addDir(0xddeeff, 2.0, -1,  3,  9);
addDir(0x5577ff, 1.4,  7,  2, -1);
addDir(0xaabbff, 0.8,  0, -4,  3);
scene.add(new THREE.AmbientLight(0x8aabff, 1.1));

const rimLight = new THREE.PointLight(0xffffff, 28, 14);
rimLight.position.set(-3, 4, -4);
scene.add(rimLight);

// ── CONTROLS ──────────────────────────────────────────────────────────────
const controls = new OrbitControls(camera, renderer.domElement);
controls.target.set(0.2, 0.2, 0.2);
controls.enableDamping = true;
controls.dampingFactor = 0.06;
controls.mouseButtons = { LEFT: null, MIDDLE: THREE.MOUSE.DOLLY, RIGHT: THREE.MOUSE.ROTATE };
controls.update();

function animate() {
  controls.update();

  blueCube.visible = false;
  blueCage.visible = false;
  renderer.setRenderTarget(glassRT);
  renderer.render(scene, camera);
  renderer.setRenderTarget(null);
  blueCube.visible = true;
  blueCage.visible = true;

  renderer.render(scene, camera);
  requestAnimationFrame(animate);
}

function resize() {
  const d = Math.min(devicePixelRatio, 2);
  camera.aspect = innerWidth / innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(innerWidth, innerHeight);
  glassRT.setSize(innerWidth * d, innerHeight * d);
  blueMaterial.uniforms.uResolution.value.set(innerWidth * d, innerHeight * d);
}

window.addEventListener("resize", resize);
animate();
