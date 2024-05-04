const { speaker } = await Service.import("audio")

function bar(monitor = 0) {
    const label = Widget.Label({
        label: "Hello, World!"
    })

    Utils.interval(1000, () => {
        label.label = Utils.exec("date")
    })

    const slider = Widget.Slider({
        value: speaker.bind("volume").as( v => v * 10 ),
        onChange: ({ value }) => speaker.volume = ( value / 10 ),
        hexpand: true,
        min: 1,
        max: 10,
    })

    const box = Widget.Box({
        children: [
            label,
            slider,
        ],
        expand: true,
    })
    
    return Widget.Window({
        monitor,
        name: `bar-${monitor}`,
        anchor: [ "top", "left", "right" ],
        child: box,
        exclusivity: "exclusive",
    })
}

App.config({
    windows: [
        bar(1),
    ]
})

export {}