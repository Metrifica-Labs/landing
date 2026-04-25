import * as THREE from 'three';
import { GLTFLoader } from 'three/addons/loaders/GLTFLoader.js';

(function () {
  'use strict';

  /**
   * Initialise the Three.js hero scene inside a given container element.
   * Called from Flutter via dart:js.
   *
   * @param {HTMLElement} container
   * @param {{variant?: string}=} options
   */
  window.initHero3D = function (container, options) {
    var config = options || {};

    // ── wait until container has real dimensions ────────────────────────────
    function tryInit() {
      if (!container || container.clientWidth === 0) {
        requestAnimationFrame(tryInit);
        return;
      }
      setup(container, config);
    }
    requestAnimationFrame(tryInit);
  };

  function setup(container, config) {
    var isCta = config.variant === 'cta';
    var W = container.clientWidth;
    var H = container.clientHeight || W;

    // ── RENDERER ────────────────────────────────────────────────────────────
    var renderer = new THREE.WebGLRenderer({
      antialias: true,
      alpha: true,
      powerPreference: 'high-performance',
    });
    renderer.setSize(W, H);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2.5));
    renderer.setClearColor(0x000000, 0);          // fully transparent bg
    renderer.physicallyCorrectLights = true;
    renderer.toneMapping = THREE.NoToneMapping;
    renderer.toneMappingExposure = 1.0;
    renderer.outputEncoding = THREE.sRGBEncoding;
    renderer.domElement.style.display = 'block';
    var mask = isCta
      ? 'radial-gradient(ellipse 62% 58% at 56% 50%, #000 50%, rgba(0,0,0,0.62) 70%, transparent 96%)'
      : 'radial-gradient(ellipse 58% 54% at 61% 46%, #000 44%, rgba(0,0,0,0.72) 62%, rgba(0,0,0,0.18) 78%, transparent 96%)';
    renderer.domElement.style.webkitMaskImage = mask;
    renderer.domElement.style.maskImage = mask;
    container.appendChild(renderer.domElement);

    // ── SCENE ───────────────────────────────────────────────────────────────
    var scene = new THREE.Scene();

    // ── CAMERA ──────────────────────────────────────────────────────────────
    // Matches the Blender camera (Y-up GLTF coords):
    //   Blender pos (9.5, -8.0, 9.5)  →  Three.js (9.5, 9.5, 8.0)
    //   Blender target (0.3, 1.0, 0.8) → Three.js (0.3, 0.8, -1.0)
    var aspect = W / H;
    var orthoSize = 8.0;
    var camera = isCta
      ? new THREE.PerspectiveCamera(38, aspect, 0.1, 300)
      : new THREE.OrthographicCamera(
          -orthoSize * aspect / 2,
          orthoSize * aspect / 2,
          orthoSize / 2,
          -orthoSize / 2,
          0.1,
          300
        );
    var cameraTarget = isCta
      ? new THREE.Vector3(0.2, -0.2, -0.65)
      : new THREE.Vector3(0.75, 0.15, -0.35);
    if (isCta) camera.position.set(-5.8, 5.2, 6.7);
    else camera.position.set(6.8, 6.8, 6.8);
    camera.lookAt(cameraTarget);

    // ── LIGHTS ──────────────────────────────────────────────────────────────
    var ambient = new THREE.AmbientLight(0xd8e6ff, isCta ? 0.72 : 0.14);
    scene.add(ambient);

    // Key light — front-left-above (like the spot in Blender)
    var keyLight = new THREE.DirectionalLight(isCta ? 0xf4f8ff : 0xffffff, isCta ? 1.25 : 3.05);
    keyLight.position.set(isCta ? -5 : -8, 12, isCta ? 12 : 10);
    var keyTarget = new THREE.Object3D();
    keyTarget.position.copy(cameraTarget);
    scene.add(keyTarget);
    keyLight.target = keyTarget;
    scene.add(keyLight);

    // Fill light — blue-tinted from left
    var fillLight = new THREE.DirectionalLight(isCta ? 0x2a74ff : 0x1d5fff, isCta ? 4.6 : 3.3);
    fillLight.position.set(-9, 7, -7);
    scene.add(fillLight);

    // Rim light — right side separation
    var rimLight = new THREE.DirectionalLight(0xffffff, isCta ? 1.45 : 3.2);
    rimLight.position.set(10, 7, -10);
    scene.add(rimLight);

    var topLight = new THREE.DirectionalLight(0xffffff, isCta ? 0.95 : 1.65);
    topLight.position.set(0, 16, 2);
    scene.add(topLight);

    // ── MATERIALS ───────────────────────────────────────────────────────────
    // Three.js MeshPhysicalMaterial gives us glass transmission + clearcoat.
    function makeMat(hexColor, hexEmissive, opacity, emissiveInt) {
      var material = new THREE.MeshPhysicalMaterial({
        color:              new THREE.Color(hexColor),
        emissive:           new THREE.Color(hexEmissive),
        emissiveIntensity:  emissiveInt,
        roughness:          0.24,
        metalness:          0.0,
        transmission:       0.0,
        clearcoat:          0.30,
        clearcoatRoughness: 0.22,
        transparent:        opacity < 0.99,
        opacity:            opacity,
        premultipliedAlpha: false,
        envMapIntensity:    0.0,
        specularIntensity:  0.24,
        specularColor:      new THREE.Color(0xffffff),
        toneMapped:         false,
        depthWrite:         true,
        side:               THREE.FrontSide,
      });

      material.userData.gradientTop = new THREE.Color(0xe9f2ff);
      material.userData.gradientBottom = new THREE.Color(hexColor);
      material.userData.gradientMix = 0.18;
      material.onBeforeCompile = function (shader) {
        shader.uniforms.gradientTop = { value: material.userData.gradientTop };
        shader.uniforms.gradientBottom = { value: material.userData.gradientBottom };
        shader.uniforms.gradientMix = { value: material.userData.gradientMix };

        shader.vertexShader = shader.vertexShader.replace(
          'void main() {',
          'varying vec3 vWorldPosition;\nvarying vec3 vWorldNormal;\nvoid main() {'
        );
        shader.vertexShader = shader.vertexShader.replace(
          '#include <defaultnormal_vertex>',
          '#include <defaultnormal_vertex>\nvWorldNormal = normalize(mat3(modelMatrix) * objectNormal);'
        );
        shader.vertexShader = shader.vertexShader.replace(
          '#include <worldpos_vertex>',
          '#include <worldpos_vertex>\nvWorldPosition = worldPosition.xyz;'
        );

        shader.fragmentShader = shader.fragmentShader.replace(
          'void main() {',
          'uniform vec3 gradientTop;\nuniform vec3 gradientBottom;\nuniform float gradientMix;\nvarying vec3 vWorldPosition;\nvarying vec3 vWorldNormal;\nvoid main() {'
        );
        shader.fragmentShader = shader.fragmentShader.replace(
          '#include <color_fragment>',
          '#include <color_fragment>\nfloat g = clamp((vWorldPosition.y + 1.8) / 3.9, 0.0, 1.0);\ng = smoothstep(0.08, 0.92, g);\nvec3 gradientColor = mix(gradientBottom, gradientTop, g);\ndiffuseColor.rgb = mix(diffuseColor.rgb, gradientColor, gradientMix);\nvec3 n = normalize(vWorldNormal);\nfloat topFace = smoothstep(0.58, 0.92, n.y);\nfloat rightFace = smoothstep(0.20, 0.78, max(n.x, n.z));\nfloat frontFace = (1.0 - topFace) * (1.0 - rightFace);\ndiffuseColor.rgb = mix(diffuseColor.rgb, vec3(0.08, 0.22, 0.68), rightFace * (1.0 - topFace) * 0.48);\ndiffuseColor.rgb = mix(diffuseColor.rgb, vec3(0.22, 0.43, 0.90), frontFace * 0.28);\ndiffuseColor.rgb = mix(diffuseColor.rgb, vec3(0.96, 0.98, 1.0), topFace * 0.82);\ndiffuseColor.rgb *= 1.08;'
        );
      };

      return material;
    }

    var matCore = makeMat(0x175cff, 0x082fb8, 1.00, 0.075);
    var matMid  = makeMat(0x4a7fe8, 0x1550d8, 1.00, 0.06);
    var matEdge = makeMat(0x72a2ff, 0x2a63f0, 0.98, 0.028);
    var matAccent = makeMat(0x2f74ff, 0x1456f0, 1.00, 0.065);
    var matDeep = makeMat(0x1a3db5, 0x071b78, 1.00, 0.055);
    var matFrost = makeMat(0xd9e7ff, 0x6d9eff, 0.94, 0.018);

    matCore.userData.gradientTop = new THREE.Color(0xdbe8ff);
    matCore.userData.gradientBottom = new THREE.Color(0x1035a8);
    matCore.userData.gradientMix = 0.30;
    matMid.userData.gradientTop = new THREE.Color(0xeef4ff);
    matMid.userData.gradientBottom = new THREE.Color(0x2465f2);
    matMid.userData.gradientMix = 0.30;
    matEdge.userData.gradientTop = new THREE.Color(0xffffff);
    matEdge.userData.gradientBottom = new THREE.Color(0x4a7fe8);
    matEdge.userData.gradientMix = 0.28;
    matAccent.userData.gradientTop = new THREE.Color(0xe8f1ff);
    matAccent.userData.gradientBottom = new THREE.Color(0x1763ff);
    matAccent.userData.gradientMix = 0.28;
    matDeep.userData.gradientTop = new THREE.Color(0x7fa5ff);
    matDeep.userData.gradientBottom = new THREE.Color(0x0b247f);
    matDeep.userData.gradientMix = 0.24;
    matFrost.userData.gradientTop = new THREE.Color(0xffffff);
    matFrost.userData.gradientBottom = new THREE.Color(0xc8daff);
    matFrost.userData.gradientMix = 0.34;

    // per-material base emissive intensity (for hover restore)
    matCore._baseEmissive = 0.06;
    matMid._baseEmissive  = 0.045;
    matEdge._baseEmissive = 0.018;
    matAccent._baseEmissive = 0.05;
    matDeep._baseEmissive = 0.045;
    matFrost._baseEmissive = 0.012;

    function makeEdgeGlow(hexColor, opacity) {
      return new THREE.LineBasicMaterial({
        color: hexColor,
        transparent: true,
        opacity: opacity,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
        toneMapped: false,
      });
    }

    var edgeBlue = makeEdgeGlow(0xffffff, 0.86);
    var edgeViolet = makeEdgeGlow(0xdce8ff, 0.68);
    var edgeWhite = makeEdgeGlow(0xffffff, 0.92);

    function addEdgeGlow(mesh, edgeMaterial, opacityScale) {
      var edgeGeometry = new THREE.EdgesGeometry(mesh.geometry, 24);
      var edge = new THREE.LineSegments(edgeGeometry, edgeMaterial.clone());
      edge.material.opacity *= opacityScale || 1.0;
      edge.renderOrder = 10;
      mesh.add(edge);
      return edge;
    }

    // ── LOAD GLB ────────────────────────────────────────────────────────────
    var cubes = [];
    var loader = new GLTFLoader();

    loader.load(
      'assets/cubos.glb',
      function (gltf) {
        gltf.scene.scale.setScalar(isCta ? 1.55 : 1.04);
        if (isCta) gltf.scene.position.set(0.15, -0.75, -0.2);
        else gltf.scene.position.set(3.0, -0.55, -0.35);

        gltf.scene.traverse(function (child) {
          if (!child.isMesh) return;

          var n = child.name;
          var tier;
          if      (n.indexOf('_C_') !== -1) { child.material = matCore.clone(); tier = 'C'; }
          else if (n.indexOf('_M_') !== -1) { child.material = matMid.clone();  tier = 'M'; }
          else                              { child.material = matEdge.clone(); tier = 'E'; }

          var deepChance = tier === 'C' ? 0.34 : tier === 'M' ? 0.18 : 0.04;
          var accentChance = tier === 'C' ? 0.66 : tier === 'M' ? 0.46 : 0.18;
          var frostChance = tier === 'C' ? 0.00 : tier === 'M' ? 0.04 : 0.10;
          var useDeep = Math.random() < deepChance;
          var useFrost = !useDeep && Math.random() < frostChance;
          var useAccent = !useDeep && !useFrost && Math.random() < accentChance;
          if (useDeep) {
            child.material = matDeep.clone();
          } else if (useFrost) {
            child.material = matFrost.clone();
          } else if (useAccent) {
            child.material = matAccent.clone();
          } else {
            var minOpacity = tier === 'C' ? 1.00 : tier === 'M' ? 1.00 : 0.96;
            var maxOpacity = 1.00;
            child.material.opacity = minOpacity + Math.random() * (maxOpacity - minOpacity);
            child.material.transparent = child.material.opacity < 0.99;
          }

          child.material._baseEmissive = useDeep
            ? matDeep._baseEmissive
            : useFrost
            ? matFrost._baseEmissive
            : useAccent
            ? matAccent._baseEmissive
            : tier === 'C' ? matCore._baseEmissive : tier === 'M' ? matMid._baseEmissive : matEdge._baseEmissive;

          var edgeMaterial = useFrost
            ? edgeWhite.clone()
            : useDeep
            ? edgeViolet.clone()
            : edgeBlue.clone();
          edgeMaterial.opacity *= tier === 'C' ? 1.0 : tier === 'M' ? 0.92 : 0.78;
          addEdgeGlow(child, edgeMaterial, 1.0);

          child.userData.baseY     = child.position.y;
          child.userData.baseScale = child.scale.clone();
          child.userData.phase     = Math.random() * Math.PI * 2;
          child.userData.freq      = 0.22 + Math.random() * 0.18;
          child.userData.depth     = tier === 'C' ? 1.0 : tier === 'M' ? 0.65 : 0.30;
          child.userData.hoverT    = 0.0;   // current smooth value
          child.userData.hoverGoal = 0.0;   // 0 or 1
          child.userData.influenceRadius = tier === 'C' ? 0.44 : tier === 'M' ? 0.38 : 0.30;
          child.userData.tier      = tier;

          cubes.push(child);
        });

        addTechDetails(gltf.scene, cubes);

        scene.add(gltf.scene);
      },
      undefined,
      function (err) { console.error('[hero3d] GLB load error:', err); }
    );

    function addTechDetails(root, cubeList) {
      var particleCount = isCta ? 42 : 72;
      var particlePositions = new Float32Array(particleCount * 3);
      for (var i = 0; i < particleCount; i++) {
        particlePositions[i * 3] = -5.8 + Math.random() * 11.6;
        particlePositions[i * 3 + 1] = -3.4 + Math.random() * 8.7;
        particlePositions[i * 3 + 2] = -0.8 + Math.random() * 4.8;
      }

      var particleGeometry = new THREE.BufferGeometry();
      particleGeometry.setAttribute('position', new THREE.BufferAttribute(particlePositions, 3));
      var particleMaterial = new THREE.PointsMaterial({
        color: 0xa0c0ff,
        size: isCta ? 0.035 : 0.045,
        transparent: true,
        opacity: isCta ? 0.18 : 0.26,
        blending: THREE.AdditiveBlending,
        depthWrite: false,
        toneMapped: false,
      });
      var particles = new THREE.Points(particleGeometry, particleMaterial);
      particles.userData.baseY = 0;
      root.add(particles);

      var connectionPoints = [];
      var selected = cubeList
        .filter(function (cube) { return cube.userData.tier !== 'E' || Math.random() < 0.35; })
        .slice(0, isCta ? 12 : 18);
      for (var j = 0; j < selected.length - 1; j += 2) {
        connectionPoints.push(selected[j].position.x, selected[j].position.y, selected[j].position.z);
        connectionPoints.push(selected[j + 1].position.x, selected[j + 1].position.y, selected[j + 1].position.z);
      }
      if (connectionPoints.length > 0) {
        var connectionGeometry = new THREE.BufferGeometry();
        connectionGeometry.setAttribute('position', new THREE.Float32BufferAttribute(connectionPoints, 3));
        var connectionMaterial = new THREE.LineBasicMaterial({
          color: 0xa0c0ff,
          transparent: true,
          opacity: isCta ? 0.12 : 0.18,
          blending: THREE.AdditiveBlending,
          depthWrite: false,
          toneMapped: false,
        });
        var connections = new THREE.LineSegments(connectionGeometry, connectionMaterial);
        connections.renderOrder = 5;
        root.add(connections);
      }

    }

    // ── MOUSE / RAYCASTER ───────────────────────────────────────────────────
    var mouse = new THREE.Vector2(9999, 9999);   // off-screen default
    var lastMouseMoveT = -999.0;
    var motionFadeSeconds = 0.22;
    var projectedCenter = new THREE.Vector3();

    container.addEventListener('mousemove', function (e) {
      var rect = container.getBoundingClientRect();
      mouse.x =  ((e.clientX - rect.left) / rect.width)  * 2 - 1;
      mouse.y = -((e.clientY - rect.top)  / rect.height) * 2 + 1;
      lastMouseMoveT = performance.now() / 1000;
    });

    container.addEventListener('mouseleave', function () {
      mouse.set(9999, 9999);
      lastMouseMoveT = -999.0;
    });

    // ── ANIMATION LOOP ──────────────────────────────────────────────────────
    var clock = new THREE.Clock();

    function animate() {
      requestAnimationFrame(animate);
      var t = clock.getElapsedTime();
      var motionT = performance.now() / 1000;
      var motionStrength = Math.max(0, 1 - (motionT - lastMouseMoveT) / motionFadeSeconds);

      for (var j = 0; j < cubes.length; j++) {
        var cube = cubes[j];
        var d    = cube.userData;

        // Autonomous float (each cube has its own freq + phase)
        var floatY = Math.sin(t * d.freq + d.phase) * 0.16 * d.depth;
        var influence = 0.0;

        // Interaction is driven by pointer motion and proximity, not by a
        // binary mesh hit. This prevents stationary cursors from retriggering
        // the lift while a cube eases back to its base position.
        if (motionStrength > 0 && mouse.x <= 1 && mouse.y <= 1) {
          projectedCenter.set(cube.position.x, d.baseY + floatY, cube.position.z);
          cube.parent.localToWorld(projectedCenter);
          projectedCenter.project(camera);

          var dx = mouse.x - projectedCenter.x;
          var dy = mouse.y - projectedCenter.y;
          var distance = Math.sqrt(dx * dx + dy * dy);
          influence = Math.max(0, 1 - distance / d.influenceRadius);
          influence = influence * influence;
        }

        d.hoverGoal = influence * motionStrength;

        // Smooth lerp (fast approach, slow retreat)
        var lerpSpeed = d.hoverGoal > d.hoverT ? 0.18 : 0.035;
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
      if (camera.isOrthographicCamera) {
        var resizeAspect = w / h;
        camera.left = -orthoSize * resizeAspect / 2;
        camera.right = orthoSize * resizeAspect / 2;
        camera.top = orthoSize / 2;
        camera.bottom = -orthoSize / 2;
      } else {
        camera.aspect = w / h;
      }
      camera.updateProjectionMatrix();
    });
    ro.observe(container);
  }

})();
