import * as THREE from 'three'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js'
import GUI from 'lil-gui'
import fragmentShaderNew from './test/fragment.glsl'
import vertexShaderNew from './test/vertex.glsl'
import bloomFragmentShader from './bloom/fragment.glsl'
import bloomVertexShader from './bloom/vertex.glsl'
import contrastFragmentShader from './contrast/fragment.glsl'
import contrastVertexShader from './contrast/vertex.glsl'
import { EffectComposer } from 'three/examples/jsm/Addons.js'
import { ShaderPass } from 'three/examples/jsm/Addons.js'
import { RenderPass } from 'three/examples/jsm/Addons.js'

/**
 * Base
 */
// Debug
const gui = new GUI()
const debugObject ={}
debugObject.Offset = 0.003
debugObject.Strength = 1.5
debugObject.BlurStrength = 0.05
debugObject.KernelSize = 3


/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
}

// Canvas
const canvas = document.querySelector('canvas.webgl')

// Scene
const scene = new THREE.Scene()

/**
 * Textures
 */
const textureLoader = new THREE.TextureLoader()
const stitch = textureLoader.load("/textures/Stitch.png")
stitch.colorSpace = THREE.LinearSRGBColorSpace

/**
 * Test mesh
 */
// Geometry
const geometry = new THREE.PlaneGeometry(1, 1, 32, 32)

// Material
const shaderMaterial = new THREE.ShaderMaterial({
    fragmentShader: fragmentShaderNew,
    vertexShader: vertexShaderNew,
    side: THREE.DoubleSide,
    uniforms: {
        tDiffuse: {value: null},
        tNormalTexture: {value: null},
        uOffset: {value: debugObject.Offset},
        uResolution: {value: new THREE.Vector2(sizes.width, sizes.height)},
        uStrength: {value: debugObject.Strength},
        uStitchTexture: {value: stitch}
        
    }
})

const bloomShader = new THREE.ShaderMaterial({
    fragmentShader: bloomFragmentShader,
    vertexShader: bloomVertexShader,
    uniforms: {
        tDiffuse: {value: null},
        tDefTex: {value: null},
        uBlurStrength: {value: debugObject.BlurStrength},
        uKernelSize: {value: debugObject.KernelSize},
    }
})

const contrastShader = new THREE.ShaderMaterial({
    fragmentShader: contrastFragmentShader,
    vertexShader: contrastVertexShader,
    uniforms: {
        tDiffuse : {value: null}
    }
})


gui.add(debugObject, 'Offset').min(0).max(1.0).step(0.0001).onChange(() => {
    shaderMaterial.uniforms.uOffset.value = debugObject.Offset
})
gui.add(debugObject, 'Strength').min(1).max(10).step(0.001).onChange(() => {
    shaderMaterial.uniforms.uStrength.value = debugObject.Strength
})
gui.add(debugObject, 'BlurStrength').min(0).max(1).step(0.001).onChange(() => {
    bloomShader.uniforms.uBlurStrength.value = debugObject.BlurStrength
})
gui.add(debugObject, 'KernelSize').min(1).max(10).step(1).onChange(() => {
    bloomShader.uniforms.uKernelSize.value = debugObject.KernelSize
})

// Mesh
const plane = new THREE.Mesh(geometry, shaderMaterial)
scene.add(plane)
plane.position.set(0.0, 2.0, 0.0)

const objectMaterial = new THREE.MeshBasicMaterial({
    // color: 'red'
})
const sphere = new THREE.Mesh(
    new THREE.SphereGeometry(0.5,16,16),
    objectMaterial
)

sphere.position.x=-2.0

const cube = new THREE.Mesh(
    new THREE.BoxGeometry(1,1,1),
    objectMaterial
)
cube.rotateX(1.0)

const torus = new THREE.Mesh(
    new THREE.TorusKnotGeometry(0.4, 0.15, 128, 128),
    objectMaterial
)
torus.position.x = 2.0

scene.add(sphere, cube, torus)



const directionalLight = new THREE.DirectionalLight('#ffffff', 7.0)
directionalLight.position.set(3,5,6)
directionalLight.lookAt(new THREE.Vector3(0, 0, 0))
scene.add(directionalLight)

const ambientLight = new THREE.AmbientLight('#ffffff', 0.3)
scene.add(ambientLight)




window.addEventListener('resize', () =>
{
    // Update sizes
    sizes.width = window.innerWidth
    sizes.height = window.innerHeight

    // Update camera
    camera.aspect = sizes.width / sizes.height
    camera.updateProjectionMatrix()

    shaderMaterial.uniforms.uResolution.value = new THREE.Vector2(sizes.width, sizes.height)

    // Update renderer
    renderer.setSize(sizes.width, sizes.height)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
})

/**
 * Camera
 */
// Base camera
const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100)
camera.position.set(0, 0, 4)
scene.add(camera)

// Controls
const controls = new OrbitControls(camera, canvas)
controls.enableDamping = true

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas
})
renderer.setSize(sizes.width, sizes.height)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
// renderer.setClearColor(new THREE.Color("#2F0B3E"))



// Shader Stuff *************************************





const composer = new EffectComposer(renderer)
const renderPass = new RenderPass(scene, camera)
composer.addPass(renderPass)

const shaderPass = new ShaderPass(shaderMaterial)

const bloomPass = new ShaderPass(bloomShader)

const contrastPass = new ShaderPass(contrastShader)

composer.addPass(shaderPass)
// composer.addPass(contrastPass)
// composer.addPass(bloomPass)

const renderTarget = new THREE.WebGLRenderTarget(sizes.width,sizes.height)






/**
 * Animate
 */
const clock = new THREE.Clock()

const tick = () =>
{
    const elapsedTime = clock.getElapsedTime()
    // scene.overrideMaterial = new THREE.MeshStandardMaterial()
    // renderer.setRenderTarget(renderTarget)
    // renderer.render(scene, camera)
    
    // shaderMaterial.uniforms.tDiffuse.value = renderTarget.texture
    // // bloomPass.uniforms.tDefTex.value = renderTarget.texture
    // scene.overrideMaterial = null
    // renderer.setRenderTarget(null)


    // Update controls
    controls.update()
    console.log(sizes.width, sizes.height);

    // Render
    
    composer.render()
    // renderer.render(scene, camera)  

    // Call tick again on the next frame
    window.requestAnimationFrame(tick)
}

tick()
