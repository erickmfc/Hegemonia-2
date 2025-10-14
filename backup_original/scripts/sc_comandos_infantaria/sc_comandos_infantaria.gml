/// @description Comandos para infantaria
/// @param comando Tipo de comando: "mover", "seguir", "patrulhar", "atacar", "parar"
/// @param alvo_x Posição X do alvo (para mover/atacar)
/// @param alvo_y Posição Y do alvo (para mover/atacar)
/// @param unidade Unidade alvo (para seguir)

function sc_comandos_infantaria(comando, alvo_x, alvo_y, unidade) {
    with (obj_infantaria) {
        if (selecionado) {
            switch (comando) {
                case "mover":
                    destino_x = alvo_x;
                    destino_y = alvo_y;
                    estado = "movendo";
                    alvo = noone; // para de atacar
                break;
                
                case "seguir":
                    seguir_alvo = unidade;
                    estado = "seguindo";
                    alvo = noone; // para de atacar
                break;
                
                case "patrulhar":
                    patrulha_p1 = [x, y]; // ponto atual
                    patrulha_p2 = [alvo_x, alvo_y]; // ponto de destino
                    indo_p1 = false; // vai para o ponto 2 primeiro
                    estado = "patrulhando";
                    alvo = noone; // para de atacar
                break;
                
                case "atacar":
                    alvo = unidade;
                    estado = "atacando";
                break;
                
                case "parar":
                    estado = "parado";
                    alvo = noone;
                    seguir_alvo = noone;
                break;
            }
        }
    }
}
