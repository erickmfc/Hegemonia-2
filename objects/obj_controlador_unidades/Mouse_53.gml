// Mouse Event - obj_controlador_unidades - VERSÃO SIMPLIFICADA
// Sistema básico de mouse

// CORREÇÃO: Verificar se clicou em edifício primeiro
var _coords = scr_mouse_to_world();
var _mouse_world_x = _coords[0];
var _mouse_world_y = _coords[1];

// Verificar se clicou em algum edifício
// CORREÇÃO: Usar instance_position para detecção mais precisa
var _edificio_clicado = noone;

// Lista de todos os edifícios que podem ser clicados
var _edificios = [
    obj_quartel,
    obj_quartel_marinha, 
    obj_aeroporto_militar,
    obj_casa,
    obj_banco,
    obj_research_center
];

// Verificar cada edifício usando instance_position
for (var i = 0; i < array_length(_edificios); i++) {
    var _edificio_obj = _edificios[i];
    if (object_exists(_edificio_obj)) {
        var _instancia = instance_position(_mouse_world_x, _mouse_world_y, _edificio_obj);
        if (_instancia != noone) {
            _edificio_clicado = _instancia;
            break;
        }
    }
}

if (_edificio_clicado != noone) {
    show_debug_message("Clique em edifício detectado - ignorando seleção de unidades");
    show_debug_message("Edifício: " + object_get_name(_edificio_clicado.object_index) + " ID: " + string(_edificio_clicado));
    // CORREÇÃO: Remover return para permitir que Mouse Events dos edifícios sejam executados
    // O Mouse Event do edifício será processado normalmente após este Mouse Event
}

// Sistema básico de mouse (sem objetos específicos)
show_debug_message("Mouse event básico ativo");