// Script: sc_ui_helpers
// Research button function removed
// Script: sc_ui_helpers

// Função para verificar se o mouse está sobre a área de um sprite
function point_in_sprite(_px, _py, _spr_x, _spr_y, _sprite) {
    // Pega as dimensões e o ponto de origem do sprite
    var _spr_w = sprite_get_width(_sprite);
    var _spr_h = sprite_get_height(_sprite);
    var _spr_xoff = sprite_get_xoffset(_sprite);
    var _spr_yoff = sprite_get_yoffset(_sprite);
    
    // Calcula o retângulo de colisão do sprite na tela
    var _x1 = _spr_x - _spr_xoff;
    var _y1 = _spr_y - _spr_yoff;
    var _x2 = _x1 + _spr_w;
    var _y2 = _y1 + _spr_h;
    
    // Retorna 'true' se o ponto (_px, _py) estiver dentro do retângulo, e 'false' caso contrário
    return point_in_rectangle(_px, _py, _x1, _y1, _x2, _y2);
}

// (Qualquer outra função auxiliar, como a de desenhar botões, pode continuar aqui)



