(function () {
  'use strict';

  // Skip 3D entirely on mobile/touch — avoids downloading THREE.js (~700 KB)
  // and eliminates the continuous WebGL render loop on low-end devices.
  var isMobile = ('ontouchstart' in window) || window.innerWidth < 900;
  if (isMobile) {
    window.initHero3D = function () {};
    return;
  }

  // Queue calls that arrive before the async import resolves.
  var _queue = [];
  var _setupFn = null;

  window.initHero3D = function (container, options) {
    if (_setupFn) {
      _setupFn(container, options || {});
    } else {
      _queue.push([container, options || {}]);
    }
  };

  // Dynamic imports — THREE.js is only downloaded on desktop.
  Promise.all([
    import('three'),
    import('three/addons/geometries/RoundedBoxGeometry.js'),
  ]).then(function (modules) {
    var THREE = modules[0];
    var RoundedBoxGeometry = modules[1].RoundedBoxGeometry;

    _setupFn = function (container, options) {
      setup(container, options, THREE, RoundedBoxGeometry);
    };

    _queue.forEach(function (args) { _setupFn(args[0], args[1]); });
    _queue = [];
  });

  // ── SETUP ────────────────────────────────────────────────────────────────────
  function setup(container, options, THREE, RoundedBoxGeometry) {
    function tryInit() {
      if (!container || container.clientWidth === 0) {
        requestAnimationFrame(tryInit);
        return;
      }
      init(container, options, THREE, RoundedBoxGeometry);
    }
    requestAnimationFrame(tryInit);
  }

  function init(container, options, THREE, RoundedBoxGeometry) {
    var W = container.clientWidth;
    var H = container.clientHeight || W;

    // ── RENDERER ────────────────────────────────────────────────────────────
    var renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true,
      powerPreference: 'high-performance',
    });
    renderer.setSize(W, H);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setClearColor(0x000000, 0);
    renderer.physicallyCorrectLights = true;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.25;
    renderer.domElement.style.display = 'block';
    renderer.domElement.style.willChange = 'transform';

    var mask = 'radial-gradient(ellipse 70% 66% at 56% 50%, #000 42%, rgba(0,0,0,0.70) 62%, rgba(0,0,0,0.14) 82%, transparent 100%)';
    renderer.domElement.style.webkitMaskImage = mask;
    renderer.domElement.style.maskImage = mask;
    container.appendChild(renderer.domElement);

    // ── SCENE ───────────────────────────────────────────────────────────────
    var scene = new THREE.Scene();

    // ── CAMERA ──────────────────────────────────────────────────────────────
    var camera = new THREE.PerspectiveCamera(38, W / H, 0.1, 200);
    camera.position.set(12, 9, 14);
    camera.lookAt(0, 0, 0);

    // ── LIGHTS ──────────────────────────────────────────────────────────────
    var ambient = new THREE.AmbientLight(0x8aabff, 1.1);
    scene.add(ambient);

    var keyLight = new THREE.DirectionalLight(0xffffff, 5.5);
    keyLight.position.set(-3, 9, 4);
    scene.add(keyLight);

    var fillLight = new THREE.DirectionalLight(0xffffff, 3.2);
    fillLight.position.set(1, 10, 1);
    scene.add(fillLight);

    var rimLight = new THREE.DirectionalLight(0xddeeff, 2.0);
    rimLight.position.set(-1, 3, 9);
    scene.add(rimLight);

    var topLight = new THREE.DirectionalLight(0x5577ff, 1.4);
    topLight.position.set(7, 2, -1);
    scene.add(topLight);

    var underLight = new THREE.DirectionalLight(0xaabbff, 0.8);
    underLight.position.set(0, -4, 3);
    scene.add(underLight);

    var sparkleLight = new THREE.PointLight(0xffffff, 28, 14);
    sparkleLight.position.set(-3, 4, -4);
    scene.add(sparkleLight);

    // ── CUBE MATERIALS ──────────────────────────────────────────────────────
    var dpr = Math.min(window.devicePixelRatio, 2);
    var glassRT = new THREE.WebGLRenderTarget(W * dpr, H * dpr, {
      samples: renderer.capabilities.isWebGL2 ? 4 : 0,
    });

    var cubeGeometry = new RoundedBoxGeometry(1.6, 1.6, 1.6, 6, 0.01);
    var tallCubeGeometry = new RoundedBoxGeometry(1.6, 2.4, 1.6, 6, 0.02);

    var blueMaterial = new THREE.ShaderMaterial({
      uniforms: {
        tDiffuse:    { value: glassRT.texture },
        uResolution: { value: new THREE.Vector2(W * dpr, H * dpr) },
        uStrength:   { value: 0.02 },
        uColor:      { value: new THREE.Color(0x1133ff) },
        uDensity:    { value: 0.88 },
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
          vec4 ref     = texture2D(tDiffuse, uv + offset);
          vec3 bg      = mix(vec3(0.80, 0.88, 1.0), ref.rgb, ref.a);

          float t      = clamp((vLocalY + 0.8) / 1.6, 0.0, 1.0);
          vec3 botCol  = vec3(0.10, 0.34, 1.00);
          vec3 topCol  = vec3(0.00, 0.04, 0.54);
          vec3 faceCol = mix(topCol, botCol, t);

          vec3 col     = mix(bg, faceCol, uDensity * 0.62);

          float nDotV  = abs(dot(normalize(vNormal), vec3(0.0, 0.0, 1.0)));
          float rim    = 1.0 - nDotV;

          col += faceCol                * pow(rim, 5.0) * 0.55;
          col += vec3(0.75, 0.88, 1.0) * pow(rim, 7.0) * 2.8;
          col += vec3(0.9,  0.95, 1.0) * pow(max(0.0, vNormal.y), 5.0) * 0.35;

          gl_FragColor = vec4(col, 1.0);
        }
      `,
    });

    var whiteMaterial = new THREE.MeshPhysicalMaterial({
      color: 0xf0f7ff,
      roughness: 0.12,
      clearcoat: 0.7,
      clearcoatRoughness: 0.12,
      specularIntensity: 1.2,
      envMapIntensity: 0,
    });

    var cageMaterial = new THREE.MeshStandardMaterial({
      color: 0xededed,
      metalness: 1.0,
      roughness: 0.3,
      emissive: 0x223355,
      emissiveIntensity: 0.82,
    });

    var hoverCubes = [];
    var raycaster = new THREE.Raycaster();
    var pointer = new THREE.Vector2(10, 10);
    var hoveredCube = null;
    var lastPointerMoveAt = 0;

    function createMetalCage(size, t) {
      var group = new THREE.Group();
      var h = size / 2 - t / 2;
      var r = t * 0.45;
      var segs = 4;
      var gX = new RoundedBoxGeometry(size, t, t, segs, r);
      var gY = new RoundedBoxGeometry(t, size, t, segs, r);
      var gZ = new RoundedBoxGeometry(t, t, size, segs, r);

      [[ h, h], [ h,-h], [-h, h], [-h,-h]].forEach(function (pair) {
        var a = pair[0];
        var b = pair[1];
        var mx = new THREE.Mesh(gX, cageMaterial); mx.position.set(0, a, b); group.add(mx);
        var my = new THREE.Mesh(gY, cageMaterial); my.position.set(a, 0, b); group.add(my);
        var mz = new THREE.Mesh(gZ, cageMaterial); mz.position.set(a, b, 0); group.add(mz);
      });

      return group;
    }

    function addCube(root, kind, x, y, z, sx, sy, sz) {
      var isBlue = kind === 'blue';
      var geometry = isBlue ? cubeGeometry : tallCubeGeometry;
      var cube = new THREE.Mesh(geometry, isBlue ? blueMaterial : whiteMaterial);
      cube.position.set(x, y, z);
      if (isBlue) {
        cube.scale.setScalar(sx || 1);
      } else {
        cube.scale.set(sx || 1, sy || 1, sz || sx || 1);
      }
      cube.renderOrder = isBlue ? 2 : 1;
      cube.frustumCulled = false;
      root.add(cube);
      var cage = null;

      if (isBlue) {
        cage = createMetalCage(1.6, 0.02);
        cage.position.copy(cube.position);
        cage.scale.copy(cube.scale);
        cage.renderOrder = 3;
        root.add(cage);
        blueObjects.push(cube, cage);
      }

      hoverCubes.push({
        mesh: cube,
        cage: cage,
        baseY: cube.position.y,
        offset: 0,
      });
    }

    function boxesOverlap(a, b) {
      var gap = 0.08;
      return Math.abs(a.x - b.x) < (a.w + b.w) * 0.5 + gap &&
        Math.abs(a.y - b.y) < (a.h + b.h) * 0.5 + gap &&
        Math.abs(a.z - b.z) < (a.d + b.d) * 0.5 + gap;
    }

    function addPlacedCube(root, placed, kind, x, z, bottom, sx, sy, sz) {
      var isBlue = kind === 'blue';
      var scaleX = sx || 1;
      var scaleY = isBlue ? scaleX : (sy || 1);
      var scaleZ = isBlue ? scaleX : (sz || scaleX);
      var width = 1.6 * scaleX;
      var height = (isBlue ? 1.6 : 2.4) * scaleY;
      var depth = 1.6 * scaleZ;
      var box = { x: x, y: bottom + height * 0.5, z: z, w: width, h: height, d: depth };
      var offsets = [
        [0, 0], [0.32, 0], [-0.32, 0], [0, 0.32], [0, -0.32],
        [0.46, 0.34], [-0.46, -0.34], [0.46, -0.34], [-0.46, 0.34],
      ];

      for (var i = 0; i < offsets.length; i++) {
        box.x = x + offsets[i][0];
        box.z = z + offsets[i][1];
        var collides = placed.some(function (other) { return boxesOverlap(box, other); });
        if (!collides) break;
      }

      placed.push({ x: box.x, y: box.y, z: box.z, w: width, h: height, d: depth });
      addCube(root, kind, box.x, box.y, box.z, scaleX, scaleY, scaleZ);
    }

    // ── CUBE CLUSTER ────────────────────────────────────────────────────────
    var modelRoot = new THREE.Group();
    var blueObjects = [];
    var placed = [];

    addPlacedCube(modelRoot, placed, 'white', -4.28,  1.08, -2.38, 0.76, 0.86, 0.76);
    addPlacedCube(modelRoot, placed, 'white', -1.98, -1.18, -0.18, 0.78, 0.88, 0.78);
    addPlacedCube(modelRoot, placed, 'white', -0.22,  0.08, -2.30, 0.94, 1.12, 0.94);
    addPlacedCube(modelRoot, placed, 'white',  0.82, -1.32,  2.00, 0.84, 0.80, 0.84);
    addPlacedCube(modelRoot, placed, 'white',  2.58, -1.58,  0.10, 0.78, 0.88, 0.78);
    addPlacedCube(modelRoot, placed, 'white',  4.24,  0.48, -1.92, 0.80, 0.86, 0.80);
    addPlacedCube(modelRoot, placed, 'white', -4.88,  1.82, -3.12, 0.54, 0.64, 0.54);

    addPlacedCube(modelRoot, placed, 'blue',  -3.04,  0.16, -2.18, 0.78);
    addPlacedCube(modelRoot, placed, 'blue',  -2.38,  1.26, -0.96, 0.82);
    addPlacedCube(modelRoot, placed, 'blue',  -1.32,  1.82, -2.44, 0.72);
    addPlacedCube(modelRoot, placed, 'blue',  -0.96, -0.62, -0.84, 1.02);
    addPlacedCube(modelRoot, placed, 'blue',   0.66, -0.82, -0.98, 1.08);
    addPlacedCube(modelRoot, placed, 'blue',   1.62,  0.88, -2.46, 0.92);
    addPlacedCube(modelRoot, placed, 'blue',   1.42,  1.38, -0.86, 0.84);
    addPlacedCube(modelRoot, placed, 'blue',   2.92, -0.24, -1.72, 0.76);
    addPlacedCube(modelRoot, placed, 'blue',   3.18,  1.72, -2.72, 0.84);
    addPlacedCube(modelRoot, placed, 'blue',  -1.72,  1.34, -3.10, 0.76);
    addPlacedCube(modelRoot, placed, 'blue',   0.18,  1.76,  0.18, 0.98);
    addPlacedCube(modelRoot, placed, 'blue',   2.96, -2.26,  0.36, 0.30);

    var box    = new THREE.Box3().setFromObject(modelRoot);
    var center = box.getCenter(new THREE.Vector3());
    var size   = box.getSize(new THREE.Vector3());
    modelRoot.position.sub(center);

    var maxDim = Math.max(size.x, size.y, size.z);
    var fovRad = camera.fov * (Math.PI / 180);
    var dist   = (maxDim * 0.5) / Math.tan(fovRad * 0.5) * 1.16;
    if (options.variant === 'cta') {
      camera.position.set(-dist * 0.62, dist * 0.34, dist * 0.82);
      camera.lookAt(0.12, -0.16, 0);
      modelRoot.rotation.z = -0.05;
    } else {
      camera.position.set(dist * 0.58, dist * 0.42, dist * 0.78);
      camera.lookAt(0, 0, 0);
    }

    scene.add(modelRoot);

    renderer.domElement.addEventListener('pointermove', function (event) {
      var rect = renderer.domElement.getBoundingClientRect();
      pointer.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
      pointer.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
      lastPointerMoveAt = performance.now();
    });

    renderer.domElement.addEventListener('pointerleave', function () {
      hoveredCube = null;
      pointer.set(10, 10);
      lastPointerMoveAt = 0;
    });

    // ── ANIMATION ───────────────────────────────────────────────────────────
    var clock = new THREE.Clock();

    function animate() {
      requestAnimationFrame(animate);

      // Pause rendering when tab is not visible — saves battery/CPU
      if (document.hidden) return;

      var t = clock.getElapsedTime();

      modelRoot.position.y = Math.sin(t * 0.42) * 0.06;
      var baseRotationY = options.variant === 'cta' ? -0.34 : 0;
      modelRoot.rotation.y = baseRotationY + Math.sin(t * 0.18) * 0.08;

      var pointerIsMoving = performance.now() - lastPointerMoveAt < 140;
      if (pointerIsMoving) {
        raycaster.setFromCamera(pointer, camera);
        var intersections = raycaster.intersectObjects(hoverCubes.map(function (item) {
          return item.mesh;
        }), false);
        hoveredCube = intersections.length ? intersections[0].object : null;
      } else {
        hoveredCube = null;
      }

      hoverCubes.forEach(function (item) {
        var target = item.mesh === hoveredCube ? 0.42 : 0;
        item.offset += (target - item.offset) * 0.12;
        item.mesh.position.y = item.baseY + item.offset;
        if (item.cage) item.cage.position.y = item.mesh.position.y;
      });

      blueObjects.forEach(function (object) { object.visible = false; });
      renderer.setRenderTarget(glassRT);
      renderer.render(scene, camera);
      renderer.setRenderTarget(null);
      blueObjects.forEach(function (object) { object.visible = true; });

      renderer.render(scene, camera);
    }

    animate();

    // ── RESIZE ──────────────────────────────────────────────────────────────
    var ro = new ResizeObserver(function () {
      var w = container.clientWidth;
      var h = container.clientHeight || w;
      var d = Math.min(window.devicePixelRatio, 2);
      renderer.setSize(w, h);
      glassRT.setSize(w * d, h * d);
      blueMaterial.uniforms.uResolution.value.set(w * d, h * d);
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
    });
    ro.observe(container);
  }
})();
