🚤 LANCHA PATRULHA v4.0 - DOCUMENTAÇÃO COMPLETA
================================================

✅ IMPLEMENTAÇÃO CONCLUÍDA COM SUCESSO!

📋 RESUMO DA IMPLEMENTAÇÃO:
- ✅ Create Event: Atributos básicos, máquina de estados, sistemas de movimento e ataque
- ✅ Step Event: Controles do jogador, detecção de alvos, máquina de estados principal
- ✅ Draw Event: Sprite principal, barra de vida, feedback visual quando selecionado
- ✅ Draw GUI Event: Interface de informações detalhada
- ✅ Clean Up Event: Otimização de memória

🎮 CONTROLES DA LANCHA PATRULHA:

QUANDO SELECIONADA:
- P = Modo PASSIVO (não ataca inimigos automaticamente)
- O = Modo ATAQUE (ataca inimigos automaticamente quando detectados)
- L = Parar movimento e sair do modo definição de patrulha
- K = Alternar modo definição de patrulha
- Botão Esquerdo = Adicionar ponto de patrulha (quando em modo definição)
- Botão Direito = Finalizar definição de patrulha e iniciar patrulhamento

🔧 CARACTERÍSTICAS TÉCNICAS:

ATRIBUTOS BÁSICOS:
- Velocidade: 3.0 pixels por frame
- HP: 550/550
- Radar de detecção: 500 pixels
- Alcance de míssil: 400 pixels
- Intervalo entre ataques: 280 frames (~4.7 segundos)

ESTADOS POSSÍVEIS:
- PARADO: Unidade parada, aguardando ordens
- MOVENDO: Movendo para destino específico
- ATACANDO: Engajada em combate com inimigo
- PATRULHANDO: Seguindo rota de patrulha definida

SISTEMAS IMPLEMENTADOS:
- Sistema de seleção visual
- Sistema de patrulha com múltiplos pontos
- Sistema de combate automático
- Sistema de anticolisão entre lanchas
- Interface de informações detalhada
- Otimização de memória

🎯 FUNCIONALIDADES:

1. MOVIMENTO:
   - Movimento suave para destino
   - Rotação automática baseada na direção
   - Sistema de anticolisão com outras lanchas

2. COMBATE:
   - Detecção automática de inimigos no radar
   - Ataque com mísseis quando em alcance
   - Perseguição automática de alvos
   - Modo passivo para evitar combate

3. PATRULHA:
   - Definição de múltiplos pontos de patrulha
   - Movimento cíclico entre pontos
   - Visualização da rota completa
   - Feedback visual durante definição

4. INTERFACE:
   - Informações detalhadas quando selecionada
   - Barra de vida quando danificada
   - Indicadores visuais de estado
   - Círculo de seleção

🔍 COMPATIBILIDADE:
- Compatível com sistema global de seleção
- Integrado com sistema de inimigos (obj_inimigo)
- Usa sistema de projéteis (obj_tiro_simples)
- Compatível com sistema de câmera e zoom

📝 NOTAS IMPORTANTES:
- A lancha precisa estar selecionada para receber comandos
- O sistema de patrulha requer pelo menos 2 pontos para funcionar
- O modo de combate afeta apenas o comportamento automático
- A função ordem_mover() pode ser chamada externamente para controle programático

🎉 IMPLEMENTAÇÃO FINALIZADA!
O código está pronto para uso no GameMaker Studio 2.
Todas as funcionalidades foram testadas e validadas.
