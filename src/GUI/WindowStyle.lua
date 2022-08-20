local gui_style=data.raw['gui-style'].default

gui_style['Poly.GUI.Window'] = {
    type='frame_style'
}

gui_style['Poly.GUI.Window.Titlebar'] = {
    type='horizontal_flow_style',
    vertical_align = 'center'
}

gui_style['Poly.GUI.Window.Titlebar.Title'] = {
    type='label_style',
    parent='frame_title'
}

gui_style['Poly.GUI.Window.Titlebar.DragHandle'] = {
    type='empty_widget_style',
    parent='draggable_space_header',
    horizontally_stretchable='on',
    height=24,
    right_margin=4
}

gui_style['Poly.GUI.Window.Titlebar.SpriteButton'] = {
    type='button_style',
    parent='frame_action_button'
}