import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';
import { DRACOLoader } from 'three/addons/loaders/DRACOLoader.js';
import { RoomEnvironment } from 'three/addons/environments/RoomEnvironment.js';

(function () {
  'use strict';

  window.initHero3D = function (container) {
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
    renderer.toneMappingExposure = 1.15;
    renderer.domElement.style.display = 'block';

    var mask = 'radial-gradient(ellipse 70% 66% at 56% 50%, #000 42%, rgba(0,0,0,0.70) 62%, rgba(0,0,0,0.14) 82%, transparent 100%)';
    renderer.domElement.style.webkitMaskImage = mask;
    renderer.domElement.style.maskImage = mask;
    container.appendChild(renderer.domElement);

    // ── SCENE ───────────────────────────────────────────────────────────────
    var scene = new THREE.Scene();

    // ── ENVIRONMENT MAP (essential for glass/transmission materials) ─────────
    var pmremGenerator = new THREE.PMREMGenerator(renderer);
    pmremGenerator.compileEquirectangularShader();
    var envTexture = pmremGenerator.fromScene(new RoomEnvironment(), 0.04).texture;
    scene.environment = envTexture;

    // ── CAMERA ──────────────────────────────────────────────────────────────
    var camera = new THREE.PerspectiveCamera(38, W / H, 0.1, 200);
    camera.position.set(12, 9, 14);
    camera.lookAt(0, 0, 0);

    // ── LIGHTS ──────────────────────────────────────────────────────────────
    var ambient = new THREE.AmbientLight(0xd8e8ff, 0.55);
    scene.add(ambient);

    var keyLight = new THREE.DirectionalLight(0xffffff, 2.4);
    keyLight.position.set(7, 14, 9);
    scene.add(keyLight);

    var fillLight = new THREE.DirectionalLight(0x3a7aff, 1.6);
    fillLight.position.set(-10, 5, -9);
    scene.add(fillLight);

    var rimLight = new THREE.DirectionalLight(0xffffff, 1.1);
    rimLight.position.set(12, 3, -12);
    scene.add(rimLight);

    var topLight = new THREE.DirectionalLight(0xeef4ff, 0.9);
    topLight.position.set(0, 22, 4);
    scene.add(topLight);

    // ── TRANSMISSION MATERIALS ───────────────────────────────────────────────
    // Drei's MeshTransmissionMaterial is a React/R3F material. This scene uses
    // vanilla Three.js, so we use the compatible MeshPhysicalMaterial
    // transmission pipeline and apply it to every GLB mesh below.
    function makeTransmissionMat(hexColor, transmission, thickness, roughness, ior) {
      return new THREE.MeshPhysicalMaterial({
        color:              new THREE.Color(hexColor),
        transmission:       transmission,
        roughness:          roughness,
        metalness:          0.0,
        thickness:          thickness,
        ior:                ior || 1.52,
        attenuationColor:   new THREE.Color(hexColor),
        attenuationDistance: 1.8,
        specularIntensity:  1.0,
        specularColor:      new THREE.Color(0xffffff),
        clearcoat:          1.0,
        clearcoatRoughness: 0.04,
        transparent:        true,
        opacity:            1.0,
        side:               THREE.DoubleSide,
        envMapIntensity:    1.7,
      });
    }

    // Border meshes -> icy glass (high transmission, barely tinted)
    var borderMatA = makeTransmissionMat(0xc8dcff, 0.96, 0.62, 0.02, 1.52);
    var borderMatB = makeTransmissionMat(0xddeeff, 0.94, 0.72, 0.035, 1.48);

    // Core meshes -> denser blue transmission glass
    var coreMat  = makeTransmissionMat(0x1a56f0, 0.82, 1.05, 0.045, 1.45);
    var coreMatB = makeTransmissionMat(0x2a6dff, 0.78, 0.96, 0.035, 1.50);
    var coreMatC = makeTransmissionMat(0x0e3bbb, 0.86, 1.16, 0.055, 1.42);

    // ── LOAD GLB ────────────────────────────────────────────────────────────
    var cubes = [];

    var dracoLoader = new DRACOLoader();
    dracoLoader.setDecoderPath(
      'https://cdn.jsdelivr.net/npm/three@0.149.0/examples/jsm/libs/draco/'
    );

    var loader = new GLTFLoader();
    loader.setDRACOLoader(dracoLoader);

    loader.load(
      'assets/assets/objects/cubes_loko.glb',
      function (gltf) {
        gltf.scene.traverse(function (child) {
          if (!child.isMesh) return;

          var isBorder = child.name.indexOf('border') !== -1;

          var mat;
          if (isBorder) {
            mat = (Math.random() > 0.5 ? borderMatA : borderMatB).clone();
          } else {
            var r = Math.random();
            if (r < 0.4)       mat = coreMat.clone();
            else if (r < 0.72) mat = coreMatB.clone();
            else               mat = coreMatC.clone();
          }
          mat.side = THREE.DoubleSide;
          child.material = mat;

          child.userData.baseY = child.position.y;
          child.userData.phase = Math.random() * Math.PI * 2;
          child.userData.freq  = 0.26 + Math.random() * 0.22;
          child.userData.amp   = 0.07 + Math.random() * 0.07;
          cubes.push(child);
        });

        // Center scene at origin and fit camera to it
        var box    = new THREE.Box3().setFromObject(gltf.scene);
        var center = box.getCenter(new THREE.Vector3());
        var size   = box.getSize(new THREE.Vector3());
        gltf.scene.position.sub(center);

        // Re-capture base Y after centering
        cubes.forEach(function (c) { c.userData.baseY = c.position.y; });

        var maxDim = Math.max(size.x, size.y, size.z);
        var fovRad = camera.fov * (Math.PI / 180);
        var dist   = (maxDim * 0.5) / Math.tan(fovRad * 0.5) * 1.55;
        camera.position.set(dist * 0.58, dist * 0.42, dist * 0.78);
        camera.lookAt(0, 0, 0);

        scene.add(gltf.scene);
      },
      undefined,
      function (err) { console.error('[hero3d] GLB load error:', err); }
    );

    // ── ANIMATION ───────────────────────────────────────────────────────────
    var clock = new THREE.Clock();

    function animate() {
      requestAnimationFrame(animate);
      var t = clock.getElapsedTime();

      for (var i = 0; i < cubes.length; i++) {
        var c = cubes[i];
        var d = c.userData;
        c.position.y = d.baseY + Math.sin(t * d.freq + d.phase) * d.amp;
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
