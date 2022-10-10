const wheels = [0, 1, 2].map(i => `wheel-${i}`)
const rotation = wheels.map(_ => 0)

let scale = 1
const origin = { x: 0, y: 0 }
let grabbed = null
let mode = true

const transform = (i) => {
    const t = `scale(${scale})`
    return (i != null) ? t + ` rotate(${rotation[i]}rad)` : t
}

const init = () => {
    const scroll = document.getElementById('board-scroll')
    const bg = document.getElementById('wheel-bg')
    origin.x = bg.clientWidth / 2
    origin.y = bg.clientHeight / 2
    scroll.style.display = ''
    wheels.forEach(wheelID => {
        const wheel = document.getElementById(wheelID)
        const left = (bg.clientWidth - wheel.clientWidth) / 2
        const top = (bg.clientHeight - wheel.clientHeight) / 2
        wheel.style.left = `${left}px`
        wheel.style.top = `${top}px`
    })
    const left = (bg.clientWidth - scroll.clientWidth) / 2
    const top = (bg.clientHeight - scroll.clientHeight) / 2
    scroll.scrollTo(left, top)
    scroll.style.display = 'block'
    scroll.style.opacity = '1'
}

const grab = (i) => {
    grabbed = i
}

const drag = (ev, i) => {
    if (grabbed !== i) return
    const a = Math.atan2(ev.pageY - origin.y, ev.pageX - origin.x)
    const a0 = Math.atan2(ev.pageY + ev.movementY - origin.y, ev.pageX + ev.movementX - origin.x)
    const da = a - a0
    rotation[i] -= da
    const wheel = document.getElementById(wheels[i])
    wheel.style.transform = transform(i)
}

const updateScale = (s) => {
    scale = Math.max(0.1, Math.min(1, scale + s))
    const bg = document.getElementById('wheel-bg')
    bg.style.transform = transform()
    const elems = wheels.map(i => document.getElementById(i))
    elems.forEach((elem, i) => {
        elem.style.transform = transform(i)
    })
}

const swapMode = () => {
    const btn = document.getElementById('mode-btn')
    mode = !mode
    btn.innerHTML = mode ? 'M' : 'R'
}