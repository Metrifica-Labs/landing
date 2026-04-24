import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';

(function () {
  'use strict';

  /**
   * Initialise the Three.js hero scene inside a given container element.
   * Called from Flutter via dart:js.
   *
   * @param {HTMLElement} container
   */
  window.initHero3D = function (container) {

    // ── wait until container has real dimensions ────────────────────────────
    function tryInit() {
      if (!container || container.clientWidth === 0) {
        requestAnimationFrame(tryInit);
        return;
      }
      setup(container);
    }
    requestAnimationFrame(tryInit);
  };

  function setup(container) {
    var W = container.clientWidth;
    var H = container.clientHeight || W;

    // ── RENDERER ────────────────────────────────────────────────────────────
    var renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(W, H);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.setClearColor(0x000000, 0);          // fully transparent bg
    renderer.physicallyCorrectLights = true;
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.25;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.domElement.style.display = 'block';
    renderer.domElement.style.webkitMaskImage = 'radial-gradient(ellipse 58% 54% at 52% 48%, #000 45%, rgba(0,0,0,0.72) 62%, rgba(0,0,0,0.22) 79%, transparent 96%)';
    renderer.domElement.style.maskImage = 'radial-gradient(ellipse 58% 54% at 52% 48%, #000 45%, rgba(0,0,0,0.72) 62%, rgba(0,0,0,0.22) 79%, transparent 96%)';
    container.appendChild(renderer.domElement);

    // ── SCENE ───────────────────────────────────────────────────────────────
    var scene = new THREE.Scene();
    var pmremGenerator = new THREE.PMREMGenerator(renderer);
    scene.environment = pmremGenerator.fromScene(new RoomEnvironment(), 0.04).texture;

    // ── CAMERA ──────────────────────────────────────────────────────────────
    // Matches the Blender camera (Y-up GLTF coords):
    //   Blender pos (9.5, -8.0, 9.5)  →  Three.js (9.5, 9.5, 8.0)
    //   Blender target (0.3, 1.0, 0.8) → Three.js (0.3, 0.8, -1.0)
    var camera = new THREE.PerspectiveCamera(33, W / H, 0.1, 300);
    camera.position.set(6.2, 6.4, 5.25);
    camera.lookAt(1.05, -0.6, -0.55);

    // ── LIGHTS ──────────────────────────────────────────────────────────────
    var ambient = new THREE.AmbientLight(0xe8f2ff, 2.25);
    scene.add(ambient);

    // Key light — front-left-above (like the spot in Blender)
    var keyLight = new THREE.DirectionalLight(0xffffff, 8.5);
    keyLight.position.set(-4, 15, 15);
    var keyTarget = new THREE.Object3D();
    keyTarget.position.set(1.05, -0.6, -0.55);
    scene.add(keyTarget);
    keyLight.target = keyTarget;
    scene.add(keyLight);

    // Fill light — blue-tinted from left
    var fillLight = new THREE.DirectionalLight(0x8dbaff, 3.8);
    fillLight.position.set(-9, 8, -7);
    scene.add(fillLight);

    // Rim light — right side separation
    var rimLight = new THREE.DirectionalLight(0xdbeaff, 3.4);
    rimLight.position.set(10, 6, -10);
    scene.add(rimLight);

    var topLight = new THREE.DirectionalLight(0xffffff, 4.2);
    topLight.position.set(0, 16, 2);
    scene.add(topLight);

    // ── MATERIALS ───────────────────────────────────────────────────────────
    // Three.js MeshPhysicalMaterial gives us glass transmission + clearcoat.
    function makeMat(hexColor, hexEmissive, transmission, emissiveInt) {
      return new THREE.MeshPhysicalMaterial({
        color:              new THREE.Color(hexColor),
        emissive:           new THREE.Color(hexEmissive),
        emissiveIntensity:  emissiveInt,
        roughness:          0.055,
        metalness:          0.0,
        transmission:       transmission,
        thickness:          0.9,
        ior:                1.46,
        clearcoat:          1.0,
        clearcoatRoughness: 0.018,
        transparent:        true,
        opacity:            0.92,
        envMapIntensity:    1.75,
        specularIntensity:  1.0,
        specularColor:      new THREE.Color(0xffffff),
        attenuationColor:   new THREE.Color(hexColor),
        attenuationDistance: 2.4,
        depthWrite:         false,
        side:               THREE.FrontSide,
      });
    }

    var matCore = makeMat(0x1262ff, 0x0642e8, 0.30, 0.44);
    var matMid  = makeMat(0x5b98ff, 0x2f69de, 0.42, 0.18);
    var matEdge = makeMat(0xeaf5ff, 0x8dbbff, 0.52, 0.04);

    // per-material base emissive intensity (for hover restore)
    matCore._baseEmissive = 0.55;
    matMid._baseEmissive  = 0.22;
    matEdge._baseEmissive = 0.06;

    // ── LOAD GLB ────────────────────────────────────────────────────────────
    var cubes = [];
    var loader = new GLTFLoader();

    loader.load(
      'assets/cubos.glb',
      function (gltf) {
        gltf.scene.scale.setScalar(1.2);
        gltf.scene.position.set(1.75, -2.05, -0.35);

        gltf.scene.traverse(function (child) {
          if (!child.isMesh) return;

          var n = child.name;
          var tier;
          if      (n.indexOf('_C_') !== -1) { child.material = matCore; tier = 'C'; }
          else if (n.indexOf('_M_') !== -1) { child.material = matMid;  tier = 'M'; }
          else                              { child.material = matEdge; tier = 'E'; }

          child.userData.baseY     = child.position.y;
          child.userData.baseScale = child.scale.clone();
          child.userData.phase     = Math.random() * Math.PI * 2;
          child.userData.freq      = 0.22 + Math.random() * 0.18;
          child.userData.depth     = tier === 'C' ? 1.0 : tier === 'M' ? 0.65 : 0.30;
          child.userData.hoverT    = 0.0;   // current smooth value
          child.userData.hoverGoal = 0.0;   // 0 or 1
          child.userData.lastHitT  = -999.0;
          child.userData.hitRadius = tier === 'C' ? 0.085 : tier === 'M' ? 0.075 : 0.065;
          child.userData.tier      = tier;

          cubes.push(child);
        });

        scene.add(gltf.scene);
      },
      undefined,
      function (err) { console.error('[hero3d] GLB load error:', err); }
    );

    // ── MOUSE / RAYCASTER ───────────────────────────────────────────────────
    var raycaster = new THREE.Raycaster();
    var mouse = new THREE.Vector2(9999, 9999);   // off-screen default
    var hoverHoldSeconds = 0.18;
    var projectedCenter = new THREE.Vector3();

    container.addEventListener('mousemove', function (e) {
      var rect = container.getBoundingClientRect();
      mouse.x =  ((e.clientX - rect.left) / rect.width)  * 2 - 1;
      mouse.y = -((e.clientY - rect.top)  / rect.height) * 2 + 1;
    });

    container.addEventListener('mouseleave', function () {
      mouse.set(9999, 9999);
    });

    // ── ANIMATION LOOP ──────────────────────────────────────────────────────
    var clock = new THREE.Clock();

    function animate() {
      requestAnimationFrame(animate);
      var t = clock.getElapsedTime();

      // raycast current frame
      raycaster.setFromCamera(mouse, camera);
      var hits = raycaster.intersectObjects(cubes, false);

      // build a set of currently-hit objects for O(1) lookup
      var hitSet = new Set();
      for (var i = 0; i < hits.length; i++) hitSet.add(hits[i].object);

      // Broaden the interactive area in screen space so hover feels like the
      // visible cube face, not only the exact transparent mesh triangles.
      if (mouse.x <= 1 && mouse.y <= 1) {
        for (var k = 0; k < cubes.length; k++) {
          var hitCube = cubes[k];
          var hitData = hitCube.userData;
          hitCube.getWorldPosition(projectedCenter);
          projectedCenter.project(camera);

          var dx = mouse.x - projectedCenter.x;
          var dy = mouse.y - projectedCenter.y;
          var radius = hitData.hitRadius;
          if ((dx * dx + dy * dy) <= radius * radius) hitSet.add(hitCube);
        }
      }

      for (var j = 0; j < cubes.length; j++) {
        var cube = cubes[j];
        var d    = cube.userData;

        // Autonomous float (each cube has its own freq + phase)
        var floatY = Math.sin(t * d.freq + d.phase) * 0.16 * d.depth;

        if (hitSet.has(cube)) d.lastHitT = t;

        // Keep hover active briefly after leaving, then ease back smoothly.
        d.hoverGoal = (t - d.lastHitT) < hoverHoldSeconds ? 1.0 : 0.0;

        // Smooth lerp (fast approach, slow retreat)
        var lerpSpeed = d.hoverGoal > d.hoverT ? 0.16 : 0.045;
        d.hoverT += (d.hoverGoal - d.hoverT) * lerpSpeed;
        var h = d.hoverT;

        // Apply position: float + hover lift
        cube.position.y = d.baseY + floatY + h * 0.95;

        // Subtle hover scale
        var s = 1.0 + h * 0.09;
        cube.scale.copy(d.baseScale).multiplyScalar(s);

        // Emissive glow boost on hover
        var baseMat  = cube.material;
        var baseEm   = baseMat._baseEmissive || 0.1;
        baseMat.emissiveIntensity = baseEm + h * 0.45;
      }

      renderer.render(scene, camera);
    }

    animate();

    // ── RESIZE ──────────────────────────────────────────────────────────────
    var ro = new ResizeObserver(function () {
      var w = container.clientWidth;
      var h = container.clientHeight || w;
      renderer.setSize(w, h);
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
    });
    ro.observe(container);
  }

})();
